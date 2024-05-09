/-  *wiki
|%
::
++  book-to-cover
  |=  [id=@ta =book]
  ^-  cover
  =,  book
  =/  front-at=(unit @da)
    ?~  front  ~
    (some time:(latest front))
  [front-at id title rules stamp]
::
++  book-to-spine
  |=  [id=@ta =book]
  ^-  spine
  :-  (book-to-cover id book)
  %-  ~(run by tales.book)
  |=  =tale
  =/  [time=@da =page]  (latest tale)
  =/  ver=@  (dec (wyt:ton tale))
  [ver time title.page]
::
--