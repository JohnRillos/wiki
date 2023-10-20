::  article
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
::
^-  (page:rudder state-0 action)
::
=<
::
|_  [=bowl:gall =order:rudder state-0]
::
+*  help  ~(. +> [bowl order books])
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
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
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
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;+  (search-bar:web `book-id.site ~)
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
          ;+  (footer:web book)
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
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
++  can-create
  =(src.bowl our.bowl)
::
--