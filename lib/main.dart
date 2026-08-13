import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tesou/app/tesou_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pupsvkzbanpfnwssjvfq.supabase.co',
    publishableKey: 'sb_publishable_plGETjmTGoEtsgLJE6RV6w_Bky9mZQ1',
  );

  runApp(const TesouApp());
}
