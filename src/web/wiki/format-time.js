Array.from(document.getElementsByClassName('time')).forEach(elem => {
  var millis = Number(elem.getAttribute('millis'));
  var local = document.createElement('span');
  local.className = 'local-time';
  local.textContent = new Date(millis).toLocaleString();
  local.setAttribute('title', elem.textContent);
  elem.replaceWith(local);
});