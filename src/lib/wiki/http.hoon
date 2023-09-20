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
        [@ta sig %edit *]     `[%page & %edit-page]
        [@ta sig %history *]  `[%page auth %history]
        [@ta *]               `[%page auth %page]
        :: to-do: see if /~/edit and /~/history can be moved to end of path
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