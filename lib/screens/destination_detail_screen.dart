import 'package:flutter/material.dart';
import 'dart:ui';

/// Theme constants for the destination detail screen
abstract class DestinationTheme {
  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color accentColor = Color(0xFF0984E3);
  static const Color darkColor = Color(0xFF2D3436);
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color gradientStart = Color(0xFF6C5CE7);
  static const Color gradientEnd = Color(0xFF0984E3);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ratingGradient = LinearGradient(
    colors: [Color(0xFFFFC837), Color(0xFFFF8008)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  bool _isFavorite = false;

  static const _animationDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get _description {
    const descriptions = {
      'Taj Mahal':
          'An ivory-white marble mausoleum on the right bank of the river Yamuna. Built by Mughal emperor Shah Jahan in memory of his wife Mumtaz Mahal, it is widely recognized as the jewel of Muslim art in India and one of the universally admired masterpieces of the world\'s heritage.',
      'Jaipur Palace':
          'The Pink City is famous for its stunning palaces, forts, and vibrant culture. Hawa Mahal, City Palace, and Amber Fort are architectural marvels showcasing Rajputana grandeur and rich heritage.',
      'Backwaters':
          'A network of brackish lagoons and lakes lying parallel to the Arabian Sea coast. Famous for houseboat cruises, serene landscapes, and lush greenery offering a unique and tranquil experience.',
      'Valley of Flowers':
          'A UNESCO World Heritage Site, this alpine valley is renowned for its meadows of endemic alpine flowers and outstanding natural beauty. A paradise for nature lovers and trekkers.',
      'Goa Beaches':
          'Known for pristine beaches, Portuguese heritage, vibrant nightlife, and water sports. A perfect blend of relaxation, adventure, and cultural experiences.',
      'Varanasi Ghats':
          'One of the oldest living cities in the world, famous for its spiritual significance, ancient temples, and the sacred Ganges river ghats where elaborate ceremonies take place.',
    };
    return descriptions[widget.name] ??
        'Discover this amazing destination in India with rich culture, heritage, and natural beauty.';
  }

  List<ExpenseItem> get _travelExpenses => const [
    ExpenseItem(name: 'Accommodation', cost: 3000, icon: Icons.hotel),
    ExpenseItem(name: 'Transportation', cost: 1500, icon: Icons.directions_car),
    ExpenseItem(name: 'Food & Dining', cost: 2000, icon: Icons.restaurant),
    ExpenseItem(name: 'Entry Fees', cost: 500, icon: Icons.confirmation_number),
    ExpenseItem(name: 'Activities', cost: 1000, icon: Icons.local_activity),
  ];

  double get _totalCost =>
      _travelExpenses.fold(0.0, (sum, item) => sum + item.cost);

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    _showSnackBar(
      _isFavorite ? 'Added to favorites' : 'Removed from favorites',
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: DestinationTheme.darkColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DestinationTheme.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(opacity: _fadeAnimation.value, child: child),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 8),
                  _buildQuickStats(),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  _buildCostBreakdown(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      backgroundColor: DestinationTheme.cardBg,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _GlassIconButton(
          icon: Icons.arrow_back_ios_new,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassIconButton(
            icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
            iconColor: _isFavorite ? Colors.red : DestinationTheme.darkColor,
            onPressed: _toggleFavorite,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
          child: _GlassIconButton(
            icon: Icons.share_outlined,
            onPressed: () => _showSnackBar('Share feature coming soon!'),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'destination_${widget.name}',
              child: Image.network(
                widget.coverImage,
                fit: BoxFit.cover,
                loadingBuilder: _imageLoadingBuilder,
                errorBuilder: _imageErrorBuilder,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(102),
                    Colors.transparent,
                    Colors.black.withAlpha(179),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Container(
      color: DestinationTheme.lightBg,
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
              : null,
          valueColor: const AlwaysStoppedAnimation<Color>(
            DestinationTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _imageErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: DestinationTheme.primaryGradient,
      ),
      child: const Center(
        child: Icon(Icons.landscape, size: 100, color: Colors.white70),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        color: DestinationTheme.cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      transform: Matrix4.translationValues(0, -32, 0),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: DestinationTheme.darkColor,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                _buildLocationRow(),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildRatingBadge(),
        ],
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DestinationTheme.gradientStart.withAlpha(26),
                DestinationTheme.gradientEnd.withAlpha(26),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: DestinationTheme.primaryColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '${widget.city}, ${widget.state}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: DestinationTheme.ratingGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8008).withAlpha(102),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            widget.rating,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.access_time_rounded,
              value: '2-3 Days',
              label: 'Duration',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.groups_rounded,
              value: 'All Ages',
              label: 'Suitable For',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.camera_alt_rounded,
              value: 'Photo Spot',
              label: 'Type',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About This Destination',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: DestinationTheme.darkColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: DestinationTheme.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              _description,
              style: TextStyle(
                fontSize: 15,
                height: 1.8,
                color: Colors.grey.shade700,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Breakdown',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: DestinationTheme.darkColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildTotalCostCard(),
          const SizedBox(height: 20),
          ..._travelExpenses.asMap().entries.map((entry) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 600 + (entry.key * 100)),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: _ExpenseItemCard(expense: entry.value),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalCostCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: DestinationTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: DestinationTheme.primaryColor.withAlpha(77),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Estimated Cost',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _totalCost.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withAlpha(77)),
                ),
                child: const Text(
                  'Per Person',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: Colors.white.withAlpha(230),
                ),
                const SizedBox(width: 6),
                Text(
                  'Estimated for 2-3 days trip',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withAlpha(230),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _PrimaryActionButton(
            label: 'Plan Your Trip',
            icon: Icons.calendar_month_rounded,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 14),
          _SecondaryActionButton(
            label: 'View More Details',
            icon: Icons.explore_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.explore_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Text('More details coming soon!'),
                    ],
                  ),
                  backgroundColor: DestinationTheme.darkColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// MARK: - Supporting Widgets

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  const _GlassIconButton({
    required this.icon,
    required this.onPressed,
    this.iconColor = DestinationTheme.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(230),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(77), width: 1.5),
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor, size: 20),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DestinationTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DestinationTheme.gradientStart.withAlpha(26),
                  DestinationTheme.gradientEnd.withAlpha(26),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: DestinationTheme.primaryColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: DestinationTheme.darkColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ExpenseItem {
  final String name;
  final double cost;
  final IconData icon;

  const ExpenseItem({
    required this.name,
    required this.cost,
    required this.icon,
  });
}

class _ExpenseItemCard extends StatelessWidget {
  final ExpenseItem expense;

  const _ExpenseItemCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DestinationTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DestinationTheme.gradientStart.withAlpha(26),
                  DestinationTheme.gradientEnd.withAlpha(26),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              expense.icon,
              color: DestinationTheme.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              expense.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: DestinationTheme.darkColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DestinationTheme.gradientStart.withAlpha(26),
                  DestinationTheme.gradientEnd.withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '₹${expense.cost.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: DestinationTheme.primaryColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        gradient: DestinationTheme.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: DestinationTheme.primaryColor.withAlpha(102),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SecondaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: DestinationTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DestinationTheme.primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 22, color: DestinationTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: DestinationTheme.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
