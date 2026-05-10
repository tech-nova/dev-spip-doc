# Liste des événements de pipelines

SPIP 5.0 propose des classes d'événements dédiées pour les pipelines les plus courants. Ces classes se trouvent dans le répertoire `ecrire/src/Framework/Pipeline/Event/`.

## Table de correspondance

| Pipeline historique | Classe d'événement | Description |
| :--- | :--- | :--- |
| `affichage_final` | `AffichageFinalEvent` | HTML final des pages publiques |
| `affichage_final_prive` | `AffichageFinalPriveEvent` | HTML final de l'espace privé |
| `insert_head` | `InsertHeadEvent` | Contenu `<head>` public (JS, meta) |
| `insert_head_css` | `InsertHeadCssEvent` | CSS dans `<head>` public |
| `header_prive` | `HeaderPriveEvent` | Contenu `<head>` privé (JS, meta) |
| `header_prive_css` | `HeaderPriveCssEvent` | CSS dans `<head>` privé |
| `formulaire_charger` | `FormulaireChargerEvent` | Chargement des formulaires CVT |
| `formulaire_verifier` | `FormulaireVerifierEvent` | Vérification des formulaires CVT |
| `formulaire_traiter` | `FormulaireTraiterEvent` | Traitement des formulaires CVT |
| `styliser` | `StyliserEvent` | Sélection du squelette |
| `recuperer_fond` | `RecupererFondEvent` | Interception des inclusions |
| `boite_infos` | `BoiteInfosEvent` | Boîte d'infos objets (privé) |
| `affiche_milieu` | `AfficheMilieuEvent` | Zone centrale des pages objets |
| `taches_generales_cron` | `TachesGeneralesCronEvent` | Déclaration des tâches cron |
| `post_insertion` | `PostInsertionEvent` | Après insertion en base |
| `pre_edition` | `PreEditionEvent` | Avant modification d'un objet |
| `post_edition` | `PostEditionEvent` | Après modification d'un objet |

## Utilisation générique

Pour les pipelines ne disposant pas encore d'une classe dédiée, vous pouvez utiliser la classe générique **`SpipLeague\Bridge\Pipeline\PipelineEvent`**.

Elle propose les méthodes suivantes :

- `getSubject()` / `setSubject()` : pour manipuler les données principales (anciennement `$flux['data']` ou `$flux`).
- `getArguments()` / `getArgument($key)` : pour accéder au contexte (anciennement `$flux['args']`).
