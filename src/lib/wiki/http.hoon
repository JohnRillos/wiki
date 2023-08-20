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
        [sig %new ~]          `[%page auth %new-book]
        [bid=@ta ~]           `[%page auth %book]
        [bid=@ta sig %new ~]  `[%page auth %new-page]
        [bid=@ta pid=@ta ~]   `[%page auth %page]
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
  --
::
--