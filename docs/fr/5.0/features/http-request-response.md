# Gestion HTTP (Request/Response)

SPIP 5.0 expose les objets **`Request`** et **`Response`** de Symfony HttpFoundation. Le code legacy est encore
largement servi via mise en tampon, mais la migration vers des `Response` natives progresse,
offrant une interception cohérente (Guard, pipelines, redirections).

Mise en œuvre dans un plugin : [HTTP Request/Response dans un plugin](../guides/http-request-response.md).

## Usage typique

```php
use Spip\Framework\Spip;

$request = Spip::request();              // requête courante (ou null hors HTTP)
$id = $request?->query->get('id_article');
```

Pour court-circuiter le flux avec une réponse immédiate (redirection, erreur), lever une `EarlyResponseException`.

## Fonctionnement

- **`request_stack`** : requête courante (query, request, session, headers).
- **`Response`** : corps, statut, en-têtes.
- **`EarlyResponseException`** : court-circuiter le flux avec une réponse immédiate (redirection, erreur).

Le routage du cœur (`SpipController`, attributs `#[Route]`) couvre `/spip.php` et `/ecrire/` ; les plugins peuvent déclarer leurs routes sur des services contrôleurs.

## Limites et pièges

- Ne pas supposer que toute page publique retourne déjà un objet `Response` : le tampon legacy reste fréquent.
- Préférer `Request` à `_request()` pour le nouveau code.

## Voir aussi

- [HTTP Request/Response dans un plugin](../guides/http-request-response.md)
- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
