import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/service_item.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../service_detail/service_detail_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppScope.read(context).loadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final services = state.services;
    Widget body;
    if (services.isFailure) {
      body = ErrorView(error: services.error!, onRetry: () => state.loadServices(force: true));
    } else if (services.isSuccess) {
      final list = services.data!;
      body = list.isEmpty
          ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(state.tr('services_empty'), textAlign: TextAlign.center)))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
              children: [
                _ServiceIntro(state: state),
                const SizedBox(height: 18),
                ...list.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: _ServiceCard(service: entry.value, index: entry.key),
                    )),
                const SizedBox(height: 6),
                AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, color: AppColors.gold),
                      const SizedBox(width: 10),
                      Expanded(child: Text(state.tr('services_backend_note'), style: const TextStyle(color: AppColors.ink, height: 1.55, fontSize: 12))),
                    ],
                  ),
                ),
              ],
            );
    } else {
      body = const LoadingView();
    }
    return StepScaffold(title: state.tr('services_title'), step: 1, child: body);
  }
}

class _ServiceIntro extends StatelessWidget {
  const _ServiceIntro({required this.state});
  final dynamic state;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(25), gradient: const LinearGradient(colors: [AppColors.darkGreen, AppColors.forest])),
        child: Row(
          children: [
            Container(width: 46, height: 46, decoration: BoxDecoration(color: AppColors.gold.withAlpha(35), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.auto_awesome_rounded, color: AppColors.goldLight)),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(state.tr('services_subtitle'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)), const SizedBox(height: 4), Text(state.tr('services_hours', {'from': AppConfig.openingTime, 'to': AppConfig.closingTime}), style: const TextStyle(color: AppColors.goldLight, fontSize: 12))])),
          ],
        ),
      );
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.index});
  final ServiceItem service;
  final int index;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final icons = [Icons.favorite_border_rounded, Icons.auto_awesome_rounded, Icons.child_care_rounded, Icons.groups_rounded, Icons.local_cafe_rounded];
    final minutes = state.durationOf(service);
    return AppCard(
      onTap: () {
        state.selectService(service);
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ServiceDetailScreen()));
      },
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            Container(width: 76, height: 126, color: index.isEven ? AppColors.darkGreen : AppColors.forest, child: Icon(icons[index % icons.length], color: AppColors.goldLight, size: 29)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Expanded(child: Text(service.displayName(state.isFa), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.darkGreen, fontSize: 16, fontWeight: FontWeight.w900))), Icon(forwardIcon(context), color: AppColors.gold)]),
                    const SizedBox(height: 8),
                    if (minutes != null) Row(children: [const Icon(Icons.schedule_rounded, size: 16, color: AppColors.gold), const SizedBox(width: 5), Text(state.digits(state.tr('duration_min', {'n': '$minutes'})), style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700))]),
                    if (service.deposit != null || service.price != null) ...[const SizedBox(height: 7), Text(state.tr('service_payment_available'), style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700))],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
