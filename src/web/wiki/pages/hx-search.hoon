::  search results
::  todo: test searching against remote wiki not in shelf
::
/-  *wiki
/+  multipart, regex, rudder, string, web=wiki-web, *wiki
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
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  |^  =/  t  get-toc
      ?~  t  [%code 404 (crip "Wiki {<book-id.site>} not found")]
      [%page render]
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
      =/  wik-dir=tape  (base-path:web site)
      %+  turn  search-results
      |=  [page-path=path =ref]
      ;li.search-result
        ;a/"{wik-dir}{(spud page-path)}": {(trip title.ref)}
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
    ^-  (list [page-path=path =ref])
    =/  toc=(map path ref)  (need get-toc)
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
  ++  host  ~+  (fall host.site our.bowl)
  ::
  ++  get-toc  ~+
    ^-  (unit (map path ref))
    ?^  spine  `toc.u.spine
    ?.  =(host our.bowl)
      %+  bind  (~(get by shelf) [host book-id.site])
      |=(=^spine toc.spine)
    %+  bind  (~(get by books) book-id.site)
    |=  =book
    %-  ~(run by tales.book)
    |=  =tale
    =/  [=time =page]  (latest tale)
    =/  ver=@  (dec (wyt:ton tale))
    [ver time title.page]
  --
--
