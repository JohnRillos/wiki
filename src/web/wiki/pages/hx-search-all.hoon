::  global search results
::
/-  *wiki
/+  multipart, regex, rudder, string, web=wiki-web, *wiki
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  =/  query=(map @t @t)  query:(sane-url:web url.request.order)
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ?:  =(~ search-terms)  stub:web
    =/  no-results=?   =(~ all-search-results)
    ;ul#search-results
      ;*
      ?:  no-results
        :_  ~
        ;li.search-result
          ;p: No Results
        ==
      %+  turn  all-search-results
      |=  [host=@p book-id=@ta page-path=path =ref]
      =/  host-dir=tape   ?:  =(host our.bowl)  ""
                          "~/p/{<host>}/"
      =/  =spine  (~(got by super-shelf) [host book-id])
      ;li.search-result.search-result
        ;a/"/wiki/{host-dir}{(trip book-id)}{(spud page-path)}"
          ;span.search-result-book-title: {(trip title.cover.spine)}
          ;span: {(trip title.ref)}
        ==
      ==
    ==
  ::
  ++  search-terms  ~+
    ^-  (list tape)
    =/  quest=@t  (fall (~(get by query) 'q') '')
    ?:  =('' quest)  ~
    ~&  "search: {<quest>}"
    %+  murn  (split:string "," (trip quest))
    |=  =tape
    ?:  (is-space:string tape)  ~
    `(cass (strip:string tape))
  ::
  ++  all-search-results  ~+
    ^-  (list [host=@p book-id=@ta page-path=path =ref])
    %-  zing
    %+  turn  ~(tap in ~(key by super-shelf))
    |=  [host=@p book-id=@ta]
    %+  turn  (search-book host book-id)
    |=  [=path =ref]
    [host book-id path ref]
  ::
  ++  search-book
    |=  [host=@p book-id=@ta]
    ^-  (list [path ref])
    =/  =spine  (~(got by super-shelf) [host book-id])
    =/  toc=(map path ref)  toc.spine
    =/  limit=@   (fall (bind (~(get by query) 'limit') (cury slav %ud)) 10)
    %-  sort-results
    ^-  (list [path ref])
    %^  skil  ~(tap by toc)  limit
    |=  [=path =ref]
    ?|  (levy search-terms (curr match-title title.ref))
        (levy search-terms (curr match-path path))
    ==
  ::
  ++  match-path
    |=  [nedl=tape =path]
    =/  hstk=(list tape)  (turn path trip)
    (lien hstk (cury has:regex nedl))
  ::
  ++  match-title
    |=  [nedl=tape title=@t]
    (has:regex nedl (cass (trip title)))
  ::
  ++  sort-results
    |=  raw=(list [path ref])
    %+  sort  raw
    |=  [a=[=path =ref] b=[=path =ref]]
    =/  at  (trip title.ref.a)
    =/  bt  (trip title.ref.b)
    ?:  (alpha-less at bt)  &
    ?.  =(at bt)            |
    (alpha-less (spud path.a) (spud path.b))
  ::
  ++  super-shelf  ~+
    ^-  shelf
    %-  ~(uni by shelf.rudyard)
    ^-  shelf
    %-  malt
    %+  turn  ~(tap by books.rudyard)
    |=  [id=@ta =book]
    [[our.bowl id] (book-to-spine id book)]
  --
--
