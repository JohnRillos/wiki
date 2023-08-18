/-  *wiki
/+  dbug, default-agent, rudder, verb
/~  web  (page:rudder (map @ta book) action)  /web/wiki
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
  |^  ?.  =(our.bowl src.bowl)  ~|('Unauthorized! ' !!)
      ?+  mark  (on-poke:default mark vase)
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
    ~&  >  act
    ?-  -.act
      %new-book       (new-book:main act)
      %mod-book-name  (mod-book-name:main act)
      %new-page       (new-page:main act)
      %mod-page       [~ state]
      %del-page       [~ state]
    ==
  ::
  ++  handle-http
    |=  =order:rudder
    ^-  (quip card _this)
    =;  out=(quip card _+.state)
      [-.out this(+.state +.out)]
    %.  [bowl order +.state]
    %-  (steer:rudder _+.state action)
    :^    web                 :: pages
        http-route            :: route
      (fours:rudder +.state)  :: adlib
    |=  act=action            :: solve
    ^-  $@(brief:rudder [brief:rudder (list card) _+.state])
    ?.  authenticated.order  ['Unauthorized!' ~ +.state]
    =^  cards  this
      (on-poke %wiki-action !>(act))
    ['Successfully processed' cards +.state]
  ::
  ++  http-route
    ^-  route:rudder
    |=  =trail:rudder
    ^-  (unit place:rudder)
    ?^  point=((point:rudder /[dap.bowl] & ~(key by web)) trail)
      point
    =/  site=(list @t)  site.trail
    =/  pat=(unit (pole knot))  (decap:rudder /wiki site)
    ?~  pat  ~
    |^  ?+  u.pat               sans-fas
          [sig %new ~]          `[%page auth %new-book]
          [bid=@ta ~]           `[%page auth %book]
          [bid=@ta sig %new ~]  `[%page auth %new-page]
          [bid=@ta pid=@ta ~]   `[%page auth %page]
        ==
    ::
    +$  sig  %~.~
    ::
    ++  auth
      ^-  ?
      =/  book-id=@ta  -.u.pat
      ?~  book=(~(get by books) book-id)  &
      !public-read.rules.u.book
    ::
    ++  sans-fas :: trim leading / or 404
      ^-  (unit place:rudder)
      ?.  ?=([%$ *] (flop u.pat))  ~
      `[%away (snip site)]
    --
  --
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
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
  ?:  =(~.~ id)  ~|("Invalid wiki ID" !!)
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
  |=  [%new-page book-id=@ta id=@ta title=@t content=tape]
  =/  =book  (~(got by books) book-id)
  ?:  (~(has by pages.book) id)  ~|("Page {<id>} already exists!" !!)
  =.  pages.book  (~(put by pages.book) id [title content])
  =.  books  (~(put by books) [book-id book])
  [~ state]
::
--