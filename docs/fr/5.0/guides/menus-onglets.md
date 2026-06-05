# Migrer menus et onglets de l’espace privé

Les menus et onglets de l’espace privé se déclarent dans `config/menus.php` et `config/onglets.php`, en remplacement des balises `<menu>` / `<onglet>` de `paquet.xml`.
Le modèle est expliqué dans [Menus et onglets](../features/menus.md).

## Objectif

Déclarer les entrées de navigation de l’espace privé en PHP statique (OPcache), aligné avec `services.php`.

## Prérequis

- Plugin SPIP 5.0.
- Connaissance des identifiants de menus parents (`menu_edition`, `menu_apparence`, etc.).

## Étapes

### 1. Créer `config/menus.php`

```php
return [
    'mon_outil' => [
        'titre'  => 'monplugin:titre_outil',
        'parent' => 'menu_edition',
        'icone'  => 'images/mon-outil-16.png',
        'action' => 'mon_outil_exec',
    ],
];
```

### 2. Créer `config/onglets.php`

```php
return [
    'mon_outil_infos' => [
        'titre'  => 'monplugin:onglet_infos',
        'parent' => 'mon_outil',
        'icone'  => 'images/infos-24.png',
    ],
];
```

### 3. Migrer depuis `paquet.xml`

**Menu :**

```xml
<menu nom="mon_outil" titre="monplugin:titre_outil" parent="menu_edition" ... />
```

→ entrée équivalente dans `config/menus.php` (voir ci-dessus).

**Onglet :**

```xml
<onglet nom="infos" titre="monplugin:onglet_infos" parent="mon_outil" ... />
```

→ entrée dans `config/onglets.php`.

### 4. Propriétés utiles

| Propriété | Description |
| :--- | :--- |
| `titre` | Item de langue |
| `parent` | Menu parent ou `exec` parent |
| `icone` | Chemin icône |
| `action` | Page `exec` (sans `?exec=`) |
| `parametres` | Query string additionnelle |
| `position` | Ordre d’affichage |

## Cas particuliers

- `menu_squelette` → **`menu_apparence`** (SPIP 5.0).
- Préfixes `bando_*` → **`menu_*`** (dépréciés).
- Renommages UI et boîtes privées : [Espace privé — ruptures](migration/espace-prive-et-menus.md).

## Vérification

- Recharger l’espace privé : le menu et les onglets apparaissent aux bons emplacements.
- Mettre à jour les liens `?exec=` et pipelines branchés sur d’anciens identifiants.

## Voir aussi

- [Menus et onglets](../features/menus.md) — modèle et identifiants standards
- [Espace privé et menus](migration/espace-prive-et-menus.md) — renommages et UI
