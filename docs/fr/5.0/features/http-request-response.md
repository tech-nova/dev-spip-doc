# Gestion HTTP (Request/Response)

SPIP 5.0 utilise désormais les objets **Request** et **Response** du composant `HttpFoundation` de Symfony pour gérer le cycle de vie d'une requête.

## La Requête (Request)

L'objet `Request` centralise toutes les informations de la requête HTTP (GET, POST, Cookies, Headers, Session).

### Accéder à la requête
Dans un contrôleur moderne ou un service, l'objet `Request` est généralement injecté. Dans un contexte legacy, vous pouvez le récupérer via le service `request_stack` :

```php
use function SpipLeague\Component\Kernel\service;
$request = service('request_stack')->getCurrentRequest();
```

### Remplacement de `_request()`
Bien que `_request()` soit toujours disponible, l'utilisation de l'objet `Request` est recommandée :

```php
$id = $request->query->get('id_article'); // $_GET
$titre = $request->request->get('titre');  // $_POST
```

## La Réponse (Response)

Toute sortie de SPIP 5.0 devrait idéalement être encapsulée dans un objet `Response`.

*Note : Actuellement, la génération des réponses s'appuie encore largement sur le code legacy via la mise en tampon de la sortie (`ob_start` / `ob_end_clean`). L'utilisation native et systématique des objets `Response` est un chantier en cours qui doit évoluer d'ici la sortie finale de SPIP 5.*

### Retourner une réponse
```php
use Symfony\Component\HttpFoundation\Response;

return new Response('Contenu de la page', 200, ['Content-Type' => 'text/plain']);
```

### Court-circuiter avec `EarlyResponseException`
Si vous devez interrompre le flux pour envoyer une réponse immédiate (par exemple une redirection ou une erreur), utilisez `EarlyResponseException`.

```php
use SpipLeague\Bridge\Http\EarlyResponseException;
use Symfony\Component\HttpFoundation\RedirectResponse;

throw new EarlyResponseException(new RedirectResponse($url));
```

## Routage

SPIP 5.0 définit ses routes principales via des attributs `#[Route]` dans `SpipController`.
- `/spip.php` : gère les actions et les pages publiques.
- `/ecrire/` : gère l'espace privé.

Vous pouvez définir vos propres routes Symfony dans vos plugins en utilisant les mêmes attributs, à condition que vos contrôleurs soient enregistrés comme services.
