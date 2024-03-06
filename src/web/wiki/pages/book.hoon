::  wiki overview
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder rudyard action)
::
=<
::
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
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
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
    =/  wik-dir=tape
      ?~  host.site  (spud /wiki/[book-id.site])
      (spud /wiki/~/p/[(scot %p u.host.site)]/[book-id.site])
    ;html
      ;+  (doc-head:web bowl (trip title.cover))
      ;body#with-sidebar(onload on-page-load)
        ;+  (global-nav:web bowl order [book-id.site [%& cover]])
        ;main
          ;+  (search-bar:web `book-id.site ~)
          ;h1#page-title: Main Page
          ;nav#wiki-controls
            ;*  ?.  (may-edit-2 bowl cover)  ~
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
            ;*  %+  turn  ~(tap by get-toc:help) :: todo: sort by path
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
++  get-book
  ^-  (unit book)
  =/  =wiki-path  wiki-path:(wiki-url:web url.request.order)
  (~(get by books) book-id.wiki-path)
::
++  get-cover
  ^-  (unit cover)
  ?^  spine  `cover.u.spine
  =/  =wiki-path  wiki-path:(wiki-url:web url.request.order)
  =/  book-id=@t  book-id.wiki-path
  =/  buuk  (~(get by books) book-id)
  %+  bind  buuk
  |=(=book [book-id title.book rules.book])
::
++  get-toc
  ^-  (map path ref)
  ?^  spine  toc.u.spine
  =/  =book  (need get-book)
  %-  ~(run by tales.book)
  |=  =tale
  =/  [=time =page]  (latest tale)
  =/  ver=@  (dec (wyt:ton tale))
  [ver time title.page]
::
--