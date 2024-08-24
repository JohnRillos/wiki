::  wiki overview
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder rudyard relay)
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
    =/  has-front=?  (~(has by toc) /[~.-]/front)
    ;html
      ;+  (doc-head:web bowl (trip title.cover))
      ;body#with-sidebar(onload on-page-load)
        ;+  (link-theme:web bowl host.site cover)
        ;+  (global-nav:web bowl order [%& cover])
        ;main
          ;+  (topbar:web bowl order cover)
          ;h1#page-title: Main Page
          ;nav#wiki-controls
            ;*
            ?.  (is-admin bowl host.site rules.cover)  ~
            ;=  ;+  (edit-front-link wik-dir toc)
                ;a/"{wik-dir}/~/import"
                  ;button(type "button"): Import
                ==
            ==
          ==
          ;+
          ?.  has-front  ;stub:web
          ;article#front(hx-get "{wik-dir}/~/x/front", hx-trigger "load", hx-swap "outerHTML")
            ;div.loader.fade-in
              ;+  load:icon:web
            ==
          ==
          ;h2: Contents
          ;+
          ?~  (no-special toc)
            ;p:"This wiki doesn't have any pages yet."
          (render-toc:help toc wik-dir)
          ;+  (footer:web (fall host.site our.bowl) [%& cover])
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
++  no-special
  |=  toc=(map path ref)
  ^-  _toc
  (~(del by toc) /[~.-]/front)
::
++  edit-front-link
  |=  [wik-dir=tape toc=(map path ref)]
  ^-  manx
  =/  link=tape
    ?:  (~(has by toc) /[~.-]/front)
      "{wik-dir}/-/front/~/edit"
    "{wik-dir}/~/new?target=/-/front"
  ;a/"{link}"
    ;button(type "button"): Edit
  ==
::
++  render-toc
  |=  [toc=(map path ref) wik-dir=tape]
  ^-  manx
  |^  (render-bush (path-ref-bush (no-special toc)) ~)
  ::
  ++  render-bush
    |=  [=(bush knot ref) =path]
    =/  data=(list [knot @ud (unit ref) @ud])
      ((bush-summary-at knot ref) bush path)
    =/  start-expanded=?  =(~ path)
    ^-  manx
    ;ul(id <path>, class (weld "toc-list " ?:(start-expanded "expanded" "collapsed")))
      ;*
      %+  turn  (sort-sections data)
      |=  [chapter=knot kids=@ud item=(unit ref) size=@ud]
      =/  loc=^path  (snoc path chapter)
      =*  on-click  ~+  (toggle-expand:web (spud loc))
      ;li
        ;div
          ;+
          ?~  item
            ;span.chapter-list-item-label.clickable(onclick on-click): {(trip chapter)}
          (render-item loc u.item)
          ;+
          ?:  =(0 kids)  stub:web
          =/  label=tape
            ?:  =(1 size)  " (1 page)"
            " ({<size>} pages)"
          ;span.clickable.note(onclick on-click): {label}
        ==
        ;+
        ?:  =(0 kids)  stub:web
        (render-bush bush loc)
      ==
    ==
  ::
  ++  render-item
    |=  [=path =ref]
    ^-  manx
    ;a/"{wik-dir}{(spud path)}": {(trip title.ref)}
  ::
  ++  sort-sections
    |=  data=(list [knot @ud (unit ref) @ud])
    ^-  _data
    %+  sort  data
    |=  [a=[chap=knot kids=@ud item=(unit ref) @ud] b=[chap=knot kids=@ud item=(unit ref) @ud]]
    ?:  &((is-pure-leaf a) !(is-pure-leaf b))  &
    ?:  &((is-pure-leaf b) !(is-pure-leaf a))  |
    (alpha-less (trip chap.a) (trip chap.b))
  ::
  ++  is-pure-leaf
    |=  [chap=knot kids=@ud item=(unit ref) @ud]
    ?~  item  |
    =(0 kids)
  --
::
--