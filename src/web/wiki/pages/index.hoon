::  app index
::
/-  *wiki
/+  rudder, web=wiki-web
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
  ++  on-page-load
    =/  alert=(unit tape)  (query-msg:web query)
    ?~  alert  ""
    """
    javascript:window.alert('{u.alert}');
    window.history.pushState(\{}, document.title, window.location.pathname);
    """
  ::
  ++  sort-shelf
    |=  [a=[[host=@p id=@ta] =^spine] b=[[host=@p id=@ta] =^spine]]
    (gth as-of.spine.a as-of.spine.b)
  ::
  ++  render
    ^-  manx
    ;html
      ;+  (doc-head:web bowl "%wiki")
      ;body(onload on-page-load)
        ;div#index-container
          ;h1: %wiki
          ;a/"/wiki/~/new"
            ;button.submit(type "button"): New Wiki
          ==
          ;*
          ?:  =(~ books)  [stub:web]~
            ;=
              ;h2: Your Wikis
              ;ul.wiki-list
                ;*
                %+  turn  ~(tap by books)
                |=  [id=@ta =book]
                ^-  manx
                ;li.wiki-list-item
                  ;a/"/wiki/{(trip id)}"
                    ;+  ?:(public-read.rules.book globe:icon:web lock:icon:web)
                    ; {(trip title.book)}
                  ==
                ==
              ==
            ==
          ;br;
          ;h2: Wikis on the Network
          ;ul.wiki-list
            ;*
            %+  turn  (sort ~(tap by shelf) sort-shelf)
            |=  [[host=@p id=@ta] =^spine]
            ^-  manx
            ;li.wiki-list-item
              ;a/"/wiki/~/p/{<host>}/{(trip id)}"
                ;+  ?:(public-read.rules.cover.spine globe:icon:web lock:icon:web)
                ; {(trip title.cover.spine)}
              ==
            ==
          ==
        ==
      ==
    ==
  --
--
