import 'package:flutter/material.dart';
import 'package:globe_trotter/screens/admin_trips_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Color scheme
  static const Color primaryPurple = Color(0xFF8B7B9E);
  static const Color darkPurple = Colors.deepPurple;
  static const Color lightPurple = Color(0xFFF0ECF4);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);

  // Mock data for analytics
  late final Map<String, dynamic> _analyticsData = {
    'totalTrips': 1247,
    'totalUsers': 892,
    'totalMembers': 5432,
    'totalRevenue': 245670.50,
    'tripsThisMonth': 156,
    'newUsersThisMonth': 45,
    'averageTripCost': 197.50,
    'tripCompletionRate': 94.2,
    'topDestinations': [
      {'name': 'Taj Mahal', 'count': 234, 'revenue': 46080.00},
      {'name': 'Goa Beaches', 'count': 189, 'revenue': 37310.00},
      {'name': 'Jaipur Palace', 'count': 156, 'revenue': 30810.00},
      {'name': 'Backwaters', 'count': 142, 'revenue': 28040.00},
      {'name': 'Valley of Flowers', 'count': 98, 'revenue': 19360.00},
    ],
    'recentTrips': [
      {
        'id': 'T001',
        'name': 'Taj Mahal Tour',
        'destination': 'Agra',
        'members': 4,
        'startDate': '2026-01-10',
        'status': 'Active',
        'cost': 800.00,
      },
      {
        'id': 'T002',
        'name': 'Goa Vacation',
        'destination': 'Panaji',
        'members': 6,
        'startDate': '2026-01-15',
        'status': 'Active',
        'cost': 1200.00,
      },
      {
        'id': 'T003',
        'name': 'Kerala Backwaters',
        'destination': 'Alleppey',
        'members': 3,
        'startDate': '2026-01-05',
        'status': 'Completed',
        'cost': 600.00,
      },
      {
        'id': 'T004',
        'name': 'Rajasthan Explorer',
        'destination': 'Jaipur',
        'members': 5,
        'startDate': '2026-01-20',
        'status': 'Scheduled',
        'cost': 950.00,
      },
      {
        'id': 'T005',
        'name': 'Himalayan Trek',
        'destination': 'Chamoli',
        'members': 2,
        'startDate': '2026-02-01',
        'status': 'Scheduled',
        'cost': 450.00,
      },
    ],
    'monthlyTripData': [12, 15, 18, 22, 25, 28, 31, 28, 26, 24, 22, 20],
    'monthlyRevenueData': [
      1200,
      1500,
      1800,
      2200,
      2500,
      2800,
      3100,
      2800,
      2600,
      2400,
      2200,
      2000,
    ],
  };

  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      body: Row(
        children: [
          if (isWideScreen) _buildSideNav(),
          Expanded(child: _buildPageContent(isWideScreen)),
        ],
      ),
    );
  }

  Widget _buildPageContent(bool isWideScreen) {
    switch (_selectedNavIndex) {
      case 0:
        return _buildDashboardContent(isWideScreen);
      case 1:
        return AdminTripsContent(
          onNavigate: (index) => setState(() => _selectedNavIndex = index),
        );
      case 2:
        return _buildPlaceholderPage('Users', Icons.people_rounded);
      case 3:
        return _buildPlaceholderPage('Destinations', Icons.location_on_rounded);
      case 4:
        return _buildPlaceholderPage('Analytics', Icons.trending_up_rounded);
      case 5:
        return _buildPlaceholderPage('Settings', Icons.settings_rounded);
      default:
        return _buildDashboardContent(isWideScreen);
    }
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Column(
      children: [
        _buildTopBar(false),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 64, color: primaryPurple.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming Soon',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardContent(bool isWideScreen) {
    return Column(
      children: [
        _buildTopBar(isWideScreen),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 40.0 : 20.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(),
                  const SizedBox(height: 32),
                  _buildKPICards(isWideScreen),
                  const SizedBox(height: 40),
                  if (isWideScreen)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildTripChart()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildRevenueMetrics()),
                      ],
                    )
                  else ...[
                    _buildTripChart(),
                    const SizedBox(height: 24),
                    _buildRevenueMetrics(),
                  ],
                  const SizedBox(height: 40),
                  _buildTopDestinations(),
                  const SizedBox(height: 40),
                  _buildRecentTripsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSideNav() {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: darkPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildNavItem(Icons.dashboard_rounded, 'Dashboard', 0),
          _buildNavItem(Icons.flight_takeoff_rounded, 'Trips', 1),
          _buildNavItem(Icons.people_rounded, 'Users', 2),
          _buildNavItem(Icons.location_on_rounded, 'Destinations', 3),
          _buildNavItem(Icons.trending_up_rounded, 'Analytics', 4),
          const Spacer(),
          const Divider(),
          _buildNavItem(Icons.settings_rounded, 'Settings', 5),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = index == _selectedNavIndex;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected ? lightPurple : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _selectedNavIndex = index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? darkPurple : Colors.grey.shade600,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? darkPurple : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isWideScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWideScreen ? 40 : 20,
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
            'GlobeTrotter Admin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: darkPurple,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.person_rounded, color: primaryPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: darkPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back, Admin',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: darkPurple,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s your GlobeTrotter platform overview for ${DateTime.now().year}',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildKPICards(bool isWideScreen) {
    final kpis = [
      {
        'title': 'Total Trips',
        'value': _analyticsData['totalTrips'],
        'icon': Icons.flight_takeoff_rounded,
        'color': primaryPurple,
        'trend': '+12.5%',
      },
      {
        'title': 'Total Users',
        'value': _analyticsData['totalUsers'],
        'icon': Icons.people_rounded,
        'color': successGreen,
        'trend': '+8.2%',
      },
      {
        'title': 'Total Members',
        'value': _analyticsData['totalMembers'],
        'icon': Icons.group_rounded,
        'color': warningOrange,
        'trend': '+15.3%',
      },
      {
        'title': 'Revenue',
        'value': '\$${_analyticsData['totalRevenue']}',
        'icon': Icons.trending_up_rounded,
        'color': Colors.blue,
        'trend': '+22.1%',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWideScreen ? 4 : 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return _buildKPICard(
          kpi['title'] as String,
          kpi['value'],
          kpi['icon'] as IconData,
          kpi['color'] as Color,
          kpi['trend'] as String,
        );
      },
    );
  }

  Widget _buildKPICard(
    String title,
    dynamic value,
    IconData icon,
    Color color,
    String trend,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2A33),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    fontSize: 12,
                    color: successGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trips Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2A33),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Monthly trip creation trend',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          _buildBarChart(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final monthlyData = _analyticsData['monthlyTripData'] as List<int>;
    final maxValue = monthlyData.reduce((a, b) => a > b ? a : b).toDouble();
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

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(monthlyData.length, (index) {
          final value = monthlyData[index].toDouble();
          final height = (value / maxValue) * 150;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: height,
                decoration: BoxDecoration(
                  color: primaryPurple.withOpacity(0.7),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                months[index],
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRevenueMetrics() {
    final kpis = [
      (
        'Average Trip Cost',
        '\$${_analyticsData['averageTripCost']}',
        primaryPurple,
      ),
      ('Trips This Month', '${_analyticsData['tripsThisMonth']}', successGreen),
      (
        'Completion Rate',
        '${_analyticsData['tripCompletionRate']}%',
        warningOrange,
      ),
      (
        'New Users (Month)',
        '${_analyticsData['newUsersThisMonth']}',
        Colors.blue,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2A33),
            ),
          ),
          const SizedBox(height: 24),
          ...(kpis)
              .map(
                (kpi) => Column(
                  children: [
                    _buildMetricRow(kpi.$1, kpi.$2, kpi.$3),
                    const SizedBox(height: 16),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopDestinations() {
    final topDest = _analyticsData['topDestinations'] as List<dynamic>;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Destinations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D2A33),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on trip bookings',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ...List.generate(topDest.length, (index) {
            final dest = topDest[index] as Map<String, dynamic>;
            final maxCount =
                (topDest[0] as Map<String, dynamic>)['count'] as int;
            final percentage = ((dest['count'] as int) / maxCount * 100)
                .toInt();

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dest['name'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D2A33),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${dest['count']} trips • \$${dest['revenue']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryPurple.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (index < topDest.length - 1)
                  const Divider(height: 20)
                else
                  const SizedBox(),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentTripsSection() {
    final recentTrips = _analyticsData['recentTrips'] as List<dynamic>;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Trips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2A33),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedNavIndex = 1),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 32,
              columns: const [
                DataColumn(
                  label: Text(
                    'Trip ID',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Trip Name',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Destination',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Members',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Start Date',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Cost',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              rows: List.generate(recentTrips.length, (index) {
                final trip = recentTrips[index] as Map<String, dynamic>;
                final statusColor = _getStatusColor(trip['status'] as String);

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        trip['id'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataCell(Text(trip['name'] as String)),
                    DataCell(Text(trip['destination'] as String)),
                    DataCell(
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${trip['members']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(trip['startDate'] as String)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          trip['status'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '\$${trip['cost']}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return successGreen;
      case 'Completed':
        return primaryPurple;
      case 'Scheduled':
        return warningOrange;
      default:
        return Colors.grey;
    }
  }
}
