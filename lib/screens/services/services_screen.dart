import 'package:flutter/material.dart';

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
      body = ErrorView(
        error: services.error!,
        onRetry: () => state.loadServices(force: true),
      );
    } else if (services.isSuccess) {
      final list = services.data!;
      body = list.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(state.tr('services_empty'),
                    textAlign: TextAlign.center),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: list.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      state.tr('services_subtitle'),
                      style: TextStyle(
                          color: AppColors.ink.withAlpha(190), fontSize: 15),
                    ),
                  );
                }
                return _ServiceTile(service: list[i - 1]);
              },
            );
    } else {
      body = const LoadingView();
    }

    return StepScaffold(
      title: state.tr('services_title'),
      step: 1,
      child: body,
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});

  final ServiceItem service;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final minutes = state.durationOf(service);
    return AppCard(
      onTap: () {
        state.selectService(service);
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ServiceDetailScreen()),
        );
      },
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.photo_camera_outlined, color: AppColors.gold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.displayName(state.isFa),
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (minutes != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    state.digits(state.tr('duration_min', {'n': '$minutes'})),
                    style: TextStyle(
                        color: AppColors.ink.withAlpha(160), fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          Icon(forwardIcon(context), color: AppColors.gold),
        ],
      ),
    );
  }
}
