import 'package:capsule/models/reminder.dart';
import 'package:capsule/providers/medicineReminderProvider.dart';
import 'package:capsule/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ==================== ReminderListItem ====================
class ReminderListItem extends StatefulWidget {
  final Reminder reminder;

  const ReminderListItem(this.reminder, {super.key});

  @override
  State<ReminderListItem> createState() => _ReminderListItemState();
}

class _ReminderListItemState extends State<ReminderListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isPast => widget.reminder.dateTime.isBefore(DateTime.now());
  bool get _isTaken => widget.reminder.isTaken;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Card(
          elevation: 2,
          shadowColor: _getStatusColor().withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _getStatusColor().withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              // الوقت والحالة
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.jm('ar').format(widget.reminder.dateTime),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: MyColors.darkNavyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: 16,
                    ),
                  ),
                ],
              ),
              // معلومات الدواء
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.reminder.medicineName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _isTaken && _isPast
                          ? MyColors.mediumGray
                          : MyColors.darkNavyBlue,
                      fontWeight: FontWeight.w600,
                      decoration: _isTaken && _isPast
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.reminder.label != null &&
                      widget.reminder.label!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        widget.reminder.label!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MyColors.mediumGray,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              // القائمة المنسدلة
              trailing: MenuAnchor(
                menuChildren: [
                  if (_isPast && !_isTaken)
                    MenuItemButton(
                      leadingIcon: const Icon(Icons.check_rounded),
                      child: const Text('تم'),
                      onPressed: () {
                        _performAction(() {
                          Provider.of<MedicineReminderProvider>(
                            context,
                            listen: false,
                          ).setIsTaken(!_isTaken, widget.reminder.id!);
                        });
                      },
                    ),
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.delete_outline_rounded),
                    child: const Text('حذف'),
                    onPressed: () {
                      _showDeleteConfirmation();
                    },
                  ),
                ],
                builder: (_, controller, __) => IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                  color: MyColors.primaryBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    if (_isPast) {
      return _isTaken ? Icons.check_circle_rounded : Icons.close_rounded;
    }
    return Icons.schedule_rounded;
  }

  Color _getStatusColor() {
    if (_isPast) {
      return _isTaken ? MyColors.accentTeal : MyColors.lightRed;
    }
    return MyColors.primaryBlue;
  }

  void _performAction(VoidCallback action) {
    _animationController.forward().then((_) {
      action();
      _animationController.reverse();
    });
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التنبيه'),
        content: const Text('هل تريد حذف هذا التنبيه بالفعل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performAction(() {
                Provider.of<MedicineReminderProvider>(
                  context,
                  listen: false,
                ).deleteReminder(widget.reminder.id!);
              });
            },
            style: TextButton.styleFrom(foregroundColor: MyColors.lightRed),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

// ==================== DayChip ====================
class DayChip extends StatelessWidget {
  const DayChip({
    super.key,
    this.label = '',
    this.selected = false,
    this.onSelected,
  });

  final String label;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 40),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? MyColors.white : MyColors.darkNavyBlue,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: MyColors.veryLightGray,
      selectedColor: MyColors.primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected
              ? MyColors.primaryBlue
              : MyColors.lightSkyBlue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      elevation: selected ? 4 : 0,
      shadowColor: selected ? MyColors.primaryBlue.withOpacity(0.3) : null,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
