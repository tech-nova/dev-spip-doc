# Référence `AsPipelineListener`

Cette page documente le comportement exact de `SpipLeague\Component\Kernel\Attribute\AsPipelineListener` dans SPIP 5.0-dev.

## Signature

```php-inline
#[AsPipelineListener(
    ?string $pipeline = null,
    string $position = 'normal',
    string $method = '__invoke',
)]
```

## Portée de l'attribut

- Attribut sur **méthode** : la méthode annotée est utilisée.
- Attribut sur **classe** : la méthode appelée par défaut est `__invoke` (sauf si `method` est fourni explicitement).

Pour une meilleure lisibilité, il est recommandé de poser l'attribut sur des méthodes nommées `onNomPipeline(...)`.

## Règles de résolution

### 1) Pipeline explicite

Si `pipeline` est renseigné, SPIP enregistre le listener sur `spip.pipeline.<pipeline>`.

### 2) Pipeline déduit

Si `pipeline` est absent (`#[AsPipelineListener]`), SPIP inspecte le type du 1er argument de la méthode listener :

- **type nommé** : résolution sur une classe d'event annotée `#[AsPipelineEvent('...')]` ;
- **type union** : résolution sur chaque classe annotée `AsPipelineEvent` (un listener est enregistré par pipeline).

### 3) Types ignorés

Sont ignorés pendant la résolution :

- types builtin (`string`, `array`, etc.) ;
- classes introuvables ;
- classes sans attribut `AsPipelineEvent`.

Si, après filtrage, aucun pipeline n'est déductible, la compilation échoue avec une exception explicite.

## Position (`position`)

Valeurs supportées :

- `prepend` : exécution en tête ;
- `normal` : valeur par défaut ;
- `append` : exécution en fin.

## Exemples

### Listener explicite

```php-inline
#[AsPipelineListener('affichage_final', position: 'append')]
public function onAffichageFinal(AffichageFinalEvent $event): void
{
    $event->appendToBody('...');
}
```

### Listener déduit

```php-inline
#[AsPipelineListener]
public function onAffichageFinal(AffichageFinalEvent $event): void
{
    $event->appendToBody('...');
}
```

### Listener multi-pipelines (union type)

```php-inline
#[AsPipelineListener]
public function onSidebar(AfficheGaucheEvent|AfficheDroiteEvent $event): void
{
    // enregistré pour les deux pipelines
}
```
