# Squelettes et Syntaxe

SPIP 5.0 apporte des améliorations et des changements de rupture dans la syntaxe des squelettes.

## Parties optionnelles des balises

Il est désormais possible d'utiliser des crochets `[` et `]` à l'intérieur des parties optionnelles des balises sans casser la syntaxe.

### Exemples

- `[avant] (#VAL{texte})]` écrit `avant] texte`
- `[(#VAL{texte}) [après]` écrit `texte [après`

### Attention aux ambiguïtés (CSS)

Certaines écritures, notamment en CSS, peuvent désormais être interprétées par erreur comme des parties optionnelles. Il convient de lever l'ambiguïté en échappant
les parenthèses ou en utilisant des guillemets.

**Avant :**

```css
a[href] { background-image: url(#CHEMIN_IMAGE{img.svg}); }
```

**Après :**

```css
a[href] { background-image: url\(#CHEMIN_IMAGE{img.svg}); }
/* ou */
a[href] { background-image: url("#CHEMIN_IMAGE{img.svg}"); }
```

## Casse des items de langue

Avant SPIP 5.0, les items de langue étaient automatiquement passés en minuscules. Désormais, la casse est respectée : `<:toto:>` n'est plus équivalent à `<:TOTO:>`.

- **Conseil :** utilisez systématiquement des minuscules pour vos clés de langue.

## Inclusions

### Suppression de l'inclusion de fichiers PHP

L'inclusion directe de fichiers PHP via `<INCLURE>` est supprimée.

- **Avant :** `<INCLURE(fichier.php)>` ou `<INCLURE{fond=fichier.php}>`
- **Après :** utilisez uniquement des fichiers de squelette `.html`.

### Suppression de la balise fermante `</INCLURE>`

La syntaxe `<INCLURE{fond=...}></INCLURE>` est supprimée au profit de la syntaxe auto-fermante.

- **Après :** `<INCLURE{fond=...} />`

## Nouveaux noms de critères (Dépréciations)

Les critères de boucle suivants sont dépréciés.

### Critère `{collecte}` → `{collate}`

**Avant :**

```spip
<BOUCLE_a(ARTICLES) {par titre} {collecte utf8_spanish_ci}>
```

**Après :**

```spip
<BOUCLE_a(ARTICLES) {par titre} {collate utf8_spanish_ci}>
```

### Critère `{fusion}` → `{groupby}`

**Avant :**

```spip
<BOUCLE_extrait(ARTICLES){fusion id_rubrique}>
```

**Après :**

```spip
<BOUCLE_extrait(ARTICLES){groupby id_rubrique}>
```

### Critère `{fusion_supprimer}` → `{groupby_supprimer}`

**Avant :**

```spip
<BOUCLE_f(ARTICLES){fusion_supprimer}{fusion YEAR(date)}>
```

**Après :**

```spip
<BOUCLE_f(ARTICLES){groupby_supprimer}{groupby YEAR(date)}>
```

## Suppression des syntaxes historiques (Dépréciations SPIP 2.x)

### Filtres de `#LOGO_`

Les faux filtres de positionnement et de lien sont supprimés.

**Avant :**

```spip
[(#LOGO_ARTICLE|left)]
[(#LOGO_ARTICLE|#URL_ARTICLE)]
[(#LOGO_ARTICLE|fichier)]
```

**Après :**

```spip
[(#LOGO_ARTICLE{left})]
[(#LOGO_ARTICLE{#URL_ARTICLE})]
[(#LOGO_ARTICLE**)]
```

### Boucle `POUR` et filtre `foreach`

Ils sont remplacés par la boucle `DATA`.

**Avant (Boucle POUR) :**

```spip
<BOUCLE_l(POUR){tableau #LISTE{a,b,c}}>
  #CLE : #VALEUR
</BOUCLE_l>
```

**Après (Boucle DATA) :**

```spip
<BOUCLE_l(DATA){source tableau, #LISTE{a,b,c}}>
  #CLE : #VALEUR
</BOUCLE_l>
```

### Autres balises

- **Balise `#EXPOSER` :** utilisez `[(#EXPOSE{on,off})]` au lieu de `[(#EXPOSER|on,off)]`.
- **Balise `#EMBED_DOCUMENT` :** utilisez `[(#MODELE{emb, ...})]` au lieu de `[(#EMBED_DOCUMENT|...)]`.

### Filtre `#FORMULAIRE_RECHERCHE|parametre`

**Avant :**

```spip
[(#FORMULAIRE_RECHERCHE|param)]
```

**Après :**

```spip
[(#FORMULAIRE_RECHERCHE{param})]
```

### Filtre `icone`

Le filtre `icone` est supprimé. Utilisez `icone_verticale` (ou `icone_horizontale`).

**Avant :**

```spip
[(#URL_ECRIRE{article_edit,id_article=#ID_ARTICLE}
  |icone{Éditer,article-24.png,#LANG_RIGHT,edit,ajax})]
```

**Après :**

```spip
[(#URL_ECRIRE{article_edit,id_article=#ID_ARTICLE}
  |icone_verticale{Éditer,article,edit,right ajax})]
```

### Filtre `foreach`

Le filtre déprécié `foreach` est supprimé. Utilisez une boucle `DATA`.

**Avant :**

```spip
[(#LISTE{a,b,c,d}|foreach)]
```

**Après :**

```spip
<BOUCLE_liste(DATA){source tableau, #LISTE{a,b,c,d}}>
- #CLE => #VALEUR <br />
</BOUCLE_liste>
```

## Test HTML5

Les tests pour envoyer un code différent selon que l'on est ou non en HTML5 sont dépréciés et seront supprimés en SPIP 6.

**Avant :**

En squelette :

```spip
[(#HTML5|oui) <code_specifique_html5>]
```

En PHP, voir [API PHP et Fonctions](php-api.md#test-html5).

**Après :**

Utiliser directement du code HTML5.

## Formulaire de recherche

La fonction `formulaire_recherche()` est supprimée. Utilisez la balise **`#FORMULAIRE_RECHERCHE_ECRIRE`**.

## Filtre `|image_typo`

Le filtre `|image_typo` n'est plus livré avec SPIP. Installez le plugin [Image Typo](https://plugins.spip.net/image_typo) pour l'obtenir.
