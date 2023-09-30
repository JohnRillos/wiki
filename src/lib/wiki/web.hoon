::
:: page-rendering utility
::
/+  rudder, *wiki
|%
::
++  form-data
  |=  =order:rudder
  ^-  (map @t @t)
  ?~  body.request.order  ~
  (frisk:rudder q.u.body.request.order)
::
++  sane-url
  |=  =cord
  ^-  [=path query=tape]
  =/  [pre=tape suf=tape]  (split-on (trip cord) '?')
  [(stab (crip pre)) suf]
::
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
  .^(@t %cx (weld /[(crip <our.bowl>)]/wiki/[(crip <now.bowl>)] path))
::
++  stub
  ^-  manx
  ;div(style "display: none");
::
++  footer  :: to-do add a log out button
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