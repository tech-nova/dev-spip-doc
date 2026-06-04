# Guide de migration vers SPIP 5.0

Ce guide regroupe les **guides pratiques** pour mettre à jour sites et plugins de SPIP 4.x vers SPIP 5.0.
Pour comprendre le « pourquoi » des briques modernes, voir [Fonctionnalités](../features/index.md).

## Sommaire de migration

### Préparation

- **[Prérequis](prerequis.md)** — PHP 8.2+, base de données, `plugins-dist/`
- **[Environnement et Kernel](environnement-kernel.md)** — `.env`, configuration du Kernel

### Cœur et squelettes

- **[Squelettes et syntaxe](squelettes.md)**
- **[API PHP et fonctions](php-api.md)**
- **[Configuration et métas](config.md)**
- **[Compilateur de squelettes](compilateur.md)**

### Plugins modernes

- **[Migrer les pipelines](pipelines.md)** · [dans un plugin](pipelines-plugins.md)
- **[Migrer les tâches cron](cron-taches-attributs.md)**
- **[Configurer les services d’un plugin](services-plugin.md)**
- **[Migrer menus et onglets](menus-onglets.md)**
- **[Façade Spip et Inputs](acces-services-spip.md)**
- **[HTTP Request/Response](http-request-response.md)**
- **[Logs PSR-3](logger.md)**
- **[Étendre Guard](guard-extension.md)**

### Interface et fin de migration

- **[Javascript et assets](javascript.md)**
- **[Espace privé — ruptures UI](espace-prive-et-menus.md)**
- **[Dépréciations et suppressions](deprecations-et-suppressions.md)**
