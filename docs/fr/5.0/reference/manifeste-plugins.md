# Manifeste des plugins actifs

Référence du fichier `var/state/plugins.php`, source de vérité du boot early (lu **sans SQL**).
Contexte : [Plugins et conteneur](../features/plugins-et-conteneur.md).

## Emplacement

| Élément | Valeur |
| :--- | :--- |
| Chemin par défaut | `var/state/plugins.php` |
| Génération | `PluginManifestStore` (`spip-league/plugin-manager`) |
| Consommation boot | `PluginManifestListProvider` → `ContainerBootstrap` |

La meta SQL `plugin` reste un miroir pour l'interface d'administration ; elle n'alimente pas le boot HTTP.

## Structure du fichier

Fichier PHP retournant un tableau associatif :

```php
return [
    'signature' => 'eb6b5e97baa2426d7a3f4380d7da8c1d',
    'paths' => ['ecrire/', 'prive/', 'squelettes-dist/', 'plugins-dist/spip/mots/'],
];
```

## Champs

| Clé | Type | Description |
| :--- | :--- | :--- |
| `signature` | `string` | Empreinte de l'ensemble ordonné des chemins actifs. Sert de clé de fraîcheur pour le conteneur compilé et les artefacts boot. |
| `paths` | `list<string>` | Chemins relatifs à la racine projet des bundles et plugins actifs, dans l'ordre de chargement. |

## Règles sur `paths`

- Chemins normalisés (slash final pour les répertoires racine comme `ecrire/`).
- Inclut les bundles noyau (`ecrire/`, `prive/`, `squelettes-dist/`) et chaque plugin activé.
- Toute modification (activation, désactivation, réordonnancement) recalcule `signature` et invalide le conteneur compilé.

## Voir aussi

- [Plugins et conteneur](../features/plugins-et-conteneur.md)
- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
