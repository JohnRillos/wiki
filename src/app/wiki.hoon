/-  *wiki
/+  dbug, default-agent, verb
::
::  types core
::
|%
::
+$  card  card:agent:gall
::
+$  versioned-state
  $%  state-0
  ==
::
+$  state-0
  $:  %0
  ==
--
::
::  state
::
=|  state-0
=*  state  -
::
::  debugging tools
::
%+  verb  |
%-  agent:dbug
::
=<  :: compose helper core into agent core
::
::  agent core
::
^-  agent:gall
|_  =bowl:gall
+*  this       .
    default  ~(. (default-agent this %|) bowl)
    main     ~(. +> bowl)
::
++  on-init   on-init:default
++  on-save   !>(~)
++  on-load   on-load:default
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?.  =(our.bowl src.bowl)  ~|('Unauthorized!' !!)
  ?+  mark  (on-poke:default mark vase)
      %cryo-action
    =^  cards  state
      (handle-action:main !<(action vase))
    [cards this]
  ==
::
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-peek   on-peek:default
++  on-agent  on-agent:default
++  on-arvo   on-arvo:default
++  on-fail   on-fail:default
--
::
::  helper core (main)
::
|_  =bowl:gall
::
++  handle-action
  |=  act=action
  ^-  (quip card _state)
  ?-  -.act
      %foo
    ~&  bar.act
    [~ state]
  ==
--