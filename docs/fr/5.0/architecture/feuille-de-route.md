# Feuille de route architecturale

Cette page décrit des **orientations envisagées** pour SPIP 5.0 ou au delà. Il ne s’agit ni d’un engagement de
livraison, ni d’un ordre de priorité figé : les chantiers dépendront des contributions, des contraintes de
compatibilité et de la maturité de chaque brique.

## Moyen terme

Objectif : consolider la couche moderne et extraire du core ce qui peut devenir des services réutilisables par
`ecrire/`, `prive/` et les plugins.

- **Renommer `spip-league/kernel` en `spip-league/bootstrap`** — le nom refléterait mieux le rôle actuel
  (amorçage, conteneur, détection d’installation) distinct du futur noyau métier.
- **Déplacer du code de `ecrire/` vers `spip/framework`** — dépôt hébergeant services, interfaces et
  classes de base partagées entre l’espace privé, le site public et les extensions.
- **Créer de nouveaux dépôts et services** — par exemple SQL / DBAL, authentification et
  cookies, envoi de courriels, chacun avec ses contrats et son implémentation testable hors du monolithe `ecrire/`.

`Spip\Framework` serait la base commune : le code historique dans `ecrire/` et les plugins s’appuieraient sur ces
abstractions plutôt que sur des fonctions globales dispersées.

## Long terme

Objectif : réduire la dette structurelle (dossier `ecrire/`, modes d’installation, debug) et enrichir le modèle
de services.

- **Services métier plus complets** — édition d’objets, couche de persistance type ORM ou équivalent moderne,
  en s’appuyant sur les briques extraites au moyen terme.
- **Modes d’installation `standalone` et `mutualized`** — faire fonctionner réellement `public/` et
  `sites/default/public/` (aujourd’hui expérimentaux ou partiels), avec une détection d’installation stable.
- **Faire disparaître le dossier `ecrire/` en tant que racine technique** — `ecrire` ne serait plus qu’une
  **route** et un ensemble de scripts legacy vers l’espace privé, pas un répertoire « noyau » au sens Composer.
- **`spip/prive` à clarifier** — squelettes de l’espace privé et certains assets publics ; articulation à définir
  avec `spip/dist` et les plugins.
- **Barre de debug Symfony** — étudier l’intégration de [Symfony Profiler](https://symfony.com/doc/current/profiler.html)
  (souvent avec Twig) pour remplacer le mode debug historique ; chantier lourd, **réservé au développement**, jamais
  en production.
- **Compilateur de squelettes** — refonte ambitieuse du pipeline de compilation (performances, typage, intégration
  au conteneur).
- **Distributions SPIP alternatives** — au-delà de `spip/classic-distribution`, permettre d’autres assemblages
  Composer (minimal, headless, etc.) sur la même base `spip/framework`.

## Très long terme

Objectif : alignement maximal avec l’écosystème Symfony, si la faisabilité et le coût de migration le permettent.

- **SPIP comme bundle Symfony** — encapsuler le CMS dans un `SpipBundle` (ou famille de bundles) installable
  dans une application Symfony standard ; à valider sur le plan technique, organisationnel et de compatibilité
  avec l’existant (plugins, squelettes, pipelines).

## Liens avec la modernisation en cours

| Aujourd’hui (SPIP 5.0) | Direction visée |
| :--- | :--- |
| `spip-league/kernel` + handlers legacy | `bootstrap` + `spip/framework` + services dédiés |
| `ecrire/` monolithique | Route privée + code métier dans packages |
| Pipelines / Event Dispatcher | Services typés, listeners Symfony |
| Mode debug SPIP | Profiler Symfony (dev uniquement) |
| `spip/classic-distribution` seule | Plusieurs distributions Composer |

## Voir aussi

- [Dépôts spip-league](depots-spip-league.md)
- [Cycle applicatif HTTP](cycle-applicatif-http.md)
- [Services Symfony](../features/services-symfony.md)
- [Guides et migration](../guides/index.md)
