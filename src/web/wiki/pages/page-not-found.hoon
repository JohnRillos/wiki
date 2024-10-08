::  article
::
/-  *wiki
/+  rudder, wiki-auth, wiki-web, *wiki
::
^-  (page:rudder rudyard relay)
::
=<
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  help  ~(. +> [bowl order rudyard])
    web   ~(. wiki-web [bowl rudyard])
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  ::
  =,  rudyard
  ::
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  =/  =cover  (book-to-cover book-id.site book)
  =/  target=(unit path)  (target-path:help query)
  ?~  target  [%code 400 'Invalid query']
  ?<  (~(has by tales.book) u.target)
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ;html
      ;+  (doc-head:web bowl "Page Not Found")
      ;body#with-sidebar
        ;+  (link-theme:web bowl host.site cover)
        ;+  (global-nav:web bowl order [%| book])
        ;main
          ;+  (topbar:web bowl order cover)
          ;h1#page-title: Page Not Found
          ;p
            ;span: There is no page at path 
            ;code: {(spud u.target)}
            ;+  ?.  can-create:help  stub:web
              ;p: Would you like to create this page?
              ;a/"./new?target={(spud u.target)}"
                ;button(type "button"): Create Page
              ==
          ==
          ;+  (footer:web (fall host.site our.bowl) [%| book])
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
+*  auth  ~(. wiki-auth [bowl ether])
::
++  book-id  ~+
  ^-  @ta
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta *] site)
  book-id.site
::
++  target-path
  |=  query=(map @t @t)
  ^-  (unit path)
  =/  target=(unit @t)  (~(get by query) 'target')
  (bind target stab)
::
++  can-create  :: todo: allow editors to create
  =(src:auth our.bowl)
::
--