::  article
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
  ~&  >>  "args: {<args>}"
  ?~  what=(~(get by args) 'action')  ~
  ~&  >>  "what: {<what>}"
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
  ?.  ?=([%wiki book-id=@tas page-id=@tas ~] site)
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
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: {(trip title.page)}
      ==
      ;body
        ;h1: {(trip title.page)}
        ;p: {content.page}
      ==
    ==
  --
--
