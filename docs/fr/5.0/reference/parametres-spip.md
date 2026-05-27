# Paramètres SPIP (conteneur)

## Configuration

Il n’y a plus de paramètres `spip.config.*` dans `config/spip/config.php` du projet. Le store par défaut (`meta`) et le cache (`spip.cache.config`, TTL 1 mois) sont déclarés dans le kernel.

## Services associés

- `spip.config` — repository du store `meta` (table `spip_meta`)
- `spip.config.manager` — factory de repositories
- `spip.config.store_registry` — registre des stores taggés `spip.config.store`
- `spip.cache.config` — adaptateur cache fichiers pour la configuration
- `spip.serializer` — sérialisation des valeurs structurées

Voir [Configuration (feature)](../features/config.md).
