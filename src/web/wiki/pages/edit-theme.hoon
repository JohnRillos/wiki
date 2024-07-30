::  Theme editing page
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
/*  codemirror-js   %js   /web/codemirror/lib/codemirror/js
/*  codemirror-css  %css  /web/codemirror/lib/codemirror/css
/*  css-mode-js     %js   /web/codemirror/mode/css/css/js
/*  css-editor-js   %js   /web/wiki/css-editor/js
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
  ^-  $@(brief:rudder relay)
  =/  args=(map @t @t)  (form-data:web order)
  ?>  ?=(%mod-look (~(got by args) 'action'))
  =/  is-default=?  =('true' (~(got by args) 'is-default'))
  =/  host  host:wiki-path:(wiki-url:web url.request.order)
  =/  theme=(each @tas @t)
    ?:  is-default  [%& %default]
    [%| (~(got by args) 'custom-css')]
  =/  =action  [%mod-look book-id:help theme]
  [%relay (fall host our.bowl) id.order action]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  next=@t
    ?.  success  url.request.order
    =/  wik-dir=tape  (base-path:web wiki-path:(wiki-url:web url.request.order))
    (crip wik-dir)
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  ?.  ?~  host.site  &
      =(u.host.site our.bowl)
    [%code 403 (crip "You are not the admin for this wiki")]
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
  =/  theme=(each @tas @t)  get-theme:help
  =/  custom=@t
    ?-  -.theme
      %&  ''
      %|  p.theme
    ==
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ;html
      ;+  (doc-head:web bowl "Edit Theme")
      ;script: {(trip codemirror-js)}
      ;style: {(trip codemirror-css)}
      ;script: {(trip css-mode-js)}
      ;body#with-sidebar
        ;+  (link-theme:web bowl host.site cover)
        ;+  (global-nav:web bowl order [%& cover])
        ;main
          ;*  ?~  msg  ~
              ~[;/((trip text.u.msg))]
          ;+  (search-bar:web `book-id.site host.site)
          ;h1: Edit Theme
          ;+
          %+  in-form:web  "Are you sure?"
          ;div
            ;div.box-item
              ;+  %+  check-if:web  -.theme
                  %+  toggle-codemirror:web  %.n
              ;input#use-default(type "radio", name "is-default", value "true");
              ;label(for "use-default"): Default
            ==
            ;div.box-item
              ;+  %+  check-if:web  ?!(-.theme)
                  %+  toggle-codemirror:web  %.y
              ;input#use-custom(type "radio", name "is-default", value "false");
              ;label(for "use-custom"): Custom style
            ==
            ;div#editor-container
              ;h3: Custom CSS
              ;textarea(id "custom-css", name "custom-css")
                ; {(trip custom)}
              ==
              ;script: {(trip css-editor-js)}
            ==
            ;br;
            ;br;
            ;button.submit
              =type   "submit"
              =name   "action"
              =value  "mod-look"
              ; Submit
            ==
          ==
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
++  book-id  ~+
  ^-  @ta
  book-id:wiki-path:(wiki-url:web url.request.order)
::
++  page-path  ~+
  ^-  path
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  (snip (snip loc.site))
::
++  get-cover :: todo: update when remote admins are a thing
  ^-  (unit cover)
  %+  bind  (~(get by books) book-id)
  |=(=book (book-to-cover book-id book))
::
++  get-theme :: todo: update when remote admins are a thing
  ^-  (each @tas @t)
  theme:(~(got by books) book-id)
::
--