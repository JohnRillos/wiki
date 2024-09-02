::  Modified from ~rabsef-bicrym's %mask
::
/-  *wiki
/+  ethereum, naive
::
|_  [=bowl:gall =ether]
::
++  validate
  |=  [who=@p challenge=@uv address=tape hancock=tape]
  ^-  ?
  =/  addy  (from-tape address)
  =/  cock  (from-tape hancock)
  =/  owner  (get-owner who)
  ?~  owner  %.n
  ?.  =(addy u.owner)  %.n
  ?.  (~(has in challenges.ether) challenge)  %.n
  =/  note=@uvI
    =+  octs=(as-octs:mimes:html (scot %uv challenge))
    %-  keccak-256:keccak:crypto
    %-  as-octs:mimes:html
    ;:  (cury cat 3)
      '\19Ethereum Signed Message:\0a'
      (crip (a-co:co p.octs))
      q.octs
    ==
  ?.  &(=(20 (met 3 addy)) =(65 (met 3 cock)))  %.n
  =/  r  (cut 3 [33 32] cock)
  =/  s  (cut 3 [1 32] cock)
  =/  v=@
    =+  v=(cut 3 [0 1] cock)
    ?+  v  !!
      %0   0
      %1   1
      %27  0
      %28  1
    ==
  ?.  |(=(0 v) =(1 v))  %.n
  =/  xy
    (ecdsa-raw-recover:secp256k1:secp:crypto note v r s)
  =/  pub  :((cury cat 3) y.xy x.xy 0x4)
  =/  add  (address-from-pub:key:ethereum pub)
  =(addy add)
::
++  from-tape
  |=(h=tape ^-(@ux (scan h ;~(pfix (jest '0x') hex))))
::
++  get-owner
  |=  [who=@p]
  ^-  (unit @ux)
  =-  ?~  pin=`(unit point:naive)`-
        ~
      ?.  |(?=(%l1 dominion.u.pin) ?=(%l2 dominion.u.pin))
        ~
      `address.owner.own.u.pin
  .^  (unit point:naive)
    %gx
    /(scot %p our.bowl)/azimuth/(scot %da now.bowl)/point/(scot %p who)/noun
  ==
::
++  src
  ~+
  ^-  @p
  (fall (~(get by users.ether) src.bowl) src.bowl)
::
++  may-edit
  |=  [host=(unit @p) =access]
  ^-  ?
  ?:  =(src (fall host our.bowl))  &
  ?:  =(%pawn (clan:title src))
    comet.edit.access
  public.edit.access
::
--