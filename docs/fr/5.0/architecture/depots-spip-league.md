# Dépôts spip-league

SPIP 5 s’appuie sur une série de bibliothèques PHP maintenues par l’organisation
[spip-league](https://git.spip.net/spip-league). Elles constituent la couche « moderne » du projet
(conteneur Symfony, HTTP, pipelines typés, cache, chemins, etc.), distincte du code historique dans `ecrire/`.

## Paquets installés

Le tableau suivant recense les paquets **spip-league** d’une distribution SPIP 5
(noms de dépôt sur [git.spip.net](https://git.spip.net/spip-league)).

| Paquet | Rôle succinct | Dépôt |
| :--- | :--- | :--- |
| **kernel** | Noyau applicatif : détection d’installation, conteneur, routage, attributs pipeline/cron. | [kernel](https://git.spip.net/spip-league/kernel) |
| **http-kernel** | Orchestration HTTP : bootstrap legacy, handlers, Request → Response. | [http-kernel](https://git.spip.net/spip-league/http-kernel) |
| **guard** | Écran de sécurité : règles sur `kernel.request` (bots, abus d’URL, délestage). | [guard](https://git.spip.net/spip-league/guard) |
| **http** | Pont HTTP (exceptions de flux, intégration HttpFoundation). | [http](https://git.spip.net/spip-league/http) |
| **pipeline-bridge** | Pont pipelines SPIP ↔ `symfony/event-dispatcher`. | [pipeline-bridge](https://git.spip.net/spip-league/pipeline-bridge) |
| **composer-installer** | Plugin Composer : layout SPIP, extensions, autoload. | [composer-installer](https://git.spip.net/spip-league/composer-installer) |
| **console** | CLI SPIP (`bin/spip`) via `symfony/console`. | [console](https://git.spip.net/spip-league/console) |
| **logger** | Journalisation PSR-3 adaptée à SPIP. | [logger](https://git.spip.net/spip-league/logger) |
| **filesystem** | Abstraction fichiers (lecture/écriture, opérations courantes). | [filesystem](https://git.spip.net/spip-league/filesystem) |
| **filesystem-contracts** | Interfaces du filesystem. | [filesystem-contracts](https://git.spip.net/spip-league/filesystem-contracts) |
| **cache** | Gestion du cache (fichiers, invalidation). | [cache](https://git.spip.net/spip-league/cache) |
| **cache-contracts** | Interfaces du cache. | [cache-contracts](https://git.spip.net/spip-league/cache-contracts) |
| **path** | Résolution et manipulation des chemins SPIP. | [path](https://git.spip.net/spip-league/path) |
| **path-contracts** | Interfaces des chemins. | [path-contracts](https://git.spip.net/spip-league/path-contracts) |
| **hasher** | Hachage de contenus (fichiers, empreintes). | [hasher](https://git.spip.net/spip-league/hasher) |
| **serializer** | Sérialisation / désérialisation de structures. | [serializer](https://git.spip.net/spip-league/serializer) |

## Regroupement fonctionnel

- **Noyau et HTTP** : `kernel`, `http`, `http-kernel`, `guard` — voir [Services Symfony](../features/services-symfony.md),
  [HTTP Request/Response](../features/http-request-response.md) et [Guard](../features/guard.md).
- **Intégration Composer & CLI** : `composer-installer`, `console`.
- **Événements** : `pipeline-bridge` (+ attributs dans `kernel`) — voir
  [Event Dispatcher et pipelines](../features/event-dispatcher-et-pipelines.md).
- **Infrastructure** : `filesystem`, `cache`, `path`, `hasher`, `logger`, `serializer`, et paquets `*-contracts`.

## Paquets d’outillage

D’autres dépôts **spip-league** servent au **développement et à la QA** des bibliothèques et du core. Ils sont
tirés en `require-dev` (souvent via `ecrire/composer.json` ou le `composer.json` de chaque dépôt) et se trouvent
le plus souvent dans `ecrire/vendor/spip-league/`, pas à la racine du projet SPIP.

| Paquet | Rôle succinct | Dépôt |
| :--- | :--- | :--- |
| **sdk** | Kit de dev : stubs legacy, doubles de test, tire `qa-tools`. | [sdk](https://git.spip.net/spip-league/sdk) |
| **qa-tools** | Métapaquet QA : PHPUnit, PHPStan, ECS, Rector upstream, VarDumper. | [qa-tools](https://git.spip.net/spip-league/qa-tools) |
| **easy-coding-standard** | Config ECS (Symplify) partagée SPIP. | [easy-coding-standard](https://git.spip.net/spip-league/easy-coding-standard) |
| **rector** | Règles Rector SPIP (`SpipSetList`, type `rector-extension`). | [rector](https://git.spip.net/spip-league/rector) |

### Ce que le SDK embarque ou orchestre

Le paquet **sdk** s’appuie sur **qa-tools** (`composer require spip-league/qa-tools`) et centralise l’outillage
attendu dans les dépôts spip-league (`composer analyse`, `composer test`, `composer fix-cs`, `composer rector`,
etc.).

**Outils tirés via `qa-tools` :**

- **[PHPUnit](https://docs.phpunit.de/)** — tests unitaires et d’intégration ;
- **[PHPStan](https://phpstan.org/user-guide/getting-started)** — analyse statique ;
- **[Easy Coding Standard](https://github.com/easy-coding-standard/easy-coding-standard#documentation)** — formatage et style (ECS / Symplify) ;
- **[Rector](https://getrector.com/documentation)** — moteur de refactorings (règles SPIP : **spip-league/rector**) ;
- **[Symfony VarDumper](https://symfony.com/doc/current/components/var_dumper.html)** — débogage en développement.

## Voir aussi

- [Cycle applicatif HTTP](cycle-applicatif-http.md)
- [Environnement et Kernel](../guides/migration/environnement-kernel.md)
- [Services et injection de dépendances](../features/services-symfony.md)
