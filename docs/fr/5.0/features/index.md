# Nouvelles fonctionnalités de SPIP 5.0

SPIP 5.0 introduit des briques architecturales basées sur Symfony pour faciliter le développement de plugins robustes, testables et maintenables.

## Sommaire des fonctionnalités

### [Event Dispatcher et Pipelines](event-dispatcher-et-pipelines.md)

Le nouveau système de communication entre composants. Remplace avantageusement les pipelines historiques par des événements typés et des listeners enregistrés comme
services. Pour les étapes de migration, consultez [Migrer les pipelines](../upgrade/pipelines.md).

### [Tâches Cron et Attributs](cron-taches-attributs.md)

Déclarez vos tâches de fond simplement avec l'attribut `#[AsCronTask]`. Plus besoin de modifier `paquet.xml` ou de passer par le pipeline `taches_generales_cron`.

### [Menus et Onglets de l'espace privé](menus.md)

Découvrez la nouvelle façon de déclarer vos menus et onglets via le fichier `config/menus.php`, remplaçant les balises XML de `paquet.xml`.

### [Services et Injection de dépendances](services-symfony.md)

Utilisez la puissance du conteneur de services Symfony. Autowiring, autoconfiguration et gestion fine des dépendances pour vos classes PHP.

### [Façade Spip et Inputs](acces-services-spip.md)

Accès typé aux services courants (`Spip::config('cle')`, `Spip::configs()`, `Spip::input()`, …), objet `Inputs` (`spip-league/http`) sur `RequestStack`.

### [Configuration (spip-league/config)](config.md)

Centralisation des métas et tables auxiliaires via **`spip-league/config`** : services `spip.config` et `spip.config.manager`, stores SQL taggés, cache PSR-16 et pont legacy vers `lire_config()` / `ecrire_config()`. Pour la migration depuis SPIP 4.x, consultez [Configuration et métas](../upgrade/config.md).

### [Gestion HTTP (Request/Response)](http-request-response.md)

SPIP 5.0 utilise désormais `Symfony\Component\HttpFoundation`. Découvrez comment manipuler la requête et retourner des réponses proprement.

### [Système de Log (PSR-3)](logger.md)

Utilisez le nouveau logger compatible PSR-3. Découvrez comment configurer vos logs et injecter le logger dans vos services.
