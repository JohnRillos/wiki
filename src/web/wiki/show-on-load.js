window.addEventListener('load', event => {
  Array.from(document.getElementsByClassName('loading')).forEach(elem => {
    elem.className = elem.className.replace('loading', '');
  });
});