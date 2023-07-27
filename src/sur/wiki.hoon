|%
::
+$  book
  $:  title=@t
      pages=(map @tas page)
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
  $%  [%new-book id=@tas title=@t rules=access]
      [%mod-book-name id=@tas title=@t]
      :: [%mod-rule-read id=@tas public-read=?]
      :: [%mod-rule-edit id=@tas public-edit=?]
      [%new-page book-id=@tas id=@tas title=@t content=tape]
      [%mod-page book-id=@tas id=@tas title=(unit @t) content=(unit tape)]
      [%del-page book-id=@tas id=@tas]
      :: [%knight book-id=@tas =ship]
      :: [%demote book-id=@tas =ship]
      :: [%banish book-id=@tas =ship]
      :: [%pardon book-id=@tas =ship]
  ==
::
--