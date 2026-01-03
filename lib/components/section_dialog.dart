import 'package:flutter/material.dart';

// Color scheme
const Color primaryPurple = Color(0xFF8B7B9E);
const Color darkPurple = Color(0xFF6B5B7A);
const Color lightPurple = Color(0xFFF0ECF4);
const Color accentPurple = Color(0xFFADA1BC);

// Predefined activities with budget
final List<PredefinedActivity> predefinedActivities = [
  PredefinedActivity(
    name: 'Flight',
    icon: Icons.flight_rounded,
    estimatedBudget: 5000,
    color: Colors.blue,
  ),
  PredefinedActivity(
    name: 'Hotel Stay',
    icon: Icons.hotel_rounded,
    estimatedBudget: 3000,
    color: Colors.green,
  ),
  PredefinedActivity(
    name: 'Taj Mahal Visit',
    icon: Icons.account_balance_rounded,
    estimatedBudget: 1500,
    color: Colors.orange,
  ),
  PredefinedActivity(
    name: 'City Palace Tour',
    icon: Icons.castle_rounded,
    estimatedBudget: 800,
    color: Colors.purple,
  ),
  PredefinedActivity(
    name: 'Hawa Mahal',
    icon: Icons.window_rounded,
    estimatedBudget: 500,
    color: Colors.pink,
  ),
  PredefinedActivity(
    name: 'Desert Safari',
    icon: Icons.landscape_rounded,
    estimatedBudget: 2500,
    color: Colors.amber,
  ),
  PredefinedActivity(
    name: 'Boat Ride',
    icon: Icons.directions_boat_rounded,
    estimatedBudget: 600,
    color: Colors.cyan,
  ),
  PredefinedActivity(
    name: 'Temple Visit',
    icon: Icons.temple_hindu_rounded,
    estimatedBudget: 200,
    color: Colors.deepPurple,
  ),
  PredefinedActivity(
    name: 'Local Food Tour',
    icon: Icons.restaurant_rounded,
    estimatedBudget: 1000,
    color: Colors.red,
  ),
  PredefinedActivity(
    name: 'Shopping',
    icon: Icons.shopping_bag_rounded,
    estimatedBudget: 2000,
    color: Colors.teal,
  ),
  PredefinedActivity(
    name: 'Museum Visit',
    icon: Icons.museum_rounded,
    estimatedBudget: 400,
    color: Colors.brown,
  ),
  PredefinedActivity(
    name: 'Trekking',
    icon: Icons.hiking_rounded,
    estimatedBudget: 1200,
    color: Colors.indigo,
  ),
];

class PredefinedActivity {
  final String name;
  final IconData icon;
  final double estimatedBudget;
  final Color color;

  PredefinedActivity({
    required this.name,
    required this.icon,
    required this.estimatedBudget,
    required this.color,
  });
}

// Function to show the dialog
Future<List<TripActivity>?> showActivityDialog(
  BuildContext context, {
  List<TripActivity>? existingActivities,
}) {
  return showDialog<List<TripActivity>>(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        ActivityDialog(existingActivities: existingActivities),
  );
}

class ActivityDialog extends StatefulWidget {
  final List<TripActivity>? existingActivities;

  const ActivityDialog({super.key, this.existingActivities});

  @override
  State<ActivityDialog> createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<ActivityDialog> {
  late List<TripActivity> _activities;

  @override
  void initState() {
    super.initState();
    _activities = widget.existingActivities ?? [];
  }

  double get _totalBudget => _activities.fold(0, (sum, a) => sum + a.budget);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWideScreen = screenWidth > 900;
    final dialogWidth = isWideScreen ? 750.0 : screenWidth * 0.95;
    final dialogHeight = screenHeight * 0.88;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FA),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDialogHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTripInfoCard(),
                    const SizedBox(height: 20),
                    _buildBudgetSummary(),
                    const SizedBox(height: 24),
                    _buildPredefinedActivitiesSection(),
                    const SizedBox(height: 24),
                    _buildSelectedActivitiesSection(),
                    const SizedBox(height: 16),
                    _buildAddCustomActivityButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildDialogActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: lightPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_note_rounded,
              color: darkPurple,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan Your Activities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Select from suggestions or add your own',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryPurple, darkPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rajasthan Heritage Tour',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mar 15 - Mar 22, 2024 • 4 Travelers',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_activities.length} Activities',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentPurple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Total Budget',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹${_totalBudget.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Per Person',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
              Text(
                '₹${(_totalBudget / 4).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredefinedActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suggested Activities',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkPurple,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tap to add to your itinerary',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
          ),
          itemCount: predefinedActivities.length,
          itemBuilder: (context, index) {
            final activity = predefinedActivities[index];
            final isAdded = _activities.any(
              (a) => a.title == activity.name && !a.isCustom,
            );
            return _buildPredefinedActivityCard(activity, isAdded);
          },
        ),
      ],
    );
  }

  Widget _buildPredefinedActivityCard(
    PredefinedActivity activity,
    bool isAdded,
  ) {
    return InkWell(
      onTap: () {
        if (!isAdded) {
          _showAddPredefinedActivityDialog(activity);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isAdded ? activity.color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAdded ? activity.color : accentPurple.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: activity.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(activity.icon, color: activity.color, size: 22),
                ),
                if (isAdded)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              activity.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isAdded ? activity.color : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '₹${activity.estimatedBudget.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 10,
                color: isAdded ? activity.color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedActivitiesSection() {
    if (_activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: lightPurple.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentPurple.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_busy_rounded,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              'No activities added yet',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'Select from suggestions above or add custom',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Itinerary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkPurple,
              ),
            ),
            Text(
              '${_activities.length} activities',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._activities.asMap().entries.map(
          (entry) => _buildSelectedActivityCard(entry.value, entry.key),
        ),
      ],
    );
  }

  Widget _buildSelectedActivityCard(TripActivity activity, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: activity.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(activity.icon, color: activity.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (activity.isCustom)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${_formatDateTime(activity.startDateTime)} - ${_formatDateTime(activity.endDateTime)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${activity.budget.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _editActivity(index),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => setState(() => _activities.removeAt(index)),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCustomActivityButton() {
    return InkWell(
      onTap: _showAddCustomActivityDialog,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryPurple.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: lightPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: darkPurple, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'Add Custom Activity',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: accentPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: darkPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _activities),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Save Activities',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPredefinedActivityDialog(PredefinedActivity predefined) {
    final budgetController = TextEditingController(
      text: predefined.estimatedBudget.toStringAsFixed(0),
    );
    DateTime startDate = DateTime.now().add(const Duration(days: 1, hours: 9));
    DateTime endDate = DateTime.now().add(const Duration(days: 1, hours: 12));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: predefined.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(predefined.icon, color: predefined.color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                predefined.name,
                style: const TextStyle(color: darkPurple, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogLabel('Budget (₹)'),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration('Enter budget'),
                ),
                const SizedBox(height: 16),
                _buildDialogLabel('Start Date & Time'),
                _buildDateTimeSelector(
                  startDate,
                  (dt) => setDialogState(() => startDate = dt),
                ),
                const SizedBox(height: 16),
                _buildDialogLabel('End Date & Time'),
                _buildDateTimeSelector(
                  endDate,
                  (dt) => setDialogState(() => endDate = dt),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: darkPurple)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _activities.add(
                    TripActivity(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: predefined.name,
                      startDateTime: startDate,
                      endDateTime: endDate,
                      budget:
                          double.tryParse(budgetController.text) ??
                          predefined.estimatedBudget,
                      icon: predefined.icon,
                      color: predefined.color,
                      isCustom: false,
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCustomActivityDialog({TripActivity? existing}) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final budgetController = TextEditingController(
      text: existing?.budget.toStringAsFixed(0) ?? '',
    );
    DateTime startDate =
        existing?.startDateTime ??
        DateTime.now().add(const Duration(days: 1, hours: 9));
    DateTime endDate =
        existing?.endDateTime ??
        DateTime.now().add(const Duration(days: 1, hours: 12));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                existing != null ? Icons.edit_rounded : Icons.add_task_rounded,
                color: primaryPurple,
              ),
              const SizedBox(width: 10),
              Text(
                existing != null ? 'Edit Activity' : 'Add Custom Activity',
                style: const TextStyle(color: darkPurple, fontSize: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogLabel('Activity Title'),
                TextField(
                  controller: titleController,
                  decoration: _buildInputDecoration('e.g., Visit local market'),
                ),
                const SizedBox(height: 16),
                _buildDialogLabel('Budget (₹)'),
                TextField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration('Enter budget'),
                ),
                const SizedBox(height: 16),
                _buildDialogLabel('Start Date & Time'),
                _buildDateTimeSelector(
                  startDate,
                  (dt) => setDialogState(() => startDate = dt),
                ),
                const SizedBox(height: 16),
                _buildDialogLabel('End Date & Time'),
                _buildDateTimeSelector(
                  endDate,
                  (dt) => setDialogState(() => endDate = dt),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: darkPurple)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  if (existing != null) {
                    setState(() {
                      existing.title = titleController.text;
                      existing.budget =
                          double.tryParse(budgetController.text) ?? 0;
                      existing.startDateTime = startDate;
                      existing.endDateTime = endDate;
                    });
                  } else {
                    setState(() {
                      _activities.add(
                        TripActivity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: titleController.text,
                          startDateTime: startDate,
                          endDateTime: endDate,
                          budget: double.tryParse(budgetController.text) ?? 0,
                          icon: Icons.event_rounded,
                          color: primaryPurple,
                          isCustom: true,
                        ),
                      );
                    });
                  }
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                existing != null ? 'Update' : 'Add',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: darkPurple,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildDateTimeSelector(
    DateTime dateTime,
    Function(DateTime) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final result = await _showDateTimePickerDialog(context, dateTime);
        if (result != null) onChanged(result);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: primaryPurple),
            const SizedBox(width: 10),
            Text(
              _formatDateTimeFull(dateTime),
              style: const TextStyle(fontSize: 13),
            ),
            const Spacer(),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showDateTimePickerDialog(
    BuildContext context,
    DateTime initialDate,
  ) async {
    DateTime selectedDate = initialDate;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(initialDate);

    return showDialog<DateTime>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: primaryPurple),
              const SizedBox(width: 10),
              const Text(
                'Select Date & Time',
                style: TextStyle(color: darkPurple, fontSize: 18),
              ),
            ],
          ),
          content: SizedBox(
            width: 350,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: accentPurple.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      onDateChanged: (date) =>
                          setDialogState(() => selectedDate = date),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: ctx,
                        initialTime: selectedTime,
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: primaryPurple,
                              onPrimary: Colors.white,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (time != null)
                        setDialogState(() => selectedTime = time);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: lightPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time_rounded, color: primaryPurple),
                          const SizedBox(width: 10),
                          Text(
                            selectedTime.format(ctx),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: darkPurple,
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: darkPurple)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(
                ctx,
                DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editActivity(int index) =>
      _showAddCustomActivityDialog(existing: _activities[index]);

  String _formatDateTime(DateTime dt) {
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
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, $hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDateTimeFull(DateTime dt) {
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
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}

class TripActivity {
  int id;
  String title;
  DateTime startDateTime;
  DateTime endDateTime;
  double budget;
  IconData icon;
  Color color;
  bool isCustom;

  TripActivity({
    required this.id,
    required this.title,
    required this.startDateTime,
    required this.endDateTime,
    required this.budget,
    required this.icon,
    required this.color,
    required this.isCustom,
  });
}
