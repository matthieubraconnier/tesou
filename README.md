# T’es où ? Je suis là !

**Rassurer plutôt que surveiller.**

TesOu est une future application mobile familiale pour envoyer, en très peu
d’actions, de petits signes rassurants à ses proches. Le partage y est
volontaire et respectueux de la vie privée.

## État du projet

Le dépôt contient uniquement les fondations Flutter et un écran d’accueil de
démonstration. L’authentification, la géolocalisation, les notifications, les
groupes et tout backend sont volontairement absents.

## Prérequis

- une version stable récente de Flutter (Dart SDK `>=3.3.0`) ;
- Android Studio et un SDK Android pour exécuter la cible Android ;
- un émulateur Android ou un appareil configuré.

Vérifier l’installation avec `flutter doctor`.

## Commandes utiles

```sh
flutter pub get       # installer les dépendances
dart format .         # formater le code
flutter analyze       # analyser le projet
flutter test          # exécuter les tests
flutter run           # lancer l’application
```

La vision produit et les périmètres envisagés sont détaillés dans
[`VISION.md`](VISION.md), [`V1.md`](V1.md) et [`V2.md`](V2.md).
