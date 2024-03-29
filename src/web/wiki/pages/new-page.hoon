::  Article creation page
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  codemirror-js   %js   /web/codemirror/lib/codemirror/js
/*  codemirror-css  %css  /web/codemirror/lib/codemirror/css
/*  markdown-js     %js   /web/codemirror/mode/markdown/markdown/js
/*  editor-js       %js   /web/wiki/editor/js
::
^-  (page:rudder rudyard relay)
::
=<
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  help  ~(. +> [bowl order rudyard])
::
:: argue
:: - poke self
::   - store current eyre-id (eyre-id-a) + URL to redirect to on success
::   - poke other (wire = eyre-id-a/...)
::
:: final
:: - redirect -> /wiki/~/wait/{eyre-id-a}?then=/next/path
::
:: /wiki/~/wait/{eyre-id-a}?then=/next/path
:: - not a real page (?)
:: - check eyre-id-a
::   - if already complete
::     - respond immediately
::     - success: redirect to success URL
::     - error: error response
::     - delete stored eyre-id(s)
::   - if not complete
::     - does not respond right away
::     - stores new eyre-id (eyre-id-b) along with eyre-id-a
::
:: on-agent
:: - poke-ack
::   - get eyre-id-a from wire
::     - if no eyre-id-b stored yet
::       - store success / error
::     - if eyre-id-b stored
::       - success: respond to eyre-id-b w/ redirect to success URL (retrieve from eyre-request B query params)
::       - error: respond to eyre-id-b w/ error response
::     - delete stored eyre-id(s)
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
    =/  bid=@t  book-id:help
    =/  =path  (part (~(got by args:help) 'page-path'))
    =/  wik-dir=tape  (base-path:web wiki-path:(wiki-url:web url.request.order))
    (crip "{wik-dir}{(spud path)}?after={(trip id.order)}")
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
  ?>  (may-edit-2 bowl cover)
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
    ;html
      ;+  (doc-head:web bowl "New Page - {(trip title.cover)}")
      ;script: {(trip codemirror-js)}
      ;style: {(trip codemirror-css)}
      ;script: {(trip markdown-js)}
      ;body#with-sidebar
        ;+  (global-nav:web bowl order [%& cover])
        ;main
          ;*  ?~  msg  ~
              ~[;/((trip text.u.msg))]
          ;+  (search-bar:web `book-id.site ~)
          ;h1: New Page
          ::
          ;form(method "post")
            ;div
              ;button.submit
                =type  "submit"
                =name  "action"
                =value  "new-page"
                ; Create Page
              ==
              ;a(href wik-dir): Cancel
            ==
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
              ;
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
|_  [=bowl:gall =order:rudder rudyard]
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
  ?^  spine  `cover.u.spine
  =/  =wiki-path  wiki-path:(wiki-url:web url.request.order)
  =/  book-id=@t  book-id.wiki-path
  =/  buuk  (~(get by books) book-id)
  %+  bind  buuk
  |=(=book [book-id title.book rules.book])
::
--