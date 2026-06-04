# Étendre Guard dans un plugin

Ce guide pratique décrit **comment** ajouter une règle personnalisée au moteur Guard de SPIP 5.0.
Le modèle est expliqué dans [Guard](../features/guard.md).

## Objectif

Bloquer ou autoriser une requête selon une logique métier (quota API, IP, route) avant le bootstrap legacy.

## Prérequis

- Plugin avec `config/services.php` (autoconfigure activé).
- Compréhension de [Guard](../features/guard.md).

## Étapes

### 1. Implémenter `GuardRuleInterface`

```php-inline
use SpipLeague\Component\Guard\Attribute\AsGuard;
use SpipLeague\Component\Guard\GuardContext;
use SpipLeague\Component\Guard\GuardRuleInterface;
use SpipLeague\Component\Guard\GuardVerdict;

#[AsGuard(priority: 50)]
final class ApiRateGuard implements GuardRuleInterface
{
    public function evaluate(GuardContext $context): GuardVerdict
    {
        // quota, IP, route…
        return GuardVerdict::allow();
    }
}
```

### 2. Enregistrer le service

La classe doit être dans le namespace chargé par `config/services.php` du plugin (autoconfigure).

### 3. Priorité

`#[AsGuard(priority: …)]` : plus la valeur est élevée, plus la règle est évaluée tôt.

## Vérification

- Déclencher une requête qui doit être bloquée : réponse 403 ou 429 avant exécution du legacy.
- Vérifier que la règle n’accède pas aux superglobales.

## Voir aussi

- [Guard](../features/guard.md)
- [HTTP Request / Response](../features/http-request-response.md)
