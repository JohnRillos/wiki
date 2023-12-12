/-  *wiki
=,  dejs:format
|%
::
++  dj-action
  ^-  $-(json action)
  (of [%imp-file dj-imp-file] ~)
::
++  dj-imp-file
  ^-  $-(json [book-id=@ta files=(map @t wain) =title-source del-missing=?])
  %-  ot
  :~  ['bookId' so]
      ['files' (om dj-wain)]
      ['titleSource' dj-title-source]
      ['delMissing' bo]
  ==
::
++  dj-title-source
    |=  =json
    =/  =cord  (so json)
    ?>  ?=(title-source cord)
    cord
::
++  dj-wain
  |=  =json
  (to-wain:format (so json))
--