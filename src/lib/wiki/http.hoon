::
:: HTTP routing utility
::
/-  *wiki
/+  rudder
/~  web  (page:rudder state-0 action)  /web/wiki/pages
::
|_  state-0
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
        [@ta ~]                 `[%page auth %book]
        [@ta sig %new ~]        `[%page & %new-page]
        [@ta sig %import ~]     `[%page & %import]
        [@ta sig %settings ~]   `[%page & %book-settings]
        [@ta sig %not-found ~]  `[%page auth %page-not-found]
      ==
  ::
  ++  far :: to-do: wrap remote-compatible paths ^
    |$  pattern
    ?([sig %p @ta pattern] pattern)
  ::
  ++  auth
    ^-  ?
    =/  book-id=@ta  -.pat
    ?~  book=(~(get by books) book-id)  &
    !public-read.rules.u.book
  ::
  ++  tail-fas  ?=([%$ *] (flop pat)) :: detect trailing /
  ::
  ++  page-resource
    ^-  (unit place:rudder)
    :-  ~
    :-  %page
    =/  n=@  (lent pat)
    ?:  (lth n 3)        [auth %page]
    =/  suf=path  (slag (sub n 2) pat)
    ?+  suf              [auth %page]
      [sig %edit ~]      [& %edit-page]
      [sig %history ~]   [auth %history]
      [sig %download ~]  [auth %download]
    ==
  --
::
--