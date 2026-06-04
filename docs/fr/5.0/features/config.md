# Configuration (spip-league/config)

Cette page **explique** l’architecture de configuration de SPIP 5.0.
Pour migrer depuis SPIP 4.x ou utiliser les APIs depuis un plugin, voir [Migration — Configuration et métas](../upgrade/config.md).

## En bref

SPIP 5.0 centralise métas et tables auxiliaires dans **`spip-league/config`**, via `spip.config` et `spip.config.manager`,
avec cache PSR-16 et pont vers `lire_config()` / `ecrire_config()`.

## Contexte

La configuration historique mélangeait fichiers, métas SQL et préfixes (`methode::`, `/<store>/...`).
Le nouveau stack unifie persistance, sérialisation et cycle de vie (bootstrap, refresh, reset) avec compatibilité `ecrire/`.

## Architecture en couches

| Couche | Interface | Rôle |
|--------|-----------|------|
| Store | `ConfigStoreInterface` | Persistance brute (chaînes SQL, mémoire…) |
| Entrées | `ConfigEntries` | Working set, cache PSR-16, écritures SQL |
| Chemins | `ConfigPathAccessor` | `get`/`set` structurés (casiers, sérialisation) |
| Repository | `ConfigRepositoryInterface` | Façade publique + cycle de vie |
| Legacy | `LegacyGlobalsBridge` | Miroir `$GLOBALS['meta']` (BC) |
| Manager | `ConfigManagerInterface` | Factory des repositories par store |

Le store par défaut est **`meta`** (table `spip_meta`).

### Working set, cache et SQL

Par requête : working set → cache PSR-16 (`tmp/cache/config/`) → SQL.
Le miroir `$GLOBALS['meta']` expose les **chaînes brutes** SQL, pas la vue désérialisée de `spip.config->get()`.

## Services du conteneur

| ID | Description |
|----|-------------|
| `spip.config` | Repository du store `meta` |
| `spip.config.manager` | Accès à tous les stores |
| `spip.config.store_registry` | Registre des stores |
| `spip.serializer` | Sérialisation des valeurs structurées |
| `spip.cache.config` | Cache fichiers (TTL défaut 1 mois) |

Préchauffage : `bin/spip cache:warmup` appelle `bootstrap()` après recompilation des plugins.

## Pont legacy

Les fonctions globales `lire_config()`, `ecrire_config()`, `ecrire_meta()`, etc. délèguent aux repositories.
Le pont ne lit ni n’écrit `$GLOBALS[$table]` comme source de vérité ; sync via `LegacyGlobalsBridge` (`@internal`).

## Limites et pièges

- Ne pas lire `$GLOBALS['meta']` pour obtenir une valeur désérialisée : utiliser `spip.config` ou `Spip::config()`.
- Les stores custom et l’usage PHP détaillé sont dans le guide de migration, pas ici.

## Voir aussi

- [Migration — Configuration et métas](../upgrade/config.md)
- [Paramètres SPIP](../reference/parametres-spip.md)
- [Façade Spip et Inputs](acces-services-spip.md)
