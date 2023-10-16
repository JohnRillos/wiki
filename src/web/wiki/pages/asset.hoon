::  load public asset file
::
/-  *wiki
/+  rudder, string, web=wiki-web, *wiki
/$  png-to-mime  %png  %mime
/*  favicon-16  %png  /web/wiki/icons/favicon-16/png
/*  favicon-32  %png  /web/wiki/icons/favicon-32/png
/*  favicon-48  %png  /web/wiki/icons/favicon-48/png
::
^-  (page:rudder (map @ta book) action)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
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
  ::
  =/  [site=(pole knot) *]  (sane-url:web url.request.order)
  ?>  ?=([%wiki %~.~ %assets filepath=*] site)
  |^  ?+  filepath.site  [%code 404 'Not found']
        [%~.favicon-16.png ~]  (mime-to-reply (png-to-mime favicon-16))
        [%~.favicon-32.png ~]  (mime-to-reply (png-to-mime favicon-32))
        [%~.favicon-48.png ~]  (mime-to-reply (png-to-mime favicon-48))
      ==
  ::
  ++  mime-to-reply
    |=  [=mite =octs]
    ^-  reply:rudder
    :-  %full
    ^-  simple-payload:http
    :_  `octs
    [200 ['content-type' (crip (tail (spud mite)))] ~]
  --
--