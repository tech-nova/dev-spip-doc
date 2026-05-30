# Façade `Spip` et entrées HTTP (`Inputs`)

SPIP 5.0 expose une façade de transition **`Spip`** (`spip/framework`) pour accéder aux services courants avec un meilleur typage IDE, sans multiplier les fonctions globales.

## Accès recommandé

| Besoin | API |
|--------|-----|
| Configuration (lecture d’une clé) | `Spip::config('cle')` |
| Configuration (dépôt / écriture) | `Spip::configs()` |
| Logs PSR-3 | `Spip::logger()` ou `Spip::logger('mysql')` |
| Entrée HTTP (une clé) | `Spip::input('cle')` |
| Entrées HTTP (objet / injection) | `Spip::inputs()` |
| Contexte back-office / public | `Spip::isBackOffice()` / `Spip::isFrontOffice()` |
| Service arbitraire | `Spip::service('id')` |
| Paramètre conteneur | `Spip::param('spip.dirs.core')` |
| Application complète | `Spip::app()` (repli) |

Seule la fonction globale **`app()`** reste la primitive canonique du noyau ; `service()` et `param()` sont **dépréciées** (SPIP 5.0) au profit de `Spip::`.

## Objet `Inputs`

La classe `SpipLeague\Bridge\Http\Inputs` (`spip-league/http`) est enregistrée comme service `spip.inputs` dans le conteneur (`spip-league/kernel`). Elle lit et écrit les paramètres via **`RequestStack`** uniquement (query puis request bag).

- Sans Request courante : lecture → `null`, écriture → exception.
- Les fonctions `_request()` / `set_request()` restent disponibles mais dépréciées ; elles délèguent à `Spip::` (charset AJAX conservé dans `_request()`).


## Migration

- Nouveau code procédural : préférer `Spip::config('cle')`, `Spip::configs()`, `Spip::input()`, etc.
- Nouveau code objet : injection (`ConfigRepositoryInterface`, `RequestStack`, `Inputs`, …).
