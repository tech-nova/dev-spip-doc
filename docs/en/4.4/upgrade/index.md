# SPIP 4.4 Upgrade Guide

This guide helps you upgrade to SPIP 4.4.

## Prerequisites

- **PHP**: Version 7.4 minimum, compatible up to PHP 8.5
- **Required PHP extensions**: sodium, Zlib, Zip, Phar

## Major Changes

### Composer Installation

The following folders are now installed via Composer:

- `ecrire/`
- `prive/`
- `squelettes-dist/`
- Security screen

!!! note "User impact"
    This change is transparent for spip_loader users.

### Password Security

SPIP no longer sends plain text passwords in emails. Users now receive links to set their password.

## Deprecations to Anticipate

These elements are deprecated and will be removed in a future version:

### Templates

- PHP file inclusion via `<INCLURE(file.php)>` or `<INCLURE{fond=file.php}>`
- Closing tag `</INCLURE>`
- `#LARGEUR_ECRAN` tag → use `#LAYOUT_PRIVE`

!!! warning "Case sensitivity"
    Starting with SPIP 5, language string calls in templates will be case-sensitive.

### PHP

- Language files populating `$GLOBALS` → return an array directly
- Constant `_DIR_IMG_PACK` (obsolete)
- Constant `_DIR_RESTREINT_ABS`
- Global `$formats_logos` → use `_images_extensions_logos()` or `image_extensions_logos` pipeline

### Removed Functions

- `verif_butineur()`
- `editer_texte_recolle()`
- `_texte_trop_long` form environment
