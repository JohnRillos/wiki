var editor = CodeMirror.fromTextArea(document.getElementById('content'), {
  mode: 'markdown',
  highlightFormatting: true,
  lineNumbers: true,
  lineWrapping: true,
  theme: 'default',
  extraKeys: {'Enter': 'newlineAndIndentContinueMarkdownList' }
});