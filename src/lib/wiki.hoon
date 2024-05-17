::
:: misc utility
::
/-  *wiki
/+  regex, *wiki-morf
|%
::
++  may-edit
  |=  [=bowl:gall host=(unit @p) =access]
  ^-  ?
  ?:  =(src.bowl (fall host our.bowl))  &
  ?:  =(%pawn (clan:title src.bowl))
    comet.edit.access
  public.edit.access
::
++  is-admin
  |=  [=bowl:gall host=(unit @p) =access] :: access isn't used... yet
  =(src.bowl (fall host our.bowl))
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
++  alpha-less
  |=  [a=tape b=tape]
  =.  a  (cass a)
  =.  b  (cass b)
  |-
  ?:  =(~ a)         &
  ?:  =(~ b)         |
  ?:  (lth -.a -.b)  &
  ?.  =(-.a -.b)     |
  $(a +.a, b +.b)
::
++  sane-newline
  |=  =cord
  %-  crip
  (gsub:regex "\0d" "" (trip cord))
::
++  skil :: skim until limit
  |*  [big=(list *) limit=@ chek=$-(* ?)]
  ^-  _big
  =/  out=_big  ~
  |-
  ?:  |(=(0 limit) =(~ big))  out
  ?.  (chek -.big)
    $(big +.big)
  $(big +.big, limit (dec limit), out [-.big out])
:::
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
::
++  filt
  |*  [cond=? val=*]
  ^-  (unit _val)
  ?:(cond `val ~)
::
++  wilt
  |*  val-type=mold
  |=  input=(list [? (list val-type)])
  ^-  (list val-type)
  (zing (murn input filt))
::
++  falt
  |*  [cond=? get=(trap *)]
  ?:(cond `(get) ~)
::
++  walt
  |*  val-type=mold
  |=  input=(list [? (trap (list val-type))])
  ^-  (list val-type)
  (zing (murn input falt))
::
++  time-ago
  |=  [now=@da then=@da]
  ^-  tape
  =/  ago=@dr  (sub now then)
  ?:  (gth ago ~d7)  <`@da`(sub then (mod then ~d1))>
  ?:  (gth ago ~d2)  "{<(div ago ~d1)>} days ago"
  ?:  (gth ago ~h2)  "{<(div ago ~h1)>} hours ago"
  ?:  (gth ago ~m2)  "{<(div ago ~m1)>} minutes ago"
  "{<(div ago ~s1)>} seconds ago"
::
--