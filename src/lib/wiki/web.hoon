::
:: page-rendering utility
::
/-  *wiki
/+  multipart, regex, rudder, server, string, *wiki
/$  html-to-mime     %html  %mime
/*  htmx-js          %js   /web/htmx/js
/*  mask-auth-js     %js   /web/wiki/mask-auth/js
/*  show-on-load-js  %js   /web/wiki/show-on-load/js
/*  globe-svg        %svg  /web/wiki/icons/globe/svg
/*  info-svg         %svg  /web/wiki/icons/info/svg
/*  load-svg         %svg  /web/wiki/icons/load/svg
/*  lock-svg         %svg  /web/wiki/icons/lock/svg
/*  menu-svg         %svg  /web/wiki/icons/menu/svg
/*  metamask-svg     %svg  /web/wiki/icons/metamask/svg
/*  search-svg       %svg  /web/wiki/icons/search/svg
/*  star-svg         %svg  /web/wiki/icons/star/svg
/*  urbit-svg        %svg  /web/wiki/icons/urbit/svg
::
|_  [=bowl:gall =rudyard]
::
+*  auth  ~(. wiki-auth [bowl ether.rudyard])
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
    =/  ext=(unit tape)  (get-extension (trip u.file.part))
    ?~  ext  ~&  "file ignored, no file extension"  ~
    ?.  =("md" (cass u.ext))
      ~&  "file ignored, not .md: {<u.type.part>} {<u.file.part>}"  ~
    ?.  ?|(=(~['text/markdown'] u.type.part) =(~['application/octet-stream'] u.type.part))
      ~&  "file ignored, invalid MIME type: {<u.type.part>} {<u.file.part>}"  ~
    =/  data=wain  (to-wain:format (sane-newline body.part))
    ~&  "parsed: {(trip u.file.part)}"
    `[u.file.part data]
  ::
  ++  get-extension
    |=  =tape
    ^-  (unit ^tape)
    ?~  found=(fand "." tape)  ~
    `(slag +((rear found)) tape)
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
  ~+
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
++  hide-if
  |=  [if=? =manx]
  ^-  ^manx
  ?.  if  manx
  manx(a.g [[%style "display:none;"] a.g.manx])
::
++  elem-id
  |=  =manx
  ^-  tape
  =/  attributes=(list (pair mane tape))  a.g.manx
  (~(got by (my attributes)) %id)
::
++  disables-other
  |=  [other-ids=(list @t) =manx]
  ^-  ^manx
  =/  scripts=(list tape)
    %+  turn  other-ids
    |=  other-id=@t
    """
    var elem = document.getElementById('{(trip other-id)}')
    elem.setAttribute('disabled', 'true');
    elem.checked = false;
    """
  =/  on-input=tape  (zing (join "\0a" scripts))
  manx(a.g [[%oninput on-input] a.g.manx])
::
++  enables-other
  |=  [other-ids=(list @t) =manx]
  ^-  ^manx
  =/  this-id=tape  (elem-id manx)
  =/  scripts=(list tape)
    %+  turn  other-ids
    |=  other-id=@t
    """
    if (document.getElementById('{this-id}').checked) \{
      document.getElementById('{(trip other-id)}').removeAttribute('disabled');
    } else \{
      document.getElementById('{(trip other-id)}').setAttribute('disabled', 'true');
    }
    """
  =/  on-input=tape  (zing (join "\0a" scripts))
  manx(a.g [[%oninput on-input] a.g.manx])
::
++  toggle-codemirror
  |=  [enables=? =manx]
  ^-  ^manx
  =/  this-id=tape  (elem-id manx)
  =/  read-only=tape  ?:(enables "false" "'nocursor'")
  =/  hidden=tape  ?:(enables "false" "true")
  =/  on-input=tape
    """
    if (document.getElementById('{this-id}').checked) \{
      editor.setOption('readOnly', {read-only});
      document.getElementById('editor-container').hidden = {hidden};
    }
    """
  manx(a.g [[%oninput on-input] a.g.manx])
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
    if (has_cookie(name)) \{
      document.cookie = name + '=; max-age=-1; path=' + path;
    }
  }
  function has_cookie(name) \{
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
  =/  =access
    ?-  -.data
      %&  rules.p.data
      %|  rules.p.data
    ==
  =/  admin=?  (is-admin host access)
  =/  write=?  (may-edit:auth host access)
  =/  check-logo=?
    ?-  -.data
      %&  (gte era.p.data 5)
      %|  &
    ==
  ;nav.sidebar
    ;+  ?:  check-logo
          ;div#logo-container(hx-get "{wik-dir}/~/x/logo", hx-trigger "load");
        ;div#logo-container
          ;img#logo(src "/wiki/~/assets/logo.svg");
        ==
    ;a.wiki-title/"{wik-dir}": {(trip book-title)}
    ;+  (nav-submenu bowl order data)
  ==
::
++  nav-submenu
  |=  [=bowl:gall =order:rudder data=(each cover book)]
  =/  =wiki-path  wiki-path:(wiki-url url.request.order)
  =/  wik-dir=tape  (base-path wiki-path)
  =/  host=(unit @p)  host.wiki-path
  =/  =access
    ?-  -.data
      %&  rules.p.data
      %|  rules.p.data
    ==
  =/  admin=?  (is-admin host access)
  =/  write=?  (may-edit:auth host access)
  =/  =flag  [(fall host our.bowl) book-id.wiki-path]
  ;div#global-menu
    ;a.menu-item/"{wik-dir}": Main Page
    ;+  ?.  write  stub
        ;a.menu-item/"{wik-dir}/~/new": New Page
    ;*
    ?:  =(%pawn (clan:title src:auth))
      :~
        ;button.menu-item(onclick "document.getElementById(\"login\").showModal()")
          ; Log in with Urbit
        ==
      ==
    ?.  =(src:auth our.bowl)
      :~  ;p.menu-item: User: {<src:auth>}
          ;button.menu-item
            =type  "button"
            =onclick  (log-out bowl)
            ; Log Out
          ==
      ==
    :~  ?.  admin  stub
        ;a.menu-item/"{wik-dir}/~/settings": Settings
        ;a.menu-item/"/wiki": All Wikis
        (fave-button flag)
        ;button.menu-item
          =type  "button"
          =onclick  (log-out bowl)
          ; Log Out
        ==
    ==
  ==
::
++  login-dialog
  |=  =order:rudder
  ^-  manx
  ;dialog#login(onmousedown "event.target == this && this.close()")
    :: todo: fix issue where redirect includes ?after= and it redirects infinitely
    ;button.login-button(onclick "window.location.href='/~/login?eauth&redirect={(trip url.request.order)}'")
      ;+  urbit:icon
      ; Login with Urbit OS
    ==
    ;div.note: Your Urbit must be online.
    ;br;
    ;button.login-button(onclick (trip mask-auth-js))
      ;+  metamask:icon
      ; Login with MetaMask
    ==
    ;div.note: You must have an Urbit ID in your MetaMask wallet.
    ;label(for "urbit-id"): Urbit ID
    ;input#mask-auth-urbit-id(type "text", name "urbit-id", placeholder "~sampel-palnet");
==
::
++  fave-button
  |=  =flag
  ?.  (~(has by shelf.rudyard) flag)  stub
  =/  fave-path=tape  "/wiki/~/x/faves/{<host.flag>}/{(trip id.flag)}"
  ?:  (~(has in faves.rudyard) flag)
    ;button.menu-item(title "Remove Favorite", hx-post "{fave-path}?set=false", hx-swap "outerHTML")
      ; Remove
      ;+  (fave:icon &)
      ;
    ==
  ;button.menu-item(title "Add Favorite", hx-post "{fave-path}?set=true", hx-swap "outerHTML")
    ; Add
    ;+  (fave:icon |)
    ;
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
++  topbar
  |=  [=bowl:gall =order:rudder =cover]
  ^-  manx
  =/  =wiki-path  wiki-path:(wiki-url url.request.order)
  =/  wik-dir=tape  (base-path wiki-path)
  =/  check-logo=?  (gte era.cover 5)
  ;div#topbar
    ;a#top-title.wiki-title/"{wik-dir}"
      ;div.logo-small
        =hx-get      ?:(check-logo "{wik-dir}/~/x/logo" "")
        =hx-trigger  ?:(check-logo "load" "")
        ;
      ==
      ;span: {(trip title.cover)}
    ==
    ;div#topbar-row-2
      ;button.sidebar-collapse-button(onclick "document.getElementById(\"navbar\").showModal()")
        ;+  menu:icon
      ==
      ;dialog#navbar(onmousedown "event.target == this && this.close()")
        ;+  (nav-submenu bowl order [%& cover])
      ==
      ;+  (search-bar `book-id.wiki-path host.wiki-path)
    ==
    ;+  (login-dialog order)
  ==
::
++  search-bar
  |=  [book-id=(unit @ta) host=(unit @p)]
  ^-  manx
  =/  search-url=tape
    ?~  book-id    !!
    ?~  host       "/wiki/{(trip u.book-id)}/~/x/search"
    "/wiki/~/p/{<u.host>}/{(trip u.book-id)}/~/x/search"
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
  |=  [host=@p =(each cover book)]
  ^-  manx
  =/  =access
    ?-  -.each
      %&  rules.p.each
      %|  rules.p.each
    ==
  =/  public-read=?  &(public.read.access urth.read.access)
  =/  mars-read=?  &(public.read.access !urth.read.access)
  =/  viz=manx
    ?:  public-read
      ;div.footer-item.note
        ;+  globe:icon
        ;span: This wiki is public
      ==
    ?:  mars-read
      ;div.footer-item.note
        ;+  urbit-small:icon
        ;span: This wiki is public on Urbit
      ==
    ;div.footer-item.note
      ;+  lock:icon
      ;span: This wiki is private
    ==
  ;footer
      ;+  viz
      ;div.footer-item.note: Hosted by {<host>}
      ;a.footer-item/"https://urbit.org": Powered by Urbit
      ;a.footer-item/"https://github.com/JohnRillos/wiki": Made with %wiki
  ==
::
++  icon
  |%
  ::
  ++  fave
    |=  [active=?]
    ;div(class ?:(active "fave-icon on" "fave-icon off"))
      ;+  (need (de-xml:html star-svg))
    ==
  ::
  ++  globe
    ^~
    ;div.access-icon(title "public")
      ;+  (need (de-xml:html globe-svg))
    ==
  ::
  ++  info
    |=  hover=tape
    ;div.access-icon(title hover)
      ;+  (need (de-xml:html info-svg))
    ==
  ::
  ++  load
    ^~
    ;div.loading-icon(title "loading")
      ;+  (need (de-xml:html load-svg))
    ==
  ::
  ++  lock
    ^~
    ;div.access-icon(title "private")
      ;+  (need (de-xml:html lock-svg))
    ==
  ::
  ++  menu
    ^~
    ;div.menu-icon(title "Menu")
      ;+  (need (de-xml:html menu-svg))
    ==
  ::
  ++  metamask
    ^~
    ;div.metamask-icon(title "MetaMask")
      ;+  (need (de-xml:html metamask-svg))
    ==
  ::
  ++  search
    ^~
    ;div.search-icon(title "search")
      ;+  (need (de-xml:html search-svg))
    ==
  ::
  ++  urbit
    ^~
    ;div.urbit-icon(title "Urbit")
      ;+  (need (de-xml:html urbit-svg))
    ==
  ::
  ++  urbit-small
    ^~
    ;div.access-icon(title "Urbit")
      ;+  (need (de-xml:html urbit-svg))
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
++  error-to-html :: todo: maybe use manx for this
  |=  =tang
  ^-  @t
  =/  trace=tape
    %-  zing
    %+  join  "<br/>"
    %+  turn  tang
    |=(=tank ~(ram re tank))      
  (crip "<html><body><p>{trace}</p></body></html>")
::
++  unauthorized :: todo: maybe redirect to login/eauth screen
  |=  =bowl:gall
  ^-  reply:rudder
  ?:  =(%pawn (clan:title src:auth))
    [%code 401 'Unauthorized: user must be logged in']
  [%code 403 (crip "Forbidden: user does not have permission: {<src:auth>}")]
::
++  toggle-expand
  |=  id=tape
  ~+
  """
  var elem = document.getElementById('{id}');
  if (elem) \{
    if (elem.className.includes('collapsed')) \{
      elem.className = elem.className.replace('collapsed', 'expanded');
    } else \{
      elem.className = elem.className.replace('expanded', 'collapsed');
    }
  } else \{
    console.error('missing elem: ' + '{id}')
  }
  """
::
++  link-theme
  |=  [=bowl:gall host=(unit @p) =cover]
  ^-  manx
  =/  =ship  (fall host our.bowl)
  ?~  theme.cover
    ;link(rel "stylesheet", href "/wiki/~/p/{<ship>}/{(trip book-id.cover)}/~/assets/style.css");
  ?+  u.theme.cover  stub
    %default  stub
  ==
::
++  sanitize-svg
  |=  raw=@t
  ~+
  ^-  @t
  =/  munx=(unit manx)  (de-xml:html (sane-newline raw))
  ?~  munx  ~|('Unable to process SVG' !!)
  =/  =manx  (need munx)
  =/  att=(map ?(@tas [@tas @tas]) tape)  (malt a.g.manx)
  =.  att  (~(gas by att) ~[[%width "inherit"] [%height "inherit"]])
  =.  a.g.manx  ~(tap by att)
  =/  tanx=tape  (en-xml:html manx)
  ?:  (is-evil tanx)  ~|('SVG rejected' !!)
  (crip tanx)
::
++  is-evil
  |=  text=tape
  (has:regex "(?i)(script)|(meta)|(on(load)|(error)|(mouseover))" text)
::
++  is-admin
  |=  [host=(unit @p) =access] :: access isn't used... yet
  =(src:auth (fall host our.bowl))
::
--