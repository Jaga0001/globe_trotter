import 'package:flutter/material.dart';

class Activity {
  final String name;
  final double expense;
  bool isCompleted;

  Activity({
    required this.name,
    required this.expense,
    this.isCompleted = false,
  });
}

class DayItinerary {
  final int dayNumber;
  final List<Activity> activities;

  DayItinerary({required this.dayNumber, required this.activities});
}

class TripDetails {
  final String tripName;
  final String date;
  final String days;
  final String status;
  final List<DayItinerary> itinerary;

  TripDetails({
    required this.tripName,
    required this.date,
    required this.days,
    required this.status,
    required this.itinerary,
  });
}

class ItineraryViewScreen extends StatefulWidget {
  final TripDetails tripDetails;

  const ItineraryViewScreen({super.key, required this.tripDetails});

  @override
  State<ItineraryViewScreen> createState() => _ItineraryViewScreenState();
}

class _ItineraryViewScreenState extends State<ItineraryViewScreen> {
  static const Color primaryPurple = Color(0xFF8B7B9E);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color cardBg = Color(0xFF2A2A2A);
  static const Color accentPurple = Color(0xFFB19CD9);

  late List<DayItinerary> _itinerary;

  @override
  void initState() {
    super.initState();
    _itinerary = widget.tripDetails.itinerary;
  }

  void _toggleActivity(int dayIndex, int activityIndex) {
    setState(() {
      _itinerary[dayIndex].activities[activityIndex].isCompleted =
          !_itinerary[dayIndex].activities[activityIndex].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'GlobalTrotter',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Courier',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_2_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTripHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: _itinerary.asMap().entries.map((entry) {
                  return _buildDaySection(entry.key, entry.value);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Itinerary for',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.2),
                  border: Border.all(color: accentPurple, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.tripDetails.tripName,
                  style: const TextStyle(
                    color: accentPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip('📅 ${widget.tripDetails.date}'),
              const SizedBox(width: 12),
              _buildInfoChip('📍 ${widget.tripDetails.days} Days'),
              const SizedBox(width: 12),
              _buildInfoChip('✓ ${widget.tripDetails.status}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDaySection(int dayIndex, DayItinerary day) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(left: BorderSide(color: accentPurple, width: 4)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Day ${day.dayNumber}',
                  style: const TextStyle(
                    color: accentPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${day.activities.length} activities',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              ...day.activities.asMap().entries.map((entry) {
                final activityIndex = entry.key;
                final activity = entry.value;
                final isLast = activityIndex == day.activities.length - 1;

                return Column(
                  children: [
                    _buildActivityRow(dayIndex, activityIndex, activity),
                    if (!isLast) _buildArrow(),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(int dayIndex, int activityIndex, Activity activity) {
    return Container(
      decoration: BoxDecoration(
        color: activity.isCompleted ? cardBg.withOpacity(0.5) : cardBg,
        border: Border.all(
          color: activity.isCompleted
              ? Colors.white10
              : accentPurple.withOpacity(0.5),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: TextStyle(
                      color: activity.isCompleted
                          ? Colors.white38
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: activity.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.white38,
                      decorationThickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 60, color: Colors.white10),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '₹${activity.expense.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: activity.isCompleted
                          ? Colors.white38
                          : accentPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: activity.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.white38,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _toggleActivity(dayIndex, activityIndex),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: activity.isCompleted
                    ? Colors.green.withOpacity(0.15)
                    : Colors.red.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Icon(
                activity.isCompleted ? Icons.check_circle : Icons.stop_circle,
                color: activity.isCompleted ? Colors.green : Colors.red,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Icon(
          Icons.arrow_downward_rounded,
          color: accentPurple.withOpacity(0.4),
          size: 22,
        ),
      ),
    );
  }
}
