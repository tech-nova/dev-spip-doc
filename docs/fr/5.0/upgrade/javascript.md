# Javascript et Assets

SPIP 5.0 marque une étape majeure dans la modernisation du Javascript, en s'émancipant de jQuery et en adoptant les modules ESM (EcmaScript Modules).

## Émancipation de jQuery

Bien que jQuery soit toujours présent, SPIP encourage désormais l'utilisation de Javascript "Vanilla" et des modules ESM.
- Le fichier `config.js` remplace l'objet `jQuery.spip` pour la configuration.
- Le fichier `ajaxCallback.js` fournit les fonctions de manipulation AJAX en ESM.

### Fonctions migrées en ESM
Les fonctions suivantes sont désormais disponibles via `import` depuis `ajaxCallback.js` :
`ajaxReload`, `onAjaxLoad`, `triggerAjaxLoad`, `positionner`, `animateLoading`, `endLoading`, `animateRemove`, `animateAppend`, `parametre_url`, `followLink`, `ajaxClick`.

### Exemple de migration

**Avant :**
```javascript
$(document).ready(function(){
    jQuery('.mon_bloc').animateLoading();
});
```

**Après (Module ESM) :**
```html
<script type="module">
    import { animateLoading } from "ajaxCallback.js";
    const monbloc = document.querySelector('.mon_bloc');
    if (monbloc) {
        animateLoading(monbloc);
    }
</script>
```

## Migration des assets (paquet.xml)

Les balises `<style>` et `<script>` dans `paquet.xml` sont dépréciées. Il est recommandé de passer par des **Listeners de Pipelines** pour injecter vos assets.

| Type d'asset | Pipeline cible | Event dédié |
| :--- | :--- | :--- |
| CSS Public | `insert_head_css` | `InsertHeadCssEvent` |
| CSS Privé | `header_prive_css` | `HeaderPriveCssEvent` |
| JS Public | `insert_head` | `InsertHeadEvent` |
| JS Privé | `header_prive` | `HeaderPriveEvent` |

Pour plus de détails sur la mise en œuvre, consultez le guide sur les [Event Dispatcher et Pipelines](../features/event-dispatcher-et-pipelines.md).

## Debugging JS
Vous pouvez activer le traçage des usages dépréciés dans la console du navigateur en ajoutant `?var_mode=debug_js` à l'URL.
