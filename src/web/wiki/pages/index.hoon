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
          msg=(unit [success=? text=@t])
      ==
  ^-  reply:rudder
  =/  [site=(pole knot) query=(map @t tape)]  (sane-url:web url.request.order)
  ::
  |^  [%page render]
  ::
  ++  on-load
    =/  alert=(unit tape)  (query-msg:web query)
    ?~  alert  ""
    "javascript:window.alert('{u.alert}')"
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
      ;body(onload on-load)
        ;h1: %wiki manager
        ;a/"/wiki/~/new"
          ;button(type "button"): New Wiki
        ==
        ;h2: Your Wikis
        ;ul.wiki-list
          ;*  %+  turn  ~(tap by books)
              |=  [id=@ta =book]
              ^-  manx
              ;li.wiki-list-item
                ;+  ?:(public-read.rules.book globe:icon:web lock:icon:web)
                ;a/"/wiki/{(trip id)}": {(trip title.book)}
              ==
        ==
      ==
    ==
  --
--
