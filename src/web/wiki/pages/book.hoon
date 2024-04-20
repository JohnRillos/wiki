::  wiki overview
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder rudyard relay)
::
=<
:::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  help  ~(. +> [bowl order rudyard])
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
  =/  spune  get-spine:help
  ?~  spune  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =^spine  u.spune
  =/  [=cover toc=(map path ref)]  u.spune
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
    =/  wik-dir=tape  (base-path:web site)
    ;html
      ;+  (doc-head:web bowl (trip title.cover))
      ;body#with-sidebar(onload on-page-load)
        ;+  (global-nav:web bowl order [%& cover])
        ;main
          ;+  (search-bar:web `book-id.site host.site)
          ;h1#page-title: Main Page
          ;nav#wiki-controls
            ;*  ?.  (may-edit bowl host.site rules.cover)  ~
            ;=  ;a/"{wik-dir}/~/new"
                  ;button(type "button"): New Page
                ==
                ;a/"{wik-dir}/~/import"
                  ;button(type "button"): Import
                ==
            ==
          ==
          :: todo: special UI for "no pages" 
          ;h2: Pages
          ;ul
            ;*  %+  turn  (sort-toc:help toc)
                |=  [=path =ref]
                ^-  manx
                ;li
                  ;form(method "post")
                    ;a/"{wik-dir}{(spud path)}"
                      ; {(trip title.ref)}
                    ==
                  ==
                ==
          ==
          ;+  (footer:web [%& cover])
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  get-spine
  ^-  (unit ^spine)
  ?^  spine  spine
  =/  =wiki-path  wiki-path:(wiki-url:web url.request.order)
  =/  book-id=@t  book-id.wiki-path
  =/  host=@p  (fall host.wiki-path our.bowl)
  ?.  =(our.bowl host)  (~(get by shelf) [host book-id.wiki-path])
  =/  buuk  (~(get by books) book-id)
  %+  bind  buuk
  |=(=book (book-to-spine book-id book))
::
++  sort-toc
  |=  toc=(map path ref)
  ^-  (list [=path =ref])
  %+  sort  ~(tap by toc)
  |=  [a=[=path =ref] b=[=path =ref]]
  (alpha-less (spud path.a) (spud path.b))
::
--