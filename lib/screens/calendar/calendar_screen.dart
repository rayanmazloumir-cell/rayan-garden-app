import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/jalali.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../slots/slots_screen.dart';
import 'jalali_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final date = state.date;

    return StepScaffold(
      title: state.tr('calendar_title'),
      step: 3,
      bottom: ElevatedButton(
        onPressed: date == null
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const SlotsScreen()),
                ),
        child: Text(state.tr('continue')),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        children: [
          Text(
            state.digits(state.tr('calendar_hint', {'n': '${AppConfig.maxAheadDays}'})),
            style: TextStyle(color: AppColors.ink.withAlpha(180), height: 1.8, fontSize: 13),
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: JalaliCalendar(
              minDate: state.today,
              maxDate: state.lastBookableDate,
              today: state.today,
              selected: date,
              onSelected: state.selectDate,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            date == null
                ? state.tr('calendar_none')
                : state.digits(state.tr('calendar_selected',
                    {'d': jalaliLongDate(date, state.isFa)})),
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
