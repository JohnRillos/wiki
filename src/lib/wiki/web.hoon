::
:: page-rendering utility
::
/+  rudder, *wiki
/*  globe-svg   %svg   /web/wiki/icons/globe/svg
/*  lock-svg    %svg   /web/wiki/icons/lock/svg
::
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
:: ++  splice
::   |=  [=manx =mart]
::   ^-  ^manx
::   =/  atts  `(list (pair mane tape))`a.g.manx
::   %=  manx
::     a.g  ~(tap by (~(gas by (my atts)) mart))
::   ==
::
:: ++  follow
::   |=  [=manx attributes=(list [@tas tape])]
::   ^-  ^manx
::   %+  splice  manx
::   :~  [%hx-target "body"]
::       [%hx-swap "outerHTML"]
::       [%hx-push-url "true"]
::   ==
::
++  confirm
  |=  =tape
  ^-  ^tape
  (weld "return confirm('" (weld tape "');"))
::
++  in-form
  |=  [warn=tape content=manx]
  ;form(method "post", onsubmit (confirm warn))
    ;+  content
  ==
::
++  stub
  ^-  manx
  ;div(style "display: none");
::
++  global-nav
  |=  [=bowl:gall =order:rudder wik=[id=@ta =book]]
  ^-  manx
  =/  site=@t  url.request.order
  ;nav.sidebar
    ;a#wiki-title/"/wiki/{(trip id.wik)}": {(trip title.book.wik)}
    ;div#global-menu
      ;+  ?:  =(%pawn (clan:title src.bowl))
            ;a/"/~/login?redirect={(trip site)}": Log in with Urbit
          ?:  =(src.bowl our.bowl)  ;a/"/wiki": Your Wikis
          ;a/"/apps/landscape/perma?ext=web+urbitgraph://~holnes/wiki/"
            ; Made with %wiki
          ==
    ==
  ==
::
++  footer
  |=  [=bowl:gall site=cord]
  ^-  manx
  ;footer
    ;a/"https://urbit.org": Powered by Urbit
  ==
::
++  icon
  |%
::
  ++  globe
    ^~
    ;div.access-icon(title "public")
      ;+  (need (de-xml:html globe-svg))
    ==
  ::
  ++  lock
    ^~
    ;div.access-icon(title "private")
      ;+  (need (de-xml:html lock-svg))
    ==
  --
--