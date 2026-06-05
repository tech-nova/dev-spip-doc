# Configuration (spip-league/config)

SPIP 5.0 centralise les métas et les tables de configuration auxiliaires dans le composant **`spip-league/config`**.
L'accès se fait via les services `spip.config` et `spip.config.manager`, avec un cache PSR-16
et un pont qui maintient `lire_config()` / `ecrire_config()` compatibles.

Mise en œuvre depuis un plugin et migration des métas : [Configuration et métas](../guides/migration/config.md).

## Usage typique

```php
use Spip\Framework\Spip;

$titre = Spip::config('nom_site');                 // lecture
$actif = Spip::config('mon_plugin/actif', false);  // chemin + valeur par défaut

Spip::configs()->set('mon_plugin/actif', true);    // écriture (sérialisée)
```

Les valeurs structurées (tableaux, booléens, entiers) sont (dé)sérialisées automatiquement par `spip.serializer` :
on récupère le type PHP d'origine, sans manipuler de chaîne brute.

## Services du conteneur

| ID | Description |
|----|-------------|
| `spip.config` | Repository du store `meta` (usage courant) |
| `spip.config.manager` | Accès à tous les stores |
| `spip.config.store_registry` | Registre des stores (`spip.config.store`) |
| `spip.serializer` | Sérialisation des valeurs structurées |
| `spip.cache.config` | Cache fichiers (TTL par défaut : 1 mois) |

Le store par défaut est **`meta`** (table `spip_meta`).
Préchauffage : `bin/spip cache:warmup` appelle `bootstrap()` après recompilation des plugins.

## Pont legacy

Les fonctions globales `lire_config()`, `ecrire_config()`, `ecrire_meta()`, etc. délèguent aux repositories :
leurs signatures restent inchangées pour les plugins existants.
Le pont expose encore `$GLOBALS['meta']` comme **miroir** (effet de bord pour la BC), jamais comme source de vérité.

## Limites et pièges

- Ne pas lire `$GLOBALS['meta']` pour obtenir une valeur désérialisée : le miroir contient la chaîne SQL brute. Utiliser `Spip::config()` ou le service `spip.config`.
- Les stores personnalisés et l'usage PHP détaillé sont décrits dans le guide de migration.
- L'architecture interne du composant (couches `ConfigStore`, `ConfigEntries`, `ConfigPathAccessor`, pont `@internal`…)
  est documentée dans le dépôt `spip-league/config` (`docs/architecture.md`), à destination des contributeurs du composant.

## Voir aussi

- [Configuration et métas](../guides/migration/config.md)
- [Paramètres SPIP](../reference/parametres-spip.md)
- [Façade Spip et Inputs](acces-services-spip.md)
