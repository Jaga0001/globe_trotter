import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

/// Theme constants for the destination detail screen
abstract class DestinationTheme {
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color accentColor = Color(0xFF06B6D4);
  static const Color darkColor = Color(0xFF0F172A);
  static const Color darkMuted = Color(0xFF64748B);
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF1F5F9);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF06B6D4), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 32,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}

class DestinationDetailScreen extends StatefulWidget {
  final String name;
  final String city;
  final String state;
  final String rating;
  final String coverImage;

  const DestinationDetailScreen({
    super.key,
    required this.name,
    required this.city,
    required this.state,
    required this.rating,
    required this.coverImage,
  });

  @override
  State<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final TabController _tabController;
  late final ScrollController _scrollController;

  bool _isFavorite = false;
  bool _isAppBarCollapsed = false;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _onScroll() {
    final isCollapsed = _scrollController.offset > 280;
    if (isCollapsed != _isAppBarCollapsed) {
      setState(() => _isAppBarCollapsed = isCollapsed);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _description {
    const descriptions = {
      'Taj Mahal':
          'An ivory-white marble mausoleum on the right bank of the river Yamuna. Built by Mughal emperor Shah Jahan in memory of his wife Mumtaz Mahal, it is widely recognized as the jewel of Muslim art in India.',
      'Jaipur Palace':
          'The Pink City is famous for its stunning palaces, forts, and vibrant culture. Hawa Mahal, City Palace, and Amber Fort are architectural marvels showcasing Rajputana grandeur.',
      'Backwaters':
          'A network of brackish lagoons and lakes lying parallel to the Arabian Sea coast. Famous for houseboat cruises, serene landscapes, and lush greenery.',
      'Valley of Flowers':
          'A UNESCO World Heritage Site, this alpine valley is renowned for its meadows of endemic alpine flowers and outstanding natural beauty.',
      'Goa Beaches':
          'Known for pristine beaches, Portuguese heritage, vibrant nightlife, and water sports. A perfect blend of relaxation and adventure.',
      'Varanasi Ghats':
          'One of the oldest living cities in the world, famous for its spiritual significance and the sacred Ganges river ghats.',
    };
    return descriptions[widget.name] ??
        'Discover this amazing destination in India with rich culture, heritage, and natural beauty.';
  }

  List<String> get _galleryImages => [
    widget.coverImage,
    'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800',
    'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800',
    'https://images.unsplash.com/photo-1585135497273-1a86b09fe70e?w=800',
  ];

  List<_FeatureItem> get _features => const [
    _FeatureItem(
      icon: Icons.schedule_rounded,
      label: '2-3 Days',
      subtitle: 'Duration',
    ),
    _FeatureItem(
      icon: Icons.group_rounded,
      label: '2-6 People',
      subtitle: 'Group Size',
    ),
    _FeatureItem(
      icon: Icons.wb_sunny_rounded,
      label: 'Oct - Mar',
      subtitle: 'Best Season',
    ),
    _FeatureItem(
      icon: Icons.translate_rounded,
      label: 'English',
      subtitle: 'Language',
    ),
  ];

  List<ExpenseItem> get _travelExpenses => const [
    ExpenseItem(
      name: 'Accommodation',
      cost: 3000,
      icon: Icons.hotel_rounded,
      color: Color(0xFF6366F1),
    ),
    ExpenseItem(
      name: 'Transportation',
      cost: 1500,
      icon: Icons.directions_car_rounded,
      color: Color(0xFF06B6D4),
    ),
    ExpenseItem(
      name: 'Food & Dining',
      cost: 2000,
      icon: Icons.restaurant_rounded,
      color: Color(0xFFF59E0B),
    ),
    ExpenseItem(
      name: 'Entry Fees',
      cost: 500,
      icon: Icons.confirmation_number_rounded,
      color: Color(0xFF10B981),
    ),
    ExpenseItem(
      name: 'Activities',
      cost: 1000,
      icon: Icons.local_activity_rounded,
      color: Color(0xFFEF4444),
    ),
  ];

  double get _totalCost =>
      _travelExpenses.fold(0.0, (sum, item) => sum + item.cost);

  void _toggleFavorite() {
    HapticFeedback.lightImpact();
    setState(() => _isFavorite = !_isFavorite);
    _showSnackBar(_isFavorite ? 'Added to wishlist' : 'Removed from wishlist');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: DestinationTheme.darkColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DestinationTheme.lightBg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeroSection(),
              SliverToBoxAdapter(child: _buildContent()),
            ],
          ),
          _buildTopBar(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isAppBarCollapsed
              ? DestinationTheme.cardBg
              : Colors.transparent,
          boxShadow: _isAppBarCollapsed ? DestinationTheme.subtleShadow : null,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.pop(context),
                  isLight: !_isAppBarCollapsed,
                ),
                const Spacer(),
                if (_isAppBarCollapsed)
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: DestinationTheme.darkColor,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const Spacer(),
                _buildCircularButton(
                  icon: _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  onTap: _toggleFavorite,
                  isLight: !_isAppBarCollapsed,
                  iconColor: _isFavorite ? DestinationTheme.errorColor : null,
                ),
                const SizedBox(width: 8),
                _buildCircularButton(
                  icon: Icons.share_rounded,
                  onTap: () => _showSnackBar('Share feature coming soon!'),
                  isLight: !_isAppBarCollapsed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isLight = true,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isLight ? 10 : 0,
            sigmaY: isLight ? 10 : 0,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isLight
                  ? Colors.black.withOpacity(0.2)
                  : DestinationTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLight
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
              ),
            ),
            child: Icon(
              icon,
              size: 22,
              color:
                  iconColor ??
                  (isLight ? Colors.white : DestinationTheme.darkColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'destination_${widget.name}',
              child: Image.network(
                widget.coverImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: DestinationTheme.surfaceColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: DestinationTheme.primaryColor,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stack) => Container(
                  decoration: const BoxDecoration(
                    gradient: DestinationTheme.primaryGradient,
                  ),
                  child: const Icon(
                    Icons.landscape_rounded,
                    size: 64,
                    color: Colors.white38,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: DestinationTheme.successColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.city}, ${widget.state}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFBBF24),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: DestinationTheme.lightBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _buildTabBar(),
          const SizedBox(height: 20),
          _buildTabContent(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: DestinationTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTab('Overview', 0),
          _buildTab('Gallery', 1),
          _buildTab('Budget', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? DestinationTheme.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? DestinationTheme.subtleShadow : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? DestinationTheme.primaryColor
                  : DestinationTheme.darkMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: IndexedStack(
        key: ValueKey(_selectedTab),
        index: _selectedTab,
        children: [_buildOverviewTab(), _buildGalleryTab(), _buildBudgetTab()],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeaturesGrid(),
          const SizedBox(height: 28),
          _buildAboutSection(),
          const SizedBox(height: 28),
          _buildHighlightsSection(),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Row(
      children: _features.map((feature) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: feature != _features.last ? 12 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DestinationTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: DestinationTheme.subtleShadow,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: DestinationTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    feature.icon,
                    color: DestinationTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  feature.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: DestinationTheme.darkColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  feature.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: DestinationTheme.darkMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: DestinationTheme.darkColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _description,
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: DestinationTheme.darkMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightsSection() {
    final highlights = [
      _HighlightItem(
        icon: Icons.camera_alt_rounded,
        title: 'Photography',
        desc: 'Stunning photo spots',
      ),
      _HighlightItem(
        icon: Icons.restaurant_rounded,
        title: 'Local Cuisine',
        desc: 'Authentic flavors',
      ),
      _HighlightItem(
        icon: Icons.history_rounded,
        title: 'Rich History',
        desc: 'Cultural heritage',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Highlights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: DestinationTheme.darkColor,
          ),
        ),
        const SizedBox(height: 16),
        ...highlights.map(
          (h) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DestinationTheme.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: DestinationTheme.subtleShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: DestinationTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(h.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: DestinationTheme.darkColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        h.desc,
                        style: TextStyle(
                          fontSize: 13,
                          color: DestinationTheme.darkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: DestinationTheme.darkMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: DestinationTheme.darkColor,
                ),
              ),
              Text(
                '${_galleryImages.length} images',
                style: TextStyle(
                  fontSize: 14,
                  color: DestinationTheme.darkMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _galleryImages.length,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right: index < _galleryImages.length - 1 ? 16 : 0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: DestinationTheme.subtleShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    _galleryImages[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: DestinationTheme.surfaceColor,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: List.generate(6, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: DestinationTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: index < _galleryImages.length
                      ? Image.network(
                          _galleryImages[index % _galleryImages.length],
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Icon(
                            Icons.add_rounded,
                            color: DestinationTheme.darkMuted,
                          ),
                        ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTotalBudgetCard(),
          const SizedBox(height: 24),
          const Text(
            'Cost Breakdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: DestinationTheme.darkColor,
            ),
          ),
          const SizedBox(height: 16),
          ..._travelExpenses.map(
            (expense) => _ExpenseRow(expense: expense, total: _totalCost),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBudgetCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: DestinationTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: DestinationTheme.primaryColor.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
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
                'Estimated Budget',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Per Person',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '₹',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _totalCost),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Prices are estimates and may vary based on season',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: DestinationTheme.cardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'From',
                    style: TextStyle(
                      fontSize: 12,
                      color: DestinationTheme.darkMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${_totalCost.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: DestinationTheme.darkColor,
                        ),
                      ),
                      Text(
                        ' /person',
                        style: TextStyle(
                          fontSize: 13,
                          color: DestinationTheme.darkMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showSnackBar('Booking feature coming soon!');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: DestinationTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: DestinationTheme.primaryColor.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Data Models & Supporting Widgets

class _FeatureItem {
  final IconData icon;
  final String label;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}

class _HighlightItem {
  final IconData icon;
  final String title;
  final String desc;

  const _HighlightItem({
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class ExpenseItem {
  final String name;
  final double cost;
  final IconData icon;
  final Color color;

  const ExpenseItem({
    required this.name,
    required this.cost,
    required this.icon,
    this.color = DestinationTheme.primaryColor,
  });
}

class _ExpenseRow extends StatelessWidget {
  final ExpenseItem expense;
  final double total;

  const _ExpenseRow({required this.expense, required this.total});

  @override
  Widget build(BuildContext context) {
    final percentage = expense.cost / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DestinationTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: DestinationTheme.subtleShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: expense.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(expense.icon, color: expense.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  expense.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: DestinationTheme.darkColor,
                  ),
                ),
              ),
              Text(
                '₹${expense.cost.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: expense.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percentage),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: expense.color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(expense.color),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
