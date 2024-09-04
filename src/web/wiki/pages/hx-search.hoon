::  htmx partial: global search results
::
/-  *wiki
/+  multipart, regex, rudder, string, wiki-auth, wiki-web, *wiki
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  auth  ~(. wiki-auth [bowl ether.rudyard])
    web   ~(. wiki-web [bowl rudyard])
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
  =/  url=[=path query=(map @t @t)]  (sane-url:web url.request.order)
  =/  query=(map @t @t)  query:url
  =/  site=(unit wiki-path)  (mole |.((to-wiki-path:web path.url)))
  =/  this-host=(unit @p)   ?~(site ~ `(fall host.u.site our.bowl))
  =/  this-book=(unit @ta)  ?~(site ~ `book-id.u.site)
  =/  limit=@   (fall (bind (~(get by query) 'limit') (cury slav %ud)) 10)
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
      =/  here=?  (is-here host book-id)
      ;li.search-result.search-result
        ;a/"/wiki/{host-dir}{(trip book-id)}{(spud page-path)}"
          ;+  ?:  here  stub:web
              ;div.search-result-book-title
                ;span: {(trip title.cover.spine)}
                ;span: {?:(=(src:auth host) "" (cite:title host))}
              ==
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
    %-  (cury scag limit)
    ^-  (list [host=@p book-id=@ta page-path=path =ref])
    %-  zing
    %+  turn  (sort-keys ~(tap in ~(key by super-shelf)))
    |=  [host=@p book-id=@ta]
    %+  turn  (search-book host book-id)
    |=  [=path =ref]
    [host book-id path ref]
  ::
  ++  search-book
    |=  [host=@p book-id=@ta]
    ^-  (list [path ref])
    =/  =spine  (~(got by super-shelf) [host book-id])
    =/  toc=(map path ref)  (no-special toc.spine)
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
  ++  sort-keys
    |=  raw=(list [@p @ta])
    %+  sort  raw
    |=  [a=[=ship id=@ta] b=[=ship id=@ta]]
    ?:  &((is-here ship.a id.a) !(is-here ship.b id.b))  &
    ?:  &(!(is-here ship.a id.a) (is-here ship.b id.b))  |
    ?:  &(=(src:auth ship.a) ?!(=(src:auth ship.b)))  &
    ?:  &(?!(=(src:auth ship.a)) =(src:auth ship.b))  |
    (alpha-less (trip id.a) (trip id.b))
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
  ++  is-here
    |=  [=ship =knot]
    ~+
    ?~  this-host  |
    ?~  this-book  |
    &(=(u.this-host ship) =(u.this-book knot))
  ::
  ++  super-shelf  ~+
    ^-  shelf
    ?.  =(src:auth our.bowl)
      =/  id=@ta  (need this-book)
      =/  =book  (~(got by books.rudyard) id)
      (malt [[our.bowl id] (book-to-spine id book)]~)
    =/  scried=(list (pair [@p @ta] spine))
      ?~  spine.rudyard  ~
      [[(need this-host) (need this-book)] u.spine.rudyard]~
    =;  local=shelf  (~(gas by local) scried)
    %-  ~(uni by shelf.rudyard)
    ^-  shelf
    %-  malt
    %+  turn  ~(tap by books.rudyard)
    |=  [id=@ta =book]
    [[our.bowl id] (book-to-spine id book)]
  ::
  ++  no-special
  |=  toc=(map path ref)
  ^-  _toc
  (~(del by toc) /[~.-]/front)
  --
--
