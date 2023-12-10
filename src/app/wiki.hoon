/-  *wiki
/+  dbug, default-agent, regex, rudder, string, verb
/+  *wiki, web=wiki-web, wiki-http
/~  libs  *  /lib/wiki  :: build all wiki libs
/~  mars  *  /mar       :: build all marks
::
::  types core
::
|%
::
+$  card  card:agent:gall
::
--
::
::  state
::
=|  state-1
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
    http     ~(. wiki-http state)
    main     ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state
    =|  state=state-1
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
    ^-  (quip card state-1)
    =|  cards=(list card)
    |-
    |^  ?-  -.old
          %1  [cards old]
          %0  $(old (state-0-to-1 old))
        ==
    ::
    ++  state-0-to-1
      |=  =state-0
      ^-  state-1
      |^  [%1 (~(run by books.state-0) grad-book)]
      ::
      ++  grad-book
        |=  =book-0
        ^-  book
        %=  book-0
          tales  (~(run by tales.book-0) grad-tale)
          rules  (grad-rules rules.book-0)
        ==
      ::
      ++  grad-tale
        |=  =tale-0
        ^-  tale
        (~(run by tale-0) grad-page)
      ::
      ++  grad-page
        |=  =page-0
        ^-  page
        %=  page-0
          content  [content.page-0 our.bowl]
        ==
      ::
      ++  grad-rules
        |=  =access-0
        ^-  access
        [public-read.access-0 [%.n %.n]]
      --
    ::
    --
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
    ?-  -.act
      %new-book       (new-book:main act)
      %mod-book-name  (mod-book-name:main act)
      %mod-rule-read  (mod-rule-read:main act)
      %mod-rule-edit  (mod-rule-edit:main act)
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
    |^  =/  out=(quip card _state)
          (serve [bowl order state])
        [-.out this(state +.out)]
    ::
    ++  serve
      %-  (steer:rudder _state action)
      :^    web:http            :: pages
          http-route:http       :: route
        (fours:rudder state)    :: adlib
      |=  act=action            :: solve
      ^-  $@(brief:rudder [brief:rudder (list card) _state])
      =^  cards  this
        (on-poke %wiki-action !>(act))
      ['Successfully processed' cards state]
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
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %new-book"  !!
  ?:  |(=(~.~ id) !((sane %ta) id))
    ~|("Invalid wiki ID" !!)
  ?:  (~(has by books) id)  ~|("Wiki '{(trip id)}' already exists!" !!)
  ?:  (is-space:string (trip title))  ~|("Wiki title must not be blank" !!)
  ?:  &(!public-read.rules public.edit.rules)
    ~|("Cannot enable public edits on private wiki." !!)
  =.  books  (~(put by books) [id [title ~ rules]])
  [~ state]
::
++  del-book
  |=  [%del-book id=@ta]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %del-book"  !!
  =.  books  (~(del by books) id)
  [~ state]
::
++  mod-book-name
  |=  [%mod-book-name id=@ta title=@t]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %mod-book-name"  !!
  =/  =book  (~(got by books) id)
  ?:  (is-space:string (trip title))  ~|("Wiki title must not be blank" !!)
  =.  title.book  title
  =.  books  (~(put by books) id book)
  [~ state]
::
++  mod-rule-read
  |=  [%mod-rule-read id=@ta public-read=?]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %mod-rule-read"  !!
  =/  =book  (~(got by books) id)
  =.  public-read.rules.book  public-read
  =.  edit.rules.book         ?.  public-read  [%.n %.n] :: disable public edit
                              edit.rules.book
  =.  books  (~(put by books) id book)
  [~ state]
::
++  mod-rule-edit
  |=  [%mod-rule-edit id=@ta =rule-edit]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %mod-rule-edit"  !!
  =/  =book  (~(got by books) id)
  ?:  &(!public-read.rules.book public.rule-edit)
    ~|  "Cannot enable public edits on private wiki. Enable public-read first"
    !!
  =.  edit.rules.book  rule-edit
  =.  books  (~(put by books) id book)
  [~ state]
::
++  new-page
  |=  [%new-page book-id=@ta =path title=@t content=wain]
  ?:  =(~ path)  ~|('Path cannot be blank!' !!)
  ?^  (find "~" path)  ~|('Path cannot contain "/~/"' !!)
  ?.  (levy path (sane %ta))  ~|('Invalid path!' !!)
  =/  =book  (~(got by books) book-id)
  ?.  (may-edit bowl book)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %new-page"  !!
  ?:  (~(has by tales.book) path)  ~|("Page {<path>} already exists!" !!)
  ?:  =('' title)  ~|("Title cannot be blank!" !!)
  =/  =page  [title content src.bowl]
  =/  =tale  (gas:ton *tale [now.bowl page]~)
  =.  tales.book  (~(put by tales.book) path tale)
  =.  books  (~(put by books) book-id book)
  ~&  "Wiki page created: {(trip book-id)}{<path>}"
  [~ state]
::
++  del-page
  |=  [%del-page book-id=@ta =path]
  ?.  =(src.bowl our.bowl)
      ~&  >>>  "Unauthorized poke from {<src.bowl>}: %del-page"  !!
  =/  =book       (~(got by books) book-id)
  =.  tales.book  (~(del by tales.book) path)
  =.  books       (~(put by books) book-id book)
  ~&  "Wiki page deleted: {(trip book-id)}{<path>}"
  [~ state]
::
++  mod-page
  |=  [%mod-page book-id=@ta =path title=(unit @t) content=(unit wain)]
  =/  =book  (~(got by books) book-id)
  ?.  (may-edit bowl book)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %mod-page"  !!
  =/  =tale  (~(got by tales.book) path)
  =/  =page  page:(latest tale)
  ?:  ?~(title | =('' u.title))  ~|("Title cannot be blank!" !!)
  ?:  ?&  ?~(content & =(content.page u.content))
          ?~(title & =(title.page u.title))
      ==
    [~ state]
  =.  title.page    (fall title title.page)
  =.  content.page  (fall content content.page)
  =.  edit-by.page  src.bowl
  =.  tale          (put:ton tale now.bowl page)
  =.  tales.book  (~(put by tales.book) path tale)
  =.  books       (~(put by books) book-id book)
  ~&  "Wiki page edited: {(trip book-id)}{<path>}"
  [~ state]
::
++  imp-file
  |=  [%imp-file book-id=@ta files=(map @t wain) =title-source]
  =/  =book  (~(got by books) book-id)
  ?.  (may-edit bowl book)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %imp-file"  !!
  :_  state
  %+  turn  ~(tap by files)
  |=  [filepath=@t data=wain]
  =/  [=path filename=tape]  (parse-filepath:web filepath)
  =/  [title=@t content=wain]
    %+  fall
      ?-  title-source
        %filename  `[(title-from-filename filename) data]
        %header    (title-from-header data)
        %front-matter  (title-from-front-matter data)
      ==
    [(title-from-filename filename) data]
  %-  poke-self
  ?:  (~(has by tales.book) path)
    [%mod-page book-id path `title `content]
  [%new-page book-id path title content]
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
  |=  filename=tape
  ^-  @t
  %-  crip
  %-  title:string
  %-  strip:string
  %-  remove-extension:web
  (gsub:regex "[_\\+]" " " filename)
::
++  title-from-front-matter
  |=  md=wain
  ^-  (unit [title=@t content=wain])
  =/  toml-loc=(list @)  (fand ~['+++'] md)
  ?.  &((gte (lent toml-loc) 2) =(0 -.toml-loc))  ~
  =/  toml=wain  (scag +((snag 1 toml-loc)) md)
  =/  lines=(list @t)
    %+  skim  toml
    |=  t=@t
    (starts-with:string (trip t) "title = ")
  ?:  =(~ lines)  ~
  =/  line=@t  (snag 0 lines)
  =/  title=@t  (crip (gsub:regex "(^\")|(\"$)" "" (slag 8 (trip line))))
  =/  content=wain  (slag (add 2 (snag 1 toml-loc)) md)
  `[title content]
::
++  poke-self
  |=  =action
  ^-  card
  [%pass [-.action ~] %agent [our.bowl %wiki] %poke %wiki-action !>(action)]
::
--