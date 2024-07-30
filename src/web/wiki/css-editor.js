var editor = CodeMirror.fromTextArea(document.getElementById('custom-css'), {
  mode: 'css',
  highlightFormatting: true,
  lineNumbers: true,
  lineWrapping: true,
  readOnly: true,
  theme: 'default'
});

if (document.getElementById('use-custom').checked) {
  editor.setOption('readOnly', false);
  document.getElementById('editor-container').hidden = false;
} else {
  document.getElementById('editor-container').hidden = true;
}
