::
:: misc utility
::
/-  *wiki
/+  regex, wiki-auth, *wiki-morf
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
++  bush :: to-do: move into other lib?
  |$  [node leaf]
  $+  bush
  $@(~ (map node (pair (bush node leaf) (unit leaf))))
::
++  bush-put
  |*  [k-type=mold v-type=mold]
  |*  [b=(bush k-type v-type) k=(list k-type) v=v-type]
  ^-  _b
  ?:  =(~ k)  !!
  %-  ~(put by b)
  |-
  ^-  (pair k-type (pair _b (unit _v)))
  ?<  ?=(~ k)
  :-  -.k
  =/  g=(unit (pair _b (unit _v)))  (~(get by b) -.k)
  =/  twig=_b  (fall (bind g head) ~)
  ?:  =(~ +.k)  [twig `v] :: put berry
  =/  gery=(unit _v)  (biff g tail)
  ^-  (pair _b (unit _v))
  :-  ^-  _b
      (~(put by twig) $(k +.k, b twig)) :: put twig
  gery
::
::  recursively count the number of leaves in a bush
::
++  bush-size
  |=  b=(bush * *)
  ~+
  ^-  @ud
  ?:  =(~ b)  0
  %+  roll  ~(val by b)
  |=  [arg=[kids=(bush * *) item=(unit *)] acc=@ud]
  %+  add  acc
  %+  add  ?~(item.arg 0 1)
  |-
  (bush-size kids.arg)
::
++  path-ref-bush
  |=  mage=(map path ref)
  ~+
  ^-  (bush knot ref)
  %-  ~(rep by mage)
  |=  [arg=[=path =ref] acc=(bush knot ref)]
  ((bush-put knot ref) acc path.arg ref.arg)
::
++  bush-summary-at
  |*  [k-type=mold leaf=mold]
  |*  [b=(bush k-type leaf) loc=(list k-type)]
  ~+
  ^-  (list [k-type kids=@ud item=(unit leaf) size=@ud])
  ?.  ?=(%~ loc)
    =/  newb=(bush k-type leaf)  p:(~(got by b) -.loc)
    =/  newl=(list k-type)       +.loc
    ((bush-summary-at k-type leaf) newb newl)
  %+  turn  ~(tap by b)
  |=  [key=k-type branch=(pair (bush k-type leaf) (unit leaf))]
  ^-  [k-type kids=@ud item=(unit leaf) size=@ud]
  :-  key
  :-  ~(wyt by p.branch)
  :-  q.branch
  (bush-size p.branch)
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
++  log-if-crash
  |*  t=mold
  |=  run=(trap t)
  ^-  t
  =/  out=(each t tang)  (mule run)
  ?-  -.out
    %&  p.out
    %|  ~&  >>>  "%wiki error:"
        ((slog p.out) |-(!!))
  ==
::
--