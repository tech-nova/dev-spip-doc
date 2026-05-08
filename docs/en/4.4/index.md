# SPIP 4.4 - Technical Documentation

SPIP 4.4 is an LTS (Long Term Support) version with extended support until July 2028.

## Compatibility

- **PHP**: 7.4 to 8.5
- **Required extensions**: sodium, Zlib, Zip, Phar

## Key highlights

This version brings several significant improvements:

- **Enhanced security**: Passwords are no longer sent in plain text in registration and password reminder emails
- **Composer installation**: The `ecrire`, `prive`, `squelettes-dist` folders and security screen are now installed via Composer
- **New tags**: `#LAYOUT_PRIVE`, `#URL_DOCUMENT_FICHIER`
- **Optimizations**: Improved performance for image filters

## Table of Contents

### [Upgrade Guide](upgrade/index.md)

Information for upgrading from a previous version.

### [New Features](features/index.md)

Discover what's new in SPIP 4.4.

- `#LAYOUT_PRIVE` tag for private area layouts
- New pipelines and image filters

### [Technical Reference](reference/index.md)

Technical details and changelog.

- API additions and modifications
- Deprecations to anticipate for SPIP 5.0
- Bug fixes
