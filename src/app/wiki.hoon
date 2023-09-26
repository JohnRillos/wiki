/-  *wiki
/+  dbug, default-agent, rudder, verb, wiki-http
/~  libs  *  /lib/wiki  :: force-build all wiki libs
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
    ~&  >  act
    ?-  -.act
      %new-book       (new-book:main act)
      %mod-book-name  (mod-book-name:main act)
      %new-page       (new-page:main act)
      %mod-page       (mod-page:main act)
      %del-page       [~ state]
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
  =.  books  (~(put by books) [id [title ~ rules]])
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
  |=  [%new-page book-id=@ta =path title=@t content=tape]
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
++  mod-page
  |=  [%mod-page book-id=@ta =path title=(unit @t) content=(unit tape)]
  =/  =book  (~(got by books) book-id)
  =/  =tale  (~(got by tales.book) path)
  =/  =page  (latest tale)
  ?:  ?~(title | =('' u.title))  ~|("Title cannot be blank!" !!)
  =.  title.page    (fall title title.page)
  =.  content.page  (fall content content.page)
  =.  tale        (put:ton tale now.bowl page)
  =.  tales.book  (~(put by tales.book) path tale)
  =.  books       (~(put by books) book-id book)
  [~ state]
::
--