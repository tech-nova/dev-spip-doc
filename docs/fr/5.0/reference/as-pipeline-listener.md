# Référence `AsPipelineListener`

Page de **référence** : comportement de `SpipLeague\Component\Kernel\Attribute\AsPipelineListener` dans SPIP 5.0-dev.
Contexte : [Event Dispatcher et Pipelines](../features/event-dispatcher-et-pipelines.md).
Migration : [Migrer les pipelines d'un plugin](../upgrade/pipelines-plugins.md).

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

Pour une meilleure lisibilité, il est recommandé de poser l'attribut sur des méthodes nommées `onNomEvenement(...)`.

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

À réserver aux pipelines qui n'ont pas encore d'event spécifique.

```php-inline
#[AsPipelineListener('pipeline_non_type', position: 'append')]
public function onPipelineNonType(PipelineEvent $event): void
{
    $subject = $event->getSubject();
    // ...
    $event->setSubject($subject);
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

## Voir aussi

- [Event Dispatcher et Pipelines](../features/event-dispatcher-et-pipelines.md)
- [Migrer les pipelines d'un plugin](../upgrade/pipelines-plugins.md)
- [Événements de pipelines](evenements-pipelines.md)
