::  wiki overview
::
/-  *wiki
/+  rudder
::
^-  (page:rudder (map @tas book) action)
::
|_  [=bowl:gall =order:rudder books=(map @tas book)]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)
    ?~(body ~ (frisk:rudder q.u.body))
  ?~  what=(~(get by args) 'action')  ~
  |^  ?+  u.what  'say what now'
      ::
          %new-page
        =/  page-id=@tas
          ~|  'Invalid page ID'  (slav %tas (~(got by args) 'page-id'))
        =/  page-title=@t  (~(got by args) 'page-title')
        [%new-page book-id page-id page-title "hello world"]
      ==
  ::
  ++  book-id
    =/  site=(pole knot)  (stab url.request.order)
    ?>  ?=([%wiki book-id=@tas ~] site)
    book-id.site
  --
::
++  final
  |=  [success=? msg=brief:rudder]
  (build ~ ~)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  ::
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@tas ~] site)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  style  ''
  ::
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: {(trip title.book)}
      ==
      ;body
        ;h1: {(trip title.book)}
        ;h2: Pages
        ;ul
          ;*  %+  turn  ~(tap by pages.book)
              |=  [page-id=@tas =page]
              ^-  manx
              ;li
                ;a/"/wiki/{(trip book-id.site)}/{(trip page-id)}": {(trip title.page)}
              ==
        ==
        ::
        ;table#add-page :: break this form out into its own page /wiki/my-wiki/new-page or /wiki/my-wiki/pages/new
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
              ;td.label
                ;input(type "text", name "page-title", placeholder "My Page");
              ==
            ==
          ==
        ==
      ==
    ==
  --
--
