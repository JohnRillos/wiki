::  wiki overview
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder state-0 action)
::
|_  [=bowl:gall =order:rudder state-0]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
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
      ;+  (doc-head:web bowl (trip title.book))
      ;body#with-sidebar(onload on-page-load)
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;+  (search-bar:web `book-id.site ~)
          ;h1#page-title: Main Page
          ;nav#wiki-controls
            ;a/"/wiki/{(trip book-id.site)}/~/new"
              ;button(type "button"): New Page
            ==
            ;*  ?.  =(src.bowl our.bowl)  ~
            :_  ~
            ;a/"/wiki/{(trip book-id.site)}/~/import"
              ;button(type "button"): Import
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
          ;+  (footer:web book)
        ==
      ==
    ==
  --
--
