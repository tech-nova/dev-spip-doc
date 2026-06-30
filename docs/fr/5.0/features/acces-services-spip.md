# Façade Spip et entrées HTTP (Inputs)

La classe **`Spip`** (`spip/framework`) centralise l'accès typé à la configuration, aux logs, aux entrées HTTP
et au conteneur, pour le code procédural de transition. Le service **`Inputs`** porte la lecture/écriture
des entrées HTTP via `RequestStack`. Les anciennes fonctions `service()` et `param()` sont dépréciées en 5.0.

Remplacer `service()` / `_request()` : [Utiliser la façade Spip](../guides/acces-services-spip.md).

## Usage typique

```php
use Spip\Framework\Spip;

$titre = Spip::config('nom_site');     // configuration
Spip::logger('mon_plugin')->info('…'); // logs PSR-3
$id = Spip::input('id_article');       // entrée HTTP
```

Le code **objet** doit préférer l'injection des services concernés (config, logger, `RequestStack`) dans ses constructeurs ; la façade reste réservée au code procédural.

## API principale

| Besoin | API |
|--------|-----|
| Configuration (lecture) | `Spip::config('cle')` / `Spip::config('sous/cle')` |
| Configuration (dépôt) | `Spip::configs()` |
| Logs PSR-3 | `Spip::logger()` / `Spip::logger('canal')` |
| Entrée HTTP | `Spip::input('cle')` / `Spip::inputs()` |
| Back-office / public | `Spip::isBackOffice()` / `Spip::isFrontOffice()` |
| Service / paramètre | `Spip::service('id')` / `Spip::param('spip.dirs.core')` |
| Répertoires | `Spip::directories()` |
| Plateforme (OS, CLI, env) | `Spip::platform()` |

## Objet Inputs

`SpipLeague\Bridge\Http\Inputs` lit et écrit via **`RequestStack`** uniquement.
Sans requête : lecture → `null`, écriture → exception.
`_request()` / `set_request()` (dépréciés) délèguent à `Spip::`.

## Voir aussi

- [Utiliser la façade Spip](../guides/acces-services-spip.md)
- [Configuration](config.md)
- [HTTP Request/Response](http-request-response.md)
