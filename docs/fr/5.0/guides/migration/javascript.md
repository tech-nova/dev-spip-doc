# Javascript et Assets

SPIP 5.0 marque une étape majeure dans la modernisation du Javascript, en s'émancipant de jQuery et en adoptant les modules ESM (EcmaScript Modules).

## Émancipation de jQuery

Bien que jQuery soit toujours présent, SPIP encourage désormais l'utilisation de Javascript "Vanilla" et des modules ESM.

- Le fichier `config.js` remplace l'objet `jQuery.spip` pour la configuration.
- Le fichier `ajaxCallback.js` fournit les fonctions de manipulation AJAX en ESM.

### Fonctions migrées en ESM

Les fonctions suivantes sont désormais disponibles via `import` depuis `ajaxCallback.js` :

`ajaxReload`, `onAjaxLoad`, `triggerAjaxLoad`, `positionner`, `animateLoading`, `endLoading`, `animateRemove`, `animateAppend`, `parametre_url`, `followLink`,
`ajaxClick`.

### Exemple de migration

**Avant :**

```html
<script>
  var ajax_image_searching = "⌛";

  $(document).ready(function(){
    console.log(jQuery.spip.load_handlers);
    jQuery('.mon_bloc').animateLoading();
  });
</script>
```

**Après (Module ESM) :**

```html
<script type="module">
  import { default as spip } from "config.js";
  import { animateLoading, onAjaxLoad } from "ajaxCallback.js";

  console.log(spip.load_handlers);
  spip.ajax_image_searching = "⌛";

  const monbloc = document.querySelector('.mon_bloc');
  if (monbloc) {
    animateLoading(monbloc);
  }
</script>
```

Les balises `<script type="module">` qui contiennent une directive `import` s'exécutent de manière asynchrone et différée,
une fois que toutes les ressources javascript de la page ont été résolues.
Auparavant, il fallait différer l'exécution du code en l'encapsulant dans `$(document).ready(function(){...})` ou `$(function(){...})`.

## Migration des assets (paquet.xml)

Les balises `<style>` et `<script>` dans `paquet.xml` sont dépréciées. Il est recommandé de passer par des **Listeners de Pipelines** pour injecter vos assets.

| Type d'asset | Pipeline cible | Event dédié |
| :--- | :--- | :--- |
| CSS Public | `insert_head_css` | `InsertHeadCssEvent` |
| CSS Privé | `header_prive_css` | `HeaderPriveCssEvent` |
| JS Public | `insert_head` | `InsertHeadEvent` |
| JS Privé | `header_prive` | `HeaderPriveEvent` |

Pour plus de détails sur la mise en œuvre, consultez le guide sur les [Event Dispatcher et Pipelines](../../features/event-dispatcher-et-pipelines.md).

## Rétrocompatibilité (`retrocompat.js`)

Un fichier `retrocompat.js` tâche d'assurer la compatibilité avec la syntaxe historique basée sur jQuery et l'objet global `spipConfig`.

Pour le code non ESM, l'objet `spipConfig` reste disponible :

```html
<script>
  document.addEventListener("DOMContentLoaded", () => {
    console.log(spipConfig.load_handlers);
    spipConfig.ajax_image_searching = "⌛";
  });
</script>
```

Pour une migration complète vers les modules ESM, consultez l'exemple ci-dessus avec `config.js` et `ajaxCallback.js`.

## Debugging JS

Vous pouvez activer le traçage des usages dépréciés dans la console du navigateur en ajoutant `?var_mode=debug_js` à l'URL.
