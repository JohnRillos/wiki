::  article revision history
::
/-  *wiki
/+  rudder, web=wiki-web
::
^-  (page:rudder state-0 action)
::
=<
::
|_  [=bowl:gall =order:rudder state-0]
::
+*  help  ~(. +> [bowl order books])
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  ::
  =/  site=(pole knot)  (stab url.request.order)
  ?.  ?=([%wiki book-id=@ta *] site)
    [%code 404 'Invalid path']
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ?~  tale=(~(get by tales.book) page-path:help)
    [%code 404 (crip "Article {<page-path:help>} not found in {<title.book>}")]
  ::
  |^  [%page render]
  ::
  ++  md-style  ""
  ::
  ++  prism-style-override
    """
    code[class*=language-] \{
      font-family: monospace;
    }
    """
  ::
  ++  zero-md-src
    "https://cdn.jsdelivr.net/gh/zerodevx/zero-md@2/dist/zero-md.min.js"
  ::
  ++  prism-css-src
    "https://cdn.jsdelivr.net/gh/PrismJS/prism@1/themes/prism.min.css"
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (spud /wiki/[book-id:help])
    =/  pag-dir=tape  (spud page-path:help)
    =/  last=page  page:(latest u.tale)
    ;html
      ;+  (doc-head:web bowl "History - {(trip title.last)}")
      ;body#with-sidebar
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;+  (search-bar:web `book-id.site ~)
          ;article
            ;header
              ;h1: {(trip title.last)}: Revision History
            ==
            ;a/"..": Back to Current Revision
            ;ul
              ;*  %+  turn  (tap:ton u.tale)
                  |=  [date=@da =page]
                  ^-  manx
                  ;li
                    ;a/"{wik-dir}{pag-dir}?t={<date>}": {<date>}
                  ==
            ==
          ==
          ;+  (footer:web bowl url.request.order)
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
++  book-id  ~+
  ^-  @ta
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta *] site)
  book-id.site
::
++  page-path  ~+
  ^-  path
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta pat=*] site)
  (snip (snip `path`pat.site))
::
--