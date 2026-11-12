import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';

class GardenTourScreen extends StatefulWidget {
  const GardenTourScreen({super.key});

  @override
  State<GardenTourScreen> createState() => _GardenTourScreenState();
}

class _GardenTourScreenState extends State<GardenTourScreen> {
  late final PageController _controller;
  int _selected = 0;

  static const _locations = <_TourLocation>[
    _TourLocation('tour_hero', 'assets/images/rayan_garden_home.png', Icons.landscape_rounded),
    _TourLocation('tour_wedding', 'assets/images/service_wedding.jpg', Icons.favorite_border_rounded),
    _TourLocation('tour_formal', 'assets/images/service_formality.jpg', Icons.auto_awesome_rounded),
    _TourLocation('tour_children', 'assets/images/service_children.jpg', Icons.child_care_rounded),
    _TourLocation('tour_family', 'assets/images/service_family.jpg', Icons.groups_rounded),
    _TourLocation('tour_cafe', 'assets/images/service_cafe.jpg', Icons.local_cafe_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .86);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(int index) {
    setState(() => _selected = index);
    _controller.animateToPage(index, duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final location = _locations[_selected];
    return Scaffold(
      appBar: AppBar(title: Text(state.tr('tour_title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 30),
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(state.tr('tour_subtitle'), style: TextStyle(color: AppColors.ink.withAlpha(185), height: 1.7))),
          const SizedBox(height: 18),
          SizedBox(
            height: 310,
            child: PageView.builder(
              controller: _controller,
              itemCount: _locations.length,
              onPageChanged: (index) => setState(() => _selected = index),
              itemBuilder: (context, index) => AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  var distance = 0.0;
                  if (_controller.hasClients && _controller.page != null) distance = (_controller.page! - index).abs().clamp(0.0, 1.0).toDouble();
                  final scale = 1 - distance * .08;
                  return Transform.scale(scale: scale, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: child));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(fit: StackFit.expand, children: [
                    Image.asset(_locations[index].asset, fit: BoxFit.cover),
                    DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AppColors.darkGreen.withAlpha(205)]))),
                    PositionedDirectional(start: 18, bottom: 18, child: Row(children: [Icon(_locations[index].icon, color: AppColors.goldLight), const SizedBox(width: 8), Text(state.tr(_locations[index].labelKey), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900))])),
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _locations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) => ChoiceChip(
                selected: index == _selected,
                showCheckmark: false,
                selectedColor: AppColors.darkGreen,
                backgroundColor: AppColors.whiteWarm,
                side: BorderSide(color: AppColors.gold.withAlpha(100)),
                label: Text(state.tr(_locations[index].labelKey)),
                labelStyle: TextStyle(color: index == _selected ? Colors.white : AppColors.darkGreen, fontWeight: FontWeight.w700),
                onSelected: (_) => _select(index),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(20, 22, 20, 0), child: AppCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.photo_camera_back_outlined, color: AppColors.gold), const SizedBox(width: 10), Expanded(child: Text(state.tr('tour_real_assets_note'), style: const TextStyle(color: AppColors.ink, height: 1.65, fontSize: 13)))]))),
          Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 0), child: Text(state.tr('tour_selected', {'location': state.tr(location.labelKey)}), style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}

class _TourLocation {
  const _TourLocation(this.labelKey, this.asset, this.icon);
  final String labelKey;
  final String asset;
  final IconData icon;
}
