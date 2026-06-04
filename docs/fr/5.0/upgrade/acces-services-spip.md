# Migrer vers la façade Spip

Ce guide pratique décrit **comment** remplacer `service()`, `param()` et `_request()` par **`Spip::`** dans le code procédural.
Le modèle est expliqué dans [Façade Spip et Inputs](../features/acces-services-spip.md).

## Objectif

Adopter la façade de transition SPIP 5.0 sans multiplier les fonctions globales.

## Prérequis

- Bootstrap HTTP actif (requête web ou CLI simulant une requête pour `input()`).

## Étapes

### 1. Configuration

```php
$site = Spip::config('nom_site');
$repo = Spip::configs();
```

### 2. Logs

```php
Spip::logger()->info('Message');
Spip::logger('mysql')->debug('Requête');
```

### 3. Entrées HTTP

```php
$id = Spip::input('id_article');
$all = Spip::inputs();
```

### 4. Services et paramètres

```php
$kernel = Spip::service('kernel');
$tmp = Spip::param('spip.dirs.tmp');
```

### 5. Code objet

Préférer l’injection : `ConfigRepositoryInterface`, `RequestStack`, `Inputs`, `LoggerInterface`.

## Vérification

- Remplacer un appel `service('spip.config')` par `Spip::configs()` et vérifier le comportement.
- S’assurer qu’aucun accès `_request()` ne reste sur du code neuf.

## Voir aussi

- [Façade Spip et Inputs](../features/acces-services-spip.md)
- [Configurer les services d’un plugin](services-plugin.md)
