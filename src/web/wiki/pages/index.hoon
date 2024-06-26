::  app index
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
    (gth stamp.cover.spine.a stamp.cover.spine.b)
  ::
  ++  render
    ^-  manx
    ;html
      ;+  (doc-head:web bowl "%wiki")
      ;body(onload on-page-load)
        ;div#index-container
          ;h1: %wiki
          ;nav#main-controls
            ;a/"/wiki/~/new"
              ;button.submit(type "button"): New Wiki
            ==
            ;a/"/wiki/~/search"
              ;button(type "button"): Search
            ==
          ==
          ;*
          ?:  =(~ books)  [stub:web]~
            ;=
              ;h2.index-header: Your Wikis
              ;ul.wiki-list
                ;*
                %+  turn  ~(tap by books)
                |=  [id=@ta =book]
                ^-  manx
                =/  hover=tape  "{<~(wyt by tales.book)>} pages"
                ;li.wiki-list-item
                  ;a/"/wiki/{(trip id)}"
                    =title  hover
                    ;+  ?:(public.read.rules.book globe:icon:web lock:icon:web)
                    ; {(trip title.book)}
                  ==
                ==
              ==
            ==
          ;br;
          ;h2.index-header
            ; More Wikis on Urbit
            ;+  (info:icon:web "Your %pals have been gossiping about these wikis")
          ==
          ;div
            ;*
            =/  pals-installed=?  .^(? %gu /(scot %p our.bowl)/pals/(scot %da now.bowl)/$)
            %-  (wilt manx)
            :~  [!pals-installed ;p:"You don't have ~paldev/pals installed." ~]
                [&(!pals-installed ?!(=(~ shelf))) ;p:"This list might be out of date." ~]
                :-  =(~ shelf)
                :~  ;p:"You haven't heard about any wikis on the network yet."
                    ;p:"%wiki uses %pals to find out about other wikis on Urbit."
                    ;p:"If you know someone who uses %wiki, add them as a pal!"
                ==
            ==
          ==
          ;ul.wiki-list
            ;*
            %+  turn  (sort ~(tap by shelf) sort-shelf)
            |=  [[host=@p id=@ta] =^spine]
            =/  host-text=tape
              ?:  =(%pawn (clan:title host))  "comet"
              (cite:title host)
            =/  hover=tape
              """
              Host: {<host>}
              Edited: {(time-ago now.bowl stamp.cover.spine)}
              {<~(wyt by toc.spine)>} pages
              """
            ^-  manx
            ;li.wiki-list-item
              ;a.remote/"/wiki/~/p/{<host>}/{(trip id)}"
                =title  hover
                ;div.wiki-name: {(trip title.cover.spine)}
                ;div.wiki-host: {host-text}
              ==
            ==
          ==
        ==
      ==
    ==
  --
--
