# Compilateur de squelettes

Cette page concerne les développeurs de plugins ou de critères de boucle qui interviennent directement sur le compilateur SPIP.

## Argument explicite de `calculer_parties()`

Le 5ᵉ argument de la fonction `calculer_parties()`, utilisée pour compiler certains critères, doit désormais être passé explicitement.

### Avant

```php
$boucle->total_parties = $pas;
calculer_parties($boucles, $idb, $partie, $mode);
```

### Après

```php
$boucle->total_parties = $pas;
calculer_parties($boucles, $idb, $partie, $mode, $pas);
```

## Classes PHP à la racine de l'espace de noms

Certaines classes PHP du compilateur de SPIP disposaient d'un alias à la racine de l'espace de noms. Ces alias sont supprimés.

Il convient de faire explicitement appel à `use` en début des fichiers qui utilisent ces classes :

```php
use Spip\Compilateur\Noeud\Boucle;
use Spip\Compilateur\Noeud\Champ;
use Spip\Compilateur\Noeud\Contexte;
use Spip\Compilateur\Noeud\Critere;
use Spip\Compilateur\Noeud\Polyglotte;
use Spip\Compilateur\Noeud\Texte;
```
