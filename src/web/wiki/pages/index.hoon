::  app index
::
/-  *wiki
/+  rudder, web=wiki-web
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
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ;html
      ;head
        ;title:"%wiki"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style: {(style:web bowl)}
      ==
      ;body
        ;h1: %wiki manager
        ;a/"/wiki/~/new"
          ;button(type "button"): New Wiki
        ==
        ;h2: Your Wikis
        ;ul
          ;*  %+  turn  ~(tap by books)
              |=  [id=@ta =book]
              ^-  manx
              ;li
                ;a/"/wiki/{(trip id)}": {(trip title.book)}
              ==
        ==
      ==
    ==
  --
--
