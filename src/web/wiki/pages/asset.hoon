::  load public asset file
::
/-  *wiki
/+  rudder, server, string, wiki-web, *wiki
/*  favicon-16  %mime  /web/wiki/assets/favicon-16/png
/*  favicon-32  %mime  /web/wiki/assets/favicon-32/png
/*  favicon-48  %mime  /web/wiki/assets/favicon-48/png
/*  wiki-logo   %mime  /web/wiki/assets/logo/svg
/*  tile        %mime  /web/wiki/assets/tile/svg
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  web  ~(. wiki-web [bowl rudyard])
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
        [%~.logo.svg ~]        (svg-reply wiki-logo)
        [%~.tile.svg ~]        (svg-reply tile)
      ==
  ::
  ++  png-reply
    |=  =mime
    ^-  reply:rudder
    [%full %*($ png-response:gen:server cache &, octs +.mime)]
  ::
  ++  svg-reply
    |=  =mime
    ^-  reply:rudder
    [%full %*($ svg-response:gen:server cache &, octs +.mime)]
  --
--