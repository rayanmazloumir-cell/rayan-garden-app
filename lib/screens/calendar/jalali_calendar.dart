import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/jalali.dart';
import '../../state/app_scope.dart';

/// Month grid in the Persian (Jalali) calendar, Saturday first.
class JalaliCalendar extends StatefulWidget {
  const JalaliCalendar({
    super.key,
    required this.minDate,
    required this.maxDate,
    required this.today,
    required this.selected,
    required this.onSelected,
  });

  final DateTime minDate; // inclusive, DateTime.utc date-only
  final DateTime maxDate; // inclusive
  final DateTime today;
  final DateTime? selected;
  final ValueChanged<DateTime> onSelected;

  @override
  State<JalaliCalendar> createState() => _JalaliCalendarState();
}

class _JalaliCalendarState extends State<JalaliCalendar> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final start = JalaliDate.fromGregorian(widget.selected ?? widget.minDate);
    _year = start.year;
    _month = start.month;
  }

  JalaliDate get _minJ => JalaliDate.fromGregorian(widget.minDate);
  JalaliDate get _maxJ => JalaliDate.fromGregorian(widget.maxDate);

  bool get _canGoPrev =>
      _year > _minJ.year || (_year == _minJ.year && _month > _minJ.month);
  bool get _canGoNext =>
      _year < _maxJ.year || (_year == _maxJ.year && _month < _maxJ.month);

  void _shift(int delta) {
    setState(() {
      var m = _month + delta;
      var y = _year;
      if (m < 1) {
        m = 12;
        y--;
      } else if (m > 12) {
        m = 1;
        y++;
      }
      _year = y;
      _month = m;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final fa = state.isFa;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final monthName = (fa ? jalaliMonthsFa : jalaliMonthsEn)[_month - 1];
    final shortDays = fa ? weekdaysShortFa : weekdaysShortEn;

    final firstG = JalaliDate(_year, _month, 1).toGregorian();
    final offset = JalaliDate.weekdayIndex(firstG);
    final length = JalaliDate.monthLength(_year, _month);

    final cells = <Widget>[];
    for (var i = 0; i < offset; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var d = 1; d <= length; d++) {
      final g = JalaliDate(_year, _month, d).toGregorian();
      final enabled = !g.isBefore(widget.minDate) && !g.isAfter(widget.maxDate);
      final isSelected = sameDay(g, widget.selected);
      final isToday = sameDay(g, widget.today);
      cells.add(_DayCell(
        label: state.digits('$d'),
        enabled: enabled,
        selected: isSelected,
        today: isToday,
        onTap: () => widget.onSelected(g),
      ));
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: state.tr('prev_month'),
              onPressed: _canGoPrev ? () => _shift(-1) : null,
              icon: Icon(rtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                state.digits('$monthName $_year'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              tooltip: state.tr('next_month'),
              onPressed: _canGoNext ? () => _shift(1) : null,
              icon: Icon(rtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final d in shortDays)
              Expanded(
                child: Center(
                  child: Text(d,
                      style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                        fontSize: fa ? 14 : 12,
                      )),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: cells,
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.enabled,
    required this.selected,
    required this.today,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final bool selected;
  final bool today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color textColor = selected
        ? Colors.white
        : enabled
            ? AppColors.ink
            : AppColors.ink.withAlpha(70);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.darkGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: today && !selected
              ? Border.all(color: AppColors.gold, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: selected || today ? FontWeight.w800 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
