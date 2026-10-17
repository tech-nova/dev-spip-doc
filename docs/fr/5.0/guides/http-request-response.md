# HTTP Request/Response dans un plugin

`Request`, `Response` et `EarlyResponseException` (HttpFoundation) remplacent `_request()` et les sorties directes.
Le modèle est expliqué dans [Gestion HTTP](../features/http-request-response.md).

## Objectif

Remplacer `_request()` et les sorties directes par l’API HttpFoundation là où c’est possible.

## Prérequis

- Service ou code avec accès au conteneur (`request_stack`).

## Étapes

### 1. Obtenir la requête courante

```php
$request = Spip::request();
// est équivalent à 
$request = Spip::service('request_stack')->getCurrentRequest();
$id = $request?->query->get('id_article');
```

### 2. Lire POST et cookies

```php
$titre = $request->request->get('titre');
```

### 3. Retourner une Response

```php
use Symfony\Component\HttpFoundation\Response;

return new Response('Contenu', 200, ['Content-Type' => 'text/plain']);
```

### 4. Court-circuiter avec EarlyResponseException

```php
use SpipLeague\Bridge\Http\EarlyResponseException;
use Symfony\Component\HttpFoundation\RedirectResponse;

throw new EarlyResponseException(new RedirectResponse($url));
```

## Vérification

- Tester une redirection ou une 403 via `EarlyResponseException` : la réponse doit être envoyée sans exécuter la suite du legacy.

## Voir aussi

- [Gestion HTTP](../features/http-request-response.md)
- [Façade Spip — entrées HTTP](acces-services-spip.md)
