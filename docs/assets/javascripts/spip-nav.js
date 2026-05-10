(function() {
  function boussoleUrl() {
    var lang = (document.documentElement.getAttribute('lang') || 'fr').split('-')[0];
    if (lang !== 'en' && lang !== 'fr') {
      lang = 'fr';
    }
    return '//boussole.spip.net/?page=spipnav.js&lang=' + encodeURIComponent(lang);
  }

  function loadSpipNav() {
    if (document.querySelector('script[src*="boussole.spip.net"]')) {
      return;
    }
    var d = document;
    var g = d.createElement('script');
    var s = d.getElementsByTagName('script')[0];
    if (!s || !s.parentNode) {
      return;
    }
    g.type = 'text/javascript';
    g.defer = true;
    g.async = true;
    g.src = boussoleUrl();
    s.parentNode.insertBefore(g, s);
  }

  loadSpipNav();

  if (typeof document$ !== 'undefined' && document$ && typeof document$.subscribe === 'function') {
    document$.subscribe(function() {
      loadSpipNav();
    });
  }
})();
