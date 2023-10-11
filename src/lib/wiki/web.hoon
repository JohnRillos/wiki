::
:: page-rendering utility
::
/-  *wiki
/+  multipart, regex, rudder, string, *wiki
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
++  wiki-url
  |=  =cord
  ^-  [=wiki-path query=(map @t @t)]
  =/  [=path que=(map @t @t)]  (sane-url cord)
  [(wiki-path path) que]
::
++  sane-url
  |=  =cord
  ~+
  ^-  [=path query=(map @t @t)]
  =/  [pre=tape suf=tape]  (split-on (trip cord) '?')
  :-  (stab (crip pre))
  (parse-query suf)
::
++  parse-query
  |=  query=tape
  ^-  (map @t @t)
  ?:  =(~ query)  ~
  (frisk:rudder (crip query))
::
++  query-msg
  |=  query=(map @t @t)
  ^-  (unit tape)
  =/  msg=(unit @t)  (~(get by query) 'msg')
  ?~  msg  ~
  (de-urlt:html (trip u.msg))
::
++  multipart-map
  |=  =order:rudder
  ^-  (map @t (list part:multipart))
  =/  parts=(unit (list [input=@t =part:multipart]))
    (de-request:multipart header-list.request.order body.request.order)
  ?~  parts  ~
  %+  roll  u.parts
  |=  [p=[input=@t =part:multipart] acc=(map @t (list part:multipart))]
  ?.  (~(has by acc) input.p)  (~(put by acc) input.p ~[part.p])
  (~(put by acc) input.p (snoc (~(got by acc) input.p) part.p))
::
:: todo: move file upload parsing to new lib maybe
::
++  get-md-files
  |=  multi=(list part:multipart)
  ^-  (map path tape)
  %-  my
  ^-  (list (pair path tape))
  (murn multi parse-md-file)
::
++  parse-md-file
  |=  =part:multipart
  ^-  (unit [=path data=tape])
  ?~  type.part  ~
  ?.  =(~['text/markdown'] u.type.part)  ~
  ?~  file.part  ~
  =/  data=tape  (trip body.part)
  |^  `[(parse-filepath u.file.part) data]
  ::
  ++  invalid-knot-char  "[^0-9a-z\\-_~\\.]"
  ::
  ++  parse-filepath
    |=  filepath=@t
    ^-  path
    =/  split=(list tape)  (split:string "/" (trip filepath))
    ?<  =(~ split)
    =.  split  +.split :: remove redundant first path segment
    =|  out=path
    |-
    ?:  =(~ split)  out
    =/  seg=@ta
      %-  coerce-to-knot
      ?.  =(~ +.split)  -.split
      (remove-extension -.split)
    $(out (snoc out seg), split +.split)
  ::
  ++  coerce-to-knot
    |=  =tape
    ^-  knot
    (crip (gsub:regex invalid-knot-char "-" (cass tape)))
  ::
  ++  remove-extension
    |=  =tape
    (flop r:(partition:string "." (flop tape)))
  --
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
      ;a/"/wiki/{(trip id.wik)}": Home
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