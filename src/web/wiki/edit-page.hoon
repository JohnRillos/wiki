::  Article editing page
::
/-  *wiki
/+  rudder
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
          %mod-page
        ?.  authenticated.order  'You must be logged in to edit an article!'
        =/  page-title=@t  (~(got by args) 'page-title')
        =/  content=tape  (trip (~(got by args) 'content'))
        [%mod-page book-id:help page-id:help `page-title `content]
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
    =/  pid=@t  page-id:help
    (crip "/wiki/{(trip bid)}/{(trip pid)}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  site=(pole knot)  (stab url.request.order)
  ?.  ?=([%wiki book-id=@ta page-id=@ta %~.~ %edit ~] site)
    [%code 404 'Invalid path']
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ?~  puge=(~(get by pages.book) page-id.site)
    [%code 404 (crip "Article {<page-id.site>} not found in {<title.book>}")]
  =/  =page  u.puge
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
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: Edit Page - {(trip title.page)}
      ==
      ;script: {(trip codemirror-js)}
      ;style: {(trip codemirror-css)}
      ;script: {(trip markdown-js)}
      ;body
        ;*  ?~  msg  ~
            ~[;/((trip text.u.msg))]
        ;nav
          ;a(href "../.."): {(trip title.book)}
        ==
        ;h1: Edit Page - {(trip title.page)}
        ::
        ;a(href ".."): Cancel
        ::
        ;form(method "post")
          ;table#add-page
            ;tr
              ;td
                ;button(type "submit", name "action", value "mod-page"): Submit Edit
              ==
              ;td:""
            ==
            ;tr
              ;th: Page ID
              ;th: Page Title
            ==
            ;tr
              ;td
                ;input(type "text", name "page-id", value (trip page-id.site), disabled "true");
              ==
              ;td
                ;input(type "text", name "page-title", value (trip title.page));
              ==
            ==
          ==
          ;h3: Content
          ;textarea(id "content", name "content"): {content.page}
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
::
++  page-id
  ^-  @ta
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta page-id=@ta *] site)
  page-id.site
--