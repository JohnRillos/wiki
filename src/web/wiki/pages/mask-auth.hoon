::  validate metamask auth challenge
::
/-  *wiki
/+  rudder, wiki-dejs
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder relay)
  =/  body=(unit octs)  body.request.order
  ?~  body                    'Error: no auth request body'
  =/  raw=@t  q.u.body
  =/  jon=(unit json)  (de:json:html raw)
  ?~  jon                     'Error: unable to parse auth request'
  =/  =action  (dj-mask-auth:wiki-dejs u.jon)
  ?.  ?=(%eth-auth -.action)  'Error: incorrect action'
  ~&  >>>  action
  [%relay our.bowl id.order action]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  ?.  success  [%code 401 'Failed wallet authentication']
  [%code 200 'Wallet authentication successful']
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [? @t])]
  ^-  reply:rudder
  !!
--