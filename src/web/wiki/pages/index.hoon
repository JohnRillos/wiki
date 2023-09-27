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
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)  (form-data:web order)
  ?~  del-book=(~(get by args) 'del-book')  ~
  [%del-book id=u.del-book]
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
                ;form(method "post")
                  ;a/"/wiki/{(trip id)}": {(trip title.book)}
                  ; 
                  ;button  :: to-do: confirmation dialog w/ htmx
                    =type   "submit"
                    =name   "del-book"
                    =value  "{(trip id)}"
                    ; Delete
                  ==
                ==
              ==
        ==
      ==
    ==
  --
--
