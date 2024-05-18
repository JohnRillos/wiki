/-  *wiki
|%
::
+$  card  card:agent:gall
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