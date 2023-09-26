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
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  ::
  =/  site=(pole knot)  (stab url.request.order)
  ?.  ?=([%wiki book-id=@ta *] site)
    [%code 404 'Invalid path']
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  =/  page-path=path  where:space-time:help
  ?~  tale=(~(get by tales.book) page-path)
    [%code 404 (crip "Article {<page-path>} not found in {<title.book>}")]
  =/  peach=(each page @t)  (get-page:help u.tale)
  ?:  ?=(%| -.peach)  [%code 404 p.peach]
  =/  =page  p.peach
  ::
  |^  [%page render]
  ::
  ++  zero-md-src
    "https://cdn.jsdelivr.net/gh/zerodevx/zero-md@2/dist/zero-md.min.js"
  ::
  ++  prism-css-src
    "https://cdn.jsdelivr.net/gh/PrismJS/prism@1/themes/prism.min.css"
  ::
  ++  render
    ^-  manx
    =/  wik-dir=tape  (spud /wiki/[book-id:help])
    =/  pag-dir=tape  (spud page-path)
    ;html
      ;head
        ;title: {(trip title.page)}
        ;style: {(style:web bowl)}
      ==
      ;body
        ;nav.global
          ;a/"{wik-dir}": {(trip title.book)}
        ==
        ;main
          ;nav.page
            ;a/"{wik-dir}{pag-dir}/~/edit": Edit
            ;a/"{wik-dir}{pag-dir}/~/history": History
          ==
          ;article
            ;header
              ;h1: {(trip title.page)}
            ==
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
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta *] site)
  book-id.site
::
++  space-time  ~+
  ^-  [where=path when=(unit (each @da @ud))]
  =/  site=(pole knot)  (stab url.request.order)
  ?>  ?=([%wiki book-id=@ta pat=*] site)
  =/  pat=(pole knot)  pat.site
  =/  n=@  (lent pat)
  ?:  (lth n 4)  [pat ~]
  =/  [pre=path suf=(pole knot)]  (split pat (sub n 3))
  ?+  suf  [pat ~]
    [%~.~ %t day=@ta ~]  [pre `[%& (slav %da day.suf)]]
    [%~.~ %v ver=@ta ~]  [pre `[%| (slav %ud ver.suf)]]
  ==
::
++  get-page
  |=  =tale
  ^-  (each page @t)
  =/  when=(unit (each @da @ud))  when:space-time
  ?~  when  [%& (latest tale)]
  ?-  -.u.when
    %&  (page-tim tale p.u.when)
    %|  (page-ver tale p.u.when)
  ==
::
++  page-tim
  |=  [=tale at=@da]
  ^-  (each page @t)
  =/  before=^tale  (lot:ton tale `(add at 1) ~)
  =/  puge=(unit page)  (bind (pry:ton before) tail)
  ?~  puge  [%| (crip "Page did not exist at {<at>}")]
  [%& u.puge]
::
++  page-ver
  |=  [=tale version=@ud]
  ^-  (each page @t)
  ?:  (gte version (wyt:ton tale))
    [%| (crip "Page has no version {<version>}")]
  [%& (tail (snag version (bap:ton tale)))]
::
--