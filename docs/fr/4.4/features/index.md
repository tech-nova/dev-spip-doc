# Nouvelles fonctionnalités de SPIP 4.4

Cette page présente les principales nouveautés introduites dans SPIP 4.4.

## Balise `#LAYOUT_PRIVE`

Cette nouvelle balise remplace `#LARGEUR_ECRAN` et permet de définir différentes dispositions pour les pages de l'espace privé :

| Layout | Description |
|--------|-------------|
| `#LAYOUT_PRIVE{fluide}` | Le contenu s'adapte selon la présence de `#extra` et `#navigation` |
| `#LAYOUT_PRIVE{pleine-largeur}` | Contenu étendu sur toute la largeur |
| `#LAYOUT_PRIVE{complements-gauche}` | Compléments positionnés à gauche |
| `#LAYOUT_PRIVE{complements-droite}` | Compléments positionnés à droite |
| `#LAYOUT_PRIVE{complements-bas}` | Compléments en bas de page |
| `#LAYOUT_PRIVE{complements-bas-inverse}` | Compléments en bas, ordre inversé |


## Balise `#URL_DOCUMENT_FICHIER`

Renvoie toujours le chemin vers le fichier d'un document, permettant d'utiliser `#URL_DOCUMENT` pour pointer vers une page web si souhaité.

## Autres balises

- `#MIME_TYPE` : Renvoie le type MIME calculé
- `#PARAM` : Récupère les paramètres du container de services

## Nouveaux pipelines

- `ajouter_menus_args` : Complément au pipeline `ajouter_menus`, transmet les arguments de `definir_barre_boutons()`
- `image_extensions_logos` : Permet de personnaliser les extensions acceptées pour les logos

## Filtres d'images

- `image_oriente_selon_exif()` : Réoriente automatiquement une image selon ses métadonnées EXIF
- Optimisations de performance pour `image_aplatir()`, `image_renforcement()`, `image_flou()`, `image_sepia()`, `image_nb()`, `image_gamma()`, `image_rotation()`, etc.

## Librairies spip-league

Le répertoire `vendor/` accueille les premières librairies `spip-league`, préparant la transition vers SPIP 5.0. Un répertoire `config/spip` est également présent.
