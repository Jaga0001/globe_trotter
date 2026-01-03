import 'package:flutter/material.dart';
import 'dart:math' as math;

class Activity {
  final String name;
  final String? description; // Add description field
  final double expense;
  bool isCompleted;

  Activity({
    required this.name,
    this.description, // Add to constructor
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

class _ItineraryViewScreenState extends State<ItineraryViewScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryPurple = Color(0xFF6d4c7d);
  static const Color bgColor = Colors.white;

  late List<DayItinerary> _itinerary;
  late AnimationController _animController;
  int? _expandedDayIndex;

  @override
  void initState() {
    super.initState();
    _itinerary = widget.tripDetails.itinerary;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleActivity(int dayIndex, int activityIndex) {
    setState(() {
      _itinerary[dayIndex].activities[activityIndex].isCompleted =
          !_itinerary[dayIndex].activities[activityIndex].isCompleted;
    });
  }

  double _getTotalExpense() {
    double total = 0;
    for (var day in _itinerary) {
      for (var activity in day.activities) {
        total += activity.expense;
      }
    }
    return total;
  }

  int _getCompletedCount() {
    int count = 0;
    for (var day in _itinerary) {
      for (var activity in day.activities) {
        if (activity.isCompleted) count++;
      }
    }
    return count;
  }

  int _getTotalActivities() {
    int count = 0;
    for (var day in _itinerary) {
      count += day.activities.length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final maxWidth = isWeb ? 1100.0 : double.infinity;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, isWeb),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    _buildStatsSection(isWeb),
                    const SizedBox(height: 32),
                    ..._itinerary.asMap().entries.map((entry) {
                      return _buildDayCard(entry.key, entry.value, isWeb);
                    }).toList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isWeb) {
    final completedCount = _getCompletedCount();
    final totalCount = _getTotalActivities();
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: primaryPurple,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryPurple, primaryPurple.withOpacity(0.7)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? 60 : 24,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.flight_takeoff,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Journey',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.tripDetails.tripName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildHeaderChip(
                        Icons.calendar_today,
                        widget.tripDetails.date,
                      ),
                      const SizedBox(width: 12),
                      _buildHeaderChip(
                        Icons.wb_sunny_outlined,
                        '${widget.tripDetails.days} Days',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$completedCount / $totalCount activities',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isWeb) {
    final totalExpense = _getTotalExpense();
    final completedCount = _getCompletedCount();
    final totalCount = _getTotalActivities();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 60 : 24, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Total Budget',
              value: '₹${totalExpense.toStringAsFixed(0)}',
              color: primaryPurple,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              icon: Icons.check_circle_outline,
              label: 'Completed',
              value: '$completedCount/$totalCount',
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(int dayIndex, DayItinerary day, bool isWeb) {
    final isExpanded = _expandedDayIndex == dayIndex;
    final completedInDay = day.activities.where((a) => a.isCompleted).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 60 : 24, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedDayIndex = isExpanded ? null : dayIndex;
                });
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryPurple,
                            primaryPurple.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryPurple.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${day.dayNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day ${day.dayNumber}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$completedInDay of ${day.activities.length} completed',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  children: day.activities.asMap().entries.map((entry) {
                    final activityIndex = entry.key;
                    final activity = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildActivityCard(
                        dayIndex,
                        activityIndex,
                        activity,
                      ),
                    );
                  }).toList(),
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    int dayIndex,
    int activityIndex,
    Activity activity,
  ) {
    return GestureDetector(
      onTap: () => _toggleActivity(dayIndex, activityIndex),
      child: Container(
        decoration: BoxDecoration(
          color: activity.isCompleted
              ? Colors.grey[50]
              : primaryPurple.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: activity.isCompleted
                ? Colors.grey[300]!
                : primaryPurple.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: activity.isCompleted ? Colors.green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: activity.isCompleted
                        ? Colors.green
                        : primaryPurple.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: activity.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: TextStyle(
                        color: activity.isCompleted
                            ? Colors.grey[500]
                            : Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: activity.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: Colors.grey[500],
                      ),
                    ),
                    if (activity.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        activity.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: activity.isCompleted
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: activity.isCompleted
                      ? Colors.grey[200]
                      : primaryPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '₹${activity.expense.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: activity.isCompleted
                        ? Colors.grey[600]
                        : primaryPurple,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: activity.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
