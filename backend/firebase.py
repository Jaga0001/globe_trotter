import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import bcrypt

# --- CONFIGURATION ---

KEY_FILE = 'serviceAccountKey.json' 

# 1. Connect to Firebase
try:
    cred = credentials.Certificate(KEY_FILE)
    if not firebase_admin._apps:
        firebase_admin.initialize_app(cred)
    db = firestore.client()
    print(f"✅ Successfully connected to Firebase using {KEY_FILE}")
except FileNotFoundError:
    print(f"❌ ERROR: Could not find '{KEY_FILE}'.")
    print("   Make sure the JSON key is in the same folder as this script.")
    exit()
except Exception as e:
    print(f"❌ Connection Error: {e}")
    exit()

# --- FUNCTIONS ---

def create_user_secure(user_id, email, plain_password, user_name):
    print(f"\n--- Creating User: {user_name} ---")
    # Hash password
    hashed = bcrypt.hashpw(plain_password.encode('utf-8'), bcrypt.gensalt())
    
    data = {
        'user_name': user_name,
        'email': email,
        'password': hashed.decode('utf-8'), # Store hash string
        'created_at': firestore.SERVER_TIMESTAMP
    }
    
    db.collection('users').document(str(user_id)).set(data)
    print(f"✅ User '{user_name}' created (Password hashed).")

def verify_login(email, input_password):
    print(f"\n--- Logging in as {email} ---")
    users = db.collection('users').where(filter=firestore.FieldFilter('email', '==', email)).stream()
    
    found = False
    for user in users:
        found = True
        stored_password = user.to_dict().get('password')
        
        # CASE 1: Password is a BCrypt Hash (Starts with $2b$)
        if stored_password.startswith('$2b$'):
            try:
                if bcrypt.checkpw(input_password.encode('utf-8'), stored_password.encode('utf-8')):
                    print("✅ SUCCESS: Password correct (Verified via Hash)!")
                else:
                    print("❌ FAILED: Wrong password.")
            except ValueError:
                print("❌ ERROR: Stored hash is corrupted.")

        # CASE 2: Password is Plain Text (Legacy Mock Data)
        else:
            print("⚠️ WARNING: Found plain text password. Please update security.")
            if input_password == stored_password:
                print("✅ SUCCESS: Password correct (Verified via Plain Text)!")
                # Optional: Upgrade them to a hash automatically here
            else:
                print("❌ FAILED: Wrong password.")
            
    if not found:
        print("❌ FAILED: User email not found.")


# --- RUN COMMANDS ---
if __name__ == "__main__":
    # 1. Create a test user (You can comment this out after running once)
    create_user_secure("1005", "jackman01@gmail.com", "jack@1234", "jack")

    # 2. Try logging in with the correct password
    verify_login("jackman01@gmail.com", "jack@1234")

    # 3. Try logging in with a WRONG password
    verify_login("jackman01@gmail.com", "wrongpassword")
