# Façade Spip et entrées HTTP (Inputs)

Cette page **explique** la façade **`Spip`** et le service **`Inputs`** (code procédural).
Pour migrer depuis `service()` / `_request()`, voir le guide pratique.

## En bref

`Spip` (`spip/framework`) centralise l’accès typé à la config, aux logs, aux entrées HTTP et au conteneur. `service()` et `param()` sont dépréciés en 5.0.

## Contexte

Les fonctions globales multipliées rendaient difficile l’autocomplétion et les tests. La façade offre un point d’entrée unique ; le code objet doit préférer l’injection.

## API principale

| Besoin | API |
|--------|-----|
| Configuration (lecture) | `Spip::config('cle')` |
| Configuration (dépôt) | `Spip::configs()` |
| Logs PSR-3 | `Spip::logger()` / `Spip::logger('canal')` |
| Entrée HTTP | `Spip::input('cle')` / `Spip::inputs()` |
| Back-office / public | `Spip::isBackOffice()` / `Spip::isFrontOffice()` |
| Service / paramètre | `Spip::service('id')` / `Spip::param('spip.dirs.core')` |

## Objet Inputs

`SpipLeague\Bridge\Http\Inputs` lit et écrit via **`RequestStack`** uniquement.
Sans requête : lecture → `null`, écriture → exception.
`_request()` / `set_request()` délèguent à `Spip::` (dépréciés).

## Voir aussi

- [Migrer vers la façade Spip](../upgrade/acces-services-spip.md)
- [Configuration](config.md)
- [HTTP Request/Response](http-request-response.md)
