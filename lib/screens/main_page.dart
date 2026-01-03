import 'package:flutter/material.dart';
import 'package:globe_trotter/components/create_dialog.dart';
import 'package:globe_trotter/screens/calendar_view.dart';
import 'package:globe_trotter/screens/profile_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  List<Map<String, String>> _filteredDestinations = [];

  // Destinations list
  late final List<Map<String, String>> _allDestinations = [
    {
      "name": "Taj Mahal",
      "city": "Agra",
      "state": "Uttar Pradesh",
      "rating": "4.9",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/1/1b/Taj_Mahal-08.jpg",
    },
    {
      "name": "Jaipur Palace",
      "city": "Jaipur",
      "state": "Rajasthan",
      "rating": "4.8",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/3/37/Hawa_Mahal_2011.jpg",
    },
    {
      "name": "Backwaters",
      "city": "Alleppey",
      "state": "Kerala",
      "rating": "4.9",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/4/4e/Kerala_backwaters%2C_Houseboats%2C_India.jpg",
    },
    {
      "name": "Valley of Flowers",
      "city": "Chamoli",
      "state": "Uttarakhand",
      "rating": "4.7",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/b/b0/Valley_of_flowers_%2829336158797%29.jpg",
    },
    {
      "name": "Goa Beaches",
      "city": "Panaji",
      "state": "Goa",
      "rating": "4.6",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/3/3f/Palolem_Beach%2C_south_Goa.jpg",
    },
    {
      "name": "Varanasi Ghats",
      "city": "Varanasi",
      "state": "Uttar Pradesh",
      "rating": "4.8",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/b/b3/Varanasi_246_view_from_Gay_Ghat_towards_Ganges_river_%2833861353814%29.jpg",
    },
  ];

  // Updated color scheme - softer purple tones
  static const Color primaryPurple = Color(0xFF8B7B9E);
  static const Color darkPurple = Colors.deepPurple;
  static const Color lightPurple = Color(0xFFF0ECF4);
  static const Color accentPurple = Color(0xFFADA1BC);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filteredDestinations = _allDestinations;
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredDestinations = _allDestinations;
      } else {
        _filteredDestinations = _allDestinations
            .where(
              (dest) =>
                  dest['name']!.toLowerCase().contains(query) ||
                  dest['city']!.toLowerCase().contains(query) ||
                  dest['state']!.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;
    final contentMaxWidth = isWideScreen ? 1200.0 : screenWidth;

    // Show Calendar View when Explore (index 1) is selected
    if (_selectedIndex == 1) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F7FA),
        body: Row(
          children: [
            if (isWideScreen) _buildSideNav(),
            const Expanded(child: CalendarViewScreen()),
          ],
        ),
        floatingActionButton: _buildFAB(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FA),
      body: Row(
        children: [
          // Side Navigation for Web
          if (isWideScreen) _buildSideNav(),

          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(isWideScreen),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
                        padding: EdgeInsets.symmetric(
                          horizontal: isWideScreen ? 40.0 : 20.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcomeSection(),
                            const SizedBox(height: 32),
                            if (isWideScreen)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildBannerSection(),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(child: _buildBudgetHighlights()),
                                ],
                              )
                            else ...[
                              _buildBannerSection(),
                              const SizedBox(height: 24),
                              _buildBudgetHighlights(),
                            ],
                            const SizedBox(height: 32),
                            _buildSearchBar(),
                            const SizedBox(height: 32),
                            _buildSectionHeader(
                              _searchController.text.isEmpty
                                  ? 'Popular Destinations in India'
                                  : 'Search Results',
                              onSeeAll: () {},
                            ),
                            const SizedBox(height: 20),
                            _buildDestinationsGrid(isWideScreen),
                            const SizedBox(height: 40),
                            _buildSectionHeader(
                              'Your Recent Trips',
                              onSeeAll: () {},
                            ),
                            const SizedBox(height: 20),
                            _buildTripsGrid(isWideScreen),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
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
          // Logo
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
                    Icons.travel_explore,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'GlobeTrotter',
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
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.explore_rounded, 'Explore', 1),
          _buildNavItem(Icons.luggage_rounded, 'Community', 2),
          _buildNavItem(Icons.bookmark_rounded, 'Saved', 3),
          const Spacer(),
          const Divider(),
          _buildNavItem(Icons.settings_rounded, 'Settings', 4),
          _buildNavItem(Icons.help_outline_rounded, 'Help', 5),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isSelected ? lightPurple : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _selectedIndex = index),
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
                Icons.travel_explore,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'GlobeTrotter',
              style: TextStyle(
                color: darkPurple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.grey.shade700,
            ),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSettingsPageWeb(
                  themeColor: primaryPurple,
                  accentColor: accentPurple,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: primaryPurple,
                child: const Text(
                  'RD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, Rahul!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Plan your next adventure across incredible India',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildBannerSection() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryPurple, darkPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            bottom: -40,
            child: Icon(
              Icons.flight_takeoff,
              size: 180,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            right: 40,
            top: 20,
            child: Icon(
              Icons.location_on,
              size: 60,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Discover India',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'From the Himalayas to Kerala\'s backwaters,\nexplore the diversity of incredible India',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: darkPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Exploring',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search destinations, cities, experiences...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: primaryPurple),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.tune, color: darkPurple, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkPurple,
          ),
        ),
        TextButton.icon(
          onPressed: onSeeAll,
          icon: const Text(
            'See All',
            style: TextStyle(color: primaryPurple, fontWeight: FontWeight.w600),
          ),
          label: const Icon(
            Icons.arrow_forward,
            color: primaryPurple,
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationsGrid(bool isWideScreen) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWideScreen ? 4 : 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: isWideScreen ? 0.85 : 0.8,
      ),
      itemCount: _filteredDestinations.length,
      itemBuilder: (context, index) {
        final dest = _filteredDestinations[index];
        return _buildDestinationCard(
          dest['name']!,
          dest['city']!,
          dest['state']!,
          dest['rating']!,
          dest['cover']!,
        );
      },
    );
  }

  Widget _buildDestinationCard(
    String name,
    String city,
    String state,
    String rating,
    String cover,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [lightPurple, accentPurple.withOpacity(0.3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(child: Image.network(cover, fit: BoxFit.cover)),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: darkPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 18,
                        color: primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              '$city, $state',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: lightPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: darkPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetHighlights() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Budget Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkPurple,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: lightPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'This Month',
                  style: TextStyle(fontSize: 12, color: darkPurple),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildBudgetItem(
            'Total Spent',
            '₹24,500',
            Icons.account_balance_wallet_rounded,
            const Color(0xFFE57373),
          ),
          const SizedBox(height: 16),
          _buildBudgetItem(
            'Saved',
            '₹5,000',
            Icons.savings_rounded,
            const Color(0xFF81C784),
          ),
          const SizedBox(height: 16),
          _buildBudgetItem(
            'Upcoming',
            '₹12,000',
            Icons.event_rounded,
            const Color(0xFFFFB74D),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripsGrid(bool isWideScreen) {
    final trips = [
      {
        'name': 'Rajasthan Heritage Tour',
        'date': 'Mar 2024',
        'days': '7 days',
        'status': 'Upcoming',
      },
      {
        'name': 'Kerala Backwaters',
        'date': 'Jan 2024',
        'days': '5 days',
        'status': 'Completed',
      },
      {
        'name': 'Himalayan Trek',
        'date': 'Dec 2023',
        'days': '10 days',
        'status': 'Completed',
      },
      {
        'name': 'Goa Beach Vacation',
        'date': 'Nov 2023',
        'days': '4 days',
        'status': 'Completed',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWideScreen ? 4 : 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: isWideScreen ? 1.0 : 0.9,
      ),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildTripCard(
          trip['name']!,
          trip['date']!,
          trip['days']!,
          trip['status']!,
        );
      },
    );
  }

  Widget _buildTripCard(String name, String date, String days, String status) {
    final isUpcoming = status == 'Upcoming';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: isUpcoming
                    ? primaryPurple.withOpacity(0.1)
                    : lightPurple,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.photo_camera_rounded,
                      size: 40,
                      color: primaryPurple.withOpacity(0.4),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isUpcoming
                            ? primaryPurple
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$date • $days',
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
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () async {
        final result = await showCreateTripDialog(context);
        if (result != null) {
          // Handle created trip
          print('Created trip: ${result.tripName}');
          print('Place: ${result.place}');
          print('Activities: ${result.activities.length}');
          print(
            'Total Budget: ${result.activities.fold(0.0, (sum, a) => sum + a.budget)}',
          );
        }
      },
      backgroundColor: primaryPurple,
      elevation: 4,
      hoverElevation: 8,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: const Text(
        'Plan New Trip',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
