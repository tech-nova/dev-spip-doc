---
hide:
- navigation
---

# SPIP 5.0 - Documentation technique

Bienvenue dans la documentation de SPIP 5.0. Cette version marque une étape importante dans la modernisation en cours de SPIP avec l'intégration de composants
Symfony et l'adoption de pratiques de développement modernes (SOLID, typage strict, PSR).

## Sommaire

### [Architecture](architecture/index.md)

- [Dépôts spip-league](architecture/depots-spip-league.md) — bibliothèques sous `vendor/spip-league/`
- [Cycle applicatif HTTP](architecture/cycle-applicatif-http.md) — front controller → Kernel → HttpKernel → legacy
- [Feuille de route](architecture/feuille-de-route.md) — orientations architecturales futures

### [Nouvelles fonctionnalités](features/index.md)

Découvrez les briques modernes de SPIP 5.0 et comment les utiliser dans vos développements.

- Système de Pipelines (Event Dispatcher)
- Tâches Cron (Attributs)
- Injection de dépendances (Services Symfony)
- Gestion HTTP (Request/Response)

### [Référence technique](reference/index.md)

Détails techniques et tables de correspondance.

- Paramètres de configuration `spip.*`
- Versionnement et symboles
- Liste des événements de pipelines

### [Guide de migration](upgrade/index.md)

Mise à jour d'un site ou d'un plugin depuis SPIP 4.x vers SPIP 5.0.

- Prérequis techniques
- Changements de rupture (Breaking changes)
- Dépréciations et suppressions
