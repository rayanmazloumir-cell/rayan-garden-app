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
  double _tiltX = 0;
  double _tiltY = 0;

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
    _controller = PageController(viewportFraction: .78);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(int index) {
    setState(() => _selected = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  void _resetTilt() {
    if (_tiltX == 0 && _tiltY == 0) return;
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              state.tr('tour_subtitle'),
              style: TextStyle(color: AppColors.ink.withAlpha(185), height: 1.7),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 350,
            child: PageView.builder(
              controller: _controller,
              itemCount: _locations.length,
              onPageChanged: (index) {
                setState(() {
                  _selected = index;
                  _tiltX = 0;
                  _tiltY = 0;
                });
              },
              itemBuilder: (context, index) => AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final page = _controller.hasClients && _controller.page != null
                      ? _controller.page!
                      : _selected.toDouble();
                  final offset = page - index;
                  final distance = offset.abs().clamp(0.0, 1.35).toDouble();
                  final normalized = (1 - distance).clamp(0.0, 1.0);
                  final rotationY = (offset * -0.52).clamp(-0.62, 0.62).toDouble();
                  final rotationX = (_tiltX * normalized).clamp(-0.12, 0.12).toDouble();
                  final gestureRotation = (_tiltY * normalized).clamp(-0.14, 0.14).toDouble();
                  final scale = .82 + normalized * .18;
                  final depth = normalized * 28;
                  final opacity = .58 + normalized * .42;
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.00125)
                    ..rotateY(rotationY + gestureRotation)
                    ..rotateX(rotationX)
                    ..translate(0.0, 0.0, depth);

                  return Transform(
                    alignment: Alignment.center,
                    transform: transform,
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                          child: _TourCard(
                            location: _locations[index],
                            title: state.tr(_locations[index].labelKey),
                            onPanUpdate: (details) {
                              setState(() {
                                _tiltY = (details.localPosition.dx - 150) / 1500;
                                _tiltX = -(details.localPosition.dy - 150) / 1800;
                              });
                            },
                            onPanEnd: (_) => _resetTilt(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.swipe_rounded, size: 17, color: AppColors.gold),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    state.tr('tour_3d_hint'),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.ink.withAlpha(165), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
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
                labelStyle: TextStyle(
                  color: index == _selected ? Colors.white : AppColors.darkGreen,
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (_) => _select(index),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.photo_camera_back_outlined, color: AppColors.gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.tr('tour_real_assets_note'),
                      style: const TextStyle(color: AppColors.ink, height: 1.65, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Text(
              state.tr('tour_selected', {'location': state.tr(location.labelKey)}),
              style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _TourCard extends StatelessWidget {
  const _TourCard({
    required this.location,
    required this.title,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  final _TourLocation location;
  final String title;
  final ValueChanged<DragUpdateDetails> onPanUpdate;
  final ValueChanged<DragEndDetails> onPanEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGreen.withAlpha(85),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(location.asset, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.darkGreen.withAlpha(220)],
                  ),
                ),
              ),
              PositionedDirectional(
                start: 20,
                bottom: 20,
                child: Row(
                  children: [
                    Icon(location.icon, color: AppColors.goldLight),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              PositionedDirectional(
                top: 16,
                end: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withAlpha(70)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 19),
                  ),
                ),
              ),
            ],
          ),
        ),
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
