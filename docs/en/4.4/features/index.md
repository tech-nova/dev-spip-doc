# SPIP 4.4 New Features

This page presents the main features introduced in SPIP 4.4.

## `#LAYOUT_PRIVE` Tag

This new tag replaces `#LARGEUR_ECRAN` and allows defining different layouts for private area pages:

| Layout | Description |
|--------|-------------|
| `#LAYOUT_PRIVE{fluide}` | Content adapts based on `#extra` and `#navigation` presence |
| `#LAYOUT_PRIVE{pleine-largeur}` | Full-width content |
| `#LAYOUT_PRIVE{complements-gauche}` | Complements positioned on the left |
| `#LAYOUT_PRIVE{complements-droite}` | Complements positioned on the right |
| `#LAYOUT_PRIVE{complements-bas}` | Complements at the bottom |
| `#LAYOUT_PRIVE{complements-bas-inverse}` | Complements at the bottom, reversed order |


## `#URL_DOCUMENT_FICHIER` Tag

Always returns the file path of a document, allowing `#URL_DOCUMENT` to point to a web page if desired.

## Other Tags

- `#MIME_TYPE`: Returns the calculated MIME type
- `#PARAM`: Retrieves parameters from the service container

## New Pipelines

- `ajouter_menus_args`: Complement to `ajouter_menus` pipeline, passes `definir_barre_boutons()` arguments
- `image_extensions_logos`: Customize accepted logo extensions

## Image Filters

- `image_oriente_selon_exif()`: Automatically reorients an image based on EXIF metadata
- Performance optimizations for `image_aplatir()`, `image_renforcement()`, `image_flou()`, `image_sepia()`, `image_nb()`, `image_gamma()`, `image_rotation()`, etc.
