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
  |^  ?:  tail-fas              `[%away (snip site)]
      ?+  pat                   page-resource
        ~                             `[%page & %index]
        [sig %assets *]               `[%page | %asset]
        [sig %new ~]                  `[%page & %new-book]
        [sig %search ~]               `[%page & %search-all]
        [sig %x %search ~]            `[%page & %hx-search]
        (far [@ta ~])                 `[%page r-auth %book]
        (far [@ta sig %new ~])        `[%page w-auth %new-page]
        (far [@ta sig %import ~])     `[%page w-auth %import]
        (far [@ta sig %settings ~])   `[%page & %book-settings]
        [@ta sig %not-found ~]        `[%page r-auth %page-not-found]
        :: (far [@ta sig %x %front ~])   `[%page r-auth %hx-front] :: todo make this page
        (far [@ta sig %x %search ~])  `[%page r-auth %hx-search]
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
    !urth.read.rules.u.book
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
    ^-  (unit place:rudder)
    :-  ~
    :-  %page
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