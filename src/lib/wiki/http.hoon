::
:: HTTP routing utility
::
/-  *wiki
/+  rudder
/~  web  (page:rudder state-1 action)  /web/wiki/pages
::
|_  state-1
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
        ~                       `[%page & %index]
        [sig %assets *]         `[%page | %asset]
        [sig %new ~]            `[%page & %new-book]
        [@ta ~]                 `[%page r-auth %book]
        [@ta sig %new ~]        `[%page w-auth %new-page]
        [@ta sig %import ~]     `[%page & %import]
        [@ta sig %settings ~]   `[%page & %book-settings]
        [@ta sig %not-found ~]  `[%page r-auth %page-not-found]
        [@ta sig %search ~]     `[%page r-auth %hx-search]
      ==
  ::
  ++  far :: to-do: wrap remote-compatible paths ^
    |$  pattern
    ?([sig %p @ta pattern] pattern)
  ::
  ++  r-auth
    ^-  ?
    =/  book-id=@ta  -.pat
    ?~  book=(~(get by books) book-id)  &
    !public-read.rules.u.book
  ::
  ++  w-auth  :: maybe use bowl + may-edit here?
    ^-  ?
    =/  book-id=@ta  -.pat
    ?~  book=(~(get by books) book-id)  &
    |(!public-read.rules.u.book !public.edit.rules.u.book)
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
--