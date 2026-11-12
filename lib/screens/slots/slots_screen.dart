import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/jalali.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../customer/customer_screen.dart';

class SlotsScreen extends StatefulWidget {
  const SlotsScreen({super.key});

  @override
  State<SlotsScreen> createState() => _SlotsScreenState();
}

class _SlotsScreenState extends State<SlotsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppScope.read(context).loadSlots();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final date = state.date;
    final slots = state.slots;
    final dateText = date == null ? '' : state.digits(jalaliLongDate(date, state.isFa));

    Widget body;
    if (slots.isFailure) {
      body = ErrorView(error: slots.error!, onRetry: state.loadSlots);
    } else if (slots.isSuccess) {
      final list = slots.data!;
      body = ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        children: [
          Text(
            state.tr('slots_for', {'d': dateText}),
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            state.digits(state.tr('slots_hint')),
            style: TextStyle(color: AppColors.ink.withAlpha(170), fontSize: 13, height: 1.8),
          ),
          const SizedBox(height: 16),
          if (list.isEmpty) ...[
            AppCard(
              child: Text(state.tr('slots_empty'), style: const TextStyle(height: 1.8)),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.calendar_month_rounded),
              label: Text(state.tr('change_date')),
            ),
          ] else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final t in list)
                  ChoiceChip(
                    label: Text(state.digits(t.label)),
                    selected: state.slot == t,
                    showCheckmark: false,
                    selectedColor: AppColors.darkGreen,
                    backgroundColor: AppColors.whiteWarm,
                    side: BorderSide(color: AppColors.gold.withAlpha(120)),
                    labelStyle: TextStyle(
                      color: state.slot == t ? Colors.white : AppColors.darkGreen,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    onSelected: (_) => state.selectSlot(t),
                  ),
              ],
            ),
        ],
      );
    } else {
      body = const LoadingView();
    }

    return StepScaffold(
      title: state.tr('slots_title'),
      step: 4,
      bottom: ElevatedButton(
        onPressed: state.slot == null
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const CustomerScreen()),
                ),
        child: Text(state.tr('continue')),
      ),
      child: body,
    );
  }
}
