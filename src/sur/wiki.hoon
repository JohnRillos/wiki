|%
::
+$  versioned-state
  $%  state-0
      state-1
      state-2
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
  $:  %2
    =later
    =shelf
    books=(map @ta book)
  ==
::
:: todo: track favorite wikis manually, using plain subscription instead of gossip
::   tbd: mirror full contents or only index
::   tbd: include in `shelf` or separate
::
+$  book
  $:  title=@t
      tales=(map path tale)
      rules=access
  ==
::
+$  tale  ((mop @da page) gth)
::
++  ton   ((on @da page) gth)
::
++  latest
  |=  =tale
  ^-  [time=@da =page]
  (need (pry:ton tale))
::
+$  page
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
+$  action
  $%  [%new-book id=@ta title=@t rules=access]
      [%del-book id=@ta]
      [%mod-book-name id=@ta title=@t]
      [%mod-rule-read id=@ta =rule-read]
      [%mod-rule-edit id=@ta =rule-edit]
      [%new-page book-id=@ta =path title=@t content=wain]
      [%del-page book-id=@ta =path]
      [%mod-page book-id=@ta =path title=(unit @t) content=(unit wain)]
      [%imp-file book-id=@ta files=(map @t wain) =title-source del-missing=?]
      :: [%knight book-id=@ta =ship]
      :: [%demote book-id=@ta =ship]
      :: [%banish book-id=@ta =ship]
      :: [%pardon book-id=@ta =ship]
  ==
::
+$  wiki-path  [[book-id=@ta loc=path] host=(unit @p)]
::
+$  title-source  ?(%header %filename %front-matter)
::
+$  cover
  $:  book-id=@ta
      title=@t
      rules=access
  ==
::
+$  shelf    (map [host=@p id=@ta] spine)
::
+$  spine    [=cover toc=(map path ref) as-of=@da]
::
+$  ref      [ver=@ edited=@da title=@t]
::
+$  booklet  [=cover =path =tale]
::
+$  rudyard  [state-2 spine=(unit spine) booklet=(unit booklet)]
::
::
::
+$  lore  shelf
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
::
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
::
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
--