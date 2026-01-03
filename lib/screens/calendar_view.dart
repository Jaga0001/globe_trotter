import 'package:flutter/material.dart';

class CalendarViewScreen extends StatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  static const Color primaryPurple = Color(0xFF8B7B9E);
  static const Color darkPurple = Color(0xFF6B5B7A);
  static const Color lightPurple = Color(0xFFF0ECF4);
  static const Color accentPurple = Color(0xFFADA1BC);

  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;

  // Sample trips data - Updated with current dates
  final List<TripEvent> _trips = [
    TripEvent(
      name: 'Rajasthan Heritage',
      startDate: DateTime(2026, 1, 18),
      endDate: DateTime(2026, 1, 24),
      color: const Color(0xFF6366F1),
      destination: 'Jaipur, Udaipur',
      budget: 45000,
      icon: Icons.fort_rounded,
    ),
    TripEvent(
      name: 'Kerala Backwaters',
      startDate: DateTime(2026, 1, 28),
      endDate: DateTime(2026, 2, 2),
      color: const Color(0xFF10B981),
      destination: 'Alleppey',
      budget: 32000,
      icon: Icons.water_rounded,
    ),
    TripEvent(
      name: 'Goa Beach Vacation',
      startDate: DateTime(2026, 2, 8),
      endDate: DateTime(2026, 2, 12),
      color: const Color(0xFFF59E0B),
      destination: 'North Goa',
      budget: 28000,
      icon: Icons.beach_access_rounded,
    ),
    TripEvent(
      name: 'Himalayan Trek',
      startDate: DateTime(2026, 2, 20),
      endDate: DateTime(2026, 2, 28),
      color: const Color(0xFFEF4444),
      destination: 'Manali',
      budget: 55000,
      icon: Icons.terrain_rounded,
    ),
    TripEvent(
      name: 'Varanasi Spiritual',
      startDate: DateTime(2026, 1, 15),
      endDate: DateTime(2026, 1, 17),
      color: const Color(0xFF8B5CF6),
      destination: 'Varanasi',
      budget: 18000,
      icon: Icons.temple_hindu_rounded,
    ),
    TripEvent(
      name: 'Mumbai Trip',
      startDate: DateTime(2026, 1, 25),
      endDate: DateTime(2026, 1, 27),
      color: const Color(0xFF06B6D4),
      destination: 'Mumbai',
      budget: 15000,
      icon: Icons.location_city_rounded,
    ),
    TripEvent(
      name: 'Agra Day Trip',
      startDate: DateTime(2026, 1, 20),
      endDate: DateTime(2026, 1, 20),
      color: const Color(0xFFEC4899),
      destination: 'Agra',
      budget: 8000,
      icon: Icons.account_balance_rounded,
    ),
    TripEvent(
      name: 'Rishikesh Adventure',
      startDate: DateTime(2026, 3, 5),
      endDate: DateTime(2026, 3, 10),
      color: const Color(0xFF14B8A6),
      destination: 'Rishikesh',
      budget: 22000,
      icon: Icons.kayaking_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      body: Column(
        children: [
          _buildCompactHeader(),
          Expanded(
            child: isWideScreen
                ? Row(
                    children: [
                      Expanded(flex: 5, child: _buildCalendarSection()),
                      Expanded(flex: 3, child: _buildSidePanel()),
                    ],
                  )
                : _buildCalendarSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    final upcomingCount = _trips
        .where((t) => t.startDate.isAfter(DateTime.now()))
        .length;
    final totalBudget = _trips.fold<double>(0, (sum, t) => sum + t.budget);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkPurple, primaryPurple, accentPurple.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: darkPurple.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo & Title
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Trip Calendar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Plan and organize your adventures',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // View Toggle
          // Stats
          _buildCompactStatCard(
            Icons.flight_takeoff_rounded,
            '$upcomingCount',
            'Upcoming',
          ),
          const SizedBox(width: 10),
          _buildCompactStatCard(
            Icons.account_balance_wallet_rounded,
            '₹${(totalBudget / 1000).toStringAsFixed(0)}K',
            'Budget',
          ),
          const SizedBox(width: 16),
          // Today Button
          _buildCompactTodayButton(),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTodayButton() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentMonth = DateTime.now();
            _selectedDate = DateTime.now();
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.today_rounded, size: 16, color: darkPurple),
              const SizedBox(width: 6),
              Text(
                'Today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: darkPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          _buildWeekdayHeader(),
          Expanded(child: _buildCalendarGrid()),
          _buildCalendarFooter(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          _buildNavButton(Icons.chevron_left_rounded, () {
            setState(
              () => _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              ),
            );
          }),
          Expanded(
            child: Center(
              child: Text(
                _getMonthYearString(_currentMonth),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkPurple,
                ),
              ),
            ),
          ),
          _buildNavButton(Icons.chevron_right_rounded, () {
            setState(
              () => _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + 1,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: lightPurple,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: darkPurple, size: 20),
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final fullWeekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: lightPurple.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final isWeekend = index == 0 || index == 6;
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekdays[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isWeekend ? primaryPurple : darkPurple,
                  ),
                ),
                Text(
                  fullWeekdays[index],
                  style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    final totalRows = ((firstWeekday + daysInMonth) / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: List.generate(totalRows, (rowIndex) {
          return Expanded(
            child: Row(
              children: List.generate(7, (colIndex) {
                final cellIndex = rowIndex * 7 + colIndex;
                final dayOffset = cellIndex - firstWeekday;
                final day = dayOffset + 1;

                if (dayOffset < 0 || day > daysInMonth) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }

                final currentDate = DateTime(
                  _currentMonth.year,
                  _currentMonth.month,
                  day,
                );
                final tripsOnDay = _getTripsForDate(currentDate);

                return Expanded(
                  child: _buildDayCell(day, currentDate, tripsOnDay),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayCell(int day, DateTime date, List<TripEvent> trips) {
    final isToday = _isToday(date);
    final isSelected =
        _selectedDate != null &&
        _selectedDate!.year == date.year &&
        _selectedDate!.month == date.month &&
        _selectedDate!.day == date.day;
    final isWeekend =
        date.weekday == DateTime.sunday || date.weekday == DateTime.saturday;
    final hasTrips = trips.isNotEmpty;

    // Check which trips START on this date (to show icon only once)
    final tripsStartingToday = trips.where((trip) {
      return trip.startDate.year == date.year &&
          trip.startDate.month == date.month &&
          trip.startDate.day == date.day;
    }).toList();

    // Check which trips are continuing (started before today)
    final tripsContinuing = trips.where((trip) {
      final tripStart = DateTime(
        trip.startDate.year,
        trip.startDate.month,
        trip.startDate.day,
      );
      final currentDate = DateTime(date.year, date.month, date.day);
      return tripStart.isBefore(currentDate);
    }).toList();

    return GestureDetector(
      onTap: () => setState(() => _selectedDate = date),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [primaryPurple, darkPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : isToday
              ? LinearGradient(
                  colors: [lightPurple, accentPurple.withOpacity(0.3)],
                )
              : null,
          color: isSelected || isToday
              ? null
              : (hasTrips
                    ? trips.first.color.withOpacity(0.1)
                    : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (hasTrips
                      ? trips.first.color.withOpacity(0.4)
                      : Colors.grey.shade200),
            width: hasTrips ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryPurple.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day number row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isToday || isSelected || hasTrips
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isToday
                          ? darkPurple
                          : isWeekend
                          ? primaryPurple
                          : Colors.black87,
                    ),
                  ),
                  if (isToday && !isSelected)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: primaryPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              // Trip indicators with icons
              if (trips.isNotEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Show icon for trips starting today
                      if (tripsStartingToday.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: tripsStartingToday.take(2).map((trip) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : trip.color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                trip.icon,
                                size: 10,
                                color: isSelected ? trip.color : Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      // Show continuation bar for ongoing trips (no icon, just bar)
                      if (tripsContinuing.isNotEmpty &&
                          tripsStartingToday.isEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : tripsContinuing.first.color.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      // Show +N more indicator
                      if (trips.length > 2)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            '+${trips.length - 2}',
                            style: TextStyle(
                              fontSize: 6,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: lightPurple.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendChip(const Color(0xFF10B981), 'Leisure'),
          const SizedBox(width: 12),
          _buildLegendChip(const Color(0xFF6366F1), 'Adventure'),
          const SizedBox(width: 12),
          _buildLegendChip(const Color(0xFFF59E0B), 'Beach'),
          const SizedBox(width: 12),
          _buildLegendChip(const Color(0xFF8B5CF6), 'Spiritual'),
        ],
      ),
    );
  }

  Widget _buildLegendChip(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSidePanel() {
    final selectedTrips = _selectedDate != null
        ? _getTripsForDate(_selectedDate!)
        : [];
    final upcomingTrips =
        _trips.where((t) => t.startDate.isAfter(DateTime.now())).toList()
          ..sort((a, b) => a.startDate.compareTo(b.startDate));

    return Container(
      margin: const EdgeInsets.only(top: 12, right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightPurple, accentPurple.withOpacity(0.3)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.event_rounded, color: darkPurple, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedDate != null
                            ? _formatFullDate(_selectedDate!)
                            : 'Select a date',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darkPurple,
                        ),
                      ),
                      Text(
                        selectedTrips.isEmpty
                            ? 'No trips scheduled'
                            : '${selectedTrips.length} trip${selectedTrips.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.upcoming_rounded, size: 16, color: darkPurple),
                const SizedBox(width: 6),
                const Text(
                  'Upcoming Trips',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const Spacer(),
                Text(
                  '${upcomingTrips.length} trips',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: upcomingTrips.length,
              itemBuilder: (context, index) =>
                  _buildTripCard(upcomingTrips[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(TripEvent trip, {bool isHighlighted = false}) {
    final daysUntil = trip.startDate.difference(DateTime.now()).inDays;
    final duration = trip.endDate.difference(trip.startDate).inDays + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? trip.color.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: trip.color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: trip.color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [trip.color, trip.color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(trip.icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 10,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          trip.destination,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trip.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${daysUntil}d left',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: trip.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildTripDetail(
                  Icons.calendar_today_rounded,
                  '${_formatShortDate(trip.startDate)} - ${_formatShortDate(trip.endDate)}',
                ),
                Container(width: 1, height: 16, color: Colors.grey.shade300),
                _buildTripDetail(Icons.schedule_rounded, '$duration days'),
                Container(width: 1, height: 16, color: Colors.grey.shade300),
                _buildTripDetail(
                  Icons.currency_rupee_rounded,
                  '${(trip.budget / 1000).toStringAsFixed(0)}K',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetail(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 10, color: Colors.grey.shade500),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<TripEvent> _getTripsForDate(DateTime date) {
    return _trips.where((trip) {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final startOnly = DateTime(
        trip.startDate.year,
        trip.startDate.month,
        trip.startDate.day,
      );
      final endOnly = DateTime(
        trip.endDate.year,
        trip.endDate.month,
        trip.endDate.day,
      );
      return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
    }).toList();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _getMonthYearString(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatFullDate(DateTime date) {
    final days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatShortDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

class TripEvent {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String destination;
  final double budget;
  final IconData icon;

  TripEvent({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.destination,
    required this.budget,
    required this.icon,
  });
}
