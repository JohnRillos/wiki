::  wiki overview
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder (map @ta book) action)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  args=(map @t @t)  (form-data:web order)
  ?~  del-book=(~(get by args) 'del-book')  ~
  [%del-book book-id.site]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  back=?  &(success (~(has by (form-data:web order)) 'del-book'))
  =/  next=@t
    ?.  back  url.request.order
    =/  msg=tape  (en-urlt:html "Wiki deleted!")
    (crip "/wiki?msg={msg}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  on-page-load
    =/  alert=(unit tape)  (query-msg:web query)
    ?~  alert  ""
    """
    javascript:window.alert('{u.alert}');
    window.history.pushState(\{}, document.title, window.location.pathname);
    """
  ::
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: {(trip title.book)}
        ;style: {(style:web bowl)}
      ==
      ;body#with-sidebar(onload on-page-load)
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;h1#wiki-title: {(trip title.book)}
          ;nav#wiki-controls
            ;a/"/wiki/{(trip book-id.site)}/~/new"
              ;button(type "button"): New Page
            ==
            ;*  ?.  =(src.bowl our.bowl)  ~
            :~
              ;a/"/wiki/{(trip book-id.site)}/~/import"
                ;button(type "button"): Import
              ==
              %+  in-form:web  "Are you sure you want to delete this wiki?"
              ;button.delete
                =type   "submit"
                =name   "del-book"
                =value  "{(trip book-id.site)}"
                ; Delete Wiki
              ==
            ==
          ==
          ;h2: Pages
          ;ul
            ;*  %+  turn  ~(tap by tales.book)
                |=  [=path =tale]
                ^-  manx
                =/  =page  page:(latest tale)
                ;li
                  ;form(method "post")
                    ;a/"/wiki/{(trip book-id.site)}{(spud path)}"
                      ; {(trip title.page)}
                    ==
                  ==
                ==
          ==
          ;+  (footer:web bowl url.request.order)
        ==
      ==
    ==
  --
--
