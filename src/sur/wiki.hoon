|%
::
+$  book
  $:  title=@t
      pages=(map @ta page) :: todo: (map path page) or similar
      rules=access
  ==
::
+$  page
  $:  title=@t
      content=tape
  ==
::
+$  access
  $:  public-read=?
      :: public-edit=?
      :: mods=(set @p)
      :: bans=(set @p)
  ==
::
+$  action
  $%  [%new-book id=@ta title=@t rules=access]
      [%mod-book-name id=@ta title=@t]
      :: [%mod-rule-read id=@ta public-read=?]
      :: [%mod-rule-edit id=@ta public-edit=?]
      [%new-page book-id=@ta id=@ta title=@t content=tape]
      [%mod-page book-id=@ta id=@ta title=(unit @t) content=(unit tape)]
      [%del-page book-id=@ta id=@ta]
      :: [%knight book-id=@ta =ship]
      :: [%demote book-id=@ta =ship]
      :: [%banish book-id=@ta =ship]
      :: [%pardon book-id=@ta =ship]
  ==
::
--