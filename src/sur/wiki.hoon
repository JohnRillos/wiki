|%
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
      [%del-book id=@ta]
      [%mod-book-name id=@ta title=@t]
      :: [%mod-rule-read id=@ta public-read=?]
      :: [%mod-rule-edit id=@ta public-edit=?]
      [%new-page book-id=@ta =path title=@t content=wain]
      [%del-page book-id=@ta =path]
      [%mod-page book-id=@ta =path title=(unit @t) content=(unit wain)]
      [%imp-file book-id=@ta files=(map path wain) =title-source]
      :: [%knight book-id=@ta =ship]
      :: [%demote book-id=@ta =ship]
      :: [%banish book-id=@ta =ship]
      :: [%pardon book-id=@ta =ship]
  ==
::
+$  wiki-path  [%wiki book-id=@ta loc=path]
::
+$  title-source  ?(%header %filename)
::
--