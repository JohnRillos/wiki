::  article
::
/-  *wiki
/+  rudder
/$  udon-to-elem  %udon  %elem
::
^-  (page:rudder (map @ta book) action)
::
=<
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
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
  ?~  puge=(~(get by pages.book) page-path:help)
    [%code 404 (crip "Article {<page-path:help>} not found in {<title.book>}")]
  =/  =page  u.puge
  ::
  |^  [%page render]
  ::
  ++  style  ""
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
    ;html
      ;head
        ;title: {(trip title.page)}
      ==
      ;body
        ;nav
          ;a(href wik-dir): {(trip title.book)}
        ==
        ;main
          ;nav
            ;a(href "{wik-dir}/~/edit{pag-dir}"): Edit
            ;a(href "{wik-dir}/~/history{pag-dir}"): Revisions
          ==
          ;article
            ;header
              ;h1: {(trip title.page)}
            ==
            ;script(type "module", src zero-md-src);
            ;zero-md
              ;template
                ;style: {md-style}
                ;link(rel "stylesheet", href prism-css-src);
                ;style: {prism-style-override};
              ==
              ;script(type "text/markdown"): {content.page}
            ==
          ==
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
  pat.site
::
--