zero.addEventListener('zero-md-ready', async () => {
  const renderer = new marked.Renderer();
  renderer.code = (code, lang) => {
    return lang === 'mermaid'
      ? `<div class="mermaid">${code}</div>`
      : `<pre><code>${code}</code></pre>`
  };
  await zero.render({ renderer });
  mermaid.init();
});