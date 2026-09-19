::  remote wiki probe
::
::    Remote-scries a wiki's host in parallel to learn whether the host is
::    online, whether %wiki is running there, and whether the wiki itself
::    is available. Scries still unanswered at the timeout are cancelled.
::
/-  spider
/+  strandio
=,  strand=strand:spider
|%
::  $echo: what answered before the timeout
::
+$  echo
  $:  host=?            ::  host's %clay answered
      app=?             ::  host's %wiki answered /ping
      book=(unit page)  ::  the wiki's resource, if it had data
  ==
::  +probe: thread for khan's %lard, produces an $echo
::
::    .book is the wiki's published path, e.g. /logo/[book-id]
::
::    We only need to know these exist, so we ask for their first
::    revision: a date-based request can go unanswered when the host's
::    clock is behind ours.
::
++  probe
  |=  [host=ship book=path timeout=@dr]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  now=@da  bind:m  get-time:strandio
  =/  base=path  /g/x/1/wiki/$/1
  =/  spars=(map @tas spar:ames)
    %-  my
    :~  ::  every live ship answers this, whatever apps it runs
        ::
        [%host host /c/z/1/kids]
        [%app host (weld base /ping)]
        [%book host (weld base book)]
    ==
  =/  at=@da  (add now timeout)
  ;<  ~  bind:m
    %-  send-raw-cards:strandio
    :-  [%pass /timeout %arvo %b %wait at]
    %+  turn  ~(tap by spars)
    |=  [k=@tas =spar:ames]
    [%pass /probe/[k] %arvo %a %keen ~ spar]
  (loop spars at [| | ~])
::
++  loop
  |=  [spars=(map @tas spar:ames) at=@da =echo]
  =/  m  (strand ,vase)
  ^-  form:m
  ::  the wiki answering is all we need to know
  ::
  ?:  |(!=(~ book.echo) =(~ spars))
    ;<  ~  bind:m
      %-  send-raw-cards:strandio
      [[%pass /timeout %arvo %b %rest at] (cancel spars)]
    (pure:m !>(echo))
  ;<  [=wire =sign-arvo]  bind:m  take-sign-arvo:strandio
  ?:  ?=([%timeout ~] wire)
    ;<  ~  bind:m  (send-raw-cards:strandio (cancel spars))
    (pure:m !>(echo))
  ?.  &(?=([%probe @ ~] wire) ?=([%ames %sage *] sign-arvo))
    (loop spars at echo)
  ::  any answer at all means they are alive, even an empty one
  ::
  =/  k=@tas  &2.wire
  =/  data=(unit page)  ?~(q.sage.sign-arvo ~ `q.sage.sign-arvo)
  =.  echo
    ?+  k  echo
      %host  echo(host &)
      %app   echo(app &)
      %book  echo(book data, app &)
    ==
  (loop (~(del by spars) k) at echo)
::  +cancel: cancel unanswered scries
::
::    re-send the %keen first: scries sent before %ames knew the peer's
::    keys are missing from its .tip index, which %yawn needs
::
++  cancel
  |=  spars=(map @tas spar:ames)
  ^-  (list card:agent:gall)
  %-  zing
  %+  turn  ~(tap by spars)
  |=  [k=@tas =spar:ames]
  :~  [%pass /probe/[k] %arvo %a %keen ~ spar]
      [%pass /probe/[k] %arvo %a %yawn spar]
  ==
--
