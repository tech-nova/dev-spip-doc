# Contribution à la documentation

## Règles éditoriales

- Un seul titre H1 (`#`) par page.
- Fichiers en kebab-case.
- Liens relatifs entre pages Markdown.
- Pas d'accents dans les noms de fichiers.
- Utiliser `php-inline` pour les extraits de code PHP sans `<?php`.

## Style d'écriture (Diátaxis)

La documentation SPIP s'appuie sur le cadre [Diátaxis](https://diataxis.fr/) : quatre types de pages, chacun répondant à un besoin distinct du lecteur. L'objectif est d'obtenir des pages **par sujet (topic)**, précises et réutilisables. Éviter l’ambiguïté, les omissions et les présupposés non explicites afin de limiter les erreurs d’inférence — notamment pour des agents IA.

### Les quatre types de pages

| Type | Le lecteur veut… | Ce qu'on écrit | Ce qu'on évite |
|------|------------------|----------------|----------------|
| **Tutoriel** | Apprendre en faisant, du début à la fin | Parcours guidé, étapes numérotées, résultat vérifiable | Options avancées, digressions théoriques |
| **Guide pratique** (how-to) | Accomplir une tâche précise | Étapes orientées objectif, prérequis explicites | Exposer tout le contexte ou l'historique du projet |
| **Référence** | Consulter une information factuelle | Tables, signatures, paramètres, listes exhaustives | Narratif, opinions, « pourquoi » |
| **Explication** | Comprendre un concept ou un choix | Contexte, architecture, comparaisons, limites | Procédures pas à pas (renvoyer vers un how-to) |

### Règle du topic unique

- **Une page = un sujet = un type dominant.**
- Si une page mélange explication et procédure (par ex. présenter un concept *et* détailler la migration), **scinder** en deux pages ou **lier** vers la page adaptée plutôt que tout regrouper.
- Le titre H1 (`#`) nomme clairement le sujet ; le lecteur doit pouvoir identifier le type de page dès l'introduction.

### Single-sourcing

- Ne pas dupliquer le même contenu sur plusieurs pages : **une source canonique**, des liens ailleurs.
- Exemple : l'explication des pipelines vit dans `features/`, les étapes de migration dans `upgrade/` — chaque page renvoie à l'autre via `## Voir aussi`.
- Préférer les liens relatifs entre pages Markdown du même dépôt.

### Terminologie précise

Utiliser de préférence les termes suivants, de façon cohérente sur toute la doc :

| Notion | Terme à privilégier | À éviter (ou préciser) |
|--------|----------------------|-------------------------|
| Conteneur Symfony | conteneur de services, autowiring | « DI » sans contexte |
| Ancien mécanisme SPIP | pipeline (historique), fonction `pipeline()` | « hook » générique |
| Nouveau mécanisme | Event Dispatcher, listener, événement | « pipeline » pour un listener Symfony |
| Configuration | `spip.config`, métas, store | « config » seul si ambigu |
| Version | SPIP 5.0, SPIP 4.x | « la nouvelle version » |
| Packages modernes | `spip-league/*` | « le nouveau SPIP » |

Une notion = un terme ; en cas de synonyme historique, le mentionner une fois puis s'en tenir au terme canonique.

### Quel type pour ma page ?

Avant de rédiger, posez-vous :

1. Le lecteur part-il de zéro pour **apprendre** ? → **Tutoriel**
2. Il sait déjà et veut **faire** une chose précise ? → **Guide pratique**
3. Il cherche une **valeur, une signature, une liste** ? → **Référence**
4. Il veut **comprendre pourquoi / comment ça marche** ? → **Explication**

### Trame de sous-titres proposés par type (non imposés)

Les listes ci-dessous sont des **squelettes indicatifs** (titres `##` / `###` suggérés). Elles visent à harmoniser la doc : prenez ce qui sert, omettez le reste, adaptez l'ordre. Le **H1** reste le titre de la page ; ne dupliquez pas un second H1.

#### Tutoriel

- `## Objectif` ou `## Ce que vous allez construire`
- `## Prérequis`
- `## Étapes` (avec `### Étape 1`, `### Étape 2`, …)
- `## Résultat attendu`
- `## Vérification`
- `## Pour aller plus loin`

#### Guide pratique (how-to)

- `## Objectif`
- `## Prérequis`
- `## Étapes`
- `## Vérification`
- `## Cas particuliers` ou `## Dépannage`
- `## Voir aussi`

#### Référence

- `## Description`
- `## Syntaxe` ou `## Signature`
- `## Paramètres`
- `## Valeur de retour`
- `## Exemples`
- `## Voir aussi`

Pour les pages essentiellement tabulaires (paramètres `spip.*`, événements de pipelines, etc.) : placer la **table en tête** de page, puis des sections courtes de notes ou d'exemples si nécessaire.

#### Explication

- `## En bref`
- `## Contexte` ou `## Pourquoi`
- `## Fonctionnement` ou `## Concepts clés`
- `## Différences avec SPIP 4.x` (le cas échéant)
- `## Limites et pièges`
- `## Voir aussi`

**Note transverse :** `## Voir aussi` est recommandé sur tous les types pour matérialiser le single-sourcing (liens croisés plutôt que duplication de contenu).

### Correspondance avec la structure actuelle

La doc est organisée par langue et version (`docs/fr/5.0/`, etc.). Les dossiers existants se rapprochent déjà de Diátaxis :

| Dossier actuel | Type Diátaxis visé | Remarques |
|----------------|-------------------|-----------|
| `architecture/` | **Explication** | Contexte, cycle applicatif, feuille de route |
| `upgrade/` (Migration) | **Guide pratique** | Tâches de migration SPIP 4.x → 5.0 |
| `reference/` | **Référence** | Paramètres, symboles, événements, attributs |
| `features/` | **Explication** (cible) | Aujourd'hui parfois **mixte** (concept + procédure) ; privilégier l'explication des briques modernes et lier vers `upgrade/` pour les étapes opératoires |

**Quadrant non encore couvert :** les **tutoriels** (apprentissage guidé de bout en bout, ex. « Créer un premier plugin SPIP 5 »). Piste future ; pas d'obligation de créer ce dossier immédiatement.

Lors d'une contribution nouvelle ou d'une révision, vérifier que la page correspond au type du dossier cible, ou proposer un déplacement / une scission si le contenu déborde.

## Checklist de revue

- Navigation mise à jour si une page est ajoutée ou déplacée.
- Liens internes valides.
- Images référencées présentes dans le dépôt.
- Cohérence FR/EN lorsque la page est traduite.
- Type de page Diátaxis identifiable ; pas de mélange concept / procédure sans lien explicite.
- Sous-titres cohérents avec la trame proposée (si applicable).

## Workflow recommandé

1. `make lint` — analyse Markdown (pymarkdown, récursif sur `docs/fr` et `docs/en`).
2. Si besoin : `make lint-fix` puis relancer `make lint` pour vérifier ce qui reste manuel.
3. `make build` — quatre builds Zensical stricts (validation avant déploiement).
