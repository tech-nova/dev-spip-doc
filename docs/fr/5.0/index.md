---
hide:
- navigation
---

# SPIP 5.0 - Documentation technique

Bienvenue dans la documentation de SPIP 5.0. Cette version marque une étape importante dans la modernisation en cours de SPIP avec l'intégration de composants
Symfony et l'adoption de pratiques de développement modernes (SOLID, typage strict, PSR).

!!! warning "Version en développement"
    SPIP 5.0 est en cours de développement (`5.0-dev`) et cette documentation évolue avec lui.
    Le contenu, les API décrites et les URL des pages peuvent changer à tout moment, sans
    garantie de compatibilité. Pour un site en production, reportez-vous à la
    [documentation de SPIP 4.4](/fr/4.4/) (version stable).

## Sommaire

### [Architecture](architecture/index.md)

- [Dépôts spip-league](architecture/depots-spip-league.md) — bibliothèques sous `vendor/spip-league/`
- [Cycle applicatif HTTP](architecture/cycle-applicatif-http.md) — front controller → Kernel → HttpKernel → legacy
- [Feuille de route](architecture/feuille-de-route.md) — orientations architecturales futures

### [Nouvelles fonctionnalités](features/index.md)

Découvrez les briques modernes de SPIP 5.0 et comment les utiliser dans vos développements.

- Injection de dépendances (Services Symfony)
- Système de Pipelines (Event Dispatcher)
- Tâches Cron (Attributs)
- Gestion HTTP (Request/Response)

### [Référence technique](reference/index.md)

Détails techniques et tables de correspondance.

- Paramètres de configuration `spip.*`
- Versionnement et symboles
- Liste des événements de pipelines

### [Guides](guides/index.md)

Guides pratiques (how-to) pour SPIP 5.0, dont la [migration depuis SPIP 4.x](guides/migration/index.md).

- How-to généraux (services, pipelines, cron, logs…)
- Migration : prérequis, ruptures, dépréciations et suppressions
