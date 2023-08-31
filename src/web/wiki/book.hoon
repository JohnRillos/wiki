::  wiki overview
::
/-  *wiki
/+  rudder
::
^-  (page:rudder (map @ta book) action)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta ~] site)
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
        ;title: {(trip title.book)}
      ==
      ;body
        ;*  ?~  msg  ~
            ~[;/((trip text.u.msg))]
        ;h1: {(trip title.book)}
        ;a/"/wiki/{(trip book-id.site)}/~/new"
          ;button(type "button"): New Article
        ==
        ;h2: Articles
        ;ul
          ;*  %+  turn  ~(tap by pages.book)
              |=  [=path =page]
              ^-  manx
              ;li
                ;a/"/wiki/{(trip book-id.site)}{(spud path)}": {(trip title.page)}
              ==
        ==
      ==
    ==
  --
--
