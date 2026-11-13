import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/local/local_simulated_backend.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../auth/auth_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(state.tr('offers_title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.local_offer_rounded, color: AppColors.goldLight),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.tr('offers_intro_title'), style: const TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(state.tr('offers_intro_body'), style: const TextStyle(color: AppColors.ink, height: 1.65, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...state.localOffers.map((offer) => _OfferCard(offer: offer, lang: state.lang)),
          const SizedBox(height: 8),
          if (!state.isLocalVipMember)
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AuthScreen())),
              icon: const Icon(Icons.workspace_premium_rounded),
              label: Text(state.tr('offers_join_vip')),
            )
          else
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: AppColors.success),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.tr('offers_vip_active'), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w800))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer, required this.lang});

  final LocalOffer offer;
  final String lang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(20)),
                  child: Text(offer.badge, style: const TextStyle(color: AppColors.darkGreen, fontSize: 10, fontWeight: FontWeight.w900)),
                ),
                const Spacer(),
                Text(offer.discount, style: const TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 10),
            Text(offer.title(lang), style: const TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(offer.description(lang), style: const TextStyle(color: AppColors.ink, height: 1.65, fontSize: 13)),
            const SizedBox(height: 13),
            Row(
              children: [
                const Icon(Icons.confirmation_number_outlined, size: 18, color: AppColors.gold),
                const SizedBox(width: 6),
                Text('${AppScope.of(context).tr('offers_code')}: ${offer.code}', style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
