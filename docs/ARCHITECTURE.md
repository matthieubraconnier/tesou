# Architecture

TesOu adopte une organisation légère par fonctionnalités. Elle vise à rendre le
petit socle actuel lisible tout en permettant de l’étendre sans introduire de
couches prématurées.

## Organisation de `lib/`

- `app/` assemble l’application : widget racine et thème global ;
- `core/` accueillera uniquement les éléments techniques transversaux réellement
  partagés (configuration ou abstractions indépendantes du produit) ;
- `features/` regroupe chaque fonctionnalité autonome. `home/` contient pour le
  moment l’écran d’accueil et ses composants privés ;
- `shared/` accueillera les widgets ou modèles utilisés par plusieurs
  fonctionnalités, et non les éléments propres à une seule page ;
- `main.dart` reste le point d’entrée minimal.

Les dossiers `core/` et `shared/` contiennent un fichier `.gitkeep` afin de
matérialiser leur intention sans inventer d’abstraction avant qu’elle soit utile.

## Dépendances

Le socle dépend uniquement du SDK Flutter. Une dépendance externe ne doit être
ajoutée que si un besoin concret ne peut pas être satisfait simplement par le
SDK. Une fonctionnalité peut utiliser `core/` ou `shared/`, mais ne doit pas
dépendre des détails internes d’une autre fonctionnalité.

## Ajouter une fonctionnalité

1. Créer `lib/features/<nom_de_fonctionnalite>/`.
2. Y regrouper son interface et, lorsque le besoin apparaît, sa logique et ses
   modèles dans des sous-dossiers explicites.
3. Exposer seulement les widgets ou services nécessaires à l’assemblage.
4. Ajouter les tests correspondants sous `test/features/<nom>/`.
5. Ne déplacer un composant vers `shared/` qu’après l’apparition d’un second
   usage réel ; ne créer une abstraction dans `core/` que pour un besoin
   transversal avéré.
