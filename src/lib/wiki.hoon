::
:: misc utility
::
/-  *wiki
|%
::
++  part
  |=  =cord
  ^-  path
  ?:  =('' cord)  ~
  =/  =tape  (trip cord)
  ?:  =('/' -.tape)  (stab cord)
  (stab (crip ['/' tape]))
::
:: same idea as partition:string but safer and maybe more efficient
::
++  split-on
  |*  [log=(list *) div=*]
  ^-  [pre=_log suf=_log]
  =/  pre=_log  ~
  |-
  ?:  =(~ log)      [pre ~]
  ?:  =(div -.log)  [pre +.log]
  $(pre (snoc pre -.log), log +.log)
::
++  bush  :: to-do: move into /sur/wiki.hoon ?
  |$  [node leaf]
  $@(~ (map node (pair (bush node leaf) (unit leaf))))
::
::  to-do: implement method to transform (map path page) -> (bush knot page)
::         this will be used to help render nested directory structure in UI
::
:: ++  bush-put
::   |*  b=(bush * *)
::   |*  [k=(list *) v=*]
::   ^-  _b
::   ?:  =(~ k)  !!
::   %-  ~(put by b)
::   |-
::   ^-  (pair * (pair _b (unit _v)))
::   ?<  ?=(~ k)
::   :-  -.k
::   =/  g=(unit (pair _b (unit _v)))  (~(get by b) -.k)
::   =/  twig=_b  (fall (bind g head) ~)
::   ?:  =(~ +.k)  [twig `v]     :: put berry
::   =/  gery=(unit _v)  (biff g tail)
::   ^-  (pair _b (unit _v))
::   :-  ^-  _b
::       (~(put by twig) $(k +.k, b twig)) :: put twig
::   gery
:: ::
:: ++  path-bush
::   |=  mage=(map path page)
::   :: *bush
::   ^-  (bush knot page)
::   %-  ~(rep by mage)
::   |=  [arg=[=path =page] acc=(bush knot page)]
::   :: =/  buu  ~(. bbbbbb acc)
::   :: ~&  "engine: {<buu>}"
::   :: (punt:buu path.arg page.arg)
::   ((bush-put acc) path.arg page.arg)
::   :: %-  ~(put burp acc)
::   :: [path.arg page.arg]
::   :: *_acc
--