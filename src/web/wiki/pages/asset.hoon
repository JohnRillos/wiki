::  load public asset file
::
/-  *wiki
/+  rudder, server, string, web=wiki-web, *wiki
/*  favicon-16  %mime  /web/wiki/assets/favicon-16/png
/*  favicon-32  %mime  /web/wiki/assets/favicon-32/png
/*  favicon-48  %mime  /web/wiki/assets/favicon-48/png
/*  tile        %mime  /web/wiki/assets/tile/svg
::
^-  (page:rudder state-0 action)
::
|_  [=bowl:gall =order:rudder state-0]
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
  =/  [site=(pole knot) *]  (sane-url:web url.request.order)
  ?>  ?=([%wiki %~.~ %assets filepath=*] site)
  |^  ?+  filepath.site  [%code 404 'Not found']
        [%~.favicon-16.png ~]  (png-reply favicon-16)
        [%~.favicon-32.png ~]  (png-reply favicon-32)
        [%~.favicon-48.png ~]  (png-reply favicon-48)
        [%~.tile.svg ~]        (svg-reply tile)
      ==
  ::
  ++  png-reply
    |=  =mime
    ^-  reply:rudder
    [%full (png-response:gen:server +.mime)]
  ::
  ++  svg-reply
    |=  =mime
    ^-  reply:rudder
    [%full (svg-response:gen:server +.mime)]
  --
--