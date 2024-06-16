/-  *wiki
|%
::
+$  card  card:agent:gall
::
++  grad-4
  |%
  ++  state
    |=  old=state-3
    ^-  state-4
    %=  old
      -  %4
      shelf  (~(run by shelf.old) grad-spine)
      books  (~(run by books.old) grad-book)
    ==
  ::
  ++  grad-booklet
    |=  =booklet-0
    ^-  booklet-1
    booklet-0(cover (grad-cover cover.booklet-0))
  ::
  ++  grad-spine
    |=  =spine-0
    ^-  spine-1
    spine-0(cover (grad-cover cover.spine-0))
  ::
  ++  grad-cover
    |=  =cover-0
    ^-  cover-1
    :-  book-id.cover-0
    [`%default +.cover-0]
  ::
  ++  grad-book
    |=  =book-2
    ^-  book-3
    [[%& %default] book-2]
  ::
  ++  grad-lore
    |=  =lore-0
    ^-  lore-1
    ?-  -.lore-0
      %burn  lore-0
      %lurn  [-.lore-0 (~(run by shelf.lore-0) grad-spine)]
    ==
  --
::
++  grad-3
  |%
  ++  state
    |=  old=state-2
    ^-  state-3
    [%3 ~ +.old]
  --
::
++  grad-2
  |%
  ++  state
    |=  =state-1
    ^-  state-2
    |^  [%2 ~ ~ grad-books]
    ::
    ++  grad-books
      ^-  (map @ta book-2)
      %-  ~(run by books.state-1)
      |=  =book-1
      :^    title.book-1
          tales.book-1
        (grad-rules rules.book-1)
      %-  (curr roll max)
      %+  turn  ~(val by tales.book-1)
      |=(=tale time:(latest tale))
    ::
    ++  grad-rules
      |=  =access-1
      ^-  access
      access-1(- ?:(public-read.access-1 [& & | |] [| | | |]))
    --
  --
::
++  grad-1
  |%
  ++  state
    |=  [=state-0 =bowl:gall]
    ^-  state-1
    |^  [%1 (~(run by books.state-0) grad-book)]
    ::
    ++  grad-book
      |=  =book-0
      ^-  book-1
      %=  book-0
        tales  (~(run by tales.book-0) grad-tale)
        rules  (grad-rules rules.book-0)
      ==
    ::
    ++  grad-tale
      |=  =tale-0
      ^-  tale
      (~(run by tale-0) grad-page)
    ::
    ++  grad-page
      |=  =page-0
      ^-  page
      %=  page-0
        content  [content.page-0 our.bowl]
      ==
    ::
    ++  grad-rules
      |=  =access-0
      ^-  access-1
      [public-read.access-0 [%.n %.n]]
    --
  --
--