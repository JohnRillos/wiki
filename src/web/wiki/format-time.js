Array.from(document.getElementsByClassName('time')).forEach(elem => {
  var millis = Number(elem.getAttribute('millis'));
  var stamp = new Date(millis).toLocaleString();
  elem.replaceWith(stamp);
});