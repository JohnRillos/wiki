::  Article editing page
::
/-  *wiki
/+  rudder, wiki-auth, wiki-web, *wiki
/*  codemirror-js   %js   /web/codemirror/lib/codemirror/js
/*  codemirror-css  %css  /web/codemirror/lib/codemirror/css
/*  markdown-js     %js   /web/codemirror/mode/markdown/markdown/js
/*  editor-js       %js   /web/wiki/editor/js
::
^-  (page:rudder rudyard relay)
::
=<
::
|_  [=bowl:gall =order:rudder =^rudyard]
::
+*  help  ~(. +> [bowl order rudyard])
    auth  ~(. wiki-auth [bowl ether.rudyard])
    web   ~(. wiki-web [bowl rudyard])
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder relay)
  =/  args=(map @t @t)  (form-data:web order)
  ?>  ?=(%mod-page (~(got by args) 'action'))
  =/  page-title=(unit @t)  (~(get by args) 'page-title')
  =/  content=wain  (to-wain:format (sane-newline (~(got by args) 'content')))
  =/  host  host:wiki-path:(wiki-url:web url.request.order)
  =/  =action  [%mod-page book-id:help page-path:help page-title `content]
  [%relay (fall host our.bowl) id.order action]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  next=@t
    ?.  success  url.request.order
    =/  wik-dir=tape  (base-path:web wiki-path:(wiki-url:web url.request.order))
    =/  pag-dir=tape
      ?:  =(/[~.-]/front page-path:help)  ""
      (spud page-path:help)
    (crip "{wik-dir}{pag-dir}?after={(trip id.order)}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
  ?.  (may-edit:auth host.site rules.cover)  (unauthorized:web bowl)
  =/  tale=(unit tale)  get-tale:help
  ?~  tale
    [%code 404 (crip "Article {<page-path:help>} not found in {<title.cover>}")]
  =/  =page  page:(latest u.tale)
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (base-path:web site)
    =/  pag-dir=tape  (spud page-path:help)
    ;html
      ;+  (doc-head:web bowl "Edit - {(trip title.page)}")
      ;script: {(trip codemirror-js)}
      ;style: {(trip codemirror-css)}
      ;script: {(trip markdown-js)}
      ;body#with-sidebar
        ;+  (link-theme:web bowl host.site cover)
        ;+  (global-nav:web bowl order [%& cover])
        ;main
          ;*  ?~  msg  ~
              ~[;/((trip text.u.msg))]
          ;+  (topbar:web bowl order cover)
          ;h1: Edit Page - {(trip title.page)}
          ::
          ;form(method "post")
            ;table
              ;tr
                ;td
                  ;button.submit.gap-r
                    =type   "submit"
                    =name   "action"
                    =value  "mod-page"
                    ; Submit Edit
                  ==
                  ;a(href "{wik-dir}{pag-dir}"): Cancel
                ==
              ==
              ;tr
                ;th: Path
                ;th: Title
              ==
              ;tr
                ;td
                  ;input
                    =type      "text"
                    =name      "page-path"
                    =value     (spud page-path:help)
                    =disabled  "true"
                    ;
                  ==
                ==
                ;td
                  ;+
                  %+  disable-if:web  =(/[%~.-]/front page-path:help)
                  ;input
                    =type      "text"
                    =name      "page-title"
                    =value     (trip title.page)
                    =required  "true"
                    ;
                  ==
                ==
              ==
            ==
            ;h3: Content
            ;textarea(id "content", name "content")
              ; {(trip (of-wain:format content.page))}
            ==
          ==
          ;script: {(trip editor-js)}
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  web   ~(. wiki-web [bowl rudyard])
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
  ?^  booklet.rudyard  `cover.u.booklet.rudyard
  %+  bind  (~(get by books.rudyard) book-id)
  |=(=book (book-to-cover book-id book))
::
++  get-tale
  ^-  (unit tale)
  ?^  booklet.rudyard  `tale.u.booklet.rudyard
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  %+  biff  (~(get by books.rudyard) book-id)
  |=  =book
  (~(get by tales.book) page-path)
::
--