::  Article creation page
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
  =/  args=(map @t @t)  args:help
  ?~  what=(~(get by args) 'action')  ~
  |^  ?+  u.what  'say what now'
      ::
          %new-page
        =/  host  host:wiki-path:(wiki-url:web url.request.order)
        =/  =path
          ~|  'Invalid page path'  (part (~(got by args) 'page-path'))
        =/  page-title=@t  (~(got by args) 'page-title')
        =/  content=wain
          (to-wain:format (sane-newline (~(got by args) 'content')))
        =/  =action  [%new-page book-id:help path page-title content]
        [%relay (fall host our.bowl) id.order action]
      ==
  ::
  ++  tie
    |=  =knot
    ^-  @ta
    (slav %ta (cat 3 '~.' knot))
  --
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  next=@t
    ?.  success  url.request.order
    =/  =path  (part (~(got by args:help) 'page-path'))
    =/  pag-dir=tape
      ?:  =(/[~.-]/front path)  ""
      (spud path)
    =/  wik-dir=tape  (base-path:web wiki-path:(wiki-url:web url.request.order))
    (crip "{wik-dir}{pag-dir}?after={(trip id.order)}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
  ?.  (may-edit:auth host.site rules.cover)  (unauthorized:web bowl)
  ::
  |^  [%page render]
  ::
  ++  path-regex  "[0-9a-z\\-_~\\.\\/]+"
  ::
  ++  path-explain  "Lowercase letters, numbers, period (.), underscore (_), hyphen (-), tilde (~), and slash (/)"
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (base-path:web site)
    =/  target=(unit path)  (target-path:help query)
    =/  default-path=tape  ?~(target "" (tail (spud u.target)))
    =/  is-front=?  =("-/front" default-path)
    ;html
      ;+  (doc-head:web bowl "New Page - {(trip title.cover)}")
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
          ;+  ?:  is-front
                ;h1: Edit Front Page
              ;h1: New Page
          ::
          ;form(method "post")
            ;div
              ;button.submit.gap-r
                =type  "submit"
                =name  "action"
                =value  "new-page"
                ; Create Page
              ==
              ;a(href wik-dir): Cancel
            ==

            ;+
            %+  hide-if:web  is-front
            ;div
              ;h3: Page Path
              ;span: {wik-dir}/
              ;input
                =type         "text"
                =name         "page-path"
                =placeholder  "my/page"
                =required     "true"
                =pattern      path-regex
                =title        path-explain
                =value        default-path
                ;
              ==

              ;h3: Page Title
              ;input
                =type         "text"
                =name         "page-title"
                =placeholder  "My Page"
                =required     "true"
                =value        ?:(is-front "Front Page" "")
                ;
              ==
            ==

            ;h3: Content
            ;textarea(id "content", name "content", placeholder "Lorem ipsum");
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
+*  web  ~(. wiki-web [bowl rudyard])
::
++  args  ~+
  ^-  (map @t @t)
  ?~  body.request.order  ~
  (frisk:rudder q.u.body.request.order)
::
++  book-id  book-id:wiki-path:(wiki-url:web url.request.order)
::
++  target-path
  |=  query=(map @t @t)
  ^-  (unit path)
  =/  target=(unit @t)  (~(get by query) 'target')
  (bind target stab)
::
++  get-cover
  ^-  (unit cover)
  ?^  spine.rudyard  `cover.u.spine.rudyard
  =/  =wiki-path  wiki-path:(wiki-url:web url.request.order)
  =/  book-id=@t  book-id.wiki-path
  %+  bind  (~(get by books.rudyard) book-id)
  |=(=book (book-to-cover book-id book))
::
--