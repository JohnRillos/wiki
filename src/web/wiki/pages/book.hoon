::  wiki overview
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  htmx-js   %js   /web/htmx/js
::
^-  (page:rudder (map @ta book) action)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)  (form-data:web order)
  ?^  del-page=(~(get by args) 'del-page')
    =/  [site=(pole knot) *]  (sane-url:web url.request.order)
    ?>  ?=([%wiki book-id=@ta ~] site)
    =/  =path  (part u.del-page)
    [%del-page book-id.site path]
  ?~  del-book=(~(get by args) 'del-book')  ~
  [%del-book id=u.del-book]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  back=?  &(success (~(has by (form-data:web order)) 'del-book'))
  =/  next=@t  ?:(back '/wiki?msg=Wiki%20deleted' url.request.order)
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=(pole knot) *]  (sane-url:web url.request.order)
  ?>  ?=([%wiki book-id=@ta ~] site)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: {(trip title.book)}
        ;style: {(style:web bowl)}
        ;script: {(trip htmx-js)}
      ==
      ;body
        ;*  ?~  msg  ~
            ~[;/((trip text.u.msg))]
        ;h1: {(trip title.book)}
        ;div#wiki-controls
          ;a/"/wiki/{(trip book-id.site)}/~/new"
            ;button(type "button"): New Article
          ==
          ;+  %+  in-form:web  "Are you sure you want to delete this wiki?"
          ;button#delete-wiki
            =type   "submit"
            =name   "del-book"
            =value  "{(trip book-id.site)}"
            ; Delete Wiki
          ==
        ==
        ;h2: Articles
        ;ul
          ;*  %+  turn  ~(tap by tales.book)
              |=  [=path =tale]
              ^-  manx
              =/  =page  page:(latest tale)
              ;li
                ;form(method "post")
                  :: to-do: icon for public vs private
                  ;a/"/wiki/{(trip book-id.site)}{(spud path)}"
                    ; {(trip title.page)}
                  ==
                  ; 
                  ;button  :: to-do: confirmation dialog w/ htmx
                    =type   "submit"
                    =name   "del-page"
                    =value  "{(spud path)}"
                    ; Delete
                  ==
                ==
              ==
        ==
        ;+  (footer:web bowl url.request.order)
      ==
    ==
  --
--
