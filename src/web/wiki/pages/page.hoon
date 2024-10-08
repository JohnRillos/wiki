::  article
::
/-  *wiki
/+  rudder, wiki-auth, wiki-web, *wiki
/*  format-time-js  %js  /web/wiki/format-time/js
/*  mermaid-zero-js  %js  /web/wiki/mermaid-zero/js
::
^-  (page:rudder rudyard relay)
::
=<
::
|_  [=bowl:gall =order:rudder =^rudyard]
::
+*  help  ~(. +> [bowl order rudyard])
    auth  ~(. wiki-auth [bowl ether.rudyard])
    web   ~(. wiki-web [bowl rudyard])
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder relay)
  =/  args=(map @t @t)  (form-data:web order)
  ?.  (~(has by args) 'del-page')  ~
  =/  [=wiki-path *]  (wiki-url:web url.request.order)
  [%relay our.bowl id.order [%del-page book-id.wiki-path where:space-time:help]]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  back=?  &(success (~(has by (form-data:web order)) 'del-page'))
  =/  next=@t
    ?.  back  url.request.order
    =/  msg=tape  (en-urlt:html "Page deleted!")
    (crip "/wiki/{(trip book-id:help)}?msg={msg}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  cuver  get-cover:help
  ?~  cuver  [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =cover  u.cuver
  =/  page-path=path  where:space-time:help
  =/  tale  get-tale:help
  ?~  tale  =/  loc=tape
              %+  weld  (spud /wiki/[book-id.site]/~/not-found)
              "?target={(spud page-path)}"
            [%next (crip loc) ~]
  =/  peach=(each [time=@da =page] @t)  (get-page:help u.tale)
  ?:  ?=(%| -.peach)  [%code 404 p.peach]
  =/  =page      page.p.peach
  =/  as-of=@da  time.p.peach
  =/  fresh=?    =(as-of time:(latest u.tale))
  =/  permalink=?  ?!(=(~ when:space-time:help))
  =/  author=tape
    ?:  =(%pawn (clan:title edit-by.page))  "a guest user"
    <edit-by.page>
  ::
  |^  [%page render]
  ::
  ++  on-load  (trip format-time-js)
  ::
  ++  mermaid-src
    "https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"
  ::
  ++  zero-md-src
    "https://cdn.jsdelivr.net/gh/zerodevx/zero-md@2/dist/zero-md.min.js"
  ::
  ++  prism-css-src
    "https://cdn.jsdelivr.net/gh/PrismJS/prism@1/themes/prism.min.css"
  ::
  ++  mermaid-script  ^~  (trip mermaid-zero-js)
  ::
  ++  version-notice
    ^-  (unit manx)
    ?.  permalink  ~
    :-  ~
    =/  pre=tape
      ?:  fresh
        "This is the current version of this page. Last edited by {author} at "
      "This is an old version of this page, as edited by {author} at "
    ;p#version-banner
      ; {pre}
      ;+  (timestamp:web as-of)
      ; .
    ==
  ::
  ++  render
    ^-  manx
    =/  host=(unit @p)  host.site
    =/  wik-dir=tape  (base-path:web site)
    =/  pag-dir=tape  (spud page-path)
    ;html
      ;+  (doc-head:web bowl (trip title.page))
      ;body#with-sidebar.loading(onload on-load)
        ;+  (link-theme:web bowl host cover)
        ;+  (global-nav:web bowl order [%& cover])
        ;main
          ;+  (topbar:web bowl order cover)
          ;+
          ?.  (may-read:auth rules.cover)  stub:web
          ;header
            ;h1#page-title: {(trip title.page)}
            ;nav.page
              ;+  ?.  (may-edit:auth host rules.cover)  stub:web
                  ;a/"{wik-dir}{pag-dir}/~/edit": Edit
              ;a/"{wik-dir}{pag-dir}/~/history": History
              ;a/"{wik-dir}{pag-dir}/~/download?t={<as-of>}"
                =download  "{(trip (rear page-path))}.md"
                ; Download
              ==
              ;+
              ?.  =(src:auth (fall host our.bowl))  stub:web
              %+  in-form:web  "Are you sure you want to delete this page?"
              ;button.delete
                =type   "submit"
                =name   "del-page"
                ; Delete
              ==
            ==
          ==
          ;+
          ?.  (may-read:auth rules.cover)
            ;div.login-gate
              ;p
                ;a/"/~/login?eauth&redirect={wik-dir}{pag-dir}": Log in
                ; 
                ; with 
                ;a/"https://urbit.org": Urbit
                ; 
                ; to view content on this wiki.
              ==
            ==
          ;article
            ;+  (fall version-notice stub:web)
            ;script(defer "", src mermaid-src);
            ;script(type "module", src zero-md-src);
            ;zero-md#zero
              =no-shadow      ""
              =manual-render  ""
              ;template
                ;link(rel "stylesheet", href prism-css-src);
                ;style: {(style:web bowl)}
                ;style: {(md-style:web bowl)}
              ==
              ;script
                =type  "text/markdown"
                ; {(trip (of-wain:format content.page))}
              ==
            ==
            ;script: {mermaid-script}
          ==
          ;+  (footer:web (fall host.site our.bowl) [%& cover])
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  web   ~(. wiki-web [bowl rudyard])
::
++  book-id  ~+
  ^-  @ta
  book-id:wiki-path:(wiki-url:web url.request.order)
::
++  space-time  ~+
  ^-  [where=path when=(unit (each @da @ud))]
  =/  [=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  :-  loc.wiki-path
  =/  day=(unit @da)  (biff (~(get by query) 't') (cury slaw %da))
  ?^  day  `[%& u.day]
  =/  ver=(unit @ud)  (biff (~(get by query) 'v') (cury slaw %ud))
  ?^  ver  `[%| u.ver]
  ~
::
++  get-cover
  ^-  (unit cover)
  ?^  booklet.rudyard  `cover.u.booklet.rudyard
  %+  bind  (~(get by books.rudyard) book-id)
  |=(=book (book-to-cover book-id book))
::
++  get-tale
  ^-  (unit tale)
  ?^  booklet.rudyard  `tale.u.booklet.rudyard
  %+  biff  (~(get by books.rudyard) book-id)
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