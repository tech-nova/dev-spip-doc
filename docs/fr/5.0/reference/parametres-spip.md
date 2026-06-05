# Paramètres SPIP (conteneur)

Page de **référence** : services du conteneur liés à la configuration SPIP 5.0.

## Liste des paramètres

TODO:

## Modifier ou créer des paramètres

TODO: parler des surcharges config/custom.php (ou via plugins config/services.php)

## Services associés

- `spip.config` — repository du store `meta` (table `spip_meta`)
- `spip.config.manager` — factory de repositories
- `spip.config.store_registry` — registre des stores taggés `spip.config.store`
- `spip.cache.config` — adaptateur cache fichiers pour la configuration
- `spip.serializer` — sérialisation des valeurs structurées

## Voir aussi

- [Configuration (feature)](../features/config.md)
- [Migration — Configuration et métas](../upgrade/config.md)
