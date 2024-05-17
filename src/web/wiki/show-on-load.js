window.addEventListener('load', event => {
  Array.from(document.getElementsByClassName('loading')).forEach(elem => {
    elem.className = elem.className.replace('loading', '');
  });
  Array.from(document.getElementsByClassName('fade-in')).forEach(elem => {
    elem.className = elem.className.replace('fade-in', 'fading-in');
  });
});