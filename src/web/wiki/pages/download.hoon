::  download page as .md
::
/-  *wiki
/+  rudder, string, web=wiki-web, *wiki
/$  md-to-mime  %md  %mime
::
^-  (page:rudder (map @ta book) action)
::
=<
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
+*  help  ~(. +> [bowl order books])
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
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  =/  page-path=path  where:space-time:help
  ?~  tale=(~(get by tales.book) page-path)  [%code 404 'Page not found']
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
    :-  ~
    =/  md=wain
      :-  (crip "# {(trip title.page)}")
      :-  ''
      content.page
    (tail (md-to-mime md))
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
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