::  download page as .md
::
/-  *wiki
/+  rudder, string, web=wiki-web, *wiki
/$  page-to-md  %wiki-page-1  %md
/$  md-to-mime  %md  %mime
::
^-  (page:rudder rudyard action)
::
=<
::
|_  [=bowl:gall =order:rudder rudyard]
::
+*  help  ~(. +> [bowl order [[%2 shelf books] spine booklet]]) :: todo: look into =, to expose rudyard namespace
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
  =/  tale=(unit tale)  get-tale:help
  ?~  tale
    [%code 404 (crip "Article {<where:space-time:help>} not found in {<title.book>}")]
  =/  peach=(each [time=@da =page] @t)  (get-page:help u.tale)
  ?:  ?=(%| -.peach)  [%code 404 p.peach]
  =/  =page      page.p.peach
  ::
  |^  [%full payload]
  ::
  ++  payload
    ^-  simple-payload:http
    :-  [200 ['content-type' 'text/markdown'] ~]
    ^-  (unit octs)
    `(tail (md-to-mime (page-to-md page)))
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  book-id  ~+
  ^-  @ta
  book-id:wiki-path:(wiki-url:web url.request.order)
::
++  space-time  ~+
  ^-  [where=path when=(unit (each @da @ud))]
  =/  [=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  :-  pre:(split-on loc.wiki-path %~.~)
  =/  day=(unit @da)  (biff (~(get by query) 't') (cury slaw %da))
  ?^  day  `[%& u.day]
  =/  ver=(unit @ud)  (biff (~(get by query) 'v') (cury slaw %ud))
  ?^  ver  `[%| u.ver]
  ~
::
++  get-cover
  ^-  (unit cover)
  ?^  booklet  `cover.u.booklet
  =/  buuk  (~(get by books) book-id)
  %+  bind  buuk
  |=(=book [book-id title.book rules.book])
::
++  get-tale
  ^-  (unit tale)
  ?^  booklet  `tale.u.booklet
  %+  biff  (~(get by books) book-id)
  |=  =book
  (~(get by tales.book) where:space-time)
::
++  get-page
  |=  =tale
  ^-  (each [time=@da =page] @t)
  =/  when=(unit (each @da @ud))  when:space-time
  ?~  when  [%& (latest tale)]
  ?-  -.u.when
    %&  (page-tim tale p.u.when)
    %|  (page-ver tale p.u.when)
  ==
::
++  page-tim
  |=  [=tale at=@da]
  ^-  (each [time=@da =page] @t)
  =/  before=^tale  (lot:ton tale `(add at 1) ~)
  =/  puge=(unit [time=@da =page])  (pry:ton before)
  ?~  puge  [%| (crip "Page did not exist at {<at>}")]
  [%& u.puge]
::
++  page-ver
  |=  [=tale version=@ud]
  ^-  (each [time=@da =page] @t)
  ?:  (gte version (wyt:ton tale))
    [%| (crip "Page has no version {<version>}")]
  [%& (snag version (bap:ton tale))]
::
--