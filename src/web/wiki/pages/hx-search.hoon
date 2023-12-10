::  search results
::
/-  *wiki
/+  multipart, regex, rudder, string, web=wiki-web, *wiki
::
^-  (page:rudder rudyard action)
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
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ?:  =(~ search-terms)  stub:web
    =/  no-results=?   =(~ search-results)
    ;ul#search-results
      ;*
      ?:  no-results
        :_  ~
        ;li.search-result
          ;p: No Results
        ==
      %+  turn  search-results
      |=  [page-path=path =page]
      ;li.search-result
        ;a/"/wiki/{(trip book-id.site)}{(spud page-path)}": {(trip title.page)}
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
  ++  search-results  ~+
    ^-  (list [page-path=path =page])
    =/  limit=@   (fall (bind (~(get by query) 'limit') (cury slav %ud)) 10)
    =/  matches=(list [path tale])
      %^  skil  ~(tap by tales.book)  limit
      |=  [=path =tale]
      ?~  last=(pry:ton tale)  %.n
      =/  =page  +.u.last
      ?|  (levy search-terms (curr match-title title.page))
          (levy search-terms (curr match-path path))
      ==
    %-  sort-results
    %+  turn  matches
    |=  [=path =tale]
    [path (tail (latest tale))]
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
    |=  raw=(list [path page])
    %+  sort  raw
    |=  [a=[=path =page] b=[=path =page]]
    =/  at  (trip title.page.a)
    =/  bt  (trip title.page.b)
    ?:  (alpha-less at bt)  &
    ?.  =(at bt)            |
    (alpha-less (spud path.a) (spud path.b))
  --
--
