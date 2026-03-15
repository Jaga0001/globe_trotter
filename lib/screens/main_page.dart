import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globe_trotter/components/create_dialog.dart';
import 'package:globe_trotter/screens/Iternary_view_screen.dart';
import 'package:globe_trotter/screens/destination_detail_screen.dart';
import 'package:globe_trotter/screens/calendar_view.dart';
import 'package:globe_trotter/screens/community_page.dart';
import 'package:globe_trotter/screens/profile_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  List<Map<String, String>> _filteredDestinations = [];
  bool _isSearchFocused = false;

  // ── Refined Palette ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDeep = Color(0xFF4834D4);
  static const Color primarySoft = Color(0xFFEEEBFF);
  static const Color surface = Color(0xFFF9F8FE);
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF1A1530);
  static const Color textSecondary = Color(0xFF8E8AA0);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentGreen = Color(0xFF00C896);
  static const Color accentAmber = Color(0xFFFFB038);

  late final List<Map<String, String>> _allDestinations = [
    {
      "name": "Taj Mahal",
      "city": "Agra",
      "state": "Uttar Pradesh",
      "rating": "4.9",
      "tag": "UNESCO",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/1/1b/Taj_Mahal-08.jpg",
    },
    {
      "name": "Jaipur Palace",
      "city": "Jaipur",
      "state": "Rajasthan",
      "rating": "4.8",
      "tag": "Heritage",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/3/37/Hawa_Mahal_2011.jpg",
    },
    {
      "name": "Backwaters",
      "city": "Alleppey",
      "state": "Kerala",
      "rating": "4.9",
      "tag": "Nature",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/4/4e/Kerala_backwaters%2C_Houseboats%2C_India.jpg",
    },
    {
      "name": "Valley of Flowers",
      "city": "Chamoli",
      "state": "Uttarakhand",
      "rating": "4.7",
      "tag": "Trek",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/b/b0/Valley_of_flowers_%2829336158797%29.jpg",
    },
    {
      "name": "Goa Beaches",
      "city": "Panaji",
      "state": "Goa",
      "rating": "4.6",
      "tag": "Beach",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/3/3f/Palolem_Beach%2C_south_Goa.jpg",
    },
    {
      "name": "Varanasi Ghats",
      "city": "Varanasi",
      "state": "Uttar Pradesh",
      "rating": "4.8",
      "tag": "Spiritual",
      "cover":
          "https://upload.wikimedia.org/wikipedia/commons/b/b3/Varanasi_246_view_from_Gay_Ghat_towards_Ganges_river_%2833861353814%29.jpg",
    },
  ];

  late final List<Map<String, dynamic>> _mockTrips = [
    {
      'name': 'Rajasthan Heritage',
      'place': 'Jaipur',
      'date': 'Mar 2024',
      'days': '7 days',
      'status': 'Upcoming',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/3/37/Hawa_Mahal_2011.jpg',
      'members': 4,
    },
    {
      'name': 'Kerala Backwaters',
      'place': 'Alleppey',
      'date': 'Jan 2024',
      'days': '5 days',
      'status': 'Completed',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/4/4e/Kerala_backwaters%2C_Houseboats%2C_India.jpg',
      'members': 2,
    },
    {
      'name': 'Himalayan Trek',
      'place': 'Manali',
      'date': 'Dec 2023',
      'days': '10 days',
      'status': 'Completed',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/b/b0/Valley_of_flowers_%2829336158797%29.jpg',
      'members': 6,
    },
    {
      'name': 'Goa Beach Vacation',
      'place': 'Panaji',
      'date': 'Nov 2023',
      'days': '4 days',
      'status': 'Completed',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/3/3f/Palolem_Beach%2C_south_Goa.jpg',
      'members': 3,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filteredDestinations = _allDestinations;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredDestinations = query.isEmpty
          ? _allDestinations
          : _allDestinations
                .where(
                  (d) =>
                      d['name']!.toLowerCase().contains(query) ||
                      d['city']!.toLowerCase().contains(query) ||
                      d['state']!.toLowerCase().contains(query),
                )
                .toList();
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: surface,
        extendBody: true,
        bottomNavigationBar: !isWide ? _buildBottomNav() : null,
        body: Row(
          children: [
            if (isWide) _buildSideNav(),
            Expanded(child: _buildMainContent(isWide)),
          ],
        ),
        floatingActionButton:
            (_selectedIndex == 0 || _selectedIndex == 1) && !isWide
            ? _buildFAB()
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildMainContent(bool isWide) {
    switch (_selectedIndex) {
      case 1:
        return const CalendarViewScreen();
      case 2:
        return const CommunityPage();
      case 3:
        return const Center(child: Text('Saved Destinations (Coming Soon)'));
      case 4:
        return const ProfileSettingsPageWeb(
          themeColor: primary,
          accentColor: primaryDeep,
        );
      default:
        return _buildHomePage(isWide);
    }
  }

  // ── HOME PAGE ─────────────────────────────────────────────────────────────
  Widget _buildHomePage(bool isWide) {
    final hPad = isWide ? 40.0 : 20.0;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── HERO SLIVER APP BAR ──
        SliverAppBar(
          pinned: true,
          expandedHeight: isWide ? 0 : 220,
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          flexibleSpace: isWide
              ? null
              : FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _buildMobileHeroHeader(),
                ),
          title: _buildCollapsedTopBar(isWide),
          titleSpacing: 0,
          toolbarHeight: 64,
        ),

        // ── WELCOME + STATS ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _buildBannerSection()),
                      const SizedBox(width: 24),
                      Expanded(flex: 3, child: _buildBudgetCard()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMobileWelcomeRow(),
                      const SizedBox(height: 20),
                      _buildMobileStatsRow(),
                    ],
                  ),
          ),
        ),

        // ── SEARCH BAR ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 28, hPad, 0),
            child: _buildSearchBar(),
          ),
        ),

        // ── SECTION: Destinations ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 32, hPad, 16),
            child: _buildSectionHeader(
              _searchController.text.isEmpty
                  ? 'Popular in India'
                  : 'Search Results',
              onSeeAll: () {},
            ),
          ),
        ),

        // ── DESTINATION CARDS ──
        isWide
            ? SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.82,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _buildDestinationCard(_filteredDestinations[i]),
                    childCount: _filteredDestinations.length,
                  ),
                ),
              )
            : SliverToBoxAdapter(
                child: SizedBox(
                  height: 260,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: hPad,
                      vertical: 4,
                    ),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredDestinations.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (ctx, i) =>
                        _buildDestinationCardMobile(_filteredDestinations[i]),
                  ),
                ),
              ),

        // ── SECTION: Recent Trips ──
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 36, hPad, 16),
            child: _buildSectionHeader('Your Trips', onSeeAll: () {}),
          ),
        ),

        // ── TRIP CARDS ──
        isWide
            ? SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _buildTripCard(_mockTrips[i]),
                    childCount: _mockTrips.length,
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTripCardMobile(_mockTrips[i]),
                    ),
                    childCount: _mockTrips.length,
                  ),
                ),
              ),
      ],
    );
  }

  // ── MOBILE HERO HEADER ────────────────────────────────────────────────────
  Widget _buildMobileHeroHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.travel_explore,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'GlobeTrotter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      // Notification + Avatar
                      Row(
                        children: [
                          _buildIconBtn(
                            Icons.notifications_outlined,
                            Colors.white,
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileSettingsPageWeb(
                                  themeColor: primary,
                                  accentColor: primaryDeep,
                                ),
                              ),
                            ),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: const Center(
                                child: Text(
                                  'RD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Good Morning,\nRahul! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where are you exploring next?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── COLLAPSED TOP BAR (shown when scrolled) ───────────────────────────────
  Widget _buildCollapsedTopBar(bool isWide) {
    if (isWide) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.travel_explore,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'GlobeTrotter',
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
            _buildIconBtn(Icons.notifications_outlined, textSecondary),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileSettingsPageWeb(
                    themeColor: primary,
                    accentColor: primaryDeep,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: primarySoft,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: primary,
                      child: Text(
                        'RD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Rahul D.',
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    // Mobile: only visible when collapsed
    return const SizedBox.shrink();
  }

  Widget _buildIconBtn(IconData icon, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color == Colors.white
            ? Colors.white.withOpacity(0.15)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  // ── MOBILE WELCOME ROW ────────────────────────────────────────────────────
  Widget _buildMobileWelcomeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore India',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '4 trips planned this year',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 14, color: primary),
              SizedBox(width: 6),
              Text(
                '2024',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── MOBILE STATS ROW ──────────────────────────────────────────────────────
  Widget _buildMobileStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatChip(
            '₹24.5K',
            'Spent',
            accent,
            Icons.account_balance_wallet_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatChip(
            '₹5K',
            'Saved',
            accentGreen,
            Icons.savings_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatChip(
            '₹12K',
            'Upcoming',
            accentAmber,
            Icons.event_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: textSecondary),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isSearchFocused = focused),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 15, color: textPrimary),
          decoration: InputDecoration(
            hintText: 'Search destinations, cities...',
            hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
            prefixIcon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.search_rounded,
                color: _isSearchFocused ? primary : textSecondary,
                size: 22,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: textSecondary,
                      size: 18,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  )
                : Container(
                    margin: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: primary,
                      size: 18,
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: primary, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 4,
            ),
          ),
        ),
      ),
    );
  }

  // ── SECTION HEADER ────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── DESTINATION CARD — MOBILE (horizontal scroll) ─────────────────────────
  Widget _buildDestinationCardMobile(Map<String, String> dest) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DestinationDetailScreen(
            name: dest['name']!,
            city: dest['city']!,
            state: dest['state']!,
            rating: dest['rating']!,
            coverImage: dest['cover']!,
          ),
        ),
      ),
      child: Container(
        width: 185,
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: primaryDeep.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'dest_img_${dest['name']}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      child: Image.network(
                        dest['cover']!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: primarySoft,
                          child: const Icon(
                            Icons.image_outlined,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Tag badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        dest['tag'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: accentAmber,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            dest['rating']!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.15),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dest['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${dest['city']}, ${dest['state']}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  // ── DESTINATION CARD — WIDE ───────────────────────────────────────────────
  Widget _buildDestinationCard(Map<String, String> dest) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DestinationDetailScreen(
              name: dest['name']!,
              city: dest['city']!,
              state: dest['state']!,
              rating: dest['rating']!,
              coverImage: dest['cover']!,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryDeep.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'dest_img_${dest['name']}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.network(dest['cover']!, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dest['tag'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: accentAmber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dest['rating']!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dest['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 13,
                                color: textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${dest['city']}, ${dest['state']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primarySoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── TRIP CARD — MOBILE (vertical list) ───────────────────────────────────
  Widget _buildTripCardMobile(Map<String, dynamic> trip) {
    final isUpcoming = trip['status'] == 'Upcoming';
    return GestureDetector(
      onTap: () => _navigateToItinerary(trip),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryDeep.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: SizedBox(
                width: 110,
                height: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      trip['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: primarySoft),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.25),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            trip['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isUpcoming
                                ? primary.withOpacity(0.12)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            trip['status']!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isUpcoming
                                  ? primary
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 12,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trip['place']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 12,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${trip['date']} · ${trip['days']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.group_rounded,
                              size: 12,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${trip['members']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(
                Icons.chevron_right_rounded,
                color: textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── TRIP CARD — WIDE ─────────────────────────────────────────────────────
  Widget _buildTripCard(Map<String, dynamic> trip) {
    final isUpcoming = trip['status'] == 'Upcoming';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _navigateToItinerary(trip),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryDeep.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(trip['image']!, fit: BoxFit.cover),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isUpcoming ? primary : Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          trip['status']!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        trip['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            size: 13,
                            color: textSecondary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${trip['date']} · ${trip['days']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: textSecondary,
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
        ),
      ),
    );
  }

  // ── BANNER (wide only) ────────────────────────────────────────────────────
  Widget _buildBannerSection() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary, primaryDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryDeep.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -30,
            child: Icon(
              Icons.flight_takeoff_rounded,
              size: 150,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
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
                const SizedBox(height: 10),
                Text(
                  'From the Himalayas to Kerala\'s backwaters,\nexplore incredible India',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => setState(() => _selectedIndex = 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryDeep,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Exploring',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BUDGET CARD (wide only) ───────────────────────────────────────────────
  Widget _buildBudgetCard() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryDeep.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Budget Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'This Month',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          _buildBudgetItem(
            'Total Spent',
            '₹24,500',
            Icons.account_balance_wallet_rounded,
            accent,
          ),
          _buildBudgetItem(
            'Saved',
            '₹5,000',
            Icons.savings_rounded,
            accentGreen,
          ),
          _buildBudgetItem(
            'Upcoming',
            '₹12,000',
            Icons.event_rounded,
            accentAmber,
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── BOTTOM NAV ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavTab(Icons.home_rounded, 'Home', 0),
              _buildNavTab(Icons.explore_rounded, 'Explore', 1),
              _buildNavTab(Icons.luggage_rounded, 'Community', 2),
              _buildNavTab(Icons.bookmark_rounded, 'Saved', 3),
              _buildNavTab(Icons.person_rounded, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _selectedIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? primary : Colors.grey.shade500,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── SIDE NAV (wide) ───────────────────────────────────────────────────────
  Widget _buildSideNav() {
    return Container(
      width: 230,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.travel_explore,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 11),
                const Text(
                  'GlobeTrotter',
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          _buildSideNavItem(Icons.home_rounded, 'Home', 0),
          _buildSideNavItem(Icons.explore_rounded, 'Explore', 1),
          _buildSideNavItem(Icons.luggage_rounded, 'Community', 2),
          _buildSideNavItem(Icons.bookmark_rounded, 'Saved', 3),
          const Spacer(),
          const Divider(indent: 20, endIndent: 20),
          _buildSideNavItem(Icons.settings_rounded, 'Settings', 4),
          _buildSideNavItem(Icons.help_outline_rounded, 'Help', 5),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSideNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: isSelected ? primarySoft : Colors.transparent,
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
                  color: isSelected ? primary : Colors.grey.shade500,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? primary : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.w700
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

  // ── FAB ───────────────────────────────────────────────────────────────────
  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [primary, primaryDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () async {
            HapticFeedback.mediumImpact();
            final result = await showCreateTripDialog(context);
            if (result != null && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Trip Created!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              result.tripName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: primaryDeep,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'VIEW',
                    textColor: Colors.white,
                    onPressed: () => setState(() => _selectedIndex = 1),
                  ),
                ),
              );
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  'Plan Trip',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── NAVIGATION ────────────────────────────────────────────────────────────
  void _navigateToItinerary(Map<String, dynamic> trip) {
    final tripDetails = TripDetails(
      tripName: trip['name']!,
      place: trip['place']!,
      members: trip['members'] as int,
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 37)),
      date: trip['date']!,
      days: trip['days']!,
      status: trip['status']!,
      imageUrl: trip['image']!,
      itinerary: [
        DayItinerary(
          dayNumber: 1,
          activities: [
            Activity(
              name: 'Morning Temple Visit',
              description: 'Visit the ancient temple and participate...',
              expense: 500,
              time: '8:00 AM',
            ),
            Activity(
              name: 'City Tour',
              description: 'Explore major landmarks...',
              expense: 1200,
              time: '11:00 AM',
            ),
          ],
        ),
      ],
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItineraryViewScreen(tripDetails: tripDetails),
      ),
    );
  }
}
