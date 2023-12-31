::  Article editing page
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  codemirror-js   %js   /web/codemirror/lib/codemirror/js
/*  codemirror-css  %css  /web/codemirror/lib/codemirror/css
/*  markdown-js     %js   /web/codemirror/mode/markdown/markdown/js
/*  editor-js       %js   /web/wiki/editor/js
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
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)  (form-data:web order)
  ?>  ?=(%mod-page (~(got by args) 'action'))
  =/  page-title=@t  (~(got by args) 'page-title')
  =/  content=wain  (to-wain:format (sane-newline (~(got by args) 'content')))
  [%mod-page book-id:help page-path:help `page-title `content]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  next=@t
    ?.  success  url.request.order
    =/  bid=@t  book-id:help
    =/  =path  page-path:help
    (crip "/wiki/{(trip bid)}{(spud path)}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  site=(pole knot)  (stab url.request.order)
  ?.  ?=([%wiki book-id=@ta *] site)
    [%code 404 'Invalid path']
  ?~  buuk=(~(get by books) book-id:help)
    [%code 404 (crip "Wiki {<book-id:help>} not found")]
  =/  =book  u.buuk
  ?>  (may-edit bowl book)
  ?~  tale=(~(get by tales.book) page-path:help)
    [%code 404 (crip "Article {<page-path:help>} not found in {<title.book>}")]
  =/  =page  page:(latest u.tale)
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (spud /wiki/[book-id:help])
    =/  pag-dir=tape  (spud page-path:help)
    ;html
      ;+  (doc-head:web bowl "Edit - {(trip title.page)}")
      ;script: {(trip codemirror-js)}
      ;style: {(trip codemirror-css)}
      ;script: {(trip markdown-js)}
      ;body#with-sidebar
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;*  ?~  msg  ~
              ~[;/((trip text.u.msg))]
          ;+  (search-bar:web `book-id.site ~)
          ;h1: Edit Page - {(trip title.page)}
          ::
          ;form(method "post")
            ;table
              ;tr
                ;td
                  ;button.submit
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