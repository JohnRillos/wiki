::  Article creation page
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  codemirror-js   %js   /lib/codemirror/lib/codemirror/js
/*  codemirror-css  %css  /lib/codemirror/lib/codemirror/css
/*  markdown-js     %js   /lib/codemirror/mode/markdown/markdown/js
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
        =/  content=tape  (trip (~(got by args) 'content'))
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
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta *] site)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  style  ""
  ::
  ++  textarea-script
    """
    var editor = CodeMirror.fromTextArea(document.getElementById('content'), \{
      mode: 'markdown',
      highlightFormatting: true,
      lineNumbers: true,
      lineWrapping: true,
      theme: 'default',
      extraKeys: \{'Enter': 'newlineAndIndentContinueMarkdownList' }
    });
    """
  ::
  ++  path-regex  "[0-9a-z\\-_~\\.\\/]+"
  ::
  ++  path-explain  "Lowercase letters, numbers, period (.), underscore (_), hyphen (-), tilde (~), and slash (/)"
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (spud /wiki/[book-id:help])
    ;html
      ;head
        ;title: New Page - {(trip title.book)}
        ;style: {(style:web bowl)}
      ==
      ;script: {(trip codemirror-js)}
      ;style: {(trip codemirror-css)}
      ;script: {(trip markdown-js)}
      ;body
        ;*  ?~  msg  ~
            ~[;/((trip text.u.msg))]
        ;nav
          ;a(href wik-dir): {(trip title.book)}
        ==
        ;h2: New Page
        ::
        ;a(href wik-dir): Cancel
        ::
        ;form(method "post")
          ;button(type "submit", name "action", value "new-page"):"Create Page"
          
          ;h3: Page Path
          ;span: /wiki/{(trip book-id:help)}/
          ;input
            =type         "text"
            =name         "page-path"
            =placeholder  "my/page"
            =required     "true"
            =pattern      path-regex
            =title        path-explain
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
        ;script: {textarea-script}
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
++  book-id
  ^-  @ta
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta *] site)
  book-id.site
--