enum TesouSignalType { here, leaving, hello, whereAreYou }

class TesouSignal {
  const TesouSignal({
    required this.senderId,
    required this.type,
    required this.sentAt,
  });

  final String senderId;
  final TesouSignalType type;
  final DateTime sentAt;

  Map<String, Object> toJson() => {
        'senderId': senderId,
        'type': type.name,
        'sentAt': sentAt.toUtc().toIso8601String(),
      };

  factory TesouSignal.fromJson(Map<String, Object?> json) => TesouSignal(
        senderId: json['senderId']! as String,
        type: TesouSignalType.values.byName(json['type']! as String),
        sentAt: DateTime.parse(json['sentAt']! as String).toLocal(),
      );
}

abstract interface class TesouExchange {
  Future<void> send(TesouSignal signal);
  Stream<TesouSignal> watchSignals();
}

/// Implémentation locale utilisée tant que le backend partagé n'est pas branché.
/// L'interface permet de remplacer ce composant par Firebase/Supabase/API sans
/// réécrire l'écran d'accueil.
class LocalTesouExchange implements TesouExchange {
  final _listeners = <void Function(TesouSignal)>[];

  @override
  Future<void> send(TesouSignal signal) async {
    for (final listener in List.of(_listeners)) {
      listener(signal);
    }
  }

  @override
  Stream<TesouSignal> watchSignals() => Stream.multi((controller) {
        void listener(TesouSignal signal) => controller.add(signal);
        _listeners.add(listener);
        controller.onCancel = () => _listeners.remove(listener);
      });
}
