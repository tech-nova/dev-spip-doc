# Espace privé et Menus

L'espace privé de SPIP 5.0 bénéficie de plusieurs renommages et simplifications pour une meilleure cohérence.

## Renommage de la page Admin Tech
La page `?exec=admin_tech` est renommée en **`?exec=admin_bdd`**.
- Elle se concentre désormais exclusivement sur la gestion de la base de données (réparation, sauvegarde, effacement).
- Pensez à mettre à jour vos liens et vos pipelines se branchant sur cet `exec`.

## Menus de l'espace privé

SPIP 5.0 simplifie la déclaration des menus et des onglets en remplaçant les balises `<menu>` et `<onglet>` de `paquet.xml` par des fichiers de configuration **`config/menus.php`** et **`config/onglets.php`**.

Pour plus de détails sur la nouvelle syntaxe et la migration complète, consultez le guide dédié : **[Menus et Onglets de l'espace privé](../features/menus.md)**.

### Renommages importants
Même si vous conservez temporairement la syntaxe `paquet.xml`, certains identifiants doivent être mis à jour.

#### Menu « Squelettes » → « Apparence »
Le menu « Squelettes » (`menu_squelette`) est renommé **« Apparence »** (`menu_apparence`).

**Avant (paquet.xml) :**
```xml
<menu nom="..." parent="menu_squelette" ... />
```

**Après :**
```xml
<menu nom="..." parent="menu_apparence" ... />
```

#### Préfixes de menus
Les identifiants de menus commençant par `bando_` sont dépréciés et doivent désormais commencer par **`menu_`**.

**Avant :**
```xml
<menu nom="..." parent="bando_configuration" ... />
```

**Après :**
```xml
<menu nom="..." parent="menu_configuration" ... />
```

## Interface et Mise en page

### Balise `#LARGEUR_ECRAN`
Dans les squelettes de l'espace privé, la balise `#LARGEUR_ECRAN` est remplacée par **`#LAYOUT_PRIVE`**.
- Exemple : `[(#LAYOUT_PRIVE{pleine_largeur})]`

### Boîtes et Cadres (PHP)
Les nombreuses fonctions de mise en page de l'espace privé (`debut_cadre_xx`, `fin_cadre_xx`, `debut_boite_xx`, etc.) sont supprimées. Elles sont remplacées par le couple unique **`boite_ouvrir()`** et **`boite_fermer()`**.

**Fonctions supprimées :**
- `debut_cadre()`, `debut_cadre_relief()`, `debut_cadre_enfonce()`, `debut_cadre_sous_rub()`, `debut_cadre_couleur()`, `debut_cadre_trait_couleur()`.
- `debut_boite_alerte()`, `debut_boite_info()`.
- `cadre_depliable()`, `bloc_des_raccourcis()`.

**Exemple de migration :**
```php
// Avant
echo debut_boite_info();
echo "Mon contenu";
echo fin_boite_info();

// Après
echo boite_ouvrir('Mon titre', 'info');
echo "Mon contenu";
echo boite_fermer();
```

## Formulaire d'édition des liaisons
Le comportement du formulaire d'association de liens a été modifié. L'édition est désormais possible dès que l'on a l'autorisation de modifier l'objet. Si vous avez surchargé ce formulaire, vérifiez la gestion du paramètre `editable`.
