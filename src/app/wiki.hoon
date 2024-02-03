/-  *wiki
/+  dbug, default-agent, gossip, regex, rudder, server, string, verb
/+  *wiki, web=wiki-web, wiki-http
/~  libs  *  /lib/wiki  :: build all wiki libs
/~  mars  *  /mar       :: build all marks
/$  html-to-mime  %html  %mime
/$  noun-to-lore  %noun  %wiki-lore
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
=|  state-2
=*  state  -
::
::  debugging tools
::
%+  verb  |
%-  %+  agent:gossip  [3 %anybody %anybody &]
    %+  ~(put by *(map mark $-(* vase)))
      %wiki-lore
    |=(=noun !>((noun-to-lore noun)))
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
    serv     ~(. wiki-http [state ~])
    main     ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state
    =|  state=state-2
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
    ^-  (quip card state-2)
    =|  cards=(list card)
    |-
    |^  ?-  -.old
          %2  [cards old]
          %1  $(old (state-1-to-2 old), cards (cards-1-to-2 old))
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
    ++  state-1-to-2
      |=  =state-1
      ^-  state-2
      [%2 ~ +.state-1]
    ::
    ++  cards-1-to-2
      |=  =state-1
      ^-  (list card)
      ~ :: todo: grow all pages in public wikis
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
    |^  ?:  is-remote  handle-http-remote
        (paddle [bowl order [state ~]])
    ::
    ++  is-remote
      =/  [site=(pole knot) *]  (sane-url:web url.request.order)
      ?.  ?=([%wiki %~.~ %p who=@ta *] site)  |
      ?~  who=(slaw %p who.site)  |
      ?!(=(u.who our.bowl))
    ::
    ++  paddle
      |=  input=[bowl:gall order:rudder rudyard]
      ^-  (quip card _this)
      =/  out=(quip card rudyard)  (serve input)
      out(+ this(state -.+.out))
    ::
    ++  serve :: consolidate in main core
      %-  (steer:rudder rudyard action)
      :^    web:serv             :: pages
          http-route:serv        :: route
        (fours:rudder [state ~]) :: adlib
      |=  act=action             :: solve
      ^-  $@(brief:rudder [brief:rudder (list card) rudyard])
      =^  cards  this
        (on-poke %wiki-action !>(act))
      ['Successfully processed' cards [state ~]]
    ::
    ++  handle-http-remote
      ^-  (quip card _this)
      =/  [site=(pole knot) *]  (sane-url:web url.request.order)
      ?>  ?=([%wiki %~.~ %p who=@ta book-id=@ta page-path=*] site)
      =/  =ship  (slav %p who.site)
      =/  book-id=@ta     book-id.site
      =/  page-path=path
        ?:  =('~' -.page-path.site)  ~
        (path-before-sig page-path.site)
      =/  mark=path
        ?~  page-path  /spine-0 :: todo: figure out this spine scry stuff
        /booklet-0
      =/  ver=@t          (get-case ship book-id page-path)
      =/  base=path  /g/x/[ver]/wiki/$
      =/  loc=path  :(weld base mark /[book-id] page-path)
      =/  =task:ames  [%keen ship loc]
      =/  =note-arvo  [%a task]
      =/  req-id=@ta  id.order
      :_  this
      ~&  "scrying {<ship>} {<loc>}"
      =/  =wire  /remote/[req-id]
      [%pass wire %arvo note-arvo]~
    ::
    ++  path-before-sig
      |=  full=path
      ^-  path
      =/  i=(unit @)  (find ~[%~.~] full)
      ?~  i  full
      (scag u.i full)
    ::
    ++  get-case
      |=  [=ship book-id=@ta =path]
      ^-  @t
      =/  ruf=(unit ref)
        %+  biff  (~(get by shelf) [ship book-id])
        |=  =spine
        (~(get by toc.spine) path)
      ?~  ruf  (crip <now.bowl>)  :: todo: better way of serializing @da
      (crip <ver.u.ruf>)
    --
  --
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:default path)
    [%http-response *]        [~ this]
    [%~.~ %gossip %source ~]  [rant:goss:main this]
  ==
::
++  on-leave  on-leave:default
++  on-peek   on-peek:default
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  |^  ?+  -.sign  (on-agent:default wire sign)
        %fact   =^  cards  state
                  (handle-fact cage.sign)
                [cards this]
      ==
  ::
  ++  handle-fact
    |=  =cage
    ^-  (quip card _state)
    ?+  wire  ~|  "Unknown wire {<wire>}"  !!
      [%~.~ %gossip %gossip ~]  (read:goss:main !<(lore q.cage))
    ==
  --
::
++  on-arvo
  |=  [wire=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?+  sign-arvo  (on-arvo:default wire sign-arvo)
  ::
      [%eyre %bound *]
    ~?  !accepted.sign-arvo
      [dap.bowl 'eyre bind rejected!' binding.sign-arvo]
    [~ this]
  ::
      [%ames %tune *]
    ?.  ?=([%remote eyre-id=@ta ~] wire)  [~ this]
    |^  ?~  roar.sign-arvo  [error-404 this] :: todo: maybe wrap all this in mole -> error response?
        =/  [=path data=(unit (cask))]  dat.u.roar.sign-arvo
        ?~  data            [error-404 this]
        ?>  ?=(%wiki-booklet-0 p.u.data) :: todo: error response about incompatible data format
        =/  =booklet  ;;(booklet q.u.data)
        =/  req=inbound-request:eyre  (eyre-request:main eyre-id.wire)
        =/  =order:rudder  [eyre-id.wire req]
        =/  out=(quip card rudyard)  (serve [bowl order [state `booklet]])
        [-.out this(state -.+.out)]
    ::
    ++  error-404
      %+  give-simple-payload:app:server  eyre-id.wire
      ^-  simple-payload:http
      =/  html=@t  '<html><body>Remote page not found!</body></html>'
      [[404 ['content-type' 'text/html']~] `(tail (html-to-mime html))]
    ::
    ++  serve :: consolidate in main core
      %-  (steer:rudder rudyard action)
      :^    web:serv             :: pages
          http-route:serv        :: route
        (fours:rudder [state ~]) :: adlib
      |=  act=action             :: solve
      ^-  $@(brief:rudder [brief:rudder (list card) rudyard])
      =^  cards  this
        (on-poke %wiki-action !>(act))
      ['Successfully processed' cards [state ~]]
    --
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
  :_  state
  ?:  public-read  ~
  (book:cull id)
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
  ~&  >  "Wiki page created: {(trip book-id)}{<path>}"
  :_  state
  ?.  public-read.rules.book  ~
  ~[(booklet-0:grow book-id book path tale)]
::
++  del-page
  |=  [%del-page book-id=@ta =path]
  ?.  =(src.bowl our.bowl)
      ~&  >>>  "Unauthorized poke from {<src.bowl>}: %del-page"  !!
  =/  =book       (~(got by books) book-id)
  =.  tales.book  (~(del by tales.book) path)
  =.  books       (~(put by books) book-id book)
  ~&  >>>  "Wiki page deleted: {(trip book-id)}{<path>}"
  :_  state
  (booklet:cull book-id path)
::
++  mod-page
  |=  [%mod-page host=(unit @p) book-id=@ta =path title=(unit @t) content=(unit wain)]
  ?^  host
    [[(poke-them u.host [%mod-page ~ book-id path title content])]~ state]
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
  ~&  >>  "Wiki page edited: {(trip book-id)}{<path>}"
  :_  state
  ?.  public-read.rules.book  ~
  :~  (booklet-0:grow book-id book path tale)
      (tell:goss book-id book)
  ==
::
++  imp-file
  |=  [%imp-file book-id=@ta files=(map @t wain) =title-source del-missing=?]
  =/  =book  (~(got by books) book-id)
  ?.  (may-edit bowl book)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %imp-file"  !!
  ~&  "importing {<~(wyt by files)>} files..."
  :_  state
  =/  parsed=(list [data=wain =path filename=tape])
    %+  turn  ~(tap by files)
    |=  [filepath=@t data=wain]
    [data (parse-filepath:web filepath)]
  %+  weld  ?:(del-missing (delete-missing book-id parsed) ~)
  %+  turn  parsed
  |=  [data=wain =path filename=tape]
  ?<  =(~ path)
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
    [%mod-page ~ book-id path `title `content]
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
  |^  (hunt |=(^ &) title-from-yaml title-from-toml)
  ::
  ++  title-from-yaml  (parse-frontmatter '---' "title: ")
  ::
  ++  title-from-toml  (parse-frontmatter '+++' "title = ")
  ::
  ++  parse-frontmatter
    |=  [delineator=@t title-marker=tape]
    ^-  (unit [title=@t content=wain])
    =/  mat-loc=(list @)  (fand ~[delineator] md)
    ?.  &((gte (lent mat-loc) 2) =(0 -.mat-loc))  ~
    =/  toml=wain  (scag +((snag 1 mat-loc)) md)
    =/  lines=(list @t)
      %+  skim  toml
      |=  t=@t
      (starts-with:string (trip t) title-marker)
    ?:  =(~ lines)  ~
    =/  line=@t  (snag 0 lines)
    =/  raw-title=tape  (slag (lent title-marker) (trip line))
    =/  title=@t  (crip (gsub:regex "(^\")|(\"$)" "" raw-title))
    =/  content=wain  (slag (add 1 (snag 1 mat-loc)) md)
    ?:  =('' -.content)  `[title +.content]
    `[title content]
  --
::
++  delete-missing
  |=  [book-id=@ta imported=(list [* path *])]
  ^-  (list card)
  ?.  =(our.bowl src.bowl)
    ~&  >>>  "Unauthorized delete request from {<src.bowl>}"  !!
  =/  =book  (~(got by books) book-id)
  =/  new-paths=(set path)  (silt (turn imported |=([* =path *] path)))
  %+  murn  ~(tap in ~(key by tales.book))
  |=  old-path=path
  ?:  (~(has in new-paths) old-path)  ~
  `(poke-self [%del-page book-id old-path])
::
++  poke-self
  |=  =action
  ^-  card
  [%pass [-.action ~] %agent [our.bowl %wiki] %poke %wiki-action !>(action)]
::
++  poke-them
  |=  [=ship =action]
  ^-  card
  [%pass [-.action ~] %agent [ship %wiki] %poke %wiki-action !>(action)]
::
++  grow
  |%
  ++  booklet-0
    |=  [book-id=@ta =book tale-path=path =tale]
    ^-  card
    =/  =wire  /wiki/booklet
    =/  loc=path  (weld /booklet-0/[book-id] tale-path)
    =/  =booklet  [[book-id title.book rules.book] tale-path tale]
    [%pass wire %grow loc %wiki-booklet-0 booklet]
  --
::
++  cull :: todo: tomb instead?
  |%
  ++  cull
    |=  targ=path
    =/  base=path  ~+  /(scot %p our.bowl)/wiki/(scot %da now.bowl)/$
    =/  ver=case  .^(case %gw (weld base targ))
    [%pass (weld /wiki/cull targ) %cull ver targ]
  ::
  ++  book
    |=  book-id=@ta
    ^-  (list card)
    =/  base=path  /(scot %p our.bowl)/wiki/(scot %da now.bowl)/$
    =/  gt=path  (weld base /booklet-0/[book-id])
    =/  paths=(list path)  .^((list path) %gt gt)
    (turn paths cull)
  ::
  ++  booklet
    |=  [book-id=@ta page-path=path]
    ^-  (list card)
    =/  base=path  /(scot %p our.bowl)/wiki/(scot %da now.bowl)/$
    =/  targ=path  (weld /booklet-0/[book-id] page-path)
    =/  full=path  (weld base targ)
    =/  paths=(list path)
      %+  skim  .^((list path) %gt (snip full))
      |=(=path =(path targ))
    (turn paths cull)
  --
::
++  eyre-request  :: todo: move to lib
  |=  eyre-id=@ta
  ^-  inbound-request:eyre
  |^  inbound-request:(~(got by connections) eyre-id)
  ::
  ++  connections
    ^-  (map @ta outstanding-connection:eyre)
    =/  scry-path=path  /(scot %p our.bowl)/connections/(scot %da now.bowl)
    =/  raw  .^((map duct outstanding-connection:eyre) %e scry-path)
    %-  my
    %+  murn  ~(tap by raw)
    |=  [=duct con=outstanding-connection:eyre]
    ^-  (unit (pair @ta outstanding-connection:eyre))
    `[(duct-to-eyre-id duct) con]
  ::
  ++  duct-to-eyre-id
    |=  =duct
    (scot %ta (cat 3 'eyre_' (scot %uv (sham duct))))
  --
::
++  goss
  |%
  ::
  ++  tell
    |=  [id=@ta =book]
    ^-  card
    =/  =lore  (malt [[our.bowl id] (to-spine id book)]~)
    [(invent:gossip %wiki-lore !>(lore))]
  ::
  ++  rant
    ^-  (list card)
    =;  =lore  [(invent:gossip %wiki-lore !>(lore))]~
    %-  my
    %+  murn  ~(tap by books)
    |=  [id=@ta =book]
    ^-  (unit (pair [@p @ta] spine))
    ?.  public-read.rules.book  ~
    (some [[our.bowl id] (to-spine id book)])
  ::
  ++  read
    |=  =lore
    ^-  (quip card _state)
    :: ~&  >>  lore
    =.  shelf
      %-  (~(uno by shelf) lore)
      |=  [k=[@p @ta] v=spine w=spine]
      ?:  (gte as-of.v as-of.w)  v
      ~&  '%wiki: received rumor, updating index...'
      w
    [~ state]
  --
::
++  to-spine
  |=  [id=@ta =book]
  ^-  spine
  =/  =cover  [id title.book rules.book]
  =/  toc=(map path ref)
    %-  ~(run by tales.book)
    |=  =tale
    =/  [time=@da =page]  (latest tale)
    =/  ver=@  (dec (wyt:ton tale))
    [ver time title.page]
  [cover toc now.bowl]
::
--