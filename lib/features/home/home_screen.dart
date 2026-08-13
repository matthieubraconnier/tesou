import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _codeController = TextEditingController();
  DateTime? _lastHereAt;
  Timer? _clock;
  bool _loading = true;
  String? _pairingCode;
  String? _error;

  SupabaseClient get _db => Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _prepareIdentity();
  }

  @override
  void dispose() {
    _clock?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _prepareIdentity() async {
    try {
      if (_db.auth.currentUser == null) {
        await _db.auth.signInAnonymously(data: const {'display_name': 'Utilisateur TesOu'});
      }
      final user = _db.auth.currentUser;
      if (user == null) throw Exception('Identité TesOu indisponible');
      final profile = await _db.from('profiles').select('pairing_code').eq('user_id', user.id).single();
      if (!mounted) return;
      setState(() {
        _pairingCode = profile['pairing_code'] as String?;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Connexion TesOu impossible pour le moment.';
        _loading = false;
      });
    }
  }

  Future<void> _connectByCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    try {
      await _db.rpc('connect_by_code', params: {'code': code});
      if (!mounted) return;
      _codeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proche associé avec succès.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code introuvable ou association impossible.')));
    }
  }

  void _markHere() {
    setState(() => _lastHereAt = DateTime.now());
    _clock ??= Timer.periodic(const Duration(seconds: 30), (_) { if (mounted) setState(() {}); });
    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('C’est envoyé : tu es là.')));
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('T’es où ?', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                    Text('Je suis là.', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  ])),
                  const _BalloonMascot(),
                ]),
                const SizedBox(height: 18),
                Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('Mon identité TesOu', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  if (_loading) const LinearProgressIndicator()
                  else if (_error != null) Text(_error!)
                  else ...[
                    const Text('Mon code à partager :'),
                    const SizedBox(height: 4),
                    SelectableText(_pairingCode ?? '—', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 3)),
                    const SizedBox(height: 14),
                    TextField(controller: _codeController, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'Code d’un proche', border: OutlineInputBorder())),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(onPressed: _connectByCode, icon: const Icon(Icons.person_add_alt_1_rounded), label: const Text('Associer ce proche')),
                  ],
                ]))),
                const SizedBox(height: 20),
                FilledButton.icon(onPressed: _markHere, icon: const Icon(Icons.favorite_rounded), label: const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text('Je suis là'))),
                const SizedBox(height: 8),
                Text(_hereLabel, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                Text('Premier objectif : relier deux téléphones. Ensuite, ce bouton enverra réellement le signe à ton proche.', textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text('Rassurer plutôt que surveiller.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ]),
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
  Widget build(BuildContext context) => Semantics(label: 'Ballon rouge, mascotte de TesOu', image: true, child: SizedBox(width: 68, height: 92, child: CustomPaint(painter: _BalloonPainter())));
}

class _BalloonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 128;
    final scaleY = size.height / 174;
    canvas.save(); canvas.scale(scaleX, scaleY);
    final balloonPaint = Paint()..color = const Color(0xFFD64045);
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.65)..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round;
    final stringPaint = Paint()..color = const Color(0xFF625B61)..style = PaintingStyle.stroke..strokeWidth = 2.5;
    const center = Offset(64, 57);
    canvas.drawOval(Rect.fromCenter(center: center, width: 102, height: 114), balloonPaint);
    final knot = Path()..moveTo(center.dx, 112)..lineTo(center.dx - 8, 125)..lineTo(center.dx + 8, 125)..close();
    canvas.drawPath(knot, balloonPaint);
    canvas.drawArc(Rect.fromLTWH(center.dx - 31, 20, 24, 45), 3.2, 1.25, false, highlightPaint);
    final string = Path()..moveTo(center.dx, 125)..cubicTo(center.dx - 17, 140, center.dx + 18, 152, center.dx, 174);
    canvas.drawPath(string, stringPaint); canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
