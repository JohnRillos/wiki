::
:: page-rendering utility
::
/-  *wiki
/+  multipart, regex, rudder, string, *wiki
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
  ^-  (map @t wain)
  %-  my
  ^-  (list (pair @t wain))
  |^  (murn multi parse-md-file)
  ::
  ++  parse-md-file
    |=  =part:multipart
    ^-  (unit [filepath=@t data=wain])
    ?~  type.part  ~
    ?.  =(~['text/markdown'] u.type.part)
      ~&  >>  "File ignored, not markdown: {<(fall file.part 'no filename')>}"
      ~
    ?~  file.part  ~
    =/  data=wain  (to-wain:format (sane-newline body.part))
    `[u.file.part data]
  --
::
++  parse-filepath
  |=  filepath=@t
  ^-  [=path filename=tape]
  =/  split=(list tape)  (split:string "/" (trip filepath))
  ?<  =(~ split)
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
  |=  [=bowl:gall =order:rudder wik=[id=@ta =book]]
  ^-  manx
  =/  site=@t  url.request.order
  ;nav.sidebar
    ;a#wiki-title/"/wiki/{(trip id.wik)}": {(trip title.book.wik)}
    ;div#global-menu
      ;a/"/wiki/{(trip id.wik)}": Home
      ;*
      ?:  =(%pawn (clan:title src.bowl))
        :_  ~
        ;a/"/~/login?redirect={(trip site)}": Log in with Urbit
      ?.  =(src.bowl our.bowl)
        :~  ;p: User: {<src.bowl>}
            ;button
              =type  "button"
              =onclick  (log-out bowl)
              ; Log out
            ==
        ==
      :~  ;a/"/wiki/{(trip id.wik)}/~/settings": Settings
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
    "/wiki/~/p/{<u.host>}/{(trip u.book-id)}/~/search"
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
  |=  =book
  ^-  manx
  =/  viz=manx
    ?:  public-read.rules.book
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
--