|%
::
::  current state type
::
+$  state-x  state-3
::
++  our-era  %3
::
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
  ==
::
+$  state-0
  $:  %0
    books=(map @ta book-0)
  ==
::
+$  state-1
  $:  %1
    books=(map @ta book-1)
  ==
::
+$  state-2
  $+  state-2
  $:  %2
    =later
    shelf=shelf-0
    books=(map @ta book-2)
  ==
::
+$  state-3
  $+  state-3
  $:  %3
    early=(list cage)
    =later
    shelf=shelf-0
    books=(map @ta book-2)
  ==
::
:: todo: track favorite wikis manually, using plain subscription instead of gossip
::   tbd: mirror full contents or only index
::   tbd: include in `shelf` or separate
::
+$  book
  $+  book
  $:  title=@t
      tales=(map path tale)
      rules=access
      stamp=@da
  ==
::
+$  tale
  $+  tale
  ((mop @da page) gth)
::
++  ton   ((on @da page) gth)
::
++  latest
  |=  =tale
  ^-  [=time =page]
  ~+
  (need (pry:ton tale))
::
+$  page
  $+  page
  $:  title=@t
      content=wain
      edit-by=@p
  ==
::
+$  access
  $:  read=rule-read
      edit=rule-edit
  ==
::
+$  rule-read  [public=? urth=? scry=? goss=?]
::
+$  rule-edit  ?([public=%.n comet=%.n] [public=%.y comet=?])
::
+$  relay  [%relay to=@p eyre-id=@ta =action]
::
+$  old-goss  [%old-goss =cage]
::
+$  action
  $+  wiki-action
  $%  [%new-book id=@ta title=@t rules=access]
      [%del-book id=@ta]
      [%mod-book-name id=@ta title=@t]
      [%mod-rule-read id=@ta =rule-read]
      [%mod-rule-edit id=@ta =rule-edit]
      [%new-page book-id=@ta =path title=@t content=wain]
      [%del-page book-id=@ta =path]
      [%mod-page book-id=@ta =path title=(unit @t) content=(unit wain)]
      [%imp-file book-id=@ta files=(map @t wain) =title-source del-missing=?]
  ==
::
+$  wiki-path  [[book-id=@ta loc=path] host=(unit @p)]
::
+$  title-source  ?(%header %filename %front-matter)
::
+$  cover
  $+  cover
  $:  book-id=@ta
      title=@t
      rules=access
      stamp=@da
  ==
::
+$  shelf    $+(shelf (map [host=@p id=@ta] spine))
::
+$  spine    $+(spine [=cover toc=(map path ref)])
::
+$  ref      [ver=@ edited=@da title=@t]
::
+$  booklet  [=cover =path =tale]
::
+$  rudyard  [state-x spine=(unit spine) booklet=(unit booklet)]
::
::
::
+$  lore
  $%  [%lurn =shelf]
      [%burn host=@p id=@ta at=@da]
  ==
::
::
::  eyre requests awaiting poke-ack before responding
::
+$  later  (map @ta wait) :: @ta = previous eyre-id (form submit)
::
+$  wait
  $:  =time
      pending-eyre-id=(unit @ta)
      done=?
      error=(unit tang)
  ==
::
::  facts from newer versions of %wiki, to be consumed on-load
::
+$  early  (list cage)
::
::  state-0
::
+$  book-0
  $:  title=@t
      tales=(map path tale-0)
      rules=access-0
  ==
::
+$  tale-0  ((mop @da page-0) gth)
::
+$  page-0  [title=@t content=wain]
::
+$  access-0  [public-read=?]
::
::  state-1
::
+$  book-1
  $:  title=@t
      tales=(map path tale)
      rules=access-1
  ==
::
+$  page-1  [title=@t content=wain edit-by=@p]
::
+$  access-1  [public-read=? edit=rule-edit]
::
::  state-3
::
+$  book-2     book
+$  lore-0     lore
+$  shelf-0    shelf
+$  spine-0    spine
+$  cover-0    cover
+$  booklet-0  booklet
::
--