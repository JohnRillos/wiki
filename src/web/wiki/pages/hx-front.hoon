::  htmx partial: front page content
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  mermaid-zero-js  %js  /web/wiki/mermaid-zero/js
::
^-  (page:rudder rudyard relay)
::
=<
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  help  ~(. +> [bowl order rudyard])
::
++  argue  |=(* !!)
::
++  final  |=(* !!)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
  =/  tale  get-tale:help
  ?~  tale  [%next (spat /wiki/[book-id.site]/~/not-found) ~]
  =/  =page  page:(latest u.tale)
  ::
  |^  [%page render]
  ::
  ++  mermaid-src
    "https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"
  ::
  ++  zero-md-src
    "https://cdn.jsdelivr.net/gh/zerodevx/zero-md@2/dist/zero-md.min.js"
  ::
  ++  prism-css-src
    "https://cdn.jsdelivr.net/gh/PrismJS/prism@1/themes/prism.min.css"
  ::
  ++  mermaid-script  ^~  (trip mermaid-zero-js)
  ::
  ++  render
    ^-  manx
    =/  host=(unit @p)  host.site
    ;html
      ;body
        ;article#front
          ;script(defer "", src mermaid-src);
          ;script(type "module", src zero-md-src);
          ;zero-md#zero
            =no-shadow      ""
            =manual-render  ""
            ;template
              ;link(rel "stylesheet", href prism-css-src);
              ;style: {(style:web bowl)}
              ;style: {(md-style:web bowl)}
            ==
            ;script
              =type  "text/markdown"
              ; {(trip (of-wain:format content.page))}
            ==
          ==
          ;script: {mermaid-script}
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  book-id  ~+
  ^-  @ta
  book-id:wiki-path:(wiki-url:web url.request.order)
::
++  get-cover
  ^-  (unit cover)
  ?^  booklet  `cover.u.booklet
  %+  bind  (~(get by books) book-id)
  |=(=book (book-to-cover book-id book))
::
++  get-tale
  ^-  (unit tale)
  ?^  booklet  `tale.u.booklet
  %+  biff  (~(get by books) book-id)
  |=  =book
  (~(get by tales.book) /['-']/front)
::
--