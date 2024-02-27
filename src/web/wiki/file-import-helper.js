const fileForm = document.getElementById('file-form');

// workaround for Safari, which does not include the path in the filename
document.getElementById('file-input').addEventListener('change', e => {
  // remove hidden input elements from previous change events
  Array.from(fileForm.querySelectorAll('[name="paths"]')).forEach(el => {
    fileForm.removeChild(el);
  });
  // create a hidden input element containing the relative path for each file
  Array.from(e.target.files).forEach(file => {
    const pathInput = document.createElement('input');
    pathInput.type = 'hidden';
    pathInput.name = 'paths';
    pathInput.value = file.webkitRelativePath;
    fileForm.appendChild(pathInput);
  });
});