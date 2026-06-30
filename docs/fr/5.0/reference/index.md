# Référence technique SPIP 5.0

Cette section regroupe les informations de référence, les tables de correspondance et les détails techniques de SPIP 5.0.

## Sommaire de référence

### [Paramètres de configuration `spip.*`](parametres-spip.md)

Liste des paramètres disponibles dans le conteneur de services pour configurer le noyau et les composants.

### [Versionnement et Symboles](spipversion-et-symboles.md)

Détails sur la classe `SpipVersion` et les changements dans les globales de version.

### [Liste des événements de pipelines](evenements-pipelines.md)

Table de correspondance entre les pipelines historiques et les nouvelles classes d'événements, avec les méthodes utiles par event.

### [Référence SpipDirectories](spip-directories.md)

Méthodes du service `spip.directories`, chemins absolus/relatifs et correspondance avec les constantes legacy `_DIR_*`.

### [Référence `AsPipelineListener`](as-pipeline-listener.md)

Détails de la résolution automatique (type-hints, union types), des positions d'exécution et des cas d'erreur.

### [Manifeste des plugins](manifeste-plugins.md)

Structure de `var/state/plugins.php`, signature du manifeste et rôle dans la compilation du conteneur.

Pour les exemples de migration, consultez [Migrer les pipelines](../guides/migration/pipelines.md).
