import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _actions = ['Je pars', 'Coucou', 'T’es où ?'];

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Fonction bientôt disponible')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _BalloonMascot(),
                  const SizedBox(height: 28),
                  Text(
                    'T’es où ? Je suis là !',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rassurer plutôt que surveiller.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 36),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final action in _actions)
                        ElevatedButton(
                          onPressed: () => _showComingSoon(context),
                          child: Text(action),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BalloonMascot extends StatelessWidget {
  const _BalloonMascot();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ballon rouge, mascotte de TesOu',
      image: true,
      child: SizedBox(
        width: 128,
        height: 174,
        child: CustomPaint(painter: _BalloonPainter()),
      ),
    );
  }
}

class _BalloonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final balloonPaint = Paint()..color = const Color(0xFFD64045);
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final stringPaint = Paint()
      ..color = const Color(0xFF625B61)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final center = Offset(size.width / 2, 57);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 102, height: 114),
      balloonPaint,
    );
    final knot = Path()
      ..moveTo(center.dx, 112)
      ..lineTo(center.dx - 8, 125)
      ..lineTo(center.dx + 8, 125)
      ..close();
    canvas.drawPath(knot, balloonPaint);
    canvas.drawArc(
      Rect.fromLTWH(center.dx - 31, 20, 24, 45),
      3.2,
      1.25,
      false,
      highlightPaint,
    );
    final string = Path()
      ..moveTo(center.dx, 125)
      ..cubicTo(center.dx - 17, 140, center.dx + 18, 152, center.dx, 174);
    canvas.drawPath(string, stringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
