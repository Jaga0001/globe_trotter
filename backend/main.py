import os
from datetime import datetime
import bcrypt
from google.cloud.firestore import transactional 
from typing import Optional

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore import FieldFilter

# --- 1. CONFIGURATION ---
KEY_FILE = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "serviceAccountKey.json")

try:
    if not firebase_admin._apps:
        cred = credentials.Certificate(KEY_FILE)
        firebase_admin.initialize_app(cred)
    db = firestore.client()
    print(f"✅ Firebase Connected using {KEY_FILE}")
except Exception as e:
    print(f"❌ Failed to connect: {e}")

app = FastAPI(title="GlobeTrotter Backend")

# --- 2. DATA MODELS (Matching your Screenshot) ---

class UserSignup(BaseModel):
    user_name: str
    email: str
    password: str


class UserLogin(BaseModel):
    email: str
    password: str


class Itinerary(BaseModel):
    date: datetime
    description: str
    expense: float
    section_id: int

class Trip(BaseModel):
    trip_id: int                 
    trip_name: str        
    place: str            
    start_date: datetime  
    end_date: datetime    
    photo_url: str        
    itinerary: Itinerary  

# --- 3. API ROUTES ---

@app.post("/signup/")
def signup(user: UserSignup):
    users_ref = db.collection('users')
    counters_ref = db.collection('counters').document('user_count')

    @transactional
    def create_user_transaction(transaction, user_input):
        # 1. Check if email exists
        existing = list(users_ref.where(filter=FieldFilter("email", "==", user_input.email)).stream())
        if len(existing) > 0:
             raise HTTPException(status_code=400, detail="User already exists")

        # 2. Get next ID
        counter_gen = transaction.get(counters_ref)
        # Handle generator/snapshot difference
        if hasattr(counter_gen, 'exists'):
            counter_doc = counter_gen
        else:
            counter_doc = next(counter_gen)

        if counter_doc.exists:
            new_count = counter_doc.get('count') + 1
        else:
            new_count = 1001

        new_user_id = str(new_count)

        # 3. Hash Password
        hashed_pw = bcrypt.hashpw(user_input.password.encode('utf-8'), bcrypt.gensalt())

        # 4. Prepare Data (WITHOUT user_id field)
        user_data = {
            "user_name": user_input.user_name,
            "email": user_input.email,
            "password": hashed_pw.decode('utf-8'),
            "created_at": datetime.utcnow()
        }

        # 5. Commit
        transaction.set(users_ref.document(new_user_id), user_data)
        transaction.set(counters_ref, {"count": new_count})
        
        return new_user_id

    try:
        transaction = db.transaction()
        created_id = create_user_transaction(transaction, user)
        return {"status": "success", "user_id": created_id} # Return ID to frontend
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/login/")
def login(user: UserLogin):
    try:
        # 1. Find user by email
        query = db.collection('users').where(filter=FieldFilter("email", "==", user.email)).stream()
        
        user_snapshot = None
        for doc in query:
            user_snapshot = doc
            break
            
        if not user_snapshot:
            raise HTTPException(status_code=404, detail="User not found")
        
        user_data = user_snapshot.to_dict()
        
        # 2. Verify Password
        stored_hash = user_data.get('password')
        if not stored_hash or not bcrypt.checkpw(user.password.encode('utf-8'), stored_hash.encode('utf-8')):
            raise HTTPException(status_code=401, detail="Incorrect password")

        # 3. SUCCESS - Return ID from the Document Key
        return {
            "status": "success", 
            "message": "Login successful",
            "user_id": user_snapshot.id,  
            "user_name": user_data.get("user_name")
        }

    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/trips/")
def create_trip(trip: Trip):
    """
    Creates a new trip with the exact schema from your screenshot.
    """
    try:
        # Convert Pydantic model to dict
        trip_data = trip.dict()
        
        
        doc_id = str(trip.trip_id) 
        
        db.collection('trips').document(doc_id).set(trip_data)
        
        return {"status": "success", "id": doc_id, "data": trip_data}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/trips/{user_id}")
def create_trip(user_id: str, trip: Trip):
    """
    Creates a new trip linked to the user_id provided in the URL.
    Example: POST /trips/1001
    """
    try:
        # 1. Validate that the user actually exists
        user_ref = db.collection('users').document(user_id)
        if not user_ref.get().exists:
            raise HTTPException(status_code=404, detail="User not found")

        # 2. Prepare Data
        trip_data = trip.dict()
        
        # Inject the user_id from the URL into the data before saving
        trip_data['user_id'] = user_id
        
        # 3. Save to Firestore
        doc_id = str(trip.trip_id)
        db.collection('trips').document(doc_id).set(trip_data)
        
        return {
            "status": "success", 
            "id": doc_id, 
            "linked_to_user": user_id,
            "data": trip_data
        }
        
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))