# Menus et Onglets de l'espace privé

SPIP 5.0 simplifie la déclaration des menus et des onglets de l'espace privé en remplaçant les balises XML de `paquet.xml` par un fichier de configuration PHP plus flexible.

## Les fichiers de configuration

SPIP 5.0 utilise deux fichiers distincts selon le type d'entrée :
- **`config/menus.php`** : pour les menus principaux et sous-menus de la barre de navigation.
- **`config/onglets.php`** : pour les onglets à l'intérieur des pages.

Ces fichiers doivent retourner un tableau associatif décrivant vos entrées.

### Exemple de `config/menus.php`
```php
// monplugin/config/menus.php
return [
    'mon_outil' => [
        'titre'  => 'monplugin:titre_outil',
        'parent' => 'menu_edition',
        'icone'  => 'images/mon-outil-16.png',
        'action' => 'mon_outil_exec',
    ],
];
```

### Exemple de `config/onglets.php`
```php
// monplugin/config/onglets.php
return [
    'ma_page_infos' => [
        'titre'  => 'monplugin:onglet_infos',
        'parent' => 'mon_outil', // Identifiant de la page parente
        'icone'  => 'images/infos-24.png',
    ],
];
```

## Propriétés d'une entrée (Menu ou Onglet)

| Propriété | Description |
| :--- | :--- |
| `titre` | Item de langue pour le libellé. |
| `parent` | Identifiant du parent (menu pour un menu, page `exec` pour un onglet). |
| `icone` | Chemin vers l'icône (relatif au plugin ou via `find_in_path`). |
| `action` | Nom de la page `exec` cible (sans le préfixe `?exec=`). |
| `parametres` | Paramètres d'URL additionnels (ex: `id=1&mode=test`). |
| `position` | Position numérique pour l'ordre d'affichage (optionnel). |

## Migration depuis `paquet.xml`

### Migration d'un `<menu>`
Déplacez la déclaration dans **`config/menus.php`**.

**Avant (`paquet.xml`) :**
```xml
<menu nom="mon_outil" titre="monplugin:titre_outil" parent="menu_edition" icone="images/mon-outil-16.png" action="mon_outil_exec" />
```

**Après (`config/menus.php`) :**
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

### Migration d'un `<onglet>`
Déplacez la déclaration dans **`config/onglets.php`**.

**Avant (`paquet.xml`) :**
```xml
<onglet nom="infos" titre="monplugin:onglet_infos" parent="mon_outil" icone="images/infos-16.png" />
```

**Après (`config/onglets.php`) :**
```php
return [
    'mon_outil_infos' => [
        'titre'  => 'monplugin:onglet_infos',
        'parent' => 'mon_outil',
        'icone'  => 'images/infos-24.png',
    ],
];
```

## Identifiants de menus standards

| Identifiant | Libellé SPIP 5.0 |
| :--- | :--- |
| `menu_accueil` | Accueil |
| `menu_edition` | Édition |
| `menu_publication` | Publication |
| `menu_activite` | Activité |
| `menu_apparence` | Apparence (anciennement `menu_squelette`) |
| `menu_administration` | Maintenance |
| `menu_configuration` | Configuration |

## Avantages et performances
- **Performance :** Le format PHP statique permet une lecture extrêmement rapide et une mise en cache native dans l'**OPcache** de PHP.
- **Simplicité :** Allège considérablement le fichier `paquet.xml` en déportant la configuration de l'interface dans des fichiers dédiés.
- **Consistance :** Aligné avec les nouveaux standards de configuration de SPIP 5.0 (comme `services.php`).

*Note : Ce format est actuellement privilégié pour la migration vers SPIP 5.0 et pourrait encore évoluer.*
