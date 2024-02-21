::  article revision history
::
/-  *wiki
/+  rudder, web=wiki-web
/*  format-time-js  %js  /web/wiki/format-time/js
::
^-  (page:rudder state-1 action)
::
=<
::
|_  [=bowl:gall =order:rudder state-1]
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
  ++  on-load  (trip format-time-js)
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (spud /wiki/[book-id:help])
    =/  pag-dir=tape  (spud page-path:help)
    =/  last=page  page:(latest u.tale)
    ;html
      ;+  (doc-head:web bowl "History - {(trip title.last)}")
      ;body#with-sidebar(onload on-load)
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
                  =/  editor=tape
                    ?:  =(%pawn (clan:title edit-by.page))  "a guest user"
                    <edit-by.page>
                  ;li
                    ;a
                      =href  "{wik-dir}{pag-dir}?t={<date>}"
                      ;+  (timestamp:web date)
                    ==
                    ;span:  by {editor}
                  ==
            ==
          ==
          ;+  (footer:web book)
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