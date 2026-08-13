import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _actions = ['Je pars', 'Coucou', 'T’es où ?'];
  DateTime? _lastHereAt;
  Timer? _clock;

  final _relatives = const [
    _Relative(name: 'Famille', status: 'Tout va bien', icon: Icons.home_rounded),
    _Relative(name: 'Amis', status: 'Aucune alerte', icon: Icons.favorite_rounded),
  ];

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void _markHere() {
    setState(() => _lastHereAt = DateTime.now());
    _clock ??= Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('C’est envoyé : tu es là.')));
  }

  String get _hereLabel {
    final sentAt = _lastHereAt;
    if (sentAt == null) return 'Donner un signe à mes proches';
    final elapsed = DateTime.now().difference(sentAt);
    if (elapsed.inMinutes < 1) return 'Signalé à l’instant';
    if (elapsed.inMinutes == 1) return 'Signalé il y a 1 min';
    if (elapsed.inMinutes < 60) return 'Signalé il y a ${elapsed.inMinutes} min';
    return 'Signalé il y a ${elapsed.inHours} h';
  }

  void _showComingSoon(String action) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$action — fonction bientôt disponible')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('T’es où ?', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            Text('Je suis là.', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const _BalloonMascot(compact: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _ReassuranceCard(relatives: _relatives),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _markHere,
                    icon: const Icon(Icons.favorite_rounded),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('Je suis là'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_hereLabel, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 28),
                  Text('Un petit signe ?', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final action in _actions)
                        FilledButton.tonalIcon(
                          onPressed: () => _showComingSoon(action),
                          icon: Icon(_iconFor(action)),
                          label: Text(action),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text('Mes proches', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  for (final relative in _relatives) ...[
                    _RelativeTile(relative: relative),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 12),
                  Text('Rassurer plutôt que surveiller.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String action) => switch (action) {
        'Je pars' => Icons.directions_walk_rounded,
        'Coucou' => Icons.waving_hand_rounded,
        _ => Icons.location_searching_rounded,
      };
}

class _ReassuranceCard extends StatelessWidget {
  const _ReassuranceCard({required this.relatives});
  final List<_Relative> relatives;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle), child: Icon(Icons.favorite_rounded, color: theme.colorScheme.onPrimaryContainer)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tout va bien', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text('${relatives.length} groupes visibles · aucun partage permanent'),
          ])),
        ]),
      ),
    );
  }
}

class _RelativeTile extends StatelessWidget {
  const _RelativeTile({required this.relative});
  final _Relative relative;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('${relative.name} — détails bientôt disponibles'))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            CircleAvatar(child: Icon(relative.icon)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(relative.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(relative.status),
            ])),
            const Icon(Icons.chevron_right_rounded),
          ]),
        ),
      ),
    );
  }
}

class _Relative {
  const _Relative({required this.name, required this.status, required this.icon});
  final String name;
  final String status;
  final IconData icon;
}

class _BalloonMascot extends StatelessWidget {
  const _BalloonMascot({this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Ballon rouge, mascotte de TesOu',
        image: true,
        child: SizedBox(width: compact ? 68 : 128, height: compact ? 92 : 174, child: CustomPaint(painter: _BalloonPainter())),
      );
}

class _BalloonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 128;
    final scaleY = size.height / 174;
    canvas.save();
    canvas.scale(scaleX, scaleY);
    final balloonPaint = Paint()..color = const Color(0xFFD64045);
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.65)..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round;
    final stringPaint = Paint()..color = const Color(0xFF625B61)..style = PaintingStyle.stroke..strokeWidth = 2.5;
    const center = Offset(64, 57);
    canvas.drawOval(Rect.fromCenter(center: center, width: 102, height: 114), balloonPaint);
    final knot = Path()..moveTo(center.dx, 112)..lineTo(center.dx - 8, 125)..lineTo(center.dx + 8, 125)..close();
    canvas.drawPath(knot, balloonPaint);
    canvas.drawArc(Rect.fromLTWH(center.dx - 31, 20, 24, 45), 3.2, 1.25, false, highlightPaint);
    final string = Path()..moveTo(center.dx, 125)..cubicTo(center.dx - 17, 140, center.dx + 18, 152, center.dx, 174);
    canvas.drawPath(string, stringPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
