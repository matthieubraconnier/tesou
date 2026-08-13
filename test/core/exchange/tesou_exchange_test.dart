import 'package:flutter_test/flutter_test.dart';
import 'package:tesou/core/exchange/tesou_exchange.dart';

void main() {
  test('un signal TesOu peut être sérialisé puis relu', () {
    final signal = TesouSignal(
      senderId: 'matthieu',
      type: TesouSignalType.here,
      sentAt: DateTime(2026, 8, 13, 13, 15),
    );

    final restored = TesouSignal.fromJson(signal.toJson());

    expect(restored.senderId, 'matthieu');
    expect(restored.type, TesouSignalType.here);
    expect(restored.sentAt, signal.sentAt);
  });

  test('l’échange local transmet un signal à un autre écouteur', () async {
    final exchange = LocalTesouExchange();
    final received = exchange.watchSignals().first;
    final signal = TesouSignal(
      senderId: 'telephone-a',
      type: TesouSignalType.hello,
      sentAt: DateTime.now(),
    );

    await exchange.send(signal);

    expect(await received, same(signal));
  });
}
