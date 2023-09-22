/-  *wiki
/+  rudder
/~  web  (page:rudder (map @ta book) action)  /web/wiki
::
|_  books=(map @ta book)
::
+$  sig  %~.~
::
++  http-route
  ^-  route:rudder
  |=  =trail:rudder
  ^-  (unit place:rudder)
  ?^  point=((point:rudder /wiki & ~(key by web)) trail)
    point
  =/  site=(list @t)  site.trail
  =/  pat=(unit (pole knot))  (decap:rudder /wiki site)
  ?~  pat  ~
  |^  ?+  u.pat               sans-fas
        [sig %new ~]          `[%page & %new-book]
        [@ta ~]               `[%page auth %book]
        [@ta sig %new ~]      `[%page & %new-page]
        [@ta *]               page-resource
      ==
  ::
  ++  auth
    ^-  ?
    =/  book-id=@ta  -.u.pat
    ?~  book=(~(get by books) book-id)  &
    !public-read.rules.u.book
  ::
  ++  sans-fas :: trim leading / or 404
    ^-  (unit place:rudder)
    ?.  ?=([%$ *] (flop u.pat))  ~
    `[%away (snip site)]
  ::
  ++  page-resource
    ^-  (unit place:rudder)
    :-  ~
    :-  %page
    =/  n=@  (lent u.pat)
    ?:  (lth n 3)        [auth %page]
    =/  suf=path  (slag (sub n 2) u.pat)
    ?+  suf              [auth %page]
      [sig %edit ~]     [& %edit-page]
      [sig %history ~]  [auth %history]
    ==
  --
::
--