import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globe_trotter/components/section_dialog.dart';

class CreateTripResult {
  final String tripName;
  final String place;
  final int? members;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<TripActivity> activities;

  const CreateTripResult({
    required this.tripName,
    required this.place,
    required this.members,
    required this.startDate,
    required this.endDate,
    required this.activities,
  });
}

Future<CreateTripResult?> showCreateTripDialog(BuildContext context) {
  return showDialog<CreateTripResult>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return const _CreateTripDialog();
    },
  );
}

class _CreateTripDialog extends StatefulWidget {
  const _CreateTripDialog();

  @override
  State<_CreateTripDialog> createState() => _CreateTripDialogState();
}

class _CreateTripDialogState extends State<_CreateTripDialog> {
  // Match the app's light palette (see MainPage): white surfaces, soft purple accent.
  static const Color _dialogBg = Colors.white;
  static const Color _accent = Color(0xFF8B7B9E);
  static const Color _divider = Color(0x1F000000);
  static const Color _border = Color(0x22000000);

  static const Color _textPrimary = Color(0xFF2D2A33);
  static const Color _textSecondary = Color(0xFF6F687A);
  static const Color _fieldFill = Color(0xFFF8F7FA);

  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  List<TripActivity> _activities = [];

  @override
  void dispose() {
    _tripNameController.dispose();
    _placeController.dispose();
    _membersController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  int? _parseMembers() {
    final raw = _membersController.text.trim();
    if (raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _accent,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      _startDate = picked;
      _startDateController.text = _formatDate(picked);
      if (_endDate != null && _endDate!.isBefore(picked)) {
        _endDate = null;
        _endDateController.clear();
      }
    });
  }

  Future<void> _pickEndDate() async {
    final base = _startDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? base,
      firstDate: base,
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _accent,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      _endDate = picked;
      _endDateController.text = _formatDate(picked);
    });
  }

  // Add validation check
  bool get _canAddActivities {
    return _tripNameController.text.trim().isNotEmpty &&
        _startDate != null &&
        _endDate != null;
  }

  Future<void> _openActivityDialog() async {
    // Check if required fields are filled
    if (!_canAddActivities) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill trip name, start date and end date first',
          ),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final result = await showActivityDialog(
      context,
      existingActivities: _activities.isNotEmpty ? _activities : null,
      tripName: _tripNameController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      members: _parseMembers() ?? 1,
    );
    if (result != null) {
      setState(() {
        _activities = result;
      });
    }
  }

  void _submit() {
    if (_tripNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a trip name'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      CreateTripResult(
        tripName: _tripNameController.text.trim(),
        place: _placeController.text.trim(),
        members: _parseMembers(),
        startDate: _startDate,
        endDate: _endDate,
        activities: _activities,
      ),
    );
  }

  double get _totalBudget => _activities.fold(0, (sum, a) => sum + a.budget);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width >= 900
        ? 820.0
        : (size.width - 32).clamp(320.0, 820.0);
    final maxHeight = (size.height * 0.88).clamp(420.0, 800.0);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: Container(
          decoration: BoxDecoration(
            color: _dialogBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTopTitleBar(),
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeaderRow(),
                      const SizedBox(height: 10),
                      _formCard(),
                      const SizedBox(height: 16),
                      _buildActivitiesSection(),
                      const SizedBox(height: 16),
                      _actionsRow(),
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

  Widget _buildTopTitleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _divider, width: 1)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Create a new Trip',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: _textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _divider, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.travel_explore,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'GlobeTrotter',
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _divider, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _divider, width: 1),
      ),
      child: Column(
        children: [
          _labeledField(
            label: 'Trip Name :',
            controller: _tripNameController,
            hintText: 'Enter your Trip name',
          ),
          const SizedBox(height: 10),
          _labeledField(
            label: 'Select a Place :',
            controller: _placeController,
            hintText: 'where are you heading?',
          ),
          const SizedBox(height: 10),
          _labeledNumberField(
            label: 'No. of Members :',
            controller: _membersController,
            hintText: 'eg : 2',
          ),
          const SizedBox(height: 10),
          _labeledDateField(
            label: 'Start Date :',
            controller: _startDateController,
            onPick: _pickStartDate,
          ),
          const SizedBox(height: 10),
          _labeledDateField(
            label: 'End Date :',
            controller: _endDateController,
            onPick: _pickEndDate,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection() {
    final isEnabled = _canAddActivities;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _divider, width: 1),
        color: isEnabled ? const Color(0xFFF8F7FA) : Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? _accent.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.event_note_rounded,
                  color: isEnabled ? _accent : Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activities & Itinerary',
                      style: TextStyle(
                        color: isEnabled ? _textPrimary : Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      !isEnabled
                          ? 'Fill trip details above to add activities'
                          : _activities.isEmpty
                          ? 'No activities added yet'
                          : '${_activities.length} activities • ₹${_totalBudget.toStringAsFixed(0)} total',
                      style: TextStyle(
                        color: isEnabled
                            ? _textSecondary
                            : Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: isEnabled ? _openActivityDialog : null,
                icon: Icon(
                  _activities.isEmpty ? Icons.add_rounded : Icons.edit_rounded,
                  size: 16,
                ),
                label: Text(_activities.isEmpty ? 'Add' : 'Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnabled ? _accent : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          if (_activities.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            SizedBox(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _activities.length > 5 ? 5 : _activities.length,
                itemBuilder: (context, index) {
                  if (index == 4 && _activities.length > 5) {
                    return _buildMoreActivitiesCard(_activities.length - 4);
                  }
                  return _buildActivityPreviewCard(_activities[index]);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityPreviewCard(TripActivity activity) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: activity.color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(activity.icon, color: activity.color, size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            activity.title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            '₹${activity.budget.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreActivitiesCard(int count) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '+$count',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _accent,
            ),
          ),
          const Text('more', style: TextStyle(fontSize: 11, color: _accent)),
        ],
      ),
    );
  }

  Widget _labeledNumberField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: _textField(
            controller: controller,
            hintText: hintText,
            readOnly: false,
            onTap: null,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ],
    );
  }

  Widget _labeledField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: _textField(
            controller: controller,
            hintText: hintText,
            readOnly: false,
            onTap: null,
          ),
        ),
      ],
    );
  }

  Widget _labeledDateField({
    required String label,
    required TextEditingController controller,
    required Future<void> Function() onPick,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: _textField(
            controller: controller,
            hintText: 'YYYY-MM-DD',
            readOnly: true,
            onTap: onPick,
            suffixIcon: Icons.calendar_today_rounded,
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
    required bool readOnly,
    required VoidCallback? onTap,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: _textPrimary, fontSize: 13),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 12),
        filled: true,
        fillColor: _fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: _divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, color: _textSecondary, size: 18),
      ),
    );
  }

  Widget _actionsRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: _textPrimary,
              side: const BorderSide(color: _divider),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create Trip',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
