# Guide permanent de développement de TesOu

Ce fichier s’applique à l’ensemble du dépôt. Toute contribution Codex doit
respecter `VISION.md`, `V1.md` et `docs/ARCHITECTURE.md`.

## Philosophie produit

- Faire vivre la promesse **« Rassurer plutôt que surveiller »**.
- Concevoir chaque interaction autour du consentement et d’un partage explicite,
  volontaire et maîtrisé par la personne.
- Respecter la vie privée par défaut, minimiser les données et préférer la
  confiance au contrôle.
- Ne jamais introduire de surveillance permanente, d’historique GPS détaillé,
  de classement ou score des proches, de publicité, ni de fonctionnalités
  sociales publiques.
- Garder l’application simple, lisible et accessible, avec un ton chaleureux,
  familial et bienveillant. Elle doit rester fun et posséder une forte
  personnalité sans devenir infantile.
- Cultiver une identité visuelle de **street-art bienveillant**. Le ballon rouge
  est l’élément emblématique de TesOu ; préserver sa reconnaissance et son rôle
  dans l’univers visuel.

## Périmètre produit

- Ne jamais inventer ni développer une fonctionnalité produit sans demande
  explicite.
- Considérer `V1.md` comme la référence du périmètre envisagé, sans supposer que
  ses éléments sont déjà fonctionnels ou automatiquement à implémenter.
- Inscrire dans `V2.md` toute idée nouvelle située hors du périmètre V1. Son
  inscription ne vaut ni validation, ni planification, ni extension de la V1.
- Signaler clairement lorsqu’une demande risque de compliquer inutilement
  l’application ou de contredire sa promesse et ses valeurs.

## Choix techniques

- Utiliser Flutter et Material 3.
- Android est la première cible, mais tout choix de code, d’interface ou de
  dépendance doit préserver la possibilité de prendre en charge Android et iOS.
- Conserver l’architecture légère par fonctionnalités :
  - `lib/app/` pour l’assemblage de l’application et le thème global ;
  - `lib/core/` uniquement pour les besoins techniques réellement transversaux ;
  - `lib/features/<fonctionnalite>/` pour chaque fonctionnalité autonome ;
  - `lib/shared/` uniquement pour les éléments ayant plusieurs usages réels ;
  - `lib/main.dart` comme point d’entrée minimal.
- Une fonctionnalité peut dépendre de `core/` ou de `shared/`, jamais des détails
  internes d’une autre fonctionnalité.
- Ne créer une abstraction, une couche ou un service que lorsqu’un besoin avéré
  le justifie. Pas de sur-ingénierie ni de structure prématurée.
- N’ajouter aucune dépendance externe sans besoin concret que le SDK Flutter ne
  peut pas satisfaire simplement. Documenter ce besoin lors de l’ajout.
- Privilégier toujours la solution la plus simple qui répond correctement au
  besoin.

## Qualité et livraison

- Écrire un code explicite, lisible, maintenable et cohérent avec la structure
  existante.
- Ajouter ou adapter des tests pour les comportements importants. Ranger les
  tests de fonctionnalité sous `test/features/<fonctionnalite>/`.
- Vérifier, lorsque l’environnement le permet, le formatage, l’analyse statique
  et les tests Flutter avant de livrer.
- Ne jamais fusionner automatiquement une modification dans la branche
  principale. Préparer une branche et une demande de fusion, puis laisser la
  décision de fusion à un humain.
