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
  =/  [site=(pole knot) *]  (sane-url:web url.request.order)
  ?>  ?=([%wiki %~.~ %p host=@ta book-id=@ta %~.~ %assets filepath=*] site)
  |^  ?+  filepath.site  [%code 404 'Not found']
        [%~.style.css ~]  (get-style (slav %p host.site) book-id.site)
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
    :: '''
    :: body {
    ::   color: blue;
    ::   background-color: pink;
    :: }
    :: '''
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