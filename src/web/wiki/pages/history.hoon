::  article revision history
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  format-time-js  %js  /web/wiki/format-time/js
::
^-  (page:rudder rudyard relay)
::
=<
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  help  ~(. +> [bowl order rudyard])
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
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
  =/  tale=(unit tale)  get-tale:help
  ?~  tale
    [%code 404 (crip "Article {<page-path:help>} not found in {<title.book>}")]
  ::
  |^  [%page render]
  ::
  ++  on-load  (trip format-time-js)
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (base-path:web site)
    =/  pag-dir=tape  (spud page-path:help)
    =/  last=page  page:(latest u.tale)
    ;html
      ;+  (doc-head:web bowl "History - {(trip title.last)}")
      ;body#with-sidebar.loading(onload on-load)
        ;+  (link-theme:web bowl host.site cover)
        ;+  (global-nav:web bowl order [%& cover])
        ;main
          ;+  (search-bar:web `book-id.site host.site)
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
          ;+  (footer:web [%& cover])
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
++  page-path  ~+
  ^-  path
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  (snip (snip loc.site))
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
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  %+  biff  (~(get by books) book-id)
  |=  =book
  (~(get by tales.book) page-path)
::
--