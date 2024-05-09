/-  *wiki
/+  dbug, default-agent, gossip, regex, rudder, server, string, verb
/+  *wiki, *wiki-grad, *wiki-morf, web=wiki-web, wiki-http
/~  libs  *  /lib/wiki  :: build all wiki libs
/~  mars  *  /mar       :: build all marks
/$  html-to-mime  %html  %mime
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
=|  state-x
=*  state  -
::
::  debugging tools
::
%+  verb  |
::
%-  %+  agent:gossip  [3 %anybody %anybody &]
    %-  ~(gas by *(map mark $-(* vase)))
    :~  [%wiki-lore |=(=noun !>((lore-0-to-1:grad-4 (lore-0 noun))))]
        [%wiki-lore-1 |=(=noun !>((lore-1 noun)))]
    ==
::
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
    serv     ~(. wiki-http [state ~ ~])
    main     ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  =^  cards  state
    =|  state=state-x
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
    ^-  (quip card state-x)
    =|  cards=(list card)
    |-
    ?-  -.old
      %4  [cards old]
      %3  $(old (state:grad-4 old), cards (cards:grad-4 old bowl))
      %2  $(old (state:grad-3 old))
      %1  $(old (state:grad-2 old))
      %0  $(old (state:grad-1 old bowl))
    ==
  --
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^  ?+  mark  (on-poke:default mark vase)
      ::
          %wiki-action
        (handle-action !<(action vase))
      ::
          %wiki-relay
        (handle-relay !<(relay vase))
      ::
          %handle-http-request
        (handle-http !<(order:rudder vase))
      ::
      ==
  ::
  ++  handle-action
    |=  act=action
    ^-  (quip card _this)
    =;  quik
      =^  cards  state  quik
      [cards this]
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
  ++  handle-relay
    |=  [%relay to=@p eyre-id=@ta =action]
    ^-  (quip card _this)
    ?:  =(to our.bowl)  (handle-action action)
    ~&  "form submitted for remote wiki, waiting for result of poke to {<to>}"
    =^  cards  state
      :-  ~[(poke-them to action eyre-id)]
      =/  =wait  [now.bowl ~ | ~]
      =.  later  (~(put by later) eyre-id wait)
      state
    [cards this]
  ::
  ++  handle-http
    |=  =order:rudder
    ^-  (quip card _this)
    |^  ?:  is-later   handle-later
        ?:  is-remote  handle-http-remote
        (paddle [bowl order [state ~ ~]])
    ::
    :: if ?after= and pending request in `later`, use `handle-later` to await poke-ack
    :: if ?after= but not pending, process normally (URL is probably being reused)
    ::
    ++  is-later
      =/  query=(map @t @t)  query:(sane-url:web url.request.order)
      ?~  after-eyre-id=(~(get by query) 'after')  |
      (~(has by later) u.after-eyre-id)
    ::
    ++  is-remote
      =/  [site=(pole knot) query=(map @t @t)]  (sane-url:web url.request.order)
      ?.  ?=([%wiki %~.~ %p who=@ta loc=*] site)  |
      ?~  who=(slaw %p who.site)  |
      ?:  =(u.who our.bowl)  |
      ?:  (~(has by query) 'fresh')  &
      ?+  loc.site  &
        :: loading main page for shelved book does not need remote scry
        [book-id=@ta ~]  ?!((~(has by shelf) [u.who book-id.loc.site]))
        :: searching in shelved book does not need remote scry
        [book-id=@ta %~.~ %search ~]  ?!((~(has by shelf) [u.who book-id.loc.site]))
      ==
    ::
    ++  paddle
      |=  input=[bowl:gall order:rudder rudyard]
      ^-  (quip card _this)
      =/  out=(quip card rudyard)  (serve input)
      out(+ this(state -.+.out))
    ::
    ++  serve :: consolidate in main core
      %-  (steer:rudder rudyard relay)
      :^    web:serv               :: pages
          http-route:serv          :: route
        (fours:rudder [state ~ ~]) :: adlib
      |=  =relay                   :: solve
      ^-  $@(brief:rudder [brief:rudder (list card) rudyard])
      =^  cards  this
        (on-poke %wiki-relay !>(relay))
      ['Successfully processed' cards [state ~ ~]]
    ::
    ++  handle-later
      ^-  (quip card _this)
      =/  [site=(pole knot) query=(map @t @t)]  (sane-url:web url.request.order)
      =/  last-eyre-id=@ta  (~(got by query) 'after')
      ~&  "requesting result of poke from request {<last-eyre-id>}"
      =/  await=(unit wait)  (~(get by later) last-eyre-id)
      ?~  await
        ~&  >>>  "something went wrong, pending request not in `later`"
        `this
      ?.  done.u.await
        :: poke-ack not received yet, wait and respond in on-agent > handle-poke-ack
        =.  later  (~(put by later) last-eyre-id u.await(pending-eyre-id `id.order))
        [~ this]
      :: poke-ack already received, respond immediately
      =.  later  (~(del by later) last-eyre-id)
      [(relay-response:main order error.u.await this) this]
    ::
    ++  handle-http-remote
      ^-  (quip card _this)
      =/  [site=(pole knot) query=(map @t @t)]  (sane-url:web url.request.order)
      ?>  ?=([%wiki %~.~ %p who=@ta book-id=@ta page-path=*] site)
      =/  =ship  (slav %p who.site)
      =/  book-id=@ta     book-id.site
      =/  page-path=path
        ?:  =(~ page-path.site)      ~
        ?:  =('~' -.page-path.site)  ~
        (path-before-sig page-path.site)
      :: =/  old=?  (is-old ship book-id)
      :: =/  resource=path
      ::   ?~  page-path  ?:(old /spine-0 /spine)
      ::   ?:(old /booklet-0 /booklet)
      =/  resource=path
        ?~  page-path  /spine
        /booklet
      =/  ver=@t  (get-case ship book-id page-path query)
      =/  base=path  /g/x/[ver]/wiki/$/1
      =/  loc=path  :(weld base resource /[book-id] page-path)
      =/  sec=(unit [idx=@ key=@])  ~
      =/  =task:ames  [%keen sec ship loc]
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
    :: ++  is-old
    ::   |=  [=ship book-id=@ta]
    ::   ^-  path
    ::   =/  spine=(unit spine)  (~(get by shelf) ship book-id)
    ::   ?~  |
    ::   =(~ front.cover.u.spine)
    ::
    ++  get-case
      |=  [=ship book-id=@ta =path query=(map @t @t)]
      ^-  @t
      =/  time=(unit @da)
        ?:  (~(has by query) 'fresh')  ~
        :: Ideally this would get the last time a page was edited,
        :: but since the booklet-1 contains data about the book itself,
        :: that data may have changed.
        :: Unfortunately this makes page scries load from cache less often
        :: todo: Maybe split into 2-step scry to get cover @ stamp then page data @edited-at
        %+  biff  (~(get by shelf) [ship book-id])
        |=  =spine
        `stamp.cover.spine
      (crip <(fall time now.bowl)>)
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
        %fact       =^  cards  state
                      (handle-fact cage.sign)
                    [cards this]
      ::
        %poke-ack   =^  cards  state
                      (handle-poke-ack p.sign)
                    [cards this]
      ==
  ::
  ++  handle-fact
    |=  =cage
    ^-  (quip card _state)
    ?+  wire  ~|  "Unknown wire {<wire>}"  !!
      [%~.~ %gossip %gossip ~]  (read:goss:main cage)
    ==
  ::
  ::  A poke to another ship may contain the eyre-id of a form submission in its path.
  ::  If any subsequent request is waiting for the poke's result, respond here.
  ::
  ++  handle-poke-ack
    |=  error=(unit tang)
    ^-  (quip card _state)
    =/  post-eyre-id=@ta  -.wire
    =/  await=(unit wait)  (~(get by later) post-eyre-id)
    ?~  await  `state
    ?~  pending-eyre-id.u.await
      :: poke-ack received early, result not yet requested, save for later
      :: respond in on-poke > handle-http > handle-later
      =.  later  (~(put by later) post-eyre-id u.await(done &, error error))
      `state
    =/  inbound=(unit inbound-request:eyre)  (eyre-request:serv bowl u.pending-eyre-id.u.await)
    ?~  inbound
      ~&  "poke-ack received but no pending request found with ID: {<pending-eyre-id.u.await>}"
      `state
    =.  later  (~(del by later) post-eyre-id)
    =/  =order:rudder  [u.pending-eyre-id.u.await u.inbound]
    [(relay-response:main order error this) state]
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
    |^  (handle-errors |.(on-remote-scry-response))
    ::
    ++  handle-errors
      |*  =(trap (quip card _this))
      =/  res=(each (quip card _this) (list tank))  (mule trap)
      ?-  -.res
        %&  p.res
        %|  ((slog p.res) [error-unknown this])
      ==
    ::
    ++  on-remote-scry-response
      ?~  roar.sign-arvo  [error-404 this]
      =/  [=path data=(unit (cask))]  dat.u.roar.sign-arvo
      ?~  data            [error-404 this]
      =/  rud=rudyard
        ?+  p.u.data  ~|("Unknown mark {<p.u.data>}" !!)
        ::
          %wiki-booklet-0  [state ~ `(booklet-0-to-1:grad-4 ;;(booklet-0 q.u.data))]
        ::
          %wiki-spine-0    [state `(spine-0-to-1:grad-4 ;;(spine-0 q.u.data)) ~]
        ::
          %wiki-booklet-1  [state ~ `(booklet-1 q.u.data)]
        ::
          %wiki-spine-1    [state `(spine-1 q.u.data) ~]
        ==
      =/  req=(unit inbound-request:eyre)  (eyre-request:serv bowl eyre-id.wire)
      ?~  req  ~|('Remote scry data received but eyre request not found' !!)
      =/  =order:rudder  [eyre-id.wire u.req]
      =/  out=(quip card rudyard)  (serve [bowl order rud])
      [-.out this(state -.+.out)]
    ::
    ++  error-404
      %+  give-simple-payload:app:server  eyre-id.wire
      ^-  simple-payload:http
      =/  html=@t  '<html><body>Remote page not found!</body></html>'
      [[404 ['content-type' 'text/html']~] `(tail (html-to-mime html))]
    ::
    ++  error-unknown
      %+  give-simple-payload:app:server  eyre-id.wire
      ^-  simple-payload:http
      =/  html=@t  '<html><body>Error handling remote data!</body></html>'
      [[500 ['content-type' 'text/html']~] `(tail (html-to-mime html))]
    ::
    ++  serve :: consolidate in main core
      %-  (steer:rudder rudyard relay)
      :^    web:serv               :: pages
          http-route:serv          :: route
        (fours:rudder [state ~ ~]) :: adlib
      |=  =relay                   :: solve
      ^-  $@(brief:rudder [brief:rudder (list card) rudyard])
      =^  cards  this
        (on-poke %wiki-relay !>(relay))
      ['Successfully processed' cards [state ~ ~]]
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
  ?:  &(!public.read.rules public.edit.rules)
    ~|("Cannot enable public edits on private wiki." !!)
  =/  =book  [~ title ~ rules now.bowl]
  =.  books  (~(put by books) id book)
  :_  state
  %-  (walt card)
  :~  [scry.read.rules |.((full:grow id book))]
      [goss.read.rules |.([(tell:goss id book) ~])]
  ==
::
++  del-book
  |=  [%del-book id=@ta]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %del-book"  !!
  =/  =book  (~(got by books) id)
  =.  books  (~(del by books) id)
  :_  state
  =/  r  read.rules.book
  %-  (walt card)
  :~  [scry.r |.((full:tomb id))]
      [goss.r |.([(hush:goss id) ~])]
  ==
::
++  mod-book-name
  |=  [%mod-book-name id=@ta title=@t]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %mod-book-name"  !!
  =/  =book  (~(got by books) id)
  ?:  (is-space:string (trip title))  ~|("Wiki title must not be blank" !!)
  =.  title.book  title
  =.  stamp.book  now.bowl
  =.  books  (~(put by books) id book)
  :_  state
  =/  r  read.rules.book
  %-  (walt card)
  :~  [scry.r |.([(back:grow id book) ~])]
      [goss.r |.([(tell:goss id book) ~])]
  ==
::
++  mod-rule-read
  |=  [%mod-rule-read id=@ta read=rule-read]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %mod-rule-read"  !!
  ?:  &(!public.read urth.read)  ~|('Private wikis do not support eauth (clearweb)' !!)
  ?:  &(!public.read scry.read)  ~|('Private wikis do not support remote scry' !!)
  ?:  &(!public.read goss.read)  ~|('Private wikis do not support gossip (global index)' !!)
  ?:  &(!scry.read goss.read)    ~|('Cannot gossip index if wiki not accessible via remote scry' !!)
  ?:  &(public.read ?!(|(urth.read scry.read)))  ~|('Public wikis must be visible via web and/or Urbit' !!)
  =/  =book  (~(got by books) id)
  =/  en-scry=?  &(!scry.read.rules.book scry.read)
  =/  un-scry=?  &(scry.read.rules.book !scry.read)
  =/  en-goss=?  &(!goss.read.rules.book goss.read)
  =/  un-goss=?  &(goss.read.rules.book !goss.read)
  =.  read.rules.book   read
  =.  edit.rules.book   ?.  public.read  [%.n %.n] :: disable public edit
                        edit.rules.book
  =.  stamp.book  now.bowl
  =.  books  (~(put by books) id book)
  :_  state
  %-  (walt card)
  :~  [en-scry |.((full:grow id book))]
      [un-scry |.((full:tomb id))]
      [en-goss |.([(tell:goss id book) ~])]
      [un-goss |.([(hush:goss id) ~])]
  ==
::
++  mod-rule-edit
  |=  [%mod-rule-edit id=@ta =rule-edit]
  ?.  =(src.bowl our.bowl)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %mod-rule-edit"  !!
  =/  =book  (~(got by books) id)
  ?:  &(!public.read.rules.book public.rule-edit)
    ~|  "Cannot enable public edits on private wiki. Enable public-read first"
    !!
  =.  edit.rules.book  rule-edit
  =.  stamp.book  now.bowl
  =.  books  (~(put by books) id book)
  :_  state
  =/  r  read.rules.book
  %-  (walt card)
  :~  [scry.r |.((full:grow id book))]
      [goss.r |.([(tell:goss id book) ~])]
  ==
::
++  new-page
  |=  [%new-page book-id=@ta =path title=@t content=wain]
  ?:  =(~ path)  ~|('Path cannot be blank!' !!)
  ?^  (find "~" path)  ~|('Path cannot contain "/~/"' !!)
  ?.  (levy path (sane %ta))  ~|('Invalid path!' !!)
  =/  =book  (~(got by books) book-id)
  ?.  (may-edit bowl ~ rules.book)
    ~&  >>>  "Unauthorized poke from {<src.bowl>}: %new-page"
    ~|("Unauthorized" !!)
  ?:  (~(has by tales.book) path)  ~|("Page {<path>} already exists!" !!)
  ?:  =('' title)  ~|("Title cannot be blank!" !!)
  =/  =page  [title content src.bowl]
  =/  =tale  (gas:ton *tale [now.bowl page]~)
  =.  tales.book  (~(put by tales.book) path tale)
  =.  stamp.book  now.bowl
  =.  books  (~(put by books) book-id book)
  ~&  >  "Wiki page created: {(trip book-id)}{<path>}"
  :_  state
  =/  r  read.rules.book
  %-  (walt card)
  :~  [scry.r |.([(part:grow book-id book path tale) ~])]
      [scry.r |.([(back:grow book-id book) ~])]
      [goss.r |.([(tell:goss book-id book) ~])]
  ==
::
++  del-page
  |=  [%del-page book-id=@ta =path]
  ?.  =(src.bowl our.bowl)
      ~&  >>>  "Unauthorized poke from {<src.bowl>}: %del-page"  !!
  =/  =book       (~(got by books) book-id)
  =.  tales.book  (~(del by tales.book) path)
  =.  stamp.book  now.bowl
  =.  books       (~(put by books) book-id book)
  ~&  >>>  "Wiki page deleted: {(trip book-id)}{<path>}"
  :_  state
  =/  r  read.rules.book
  %-  (walt card)
  :~  [scry.r |.((part:tomb book-id path))]
      [scry.r |.([(back:grow book-id book) ~])]
      [goss.r |.([(tell:goss book-id book) ~])]
  ==
::
++  mod-page
  |=  [%mod-page book-id=@ta =path title=(unit @t) content=(unit wain)]
  =/  =book  (~(got by books) book-id)
  ?.  (may-edit bowl ~ rules.book)
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
  =.  stamp.book  now.bowl
  =.  books       (~(put by books) book-id book)
  ~&  >>  "Wiki page edited: {(trip book-id)}{<path>}"
  :_  state
  =/  r  read.rules.book
  %-  (walt card)
  :~  [scry.r |.([(part:grow book-id book path tale) ~])]
      [scry.r |.([(back:grow book-id book) ~])]
      [goss.r |.([(tell:goss book-id book) ~])]
  ==
::
++  imp-file
  |=  [%imp-file book-id=@ta files=(map @t wain) =title-source del-missing=?]
  =/  =book  (~(got by books) book-id)
  ?.  (may-edit bowl ~ rules.book)
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
  |=  [=ship =action eyre-id=@ta]
  ^-  card
  [%pass [eyre-id -.action ~] %agent [ship %wiki] %poke %wiki-action !>(action)]
::
++  grow :: todo: decide if I keep using /booklet-0 (safe, but gross), or force switch to /booklet (potentially breaking)
  |%
  ++  part
    |=  [book-id=@ta =book tale-path=path =tale]
    ^-  card
    =/  =wire  /wiki/booklet
    =/  loc=path  (weld /booklet/[book-id] tale-path)
    =/  =booklet  [(book-to-cover book-id book) tale-path tale]
    [%pass wire %grow loc %wiki-booklet-1 booklet]
  ::
  ++  back
    |=  [id=@ta =book]
    ^-  card
    [%pass /wiki/spine %grow /spine/[id] %wiki-spine-1 (book-to-spine id book)]
  ::
  ++  full
    |=  [id=@ta =book]
    ^-  (list card)
    :-  (back id book)
    %+  turn  ~(tap by tales.book)
    |=  [=path =tale]
    (part id book path tale)
  --
::
++  tomb
  |%
  ++  tomb
    |=  targ=path
    ^-  (list card)
    =/  base=path  ~+  /(scot %p our.bowl)/wiki/(scot %da now.bowl)/$/1
    =/  fans=(unit fans:gall)  (~(get by sky.bowl) targ)
    ?~  fans  ~
    %+  murn  ~(tap by u.fans)
    |=  [v=@ud =time data=(each page:clay @uvI)]
    ?.  -.data  ~
    `[%pass (weld /wiki/tomb targ) %tomb [%ud v] targ]
  ::
  ++  full
    |=  book-id=@ta
    ^-  (list card)
    =;  paths=(list path)  (zing (turn paths tomb))
    :-  /spine/[book-id]
    :-  /spine-0/[book-id]
    %+  skim  ~(tap in ~(key by sky.bowl))
    |=  =(pole knot)
    ?+  pole  |
      [%booklet bid=@ta *]    =(book-id bid.pole)
      [%booklet-0 bid=@ta *]  =(book-id bid.pole)
    ==
  ::
  ++  part
    |=  [book-id=@ta page-path=path]
    ^-  (list card)
    %+  weld
      (tomb (weld /booklet/[book-id] page-path))
    (tomb (weld /booklet-0/[book-id] page-path))
  --
::
++  goss
  |%
  ::
  ++  tell
    |=  [id=@ta =book]
    ^-  card
    ~&  '%wiki starting a rumor...'
    =/  =lore  [%lurn (malt [[our.bowl id] (book-to-spine id book)]~)]
    [(invent:gossip %wiki-lore !>(lore))]
  ::
  ++  hush
    |=  [id=@ta]
    ^-  card
    ~&  '%wiki denying a rumor...'
    =/  =lore  [%burn our.bowl id now.bowl]
    [(invent:gossip %wiki-lore !>(lore))]
  ::
  ++  rant
    ^-  (list card)
    ~&  '%wiki spreading rumors...'
    =;  library
      %+  turn  library
      |=  item=[[@p @ta] spine]
      =/  =lore  [%lurn (malt [item]~)]
      (invent:gossip %wiki-lore !>(lore))
    %+  weld  ~(tap by shelf)
    %+  murn  ~(tap by books)
    |=  [id=@ta =book]
    ?.  goss.read.rules.book  ~
    `[[our.bowl id] (book-to-spine id book)]
  ::
  ++  read
    |=  =cage
    ^-  (quip card _state)
    ~&  "%wiki heard a rumor from {<src.bowl>}..."
    ?.  ?=(%wiki-lore p.cage)  (cope cage)
    =/  =lore  !<(lore q.cage)
    ?-  -.lore
      %lurn
        =/  other=_shelf
          %-  my
          %+  skip  ~(tap by shelf.lore)
          |=  [[host=@p @ta] *]
          =(host our.bowl)
        =.  shelf
          %-  (~(uno by shelf) other)
          |=  [k=[@p @ta] v=spine w=spine]
          ?:  (gte stamp.cover.v stamp.cover.w)  v
          ~&  "... updating index for {<k>}"
          w
        [~ state]
      ::
      %burn
        :-  ~
        =/  old=(unit spine)  (~(get by shelf) [host.lore id.lore])
        ?~  old                              state
        ?:  (gth stamp.cover.u.old at.lore)  state
        ~&  "... un-indexing {<[host.lore id.lore]>}"
        =.  shelf  (~(del by shelf) [host.lore id.lore])
        state
    ==
  ::
  ++  cope
    |=  =cage
    ^-  (quip card _state)
    ~&  "... but didn't understand it (will try again after next update)"
    =.  early  (snoc early cage)
    [~ state]
  --
::
++  relay-response
  |=  [=order:rudder error=(unit tang) =agent:gall]
  ^-  (list card)
  =/  pending-eyre-id=@ta  id.order
  ?~  error
    =/  base-path=tape  (spud path:(sane-url:web url.request.order))
    =.  url.request.order  (crip (weld base-path "?fresh=true"))
    -:(on-poke:agent %handle-http-request !>(order))
  %+  give-simple-payload:app:server  pending-eyre-id
  ^-  simple-payload:http
  =/  html=@t  (error-to-html:web u.error)
  [[400 ['content-type' 'text/html']~] `(tail (html-to-mime html))]
::
--