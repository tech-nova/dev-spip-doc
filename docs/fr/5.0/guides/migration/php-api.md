# API PHP et Fonctions

SPIP 5.0 modernise son API PHP en adoptant des standards PSR et en simplifiant plusieurs fonctions historiques.

## Système de Log (PSR-3)

La fonction `spip_log()` est dépréciée au profit de `Spip::logger()`, qui retourne une instance compatible avec `Psr\Log\LoggerInterface`.

Pour plus de détails sur l'utilisation, l'injection de dépendances et la configuration du logger, consultez le guide dédié :
**[Système de Log (PSR-3)](../../features/logger.md)**.

## Nouvelles dépréciations (SPIP 5.0)

Les éléments suivants sont dépréciés et seront supprimés dans une future version.

### Fonctions `extraire_multi` et `extraire_idiome`

Le 3ᵉ paramètre `$options` est déprécié s'il est booléen. Ce paramètre doit être un `array`.

**Avant :**

```php
$multi = extraire_multi($texte, 'en', true);
$idiome = extraire_idiome($texte, 'en', true);
```

**Après :**

```php
$multi = extraire_multi($texte, 'en', ['echappe_span' => true]);
$idiome = extraire_idiome($texte, 'en', ['echappe_span' => true]);
```

### Fonction `spip_setcookie`

La fonction `spip_setcookie()` reprend les arguments de la fonction PHP [`setcookie`](https://www.php.net/manual/fr/function.setcookie.php).

Les constantes `_COOKIE_SECURE` et `_COOKIE_SECURE_LIST` sont dépréciées au profit des options `secure` (activée par défaut en HTTPS) et `httponly` de la fonction.

**Exemple :**

```php
spip_setcookie('mon_cookie', 'ma valeur', time() + 3600, httponly: true);
```

### Fonction `mail_embarquer_pieces_jointes()`

La création d'une fonction `mail_embarquer_pieces_jointes()` est dépréciée. Utilisez le plugin **facteur**.

**Avant :**

```php
function mail_embarquer_pieces_jointes(...) {
    // ...
}
```

**Après :**

Utiliser le plugin [facteur](https://plugins.spip.net/facteur).

### Test HTML5

Les tests pour envoyer un code différent selon que l'on est ou non en HTML5 sont dépréciés et seront supprimés en SPIP 6.

**Avant (PHP) :**

```php
if (html5_permis()) {
    // code spécifique HTML5
}
```

**Après :**

Utiliser directement du code HTML5. En squelette, voir la section correspondante dans [Squelettes et Syntaxe](squelettes.md#test-html5).

## Fonctions supprimées ou renommées

Plusieurs fonctions dépréciées ont été supprimées. Voici les principales correspondances :

| Fonction supprimée | Remplacement |
| :--- | :--- |
| `spip_sha256($val)` | `hash('sha256', $val)` |
| `abs_url($url)` | `url_absolue($url)` ou `liens_absolus($texte)` |
| `http_status($code)` | `http_response_code($code)` |
| `json_export($data)` | `json_encode($data)` |
| `var2js($data)` | `json_encode($data)` |
| `compacte($css, 'css')` | `minifier($css, 'css')` |
| `formulaire_recherche()` | balise `#FORMULAIRE_RECHERCHE_ECRIRE` |
| `regledetrois($a, $b, $c)` | combinaison de filtres (`div`, `mult`, etc.) |

### Fonctions `generer_{x}_entite` et `generer_{x}_{objet}`

De même que `generer_url_ecrire_objet`, les fonctions `generer_*_entite` dépréciées sont supprimées.
Les fonctions remplaçantes ont les mêmes arguments.

| Supprimé | Remplacé par |
| :--- | :--- |
| `generer_url_entite` | `generer_objet_url` |
| `generer_url_entite_absolue` | `generer_objet_url_absolue` |
| `generer_url_ecrire_objet` | `generer_objet_url_ecrire` |
| `generer_url_ecrire_entite_edit` | `generer_objet_url_ecrire_edit` |
| `generer_introduction_entite` | `generer_objet_introduction` |
| `generer_info_entite` | `generer_objet_info` |
| `generer_lien_entite` | `generer_objet_lien` |

Les fonctions personnalisées plus spécifiques `generer_{x}_{objet}`, telles que `generer_introduction_article`, sont supprimées.
Utilisez `generer_{objet}_{x}`, par exemple `generer_article_introduction`.

De même, les fonctions génériques `generer_{x}_entite` sont supprimées. Utilisez `generer_objet_{x}`.

Note : ces diverses fonctions peuvent être appelées depuis `generer_objet_info`, qui cherchera une fonction spécifique, si elle existe, pour répondre.

| Supprimé | Remplacé par |
| :--- | :--- |
| `generer_{x}_{objet}` | `generer_{objet}_{x}` |
| `generer_{x}_entite` | `generer_objet_{x}` |

### Fonction de liste `inc_lister_objets_dist`

La fonction dépréciée depuis SPIP 3.1 est supprimée au profit d'inclusions directes de squelettes.

**Avant :**

```php
$lister_objets = charger_fonction('lister_objets', 'inc');
$html = $lister_objets('breves', [
  'id_rubrique' => $id_rubrique,
]);
```

**Après :**

```php
$html = recuperer_fond('prive/objets/liste/breves', [
  'id_rubrique' => $id_rubrique,
], [
  'ajax' => true,
]);
```

### Filtre `regledetrois`

La fonction ou filtre `regledetrois` est supprimée. Elle ne servait plus dans le core et n'a pas vraiment d'utilité.

**Avant :**

```html
[(#VAL{6}|regledetrois{4,3})] retourne 8
```

**Après :**

```html
[(#VAL{6}|div{3}|mult{4})] retourne 8
```

### Fichiers `base/serial.php` et `base/auxiliaires.php`

Les appels à ces fichiers, via `include_spip('base/serial')` par exemple, seront sans effet.
Remplacez-les par l'appel à la fonction `lister_tables_objets_sql()`.

### Exemples de migration

**Migration de `abs_url()` :**

```php
// Avant
$url = abs_url($url);
$texte = abs_url($texte);

// Après
$url = url_absolue($url);
$texte = liens_absolus($texte);
```

**Migration de `generer_url_ecrire_objet()` :**

```php
// Avant
$url = generer_url_ecrire_objet(3, 'article');

// Après
$url = generer_objet_url_ecrire(3, 'article');
```

**Migration de `json_export()` :**

```php
// Avant
$json = json_export($data);

// Après
$json = json_encode($data);
```

## Paramètres des fonctions de traduction `_T()` et `_L()`

Le 3ᵉ paramètre (options) des fonctions `_T` et `_L` ne peut plus être une chaîne (nom d'une classe CSS) et doit toujours être un tableau.

**Avant :**

```php
_T('cle', [], 'classe_css');
_L('texte', [], 'classe_css');
```

**Après :**

```php
_T('cle', [], ['class' => 'classe_css']);
_L('texte', [], ['class' => 'classe_css']);
```

## Migration des constantes vers le Kernel

De nombreuses constantes de chemin et d'état sont supprimées au profit de la façade `Spip` (services du conteneur).

| Ancienne constante | Remplacement PHP recommandé |
| :--- | :--- |
| `_DIR_RESTREINT_ABS` | `Spip::param('spip.routes.back_office')` ou `Spip::param('spip.dirs.core')` |
| `_ROOT_RACINE` | `Spip::directories()->getProjectDir()` |
| `_ROOT_RESTREINT` | `Spip::directories()->getCoreDir()` |
| `_ROOT_CWD` | `Spip::platform()->getCwd()` |
| `_DIR_LOG` | `Spip::directories()->getLogDir()` |
| `_ESPACE_PRIVE` | `Spip::isBackOffice()` |
| `_ROOT_IMG_PACK` / `_DIR_IMG_PACK` | voir ci-dessous |
| `_IS_CLI` | `Spip::platform()->isCli()` |

*Note : la façade est la classe `Spip\Framework\Spip`, également disponible sous l'alias global `Spip`.
Les fonctions `param()` et `service()` de l'espace de nom `SpipLeague\Component\Kernel` sont dépréciées,
ainsi que les méthodes de chemins du Kernel (`app()->getRootDir()`, `app()->getCoreDir()`, `app()->relative()`…).*

### Accès aux paramètres du Kernel en squelette (`#PARAM`)

Dans un squelette, la balise `#PARAM` permet de récupérer un paramètre de service du conteneur :

```html
[(#PARAM{spip.routes.back_office})]
```

Est équivalent à `Spip::param('spip.routes.back_office')` en PHP.

### `_DIR_RESTREINT_ABS`

**Avant :**

```php
function lambda() {
  $chaine = _DIR_RESTREINT_ABS . 'suite';
}
```

Dans un squelette :

```html
[(#CONST{_DIR_RESTREINT_ABS})]
```

**Après :**

```php
function lambda() {
    // suivant le contexte (URL vers l'espace privé / répertoire physique "ecrire/")
    $chaine = Spip::param('spip.routes.back_office') . 'suite';
    // ou
    $chaine = Spip::param('spip.dirs.core') . 'suite';
}
```

Dans un squelette :

```html
[(#PARAM{spip.routes.back_office})]
```

### `_ESPACE_PRIVE`

**Avant :**

```php
if (defined('_ESPACE_PRIVE')) {
    // ...
} else {
    // ...
}
```

En squelette :

```spip
[(#CONST{_ESPACE_PRIVE}|?{oui,non})]
```

**Après :**

```php
if (Spip::isBackOffice()) {
    // ...
} else {
    // ...
}
```

En squelette :

```spip
[(#NULL|test_espace_prive|?{oui,non})]
```

### `_ROOT_IMG_PACK` et `_DIR_IMG_PACK`

**Avant :**

```php
$absolute = _ROOT_IMG_PACK;
$relative = _DIR_IMG_PACK;
```

**Après :**

```php
$absolute = Spip::directories()->getPrivateTemplateDir() . _NOM_IMG_PACK;
$relative = Spip::directories()->relative()->getPrivateTemplateDir() . _NOM_IMG_PACK;
```

Préférez cependant `find_in_theme()` ou `chemin_image()` (qui recherchent dans des dossiers différents).

## Fichiers de langue

Les fichiers de langue ne doivent plus peupler la globale `$GLOBALS[$GLOBALS['idx_lang']]`.
Ils doivent désormais simplement retourner le tableau PHP.

```php
// config/lang/paquet-monplugin_fr.php
return [
    'monplugin_titre' => 'Mon Plugin',
];
```

## Compilateur

Pour les adaptations liées au compilateur de squelettes (`calculer_parties()`, alias de classes PHP), consultez
**[Compilateur de squelettes](compilateur.md)**.
