# Gestion HTTP (Request/Response)

Cette page **explique** l’usage de **HttpFoundation** dans SPIP 5.0.

## En bref

SPIP 5.0 expose `Request` et `Response` Symfony. Le legacy est encore largement servi via mise en tampon ; la migration vers des `Response` natives progresse.

## Contexte

`_request()` et sorties ad hoc dispersaient la logique HTTP.
`RequestStack` et `Response` permettent une interception cohérente (Guard, pipelines, redirections).

## Fonctionnement

- **`request_stack`** : requête courante (query, request, session, headers).
- **`Response`** : corps, statut, en-têtes.
- **`EarlyResponseException`** : court-circuiter le flux avec une réponse immédiate (redirection, erreur).

Le routage du cœur (`SpipController`, attributs `#[Route]`) couvre `/spip.php` et `/ecrire/` ; les plugins peuvent déclarer leurs routes sur des services contrôleurs.

## Limites et pièges

- Ne pas supposer que toute page publique retourne déjà un objet `Response` : le tampon legacy reste fréquent.
- Préférer `Request` à `_request()` pour le nouveau code.

## Voir aussi

- [HTTP Request/Response dans un plugin](../upgrade/http-request-response.md)
- [Cycle applicatif HTTP](../architecture/cycle-applicatif-http.md)
