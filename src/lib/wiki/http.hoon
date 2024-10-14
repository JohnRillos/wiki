::
:: HTTP routing utility
::
/-  *wiki
/+  rudder
/~  web  (page:rudder rudyard relay)  /web/wiki/pages
::
|_  rudyard
::
+$  sig  %~.~
::
++  http-route
  ^-  route:rudder
  |=  =trail:rudder
  ^-  (unit place:rudder)
  =/  site=(list @t)  site.trail
  =/  pat=(pole knot)  (need (decap:rudder /wiki site))
  |^  ?:  tail-fas                    `[%away (snip site)]
      :-  ~
      :-  %page
      ?+  pat                               page-resource
        ~                                   [& %index]
        [sig %assets *]                     [| %asset]
        [sig %auth ~]                       [| %mask-auth]
        [sig %new ~]                        [& %new-book]
        [sig %search ~]                     [& %search-all]
        [sig %x %faves *]                   [| %hx-fave]
        [sig %x %search ~]                  [& %hx-search]
        (far [@ta ~])                       [r-auth %book]
        (far [@ta sig %assets *])           [| %book-asset]
        (far [@ta sig %new ~])              [w-auth %new-page]
        (far [@ta sig %import ~])           [w-auth %import]
        (far [@ta sig %settings ~])         [& %book-settings]
        (far [@ta sig %settings %theme ~])  [& %edit-theme]
        [@ta sig %not-found ~]              [r-auth %page-not-found]
        (far [@ta sig %x %front ~])         [r-auth %hx-front]
        (far [@ta sig %x %logo ~])          [r-auth %hx-logo]
        (far [@ta sig %x %search ~])        [r-auth %hx-search]
      ==
  ::
  ++  far
    |$  pattern
    ?([sig %p @ta pattern] pattern)
  ::
  ++  r-auth
    ^-  ?
    =/  book-id=@ta  -.pat
    ?~  book=(~(get by books) book-id)  &
    !public.read.rules.u.book
  ::
  ++  w-auth
    ^-  ?
    =/  book-id=@ta  -.pat
    ?~  book=(~(get by books) book-id)  &
    |(!public.read.rules.u.book !public.edit.rules.u.book)
  ::
  ++  tail-fas  ?=([%$ *] (flop pat)) :: detect trailing /
  ::
  ++  page-resource
    ^-  [? @tas]
    =/  n=@  (lent pat)
    ?:  (lth n 3)        [r-auth %page]
    =/  suf=path  (slag (sub n 2) pat)
    ?+  suf              [r-auth %page]
      [sig %edit ~]      [w-auth %edit-page]
      [sig %history ~]   [r-auth %history]
      [sig %download ~]  [r-auth %download]
    ==
  --
::
++  eyre-request
  |=  [=bowl:gall eyre-id=@ta]
  ^-  (unit inbound-request:eyre)
  |^  %+  bind  (~(get by connections) eyre-id)
      |=(con=outstanding-connection:eyre inbound-request:con)
  ::
  ++  connections
    ^-  (map @ta outstanding-connection:eyre)
    =/  scry-path=path  /(scot %p our.bowl)/connections/(scot %da now.bowl)
    =/  raw  .^((map duct outstanding-connection:eyre) %e scry-path)
    %-  my
    %+  murn  ~(tap by raw)
    |=  [=duct con=outstanding-connection:eyre]
    ^-  (unit (pair @ta outstanding-connection:eyre))
    `[(duct-to-eyre-id duct) con]
  ::
  ++  duct-to-eyre-id
    |=  =duct
    (scot %ta (cat 3 'eyre_' (scot %uv (sham duct))))
  --
::
--