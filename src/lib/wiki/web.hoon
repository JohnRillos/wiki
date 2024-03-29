::
:: page-rendering utility
::
/-  *wiki
/+  multipart, regex, rudder, server, string, *wiki
/$  html-to-mime     %html  %mime
/*  htmx-js          %js   /web/htmx/js
/*  show-on-load-js  %js   /web/wiki/show-on-load/js
/*  globe-svg        %svg  /web/wiki/icons/globe/svg
/*  lock-svg         %svg  /web/wiki/icons/lock/svg
/*  search-svg       %svg  /web/wiki/icons/search/svg
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
  ~+
  ^-  [=wiki-path query=(map @t @t)]
  =/  [=path que=(map @t @t)]  (sane-url cord)
  [(to-wiki-path path) que]
::
++  to-wiki-path
  |=  pat=(pole knot)
  ^-  wiki-path
  ~|  'Invalid path'
  ?+  pat  !!
  ::
      [%wiki %~.~ %p p=@ta l=[@ta *]]
    :-  l.pat
    ~|  "Invalid @p: {(trip p.pat)}"
    `(slav %p p.pat)
  ::
    [%wiki @ta *]  [+.pat ~]
  ==
::
++  sane-url
  |=  =cord
  ~+
  ^-  [=path query=(map @t @t)]
  =/  [pre=tape suf=tape]  (split-on (trip cord) '?')
  :-  (stab (crip (sans-fas pre)))
  (parse-query suf)
::
++  sans-fas
  |=  =tape
  |-
  ?:  (lte (lent tape) 1)  tape
  ?.  =('/' (rear tape))   tape
  $(tape (flop (tail (flop tape))))
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
  |=  [multi=(list part:multipart) filepaths=(list part:multipart)]
  ^-  (map @t wain)
  ~&  "parsing multipart/form-data - # of items: {<(lent multi)>}"
  %-  my
  ^-  (list (pair @t wain))
  |^  (murn files-with-paths parse-md-file)
  ::
  ::  replace filename w/ webkitRelativeDirectory (needed for Safari)
  ::
  ++  files-with-paths
    ^-  (list part:multipart)
    ?.  =((lent multi) (lent filepaths))  multi
    %+  roll  multi
    |=  [file=part:multipart acc=(list part:multipart)]
    ^-  _acc
    =/  dir=part:multipart  (snag (lent acc) filepaths)
    =.  file.file :: only replace if path ends with filename
      ?~  file.file  ~
      ?:  (ends-with body.dir u.file.file)  `body.dir
      file.file
    (snoc acc file)
  ::
  ++  ends-with
    |=  [tex=@t end=@t]
    =/  text  (trip tex)
    =/  suff  (trip end)
    ?:  (lth (lent text) (lent suff))  %.n
    =/  i=@  (sub (lent text) (lent suff))
    =((slag i text) suff)
  ::
  ++  parse-md-file
    |=  =part:multipart
    ^-  (unit [filepath=@t data=wain])
    ?~  file.part
      ~&  "file ignored, no filename - type: {<type.part>}"  ~
    ?:  =(~ u.file.part)
      ~&  "file ignored, empty filename - type: {<type.part>}"  ~
    ?~  type.part
      ~&  "file ignored, no MIME type: {<u.file.part>}"  ~
    ?.  =(~['text/markdown'] u.type.part)
      ~&  "file ignored, not markdown: {<u.type.part>} {<u.file.part>}"  ~
    =/  data=wain  (to-wain:format (sane-newline body.part))
    ~&  "parsed: {(trip u.file.part)}"
    `[u.file.part data]
  --
::
++  parse-filepath
  |=  filepath=@t
  ^-  [=path filename=tape]
  =/  split=(list tape)
    %+  skip  (split:string "/" (trip filepath))
    (curr test ~)
  ?:  =(1 (lent split))  ~|("Filepath does not contain folder hierarchy" !!)
  ?:  =(0 (lent split))  ~|("Empty filepath" !!)
  :_  (rear split)
  =.  split  +.split :: remove redundant first path segment
  =|  out=path
  |^  |-
      ?:  =(~ split)  out
      =/  seg=@ta
        %-  coerce-to-knot
        ?.  =(~ +.split)  -.split
        (remove-extension -.split)
      $(out (snoc out seg), split +.split)
  ::
  ++  invalid-knot-char  "[^0-9a-z\\-_~\\.]"
  ::
  ++  coerce-to-knot
    |=  =tape
    ^-  knot
    (crip (gsub:regex invalid-knot-char "-" (cass tape)))
  --
::
++  remove-extension
  |=  =tape
  ?~  found=(fand "." tape)  tape
  (scag (rear found) tape)
::
++  base-path
  |=  site=wiki-path
  ^-  tape
  ?~  host.site  (spud /wiki/[book-id.site])
  (spud /wiki/~/p/[(scot %p u.host.site)]/[book-id.site])
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
  (weld "return confirm(`" (weld tape "`);"))
::
++  in-form
  |=  [warn=tape content=manx]
  ;form(method "post", onsubmit (confirm warn))
    ;+  content
  ==
::
++  check-if
  |=  [if=? =manx]
  ^-  ^manx
  ?.  if  manx
  manx(a.g [[%checked ""] a.g.manx])
::
++  disable-if
  |=  [if=? =manx]
  ^-  ^manx
  ?.  if  manx
  manx(a.g [[%disabled ""] a.g.manx])
::
++  stub
  ^-  manx
  ;div(style "display: none");
::
++  disable-on-submit
  |=  [id=tape loading-text=(unit tape)]
  ^-  tape
  %^    sub:regex
      "TEXT_REPLACER"
    ?~  loading-text  ""
    "elem.textContent = '{u.loading-text}';"
  %^    sub:regex
      "ELEM_ID"
    id
  %-  trip
  '''
    document.addEventListener('submit', (event) => {
      var elem = document.getElementById('ELEM_ID');
      elem.setAttribute('disabled', 'true');
      TEXT_REPLACER
    });
  '''
::
++  log-out
  |=  =bowl:gall
  ^-  tape
  """
  function delete_cookie(name, path, domain) \{
    if (get_cookie(name)) \{
      document.cookie = name + "=" +
        ((path) ? ";path=" + path : "")+
        ((domain) ? ";domain=" + domain : "") +
        ";expires=Thu, 01 Jan 1970 00:00:01 GMT";
    }
  }
  function get_cookie(name) \{
    return document.cookie.split(';').some(c => \{
        return c.trim().startsWith(name + '=');
    });
  }
  delete_cookie('urbauth-{<our.bowl>}', '/', window.location.hostname);
  location.reload(true);
  """
::
++  global-nav
  |=  [=bowl:gall =order:rudder data=(each cover book)]
  ^-  manx
  =/  =wiki-path  wiki-path:(wiki-url url.request.order)
  =/  wik-dir=tape  (base-path wiki-path)
  =/  host=(unit @p)  host.wiki-path
  =/  book-title=@t
    ?-  -.data
      %&  title.p.data
      %|  title.p.data
    ==
  ;nav.sidebar
    ;a#wiki-title/"{wik-dir}": {(trip book-title)}
    ;div#global-menu
      ;a/"{wik-dir}": Home
      ;*
      ?:  =(%pawn (clan:title src.bowl))
        :_  ~
        ;a/"/~/login?redirect={(trip url.request.order)}": Log in with Urbit
      =*  my-req  =(src.bowl our.bowl)
      =*  my-wik  ?~(host & =(u.host our.bowl))
      ?.  my-req
        :~  ;p: User: {<src.bowl>}
            ;button
              =type  "button"
              =onclick  (log-out bowl)
              ; Log out
            ==
        ==
      :~  ?.  my-wik  stub
          ;a/"{wik-dir}/~/settings": Settings
          ;a/"/wiki": All Wikis
          ;button
            =type  "button"
            =onclick  (log-out bowl)
            ; Log out
          ==
      ==
    ==
  ==
::
++  doc-head
  |=  [=bowl:gall title=tape]
  ^-  manx
  ;head
    ;title: {title}
    ;meta(charset "utf-8");
    ;meta(name "viewport", content "width=device-width, initial-scale=1");
    ;link/"/wiki/~/assets/favicon-16.png"(rel "icon", type "image/png");
    ;link/"/wiki/~/assets/favicon-32.png"(rel "icon", type "image/png");
    ;link/"/wiki/~/assets/favicon-48.png"(rel "icon", type "image/png");
    ;style: {(style bowl)}
    ;script: {^~((trip htmx-js))}
    ;script: {^~((trip show-on-load-js))}
  ==
::
++  search-keybind-script
  ^~
  %-  trip
  '''
  document.addEventListener("keydown", e => {
    if (e.key.toLowerCase() === 'k' && e.ctrlKey) {
      e.preventDefault();
      document.getElementById("search-input").focus();
    }
  });
  '''
::
++  search-bar
  |=  [book-id=(unit @ta) host=(unit @p)]
  ^-  manx
  =/  search-url=tape
    ?~  book-id    !!  :: todo: global search: /wiki/~/search
    ?~  host       "/wiki/{(trip u.book-id)}/~/search"
    "/wiki/~/p/{<u.host>}/{(trip u.book-id)}/~/search" :: todo: get remote search working
  ;div#search
    ;script: {search-keybind-script}
    ;div#search-bar
      ;+  search:icon
      ;input#search-input
        =type         "search"
        =name         "q"
        =style        "margin-left: 4px"
        =placeholder  "Search (Ctrl-K)"
        =hx-get       search-url
        =hx-params    "*"
        =hx-trigger   "keyup changed delay:100ms, search"
        =hx-target    "#search-results-container"
        ;
      ==
    ==
    ;div#search-results-container;
  ==
::
++  footer
  |=  =(each cover book)
  ^-  manx
  =/  public-read=?  public-read.rules.p.each
  =/  viz=manx
    ?:  public-read
      ;div.note
        ;+  globe:icon
        ;span: This wiki is public
      ==
    ;div.note
      ;+  lock:icon
      ;span: This wiki is private
    ==
  ;footer
    ;+  viz
    ;a/"https://urbit.org": Powered by Urbit
    ;a/"https://github.com/JohnRillos/wiki": Made with %wiki
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
  ::
  ++  search
    ^~
    ;div.search-icon(title "search")
      ;+  (need (de-xml:html search-svg))
    ==
  --
::
::  creates a <span> that can be replaced by a localized timestamp on page load
::
++  timestamp
  |=  =time
  ^-  manx
  =/  millis=tape  (a-co:co (unm:chrono:userlib time))
  ;span.time(millis millis): {<time>}
::
++  relay-response
  |=  [=order:rudder error=(unit tang) =agent:gall]
  ^-  (list card:agent:gall)
  =/  pending-eyre-id=@ta  id.order
  ?~  error
    =.  url.request.order  (crip (weld (spud path:(sane-url url.request.order)) "?fresh=true"))
    =/  result=(quip card:agent:gall _agent)  (on-poke:agent %handle-http-request !>(order))
    -.result
  %+  give-simple-payload:app:server  pending-eyre-id
  ^-  simple-payload:http
  =/  html=@t  (error-to-html u.error)
  [[400 ['content-type' 'text/html']~] `(tail (html-to-mime html))]
::
++  error-to-html :: todo: maybe use manx for this
  |=  =tang
  ^-  @t
  =/  trace=tape
    %-  zing
    %+  join  "<br/>"
    %+  turn  tang
    |=(=tank ~(ram re tank))      
  (crip "<html><body><p>{trace}</p></body></html>")
--