# Contribution à la documentation

## Règles éditoriales

- Un seul titre H1 (`#`) par page.
- Fichiers en kebab-case.
- Liens relatifs entre pages Markdown.
- Pas d'accents dans les noms de fichiers.
- Utiliser `php` pour les extraits de code PHP (sans `<?php` en tête).

## Style d'écriture (Diátaxis)

La documentation SPIP s'appuie sur le cadre [Diátaxis](https://diataxis.fr/) : quatre types de pages, chacun répondant à un besoin distinct des lectrices et lecteurs. L'objectif est d'obtenir des pages **par sujet (topic)**, précises et réutilisables. Éviter l’ambiguïté, les omissions et les présupposés non explicites afin de limiter les erreurs d’inférence — notamment pour des agents IA.

### Les quatre types de pages

| Type | Le lecteur veut… | Ce qu'on écrit | Ce qu'on évite |
|------|------------------|----------------|----------------|
| **Tutoriel** | Apprendre en faisant, du début à la fin | Parcours guidé, étapes numérotées, résultat vérifiable | Options avancées, digressions théoriques |
| **Guide pratique** (how-to) | Accomplir une tâche précise | Étapes orientées objectif, prérequis explicites | Exposer tout le contexte ou l'historique du projet |
| **Référence** | Consulter une information factuelle | Tables, signatures, paramètres, listes exhaustives | Narratif, opinions, « pourquoi » |
| **Explication** | Comprendre un concept ou un choix | Contexte, architecture, comparaisons, limites | Procédures pas à pas (renvoyer vers un how-to) |

### Règle du topic unique

- **Une page = un sujet = un type dominant.**
- Si une page mélange explication et procédure (par ex. présenter un concept *et* détailler la migration), **scinder** en deux pages et/ou **lier** vers la page adaptée plutôt que tout regrouper.
- Le titre H1 (`#`) nomme clairement le sujet ; le lecteur doit pouvoir identifier le type de page dès l'introduction.

### Single-sourcing

- Ne pas dupliquer le même contenu sur plusieurs pages : **une source canonique**, des liens ailleurs.
- Exemple : l'explication des pipelines vit dans `features/`, les étapes de migration dans `guides/migration/` — chaque page renvoie à l'autre via `## Voir aussi`.
- Préférer les liens relatifs entre pages Markdown du même dépôt.

### Liens en introduction

Par défaut, **tous** les renvois vont en fin d'article dans la section `## Voir aussi`.

En introduction, on tolère **au plus un seul lien** : celui vers la page **jumelée du type complémentaire** (explication ↔ guide pratique), formulé de façon homogène. Concrètement :

- Page **explication** (`features/`) : l'intro peut lier vers le guide pratique jumelé (`Mise en œuvre : [...](...)`).
- Page **guide pratique** (`guides/`) : l'intro peut lier vers la page **explication** associée (`Le modèle est expliqué dans [...](...)`).
- **Jamais** de lien vers `reference/` en intro (toujours en `## Voir aussi`), ni de second lien « bonus ».

Éviter la phrase d'ouverture boilerplate « Cette page **explique**… / Ce guide pratique décrit **comment**… » : le type de page est déjà porté par l'onglet de navigation et le H1. Préférer une intro substantielle qui entre dans le sujet.

### Code dans les pages d'explication

Diátaxis proscrit les **instructions** (pas-à-pas) dans l'explication, **pas** le code illustratif. Une page `features/` **doit** donc montrer un court extrait **canonique / idiomatique** (≈ 15 lignes max) donnant à voir « à quoi ressemble » l'API publique.

- `features/` : *un* extrait minimal qui illustre l'usage typique (pas de prérequis, pas d'étapes numérotées).
- `guides/` : la procédure complète, étape par étape, avec variantes et dépannage.

Éviter la duplication : l'extrait de `features/` reste conceptuel et court ; il ne recopie pas mot pour mot un bloc d'un guide.

### Frontière interne / public

`doc.spip.net` (ce dépôt) s'adresse aux **utilisateurs et développeuses** : API publique stable, points d'**extensibilité**, migration. Les **détails d'implémentation interne** d'un composant (couches privées, classes `@internal`, choix d'architecture) vivent dans le dépôt du composant : `vendor/spip-league/<paquet>/docs/*.md` (+ `README.md`), à destination des **contributeurs** de ce composant.

En cas de doute : « est-ce nécessaire pour *utiliser* ou *étendre* la brique ? » → ici ; « est-ce utile seulement pour *modifier le composant* ? » → docs du dépôt.

### Organisation par type, pas par concept

Les dossiers suivent les **types** Diátaxis (`features/` = explication, `guides/` = how-to, `reference/` = référence), **pas** les concepts. Un concept (ex. `spip.config`) se matérialise de façon transverse, sans dossier dédié, via trois leviers :

1. **Hub** : la page `features/<concept>.md` est le point d'entrée ; son `## Voir aussi` liste les facettes (how-to dans `guides/`, signatures dans `reference/`).
2. **Nommage en miroir** : même radical de fichier d'un dossier à l'autre (`features/config.md` ↔ `guides/migration/config.md`).
3. **Matrice d'index** : `features/index.md` tient la table « Sujet | Explication | Guide pratique | Référence » qui sert d'index par concept.

Raisons : beaucoup de how-to sont transverses (prérequis, dépréciations…), les concepts ont des facettes asymétriques, et le type garde des URLs stables.

### How-to (`guides/`) et migration (`guides/migration/`)

Le quadrant how-to de Diátaxis s'appelle « Guides ». La **migration 4.x → 5.0** n'en est qu'un sous-ensemble :

- `guides/` : how-to **généraux**, utiles même pour un plugin neuf (ex. « Configurer les services d'un plugin »).
- `guides/migration/` : how-to **spécifiques à la migration** depuis SPIP 4.x (prérequis, dépréciations, changements de syntaxe…).

### Terminologie précise

Utiliser de préférence les termes suivants, de façon cohérente sur toute la doc :

| Notion | Terme à privilégier | À éviter (ou préciser) |
|--------|----------------------|-------------------------|
| Conteneur Symfony | conteneur de services, autowiring | « DI » sans contexte |
| Ancien mécanisme SPIP | pipeline (historique), fonction `pipeline()` | « hook » générique |
| Nouveau mécanisme | Event Dispatcher, listener, événement | « pipeline » pour un listener Symfony |
| Configuration | `spip.config`, métas | « config » seul si ambigu |
| Version | SPIP 5.0, SPIP 4.x | « la nouvelle version » |
| Packages modernes | `spip-league/*` | « le nouveau SPIP » |

Une notion = un terme ; en cas de synonyme historique, le mentionner une fois puis s'en tenir au terme canonique.

### Quel type pour ma page ?

Avant de rédiger, posez-vous les questions suivantes :

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
| `features/` | **Explication** | Explication des briques modernes (+ extrait canonique) et liens vers `guides/` pour les étapes opératoires |
| `reference/` | **Référence** | Paramètres, symboles, événements, attributs |
| `guides/` | **Guide pratique** | How-to généraux (faire X en SPIP 5.0) |
| `guides/migration/` | **Guide pratique** | Tâches de migration SPIP 4.x → 5.0 |

**Quadrant non encore couvert :** les **tutoriels** (apprentissage guidé de bout en bout, ex. « Créer un premier plugin SPIP 5 »).

Lors d'une contribution nouvelle ou d'une révision, vérifier que la page correspond au type du dossier cible, ou proposer un déplacement / une scission si le contenu déborde.

### Alignement du corpus existant

- **`features/`** : explication + un extrait canonique court ; procédures détaillées → **`guides/`**.
- **`guides/`** : how-to généraux ; **`guides/migration/`** : how-to spécifiques à la migration 4.x → 5.0. Pas de long exposé conceptuel (lien vers `features/`).
- **`reference/`** : faits, tables, signatures.
- **Détails internes d'un composant** : dans `vendor/spip-league/<paquet>/docs/` (+ `README.md`), pas sur `doc.spip.net`.
- **Traductions** : stabiliser le français (`docs/fr/5.0/`) avant de traduire ; les index `docs/en/` et `docs/fr/4.4/` peuvent renvoyer vers le contenu FR en attendant.

### Navigation (Zensical / SPIP 5.0)

Configuration dans `zensical-fr-5.0.toml` :

- **Onglets** (`navigation.tabs`) : Accueil, Architecture, Fonctionnalités, Référence, Guides (avec la migration 4.x → 5.0 en sous-section, en dernier).
- **Accueil** : conservé comme premier onglet (page d’accueil) ; le logo renvoie aussi vers l’index.
- **Profondeur** : regrouper les longues listes (surtout `guides/`) en sous-sections niveau 3, alignées sur les sommaires `*/index.md`.
- **Libellés** : courts dans le `nav` ; titre complet dans le H1 de la page.
- Ne pas activer `navigation.expand` (sidebar trop longue) ni `navigation.prune` (exploration limitée).

Voir [Navigation — Zensical](https://zensical.org/docs/setup/navigation/).

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
