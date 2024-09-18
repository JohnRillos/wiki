|%
::
::  current state type
::
+$  state-x  state-7
::
++  our-era  %7
::
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
      state-4
      state-5
      state-6
      state-7
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
+$  state-4
  $+  state-4
  $:  %4
    wordy=_|
    early=(list cage)
    =later
    shelf=shelf-1
    books=(map @ta book-3)
  ==
::
+$  state-5
  $+  state-5
  $:  %5
    wordy=_|
    early=(list cage)
    =later
    shelf=shelf-1
    books=(map @ta book-4)
  ==
::
+$  state-6
  $+  state-6
  $:  %6
    =ether
    wordy=_|
    early=(list cage)
    =later
    shelf=shelf-1
    books=(map @ta book-4)
  ==
::
+$  state-7
  $+  state-7
  $:  %7
    faves=(set flag)
    =ether
    wordy=_|
    early=(list cage)
    =later
    shelf=shelf-1
    books=(map @ta book-4)
  ==
::
+$  book
  $+  book
  $:  crest=(unit image)
      theme=(each @tas @t)
      title=@t
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
+$  flag  [host=@p id=@ta]
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
      [%mod-logo id=@ta logo=(unit image)]
      [%mod-look id=@ta theme=(each @tas @t)]
      [%new-page book-id=@ta =path title=@t content=wain]
      [%del-page book-id=@ta =path]
      [%mod-page book-id=@ta =path title=(unit @t) content=(unit wain)]
      [%imp-file book-id=@ta files=(map @t wain) =title-source del-missing=?]
      [%set-verb wordy=?]
      [%eth-auth who=@p secret=@uv address=tape signature=tape]
      [%add-fave =flag]
      [%del-fave =flag]
  ==
::
+$  wiki-path  [[book-id=@ta loc=path] host=(unit @p)]
::
+$  ether
  $:  challenges=(set @uv)
      users=(map comet=@p id=@p)
  ==
::
+$  title-source  ?(%header %filename %front-matter)
::
+$  cover
  $+  cover
  $:  era=@ud
      book-id=@ta
      theme=(unit @tas)
      title=@t
      rules=access
      stamp=@da
  ==
::
+$  shelf    $+(shelf (map [host=@p id=@ta] spine))
::
+$  spine    $+(spine [=cover toc=(map path ref)])
::
+$  ref      $+(ref [ver=@ edited=@da title=@t])
::
+$  booklet  [=cover =path =tale]
::
+$  rudyard  [state-x spine=(unit spine) booklet=(unit booklet) asset=(unit mime) logo=(unit (unit image))]
::
+$  image
  $%  [%url url=@t]
      [%svg svg=@t]
  ==
::
::
::
+$  lore
  $%  [%lurn =shelf]
      [%burn host=@p id=@ta at=@da]
  ==
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
+$  book-2
  $+  book-2
  $:  title=@t
      tales=(map path tale)
      rules=access
      stamp=@da
  ==
::
+$  lore-0
  $+  lore-0
  $%  [%lurn shelf=shelf-0]
      [%burn host=@p id=@ta at=@da]
  ==
::
+$  shelf-0    $+(shelf-0 (map [host=@p id=@ta] spine-0))
+$  spine-0    $+(spine-0 [cover=cover-0 toc=(map path ref)])
+$  booklet-0  [cover=cover-0 =path =tale]
+$  cover-0
  $+  cover-0
  $:  book-id=@ta
      title=@t
      rules=access
      stamp=@da
  ==
::
::  state-4
::
+$  book-3
  $+  book-3
  $:  theme=(each @tas @t)
      title=@t
      tales=(map path tale)
      rules=access
      stamp=@da
  ==
::
+$  lore-1     lore
+$  shelf-1    shelf
+$  spine-1    spine
+$  booklet-1  booklet
+$  cover-1    cover
::
::  state-5
::
+$  book-4  book
::
--