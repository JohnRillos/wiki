|%
++  style
  |=  =bowl:gall
  (read-file bowl /web/wiki/style/css)
::
++  md-style
  |=  =bowl:gall
  (read-file bowl /web/wiki/md-style/css)
::
:: used instead of /* for frequently edited files with many consumers
:: guarantees consumers can get latest version without rebuilding
::
++  read-file
  |=  [=bowl:gall =path]
  ~+
  ^-  tape
  %-  trip
  .^(@t %cx (weld /[(crip <src.bowl>)]/wiki/[(crip <now.bowl>)] path))
::
++  footer
  |=  [=bowl:gall site=cord]
  ^-  manx
  ;footer
    ;+  ?:  =(%pawn (clan:title src.bowl))
          ;a/"/~/login?redirect={(trip site)}": Log in with Urbit
        ?:  =(src.bowl our.bowl)  ;a/"/wiki": Your wikis
        ;a/"/apps/landscape/perma?ext=web+urbitgraph://~holnes/wiki/"
          ; Made with %wiki
        ==
    ;a/"https://urbit.org": Powered by Urbit
  ==
--