# Architecture SPIP 5.0

Cette section **explique** la couche moderne de SPIP 5.0 et son articulation avec le code historique (Diátaxis : explications).

## Sommaire

### [Dépôts spip-league](depots-spip-league.md)

Présentation des bibliothèques **spip-league** installées sous `vendor/spip-league/` : rôles, liens vers les dépôts
et regroupement fonctionnel.

### [Cycle applicatif HTTP](cycle-applicatif-http.md)

Séquence de démarrage et de réponse d’une requête web : front controller, Kernel, `SpipHttpKernel`, routage et
handlers legacy.

### [Feuille de route architecturale](feuille-de-route.md)

Orientations moyen, long et très long terme : `spip/framework`, évolution de `ecrire/`, modes d’installation,
profiler, compilateur, distributions alternatives.
