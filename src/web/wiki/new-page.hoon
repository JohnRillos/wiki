::  Article creation page
::
/-  *wiki
/+  rudder
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
        =/  page-id=@ta
          ~|  'Invalid page ID'  (tie (~(got by args) 'page-id'))
        =/  page-title=@t  (~(got by args) 'page-title')
        [%new-page book-id:help page-id page-title "hello world"]
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
    =/  pid=@t  (~(got by args:help) 'page-id')
    (crip "/wiki/{(trip bid)}/{(trip pid)}")
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
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: New Page - {(trip title.book)}
      ==
      ;body
        ;*  ?~  msg  ~
            ~[;/((trip text.u.msg))]
        ;h1: {(trip title.book)}
        ;h2: New Page
        ::
        ;table#add-page
          ;form(method "post")
            ;tr(style "font-weight: bold")
              ;td:""
              ;td:""
              ;td:"Page ID"
              ;td:"Page Title"
            ==
            ;tr
              ;td:""
              ;td
                ;button(type "submit", name "action", value "new-page"):"Create Page"
              ==
              ;td
                ;input(type "text", name "page-id", placeholder "my-page");
              ==
              ;td
                ;input(type "text", name "page-title", placeholder "My Page");
              ==
            ==
          ==
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
++  book-id
  ^-  @ta
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta *] site)
  book-id.site
--