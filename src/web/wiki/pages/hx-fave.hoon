::  htmx partial: add/remove favorite button
::
/-  *wiki
/+  rudder, wiki-auth, wiki-web, *wiki
/$  svg-to-mime  %svg  %mime
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
+*  auth  ~(. wiki-auth [bowl ether.rudyard])
    web   ~(. wiki-web [bowl rudyard])
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder relay)
  ?.  =(src:auth our.bowl)  'Unauthorized'
  =/  [site=(pole knot) query=(map @t @t)]  (sane-url:web url.request.order)
  ?>  ?=([%wiki %~.~ %x %faves host=@ta book-id=@ta ~] site)
  =/  host=@p  (slav %p host.site)
  =/  en-fave=?  =((~(got by query) 'set') 'true')
  :^  %relay  our.bowl  id.order
  ?:  en-fave  [%add-fave host book-id.site]
  [%del-fave host book-id.site]
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ?.  =(src:auth our.bowl)  [%code 403 'Unauthorized']
  =/  [site=(pole knot) query=(map @t @t)]  (sane-url:web url.request.order)
  ?>  ?=([%wiki %~.~ %x %faves host=@ta book-id=@ta ~] site)
  =/  host=@p  (slav %p host.site)
  [%page (fave-button:web [host book-id.site])]
--
