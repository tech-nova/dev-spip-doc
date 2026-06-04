# Event Dispatcher et Pipelines

Cette page **explique** le modèle de communication par événements de SPIP 5.0.
Pour migrer du code : [Migrer les pipelines](../upgrade/pipelines.md), [dans un plugin](../upgrade/pipelines-plugins.md).
Pour les signatures : [Événements de pipelines](../reference/evenements-pipelines.md), [`AsPipelineListener`](../reference/as-pipeline-listener.md).

## En bref

SPIP 5.0 s’appuie sur le **Event Dispatcher** de Symfony pour les pipelines historiques :
events typés, listeners en services, pont avec `pipeline()` pour la compatibilité.

## Contexte

Les pipelines SPIP permettent aux plugins d’intercepter des données à des points fixes du cycle de publication.
Le modèle historique reposait sur des fonctions globales et `pipelines.php`.
SPIP 5.0 conserve ce mécanisme tout en offrant une couche typée et testable.

## Concepts clés

- **Event :** classe PHP qui transporte les données du pipeline (ex. `AffichageFinalEvent`).
- **Listener :** méthode de service qui réagit à un event, déclarée via `#[AsPipelineListener]`.
- **Event générique :** `PipelineEvent` pour les pipelines sans classe dédiée encore.

La déduction du nom de pipeline depuis le type d’event (`#[AsPipelineEvent('nom')]`) évite les erreurs.
Les unions de types permettent d’écouter plusieurs pipelines avec un seul listener.

## Fonctionnement

Le conteneur enregistre les listeners au boot des plugins.
L’ordre d’exécution se règle avec `position` (`prepend`, `normal`, `append`).
Les données passent par l’objet event plutôt que par des tableaux non typés.

## Différences avec SPIP 4.x

| SPIP 4.x | SPIP 5.0 |
|----------|----------|
| `prefixe_pipeline()` dans le plugin | Listener + `#[AsPipelineListener]` |
| `pipeline('nom', $data)` | Event Dispatcher + classes d’event |
| Données souvent non typées | Typage fort sur les events du cœur |

## Limites et pièges

- Ne pas confondre **pipeline historique** et **listener Symfony** dans la terminologie.
- Les pipelines sans classe dédiée restent sur `PipelineEvent` : le nom doit être indiqué explicitement sur l’attribut.
- La procédure de déclaration et de migration est détaillée dans les guides pratiques, pas ici.

## Voir aussi

- [Migrer les pipelines](../upgrade/pipelines.md)
- [Migrer les pipelines d’un plugin](../upgrade/pipelines-plugins.md)
- [Événements de pipelines](../reference/evenements-pipelines.md)
- [Référence `AsPipelineListener`](../reference/as-pipeline-listener.md)
