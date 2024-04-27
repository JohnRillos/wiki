::  global search page
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [success=? text=@t])
      ==
  ^-  reply:rudder
  =/  [site=(pole knot) query=(map @t @t)]  (sane-url:web url.request.order)
  ::
  |^  [%page render]
  ::
  ++  sort-shelf
    |=  [a=[[host=@p id=@ta] =^spine] b=[[host=@p id=@ta] =^spine]]
    (gth stamp.cover.spine.a stamp.cover.spine.b)
  ::
  ++  render :: todo: Back button actually returns to previous page, not hardcoded to /wiki
    ^-  manx
    =/  search-url=tape  "/wiki/~/x/search"
    ;html
      ;+  (doc-head:web bowl "Search %wiki")
      ;body#search-page
        ;h1: Search
        ;nav#main-controls
          ;a/"/wiki"
            ;button: Back
          ==
        ==
        ;script: {search-keybind-script:web}
        ;div#search-bar
          ;+  search:icon:web
          ;input#search-input
            =type         "search"
            =name         "q"
            =style        "margin-left: 4px"
            =placeholder  "Search all wikis (Ctrl-K)"
            =hx-get       search-url
            =hx-params    "*"
            =hx-trigger   "keyup changed delay:100ms, search"
            =hx-target    "#search-all-results-container"
            ;
          ==
        ==
        ;div#search-all-results-container;
      ==
    ==
  --
--
