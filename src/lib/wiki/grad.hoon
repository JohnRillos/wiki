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
      shelf  (shelf-0-to-1 shelf.old)
      books  (~(run by books.old) book-2-to-3)
    ==
  ::
  ++  book-2-to-3
    |=  old=book-2
    ^-  book-3
    [~ old]
  ::
  ++  lore-0-to-1
    |=  old=lore-0
    ^-  lore-1
    ?-  -.old
      %burn  old
      %lurn  [-.old (shelf-0-to-1 shelf.old)]
    ==
  ::
  ++  shelf-0-to-1
    |=  old=shelf-0
    ^-  shelf-1
    (~(run by old) spine-0-to-1)
  ::
  ++  spine-0-to-1
    |=  old=spine-0
    ^-  spine-1
    [[~ cover.old] toc.old]
  ::
  ++  booklet-0-to-1
    |=  old=booklet-0
    ^-  booklet-1
    [[~ cover.old] +.old]
  ::
  ++  cards
    |=  [=state-3 =bowl:gall]
    ^-  (list card)
    :: todo: cards -> re-grow all /booklet-0 + /spine-0 paths -> /booklet & /spine
    ~
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