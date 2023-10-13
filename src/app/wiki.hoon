/-  *wiki
/+  dbug, default-agent, regex, rudder, string, verb, wiki-http
/~  libs  *  /lib/wiki  :: build all wiki libs
/~  mars  *  /mar       :: build all marks
::
::  types core
::
|%
::
+$  card  card:agent:gall
::
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  %0
    books=(map @ta book)
  ==
--
::
::  state
::
=|  state-0
=*  state  -
::
::  debugging tools
::
%+  verb  |
%-  agent:dbug
::
=<  :: compose helper core into agent core
::
::  agent core
::
^-  agent:gall
|_  =bowl:gall
+*  this       .
    default  ~(. (default-agent this %|) bowl)
    http     ~(. wiki-http books)
    main     ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state
    =|  state=state-0
    =.  books.state  ~
    :_  state
    [%pass /eyre/connect %arvo %e %connect [~ /[dap.bowl]] dap.bowl]~
  [cards this]
::
++  on-save  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  |^  =+  !<(old=versioned-state old-vase)
      =^  cards  state  (build-state old)
      [cards this]
  ::
  ++  build-state
    |=  old=versioned-state
    ^-  (quip card state-0)
    =|  cards=(list card)
    |-
    ?-  -.old
      %0  [cards old]
    ==
  --
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^  ?+  mark  (on-poke:default mark vase)
      ::
          %wiki-action
        =^  cards  state  (handle-action !<(action vase))
        [cards this]
      ::
          %handle-http-request
        (handle-http !<(order:rudder vase))
      ::
      ==
  ::
  ++  handle-action
    |=  act=action
    ^-  (quip card _state)
    ?.  =(our.bowl src.bowl)  ~|('Unauthorized! ' !!)
    ?-  -.act
      %new-book       (new-book:main act)
      %mod-book-name  (mod-book-name:main act)
      %del-book       (del-book:main act)
      %new-page       (new-page:main act)
      %mod-page       (mod-page:main act)
      %del-page       (del-page:main act)
      %imp-file       (imp-file:main act)
    ==
  ::
  ++  handle-http
    |=  =order:rudder
    ^-  (quip card _this)
    |^  =/  out=(quip card _+.state)
          (serve [bowl order +.state])
        [-.out this(+.state +.out)]
    ::
    ++  serve
      %-  (steer:rudder _+.state action)
      :^    web:http            :: pages
          http-route:http       :: route
        (fours:rudder +.state)  :: adlib
      |=  act=action            :: solve
      ^-  $@(brief:rudder [brief:rudder (list card) _+.state])
      ?.  authenticated.order  ['Unauthorized!' ~ +.state]
      =^  cards  this
        (on-poke %wiki-action !>(act))
      ['Successfully processed' cards +.state]
    --
  --
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:default path)
    [%http-response *]  [~ this]
  ==
::
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  sign-arvo  (on-arvo:default wire sign-arvo)
      [%eyre %bound *]
    ~?  !accepted.sign-arvo
      [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
    [~ this]
  ==
::
++  on-fail   on-fail:default
--
::
::  helper core (main)
::
|_  =bowl:gall
::
++  new-book
  |=  [%new-book id=@ta title=@t rules=access]
  ?:  |(=(~.~ id) !((sane %ta) id))
    ~|("Invalid wiki ID" !!)
  ?:  (~(has by books) id)  ~|("Wiki '{(trip id)}' already exists!" !!)
  =.  books  (~(put by books) [id [title ~ rules]])
  [~ state]
::
++  del-book
  |=  [%del-book id=@ta]
  =.  books  (~(del by books) id)
  [~ state]
::
++  mod-book-name
  |=  [%mod-book-name id=@ta title=@t]
  =/  =book  (~(got by books) id)
  =.  title.book  title
  =.  books  (~(put by books) id book)
  [~ state]
::
++  new-page
  |=  [%new-page book-id=@ta =path title=@t content=wain]
  ?:  =(~ path)  ~|('Path cannot be blank!' !!)
  ?^  (find "~" path)  ~|('Path cannot contain "/~/"' !!)
  ?.  (levy path (sane %ta))  ~|('Invalid path!' !!)
  =/  =book  (~(got by books) book-id)
  ?:  (~(has by tales.book) path)  ~|("Page {<path>} already exists!" !!)
  ?:  =('' title)  ~|("Title cannot be blank!" !!)
  =/  =page  [title content]
  =/  =tale  (gas:ton *tale [now.bowl page]~)
  =.  tales.book  (~(put by tales.book) path tale)
  =.  books  (~(put by books) book-id book)
  [~ state]
::
++  del-page
  |=  [%del-page book-id=@ta =path]
  =/  =book       (~(got by books) book-id)
  =.  tales.book  (~(del by tales.book) path)
  =.  books       (~(put by books) book-id book)
  [~ state]
::
++  mod-page
  |=  [%mod-page book-id=@ta =path title=(unit @t) content=(unit wain)]
  =/  =book  (~(got by books) book-id)
  =/  =tale  (~(got by tales.book) path)
  =/  =page  page:(latest tale)
  ?:  ?~(title | =('' u.title))  ~|("Title cannot be blank!" !!)
  ?:  ?&  ?~(content & =(content.page u.content))
          ?~(title & =(title.page u.title))
      ==
    [~ state]
  =.  title.page    (fall title title.page)
  =.  content.page  (fall content content.page)
  =.  tale          (put:ton tale now.bowl page)
  =.  tales.book  (~(put by tales.book) path tale)
  =.  books       (~(put by books) book-id book)
  [~ state]
::
++  imp-file
  |=  [%imp-file book-id=@ta files=(map path wain) =title-source]
  :_  state
  %+  turn  ~(tap by files)
  |=  [=path data=wain]
  =/  [title=@t content=wain]
    %+  fall
      ?-  title-source
        %filename  `[(title-from-filename path) data]
        %header    (title-from-header data)
      ==
    [(title-from-filename path) data]
  (poke-self [%new-page book-id path title content])
::
++  title-from-header
  |=  md=wain
  ^-  (unit [title=@t content=wain])
  =/  pattern  "#+\\s+.+"
  ?:  (lth (lent md) 3)                ~
  =/  first-line  (trip -.md)
  ?.  (has:regex pattern first-line)   ~
  ?.  (is-space:string (trip -.+.md))  ~
  :-  ~
  :-  (crip (sub:regex "#+\\s+" "" first-line)) :: 1st line = title
  +.+.md                                        :: skip 2nd line
::
++  title-from-filename
  |=  =path
  ^-  @t
  (crip (title:string (gsub:regex "_" " " (trip (rear path)))))
::
++  poke-self
  |=  =action
  ^-  card
  [%pass [-.action ~] %agent [our.bowl %wiki] %poke %wiki-action !>(action)]
::
--