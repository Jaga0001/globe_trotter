import 'package:flutter/material.dart';

// Change from full page to content widget that can be embedded
class AdminTripsContent extends StatefulWidget {
  final Function(int)? onNavigate;

  const AdminTripsContent({super.key, this.onNavigate});

  @override
  State<AdminTripsContent> createState() => _AdminTripsContentState();
}

class _AdminTripsContentState extends State<AdminTripsContent> {
  static const Color primaryPurple = Color(0xFF8B7B9E);
  static const Color darkPurple = Color(0xFF6B5B7A);
  static const Color lightPurple = Color(0xFFF0ECF4);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  String _selectedSort = 'Newest';

  // Mock trips data
  final List<Map<String, dynamic>> _allTrips = [
    {
      'id': 'TRP001',
      'name': 'Rajasthan Heritage Tour',
      'destination': 'Jaipur, Udaipur',
      'organizer': 'Rahul Sharma',
      'organizerEmail': 'rahul@email.com',
      'members': 4,
      'startDate': DateTime(2026, 1, 18),
      'endDate': DateTime(2026, 1, 24),
      'status': 'Active',
      'budget': 45000.0,
      'activities': 8,
      'icon': Icons.fort_rounded,
      'color': const Color(0xFF6366F1),
    },
    {
      'id': 'TRP002',
      'name': 'Kerala Backwaters',
      'destination': 'Alleppey, Kochi',
      'organizer': 'Priya Patel',
      'organizerEmail': 'priya@email.com',
      'members': 6,
      'startDate': DateTime(2026, 1, 28),
      'endDate': DateTime(2026, 2, 2),
      'status': 'Scheduled',
      'budget': 32000.0,
      'activities': 5,
      'icon': Icons.water_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'id': 'TRP003',
      'name': 'Goa Beach Vacation',
      'destination': 'North Goa',
      'organizer': 'Amit Kumar',
      'organizerEmail': 'amit@email.com',
      'members': 8,
      'startDate': DateTime(2026, 2, 8),
      'endDate': DateTime(2026, 2, 12),
      'status': 'Scheduled',
      'budget': 28000.0,
      'activities': 6,
      'icon': Icons.beach_access_rounded,
      'color': const Color(0xFFF59E0B),
    },
    {
      'id': 'TRP004',
      'name': 'Himalayan Trek',
      'destination': 'Manali, Leh',
      'organizer': 'Vikram Singh',
      'organizerEmail': 'vikram@email.com',
      'members': 5,
      'startDate': DateTime(2025, 12, 10),
      'endDate': DateTime(2025, 12, 18),
      'status': 'Completed',
      'budget': 55000.0,
      'activities': 12,
      'icon': Icons.terrain_rounded,
      'color': const Color(0xFFEF4444),
    },
    {
      'id': 'TRP005',
      'name': 'Varanasi Spiritual Journey',
      'destination': 'Varanasi',
      'organizer': 'Sneha Gupta',
      'organizerEmail': 'sneha@email.com',
      'members': 3,
      'startDate': DateTime(2025, 11, 15),
      'endDate': DateTime(2025, 11, 17),
      'status': 'Completed',
      'budget': 18000.0,
      'activities': 4,
      'icon': Icons.temple_hindu_rounded,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'id': 'TRP006',
      'name': 'Mumbai City Exploration',
      'destination': 'Mumbai',
      'organizer': 'Rohan Desai',
      'organizerEmail': 'rohan@email.com',
      'members': 2,
      'startDate': DateTime(2026, 1, 25),
      'endDate': DateTime(2026, 1, 27),
      'status': 'Active',
      'budget': 15000.0,
      'activities': 7,
      'icon': Icons.location_city_rounded,
      'color': const Color(0xFF06B6D4),
    },
    {
      'id': 'TRP007',
      'name': 'Agra Taj Mahal Visit',
      'destination': 'Agra',
      'organizer': 'Neha Verma',
      'organizerEmail': 'neha@email.com',
      'members': 4,
      'startDate': DateTime(2025, 10, 20),
      'endDate': DateTime(2025, 10, 21),
      'status': 'Completed',
      'budget': 8000.0,
      'activities': 3,
      'icon': Icons.account_balance_rounded,
      'color': const Color(0xFFEC4899),
    },
    {
      'id': 'TRP008',
      'name': 'Rishikesh Adventure',
      'destination': 'Rishikesh',
      'organizer': 'Karan Malhotra',
      'organizerEmail': 'karan@email.com',
      'members': 6,
      'startDate': DateTime(2026, 3, 5),
      'endDate': DateTime(2026, 3, 10),
      'status': 'Scheduled',
      'budget': 22000.0,
      'activities': 9,
      'icon': Icons.kayaking_rounded,
      'color': const Color(0xFF14B8A6),
    },
    {
      'id': 'TRP009',
      'name': 'Darjeeling Tea Gardens',
      'destination': 'Darjeeling',
      'organizer': 'Ananya Das',
      'organizerEmail': 'ananya@email.com',
      'members': 3,
      'startDate': DateTime(2026, 4, 15),
      'endDate': DateTime(2026, 4, 20),
      'status': 'Scheduled',
      'budget': 25000.0,
      'activities': 5,
      'icon': Icons.local_cafe_rounded,
      'color': const Color(0xFF84CC16),
    },
    {
      'id': 'TRP010',
      'name': 'Andaman Beach Holiday',
      'destination': 'Port Blair',
      'organizer': 'Sanjay Reddy',
      'organizerEmail': 'sanjay@email.com',
      'members': 4,
      'startDate': DateTime(2025, 9, 10),
      'endDate': DateTime(2025, 9, 17),
      'status': 'Cancelled',
      'budget': 65000.0,
      'activities': 10,
      'icon': Icons.scuba_diving_rounded,
      'color': const Color(0xFF0EA5E9),
    },
  ];

  List<Map<String, dynamic>> get _filteredTrips {
    var trips = List<Map<String, dynamic>>.from(_allTrips);

    // Filter by status
    if (_selectedStatus != 'All') {
      trips = trips.where((t) => t['status'] == _selectedStatus).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      trips = trips.where((t) {
        return (t['name'] as String).toLowerCase().contains(query) ||
            (t['destination'] as String).toLowerCase().contains(query) ||
            (t['organizer'] as String).toLowerCase().contains(query) ||
            (t['id'] as String).toLowerCase().contains(query);
      }).toList();
    }

    // Sort
    switch (_selectedSort) {
      case 'Newest':
        trips.sort(
          (a, b) => (b['startDate'] as DateTime).compareTo(
            a['startDate'] as DateTime,
          ),
        );
        break;
      case 'Oldest':
        trips.sort(
          (a, b) => (a['startDate'] as DateTime).compareTo(
            b['startDate'] as DateTime,
          ),
        );
        break;
      case 'Budget (High)':
        trips.sort(
          (a, b) => (b['budget'] as double).compareTo(a['budget'] as double),
        );
        break;
      case 'Budget (Low)':
        trips.sort(
          (a, b) => (a['budget'] as double).compareTo(b['budget'] as double),
        );
        break;
      case 'Members':
        trips.sort(
          (a, b) => (b['members'] as int).compareTo(a['members'] as int),
        );
        break;
    }

    return trips;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Column(
      children: [
        _buildTopBar(isWideScreen),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isWideScreen ? 32 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStatsRow(isWideScreen),
                const SizedBox(height: 24),
                _buildFiltersSection(isWideScreen),
                const SizedBox(height: 24),
                _buildTripsTable(isWideScreen),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(bool isWideScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? 32 : 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isWideScreen) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          const Text(
            'Trip Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkPurple,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Trip'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Trips',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: darkPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage and monitor all trips across the platform',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isWideScreen) {
    final stats = [
      {
        'label': 'Total Trips',
        'value': '${_allTrips.length}',
        'icon': Icons.flight_takeoff_rounded,
        'color': primaryPurple,
      },
      {
        'label': 'Active',
        'value': '${_allTrips.where((t) => t['status'] == 'Active').length}',
        'icon': Icons.play_circle_rounded,
        'color': successGreen,
      },
      {
        'label': 'Scheduled',
        'value': '${_allTrips.where((t) => t['status'] == 'Scheduled').length}',
        'icon': Icons.schedule_rounded,
        'color': warningOrange,
      },
      {
        'label': 'Completed',
        'value': '${_allTrips.where((t) => t['status'] == 'Completed').length}',
        'icon': Icons.check_circle_rounded,
        'color': const Color(0xFF6366F1),
      },
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (stat['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat['value'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),
                    Text(
                      stat['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFiltersSection(bool isWideScreen) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search trips by name, destination, organizer...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade400,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8F7FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildFilterDropdown(
                'Status',
                _selectedStatus,
                ['All', 'Active', 'Scheduled', 'Completed', 'Cancelled'],
                (val) {
                  setState(() => _selectedStatus = val!);
                },
              ),
              const SizedBox(width: 16),
              _buildFilterDropdown(
                'Sort by',
                _selectedSort,
                [
                  'Newest',
                  'Oldest',
                  'Budget (High)',
                  'Budget (Low)',
                  'Members',
                ],
                (val) {
                  setState(() => _selectedSort = val!);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Showing ${_filteredTrips.length} of ${_allTrips.length} trips',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedStatus = 'All';
                    _selectedSort = 'Newest';
                  });
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reset Filters'),
                style: TextButton.styleFrom(foregroundColor: primaryPurple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: const TextStyle(
            fontSize: 14,
            color: darkPurple,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTripsTable(bool isWideScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: lightPurple.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                _buildTableHeader('Trip', 3),
                _buildTableHeader('Organizer', 2),
                _buildTableHeader('Dates', 2),
                _buildTableHeader('Members', 1),
                _buildTableHeader('Budget', 1),
                _buildTableHeader('Status', 1),
                _buildTableHeader('Actions', 1),
              ],
            ),
          ),
          // Table Body
          if (_filteredTrips.isEmpty)
            Container(
              padding: const EdgeInsets.all(48),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No trips found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          else
            ...List.generate(
              _filteredTrips.length,
              (index) => _buildTripRow(_filteredTrips[index], index),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: darkPurple,
        ),
      ),
    );
  }

  Widget _buildTripRow(Map<String, dynamic> trip, int index) {
    final startDate = trip['startDate'] as DateTime;
    final endDate = trip['endDate'] as DateTime;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        color: index.isEven ? Colors.white : const Color(0xFFFCFCFD),
      ),
      child: Row(
        children: [
          // Trip Info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (trip['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    trip['icon'] as IconData,
                    color: trip['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              trip['destination'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        trip['id'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Organizer
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['organizer'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  trip['organizerEmail'] as String,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Dates
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatDate(startDate)} - ${_formatDate(endDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${endDate.difference(startDate).inDays + 1} days',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          // Members
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Text(
                  '${trip['members']}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Budget
          Expanded(
            flex: 1,
            child: Text(
              '₹${(trip['budget'] as double).toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: darkPurple,
              ),
            ),
          ),
          // Status
          Expanded(flex: 1, child: _buildStatusChip(trip['status'] as String)),
          // Actions
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showTripDetails(trip),
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  tooltip: 'View Details',
                  color: Colors.grey.shade600,
                ),

                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                  onSelected: (value) => _handleMenuAction(value, trip),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Text('Duplicate'),
                    ),
                    const PopupMenuItem(value: 'export', child: Text('Export')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    Color bgColor;
    IconData icon;

    switch (status) {
      case 'Active':
        color = successGreen;
        bgColor = successGreen.withOpacity(0.1);
        icon = Icons.play_circle_outline_rounded;
        break;
      case 'Scheduled':
        color = warningOrange;
        bgColor = warningOrange.withOpacity(0.1);
        icon = Icons.schedule_rounded;
        break;
      case 'Completed':
        color = const Color(0xFF6366F1);
        bgColor = const Color(0xFF6366F1).withOpacity(0.1);
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'Cancelled':
        color = errorRed;
        bgColor = errorRed.withOpacity(0.1);
        icon = Icons.cancel_outlined;
        break;
      default:
        color = Colors.grey;
        bgColor = Colors.grey.withOpacity(0.1);
        icon = Icons.help_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showTripDetails(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (trip['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      trip['icon'] as IconData,
                      color: trip['color'] as Color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip['name'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),
                        Text(
                          trip['id'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow(
                Icons.location_on_outlined,
                'Destination',
                trip['destination'] as String,
              ),
              _buildDetailRow(
                Icons.person_outline_rounded,
                'Organizer',
                '${trip['organizer']} (${trip['organizerEmail']})',
              ),
              _buildDetailRow(
                Icons.calendar_today_outlined,
                'Dates',
                '${_formatDate(trip['startDate'] as DateTime)} - ${_formatDate(trip['endDate'] as DateTime)}',
              ),
              _buildDetailRow(
                Icons.people_outline_rounded,
                'Members',
                '${trip['members']} travelers',
              ),
              _buildDetailRow(
                Icons.currency_rupee_rounded,
                'Budget',
                '₹${(trip['budget'] as double).toStringAsFixed(0)}',
              ),
              _buildDetailRow(
                Icons.event_note_outlined,
                'Activities',
                '${trip['activities']} planned',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Edit Trip'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: darkPurple),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> trip) {
    switch (action) {
      case 'delete':
        _showDeleteConfirmation(trip);
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip "${trip['name']}" duplicated'),
            backgroundColor: successGreen,
          ),
        );
        break;
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exporting "${trip['name']}"...'),
            backgroundColor: primaryPurple,
          ),
        );
        break;
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text('Delete Trip'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${trip['name']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(
                () => _allTrips.removeWhere((t) => t['id'] == trip['id']),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Trip "${trip['name']}" deleted'),
                  backgroundColor: errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// Keep the original AdminTripsPage for standalone use if needed
class AdminTripsPage extends StatelessWidget {
  const AdminTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AdminTripsContent());
  }
}
