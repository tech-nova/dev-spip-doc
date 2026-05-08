# SPIP 4.4 Technical Reference

This section contains technical details and changes in SPIP 4.4.

## Changes Summary

### Additions

| Element | Description |
|---------|-------------|
| `#LAYOUT_PRIVE` | New private area layouts |
| `#TRAD` | Simplified syntax for language strings |
| `#URL_DOCUMENT_FICHIER` | URL to document file |
| `#MIME_TYPE` | Calculated MIME type |
| `#PARAM` | Access to service container parameters |
| `image_oriente_selon_exif()` | Automatic image reorientation |
| `ajouter_menus_args` pipeline | `definir_barre_boutons()` arguments |
| `image_extensions_logos` pipeline | Logo extensions customization |

### Behavioral Changes

- Image filters like `image_recadre` now reorient images based on EXIF
- The `|affdate` filter accepts timestamp input
- Values cleared in AJAX go through `var_nullify`
- CSS variables and logical properties used in private area

### Notable Fixes

- Image rotation with ImageMagick (convert)
- Using `fpassthru()` instead of `readfile()` to avoid memory limits
- Remote requests with `STREAM_CRYPTO_METHOD_TLS_CLIENT`
- Author emails hidden by default

## Deprecations

!!! warning "Deprecated elements"
    These elements generate warnings and will be removed in SPIP 5.0.

### Tags and Includes

- `<INCLURE(file.php)>`
- `<INCLURE{fond=file.php}>`
- `</INCLURE>` (closing tag)
- `#LARGEUR_ECRAN`

### Constants and Globals

- `_DIR_IMG_PACK`
- `_DIR_RESTREINT_ABS`
- `$formats_logos`
- `$traiter_math`, `$tex_server`

### Functions

- `produire_image_math()`, `traiter_math()`, `replace_math()` → use `mathjax` plugin
- `phraser_boucle_placeholder()` → `phraser_placeholder_memoriser()` or `phraser_placeholder_reinjecter()`
- `public_generer_boucle_placeholder()` → `public_placeholder_generer()`
- `|image_typo` and related → "Images typographiques" plugin

## Removals

These elements have been removed from SPIP 4.4:

- `verif_butineur()`
- `editer_texte_recolle()`
- `_texte_trop_long` environment (was for Internet Explorer)
