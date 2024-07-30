::  load public per-book asset
::
/-  *wiki
/+  rudder, server, string, web=wiki-web, *wiki
/$  css-to-mime  %css  %mime
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
++  argue
  |=  [header-list:http (unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  =,  -.rudyard
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  loc=(pole knot)  loc.site
  ?>  ?=([%~.~ %assets filepath=*] loc)
  |^  ?+  filepath.loc  [%code 404 'Not found']
        [%~.style.css ~]  (get-style (fall host.site our.bowl) book-id.site)
      ==
  ::
  ++  css-reply
    |=  =mime
    ^-  reply:rudder
    [%full (css-response:gen:server +.mime)]
  ::
  ++  get-style
    |=  [=ship book-id=@ta]
    ^-  reply:rudder
    =;  style=(unit mime)
      ?~  style  [%code 404 'Not found']
      (css-reply u.style)
    ?.  =(our.bowl ship)  asset.rudyard
    %+  bind  (~(get by books) book-id)
    |=  =book
    %-  css-to-mime
    ?-  -.theme.book
      %|  +.theme.book
      %&  (preset-theme +.theme.book)
    ==
  ::
  ++  preset-theme
    |=  =term
    ?+  term    ''
      %default  ''
    ==
  ::
  --
--