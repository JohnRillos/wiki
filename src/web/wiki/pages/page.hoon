::  article
::
/-  *wiki
/+  rudder, web=wiki-web, *wiki
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
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)  (form-data:web order)
  ?.  (~(has by args) 'del-page')  ~
  =/  [=wiki-path *]  (wiki-url:web url.request.order)
  [%del-page book-id.wiki-path where:space-time:help]
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
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  =/  page-path=path  where:space-time:help
  ?~  tale=(~(get by tales.book) page-path)
    =/  loc=tape
      (weld (spud /wiki/[book-id.site]/~/not-found) "?target={(spud page-path)}")
    [%next (crip loc) ~]
  =/  peach=(each [time=@da =page] @t)  (get-page:help u.tale)
  ?:  ?=(%| -.peach)  [%code 404 p.peach]
  =/  =page      page.p.peach
  =/  as-of=@da  time.p.peach
  =/  fresh=?    =(as-of time:(latest u.tale))
  =/  permalink=?  ?!(=(~ when:space-time:help))
  =/  author=tape  <our.bowl>  :: to-do: really track author
  ::
  |^  [%page render]
  ::
  ++  zero-md-src
    "https://cdn.jsdelivr.net/gh/zerodevx/zero-md@2/dist/zero-md.min.js"
  ::
  ++  prism-css-src
    "https://cdn.jsdelivr.net/gh/PrismJS/prism@1/themes/prism.min.css"
  ::
  ++  render  :: to-do: display if this page is public or private
    ^-  manx
    =/  wik-dir=tape  (spud /wiki/[book-id:help])
    =/  pag-dir=tape  (spud page-path)
    =/  version-notice=(unit tape)
      ?.  permalink  ~
      :-  ~
      ?:  fresh
        %+  weld
        "This is the current version of this page. "
        "Last edited by {author} at {<as-of>}."
      "This is an old version of this page, as edited by {author} at {<as-of>}."
    :: =/  footer-text=tape  "Edited by {author} at {<as-of>}." :: to-do: put in footer
    ;html
      ;head
        ;title: {(trip title.page)}
        ;style: {(style:web bowl)}
      ==
      ;body#with-sidebar
        ;+  (global-nav:web bowl order [book-id:help book])
        ;main
          ;header
            ;h1#page-title: {(trip title.page)}
            ;nav.page
              ;a/"{wik-dir}{pag-dir}/~/edit": Edit
              ;a/"{wik-dir}{pag-dir}/~/history": History
              ;+
              ?.  =(src.bowl our.bowl)  stub:web
              %+  in-form:web  "Are you sure you want to delete this page?"
              ;button.delete
                =type   "submit"
                =name   "del-page"
                ; Delete
              ==
            ==
          ==
          ;article
            ;+  ?~  version-notice  stub:web
                ;p#version-banner: {u.version-notice}
            ;script(type "module", src zero-md-src);
            ;zero-md
              ;template
                ;link(rel "stylesheet", href prism-css-src);
                ;style: {(style:web bowl)}
                ;style: {(md-style:web bowl)}
              ==
              ;script(type "text/markdown"): {content.page}
            ==
          ==
          ;+  (footer:web bowl url.request.order)
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
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
:: ++  time-to-ver
::   |=  [=tale at=@da]
::   ^-  @ud
::   =/  story=(list [@da page])  (tap:ton tale)
::   =/  ver=@ud  (dec (wyt:ton tale))
::   |-
::   =/  head=[@da page]  -.story
::   ?:  =(at -.head)  ver
::   ?<  =(0 ver)
::   $(story +.story, ver (dec ver))
::
--