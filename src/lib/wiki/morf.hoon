/-  *wiki
|%
::
++  book-to-cover
  |=  [id=@ta =book]
  ^-  cover
  =,  book
  =/  look=(unit @tas)
    ?:  -.theme
      `+.theme
    ~
  [id look title rules stamp]
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