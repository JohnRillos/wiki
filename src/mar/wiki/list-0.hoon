/-  *wiki
::
|_  wist=(list blurb-0)
++  grad  %noun
++  grow
  |%
  ++  noun  wist
  ++  json
    :-  %a
    %+  turn  wist
    |=  b=blurb-0
    %-  pairs:enjs:format
    :~  ['host' %s (scot %p host.b)]
        ['id' %s id.b]
        ['title' %s title.b]
        ['public' %b public.b]
        ['mustLogin' %b must-login.b]
        ['pageCount' (numb:enjs:format page-count.b)]
        ['edited' (time:enjs:format edited.b)]
    ==
  --
::
++  grab
  |%
  ++  noun  (list blurb-0)
  --
--