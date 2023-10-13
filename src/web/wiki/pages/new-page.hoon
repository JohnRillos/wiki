::  Article creation page
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  codemirror-js   %js   /web/codemirror/lib/codemirror/js
/*  codemirror-css  %css  /web/codemirror/lib/codemirror/css
/*  markdown-js     %js   /web/codemirror/mode/markdown/markdown/js
/*  editor-js       %js   /web/wiki/editor/js
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
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)  args:help
  ?~  what=(~(get by args) 'action')  ~
  |^  ?+  u.what  'say what now'
      ::
          %new-page
        ?.  authenticated.order  'You must be logged in to create an article!'
        =/  =path
          ~|  'Invalid page path'  (part (~(got by args) 'page-path'))
        =/  page-title=@t  (~(got by args) 'page-title')
        =/  content=wain  (to-wain:format (~(got by args) 'content'))
        [%new-page book-id:help path page-title content]
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
    (crip "/wiki/{(trip bid)}{(spud path)}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  path-regex  "[0-9a-z\\-_~\\.\\/]+"
  ::
  ++  path-explain  "Lowercase letters, numbers, period (.), underscore (_), hyphen (-), tilde (~), and slash (/)"
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (spud /wiki/[book-id.site])
    =/  target=(unit path)  (target-path:help query)
    =/  default-path=tape  ?~(target "" (tail (spud u.target)))
    ;html
      ;head
        ;title: New Page - {(trip title.book)}
        ;style: {(style:web bowl)}
      ==
      ;script: {(trip codemirror-js)}
      ;style: {(trip codemirror-css)}
      ;script: {(trip markdown-js)}
      ;body#with-sidebar
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;*  ?~  msg  ~
              ~[;/((trip text.u.msg))]
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
            ;span: /wiki/{(trip book-id.site)}/
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
|_  [=bowl:gall =order:rudder books=(map @ta book)]
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
--