::  wiki settings
::
::  to-do:
::  * option to add logo
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder relay)
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  args=(map @t @t)  (form-data:web order)
  =/  =action
    ?+  (~(got by args) 'action')  !!
        %mod-book-name
      [%mod-book-name book-id.site (~(got by args) 'book-name')]
    ::
        %mod-rule-read
      =/  =rule-read
        =/  public=?  =('true' (~(got by args) 'read-public'))
        =/    urth=?  &(public (~(has by args) 'read-urth'))
        =/    scry=?  &(public (~(has by args) 'read-scry'))
        =/    goss=?    &(scry (~(has by args) 'read-goss'))
        [public urth scry goss]
      [%mod-rule-read book-id.site rule-read]
    ::
        %mod-rule-edit
      =/  =rule-edit
        ?+  (~(got by args) 'rule-edit')  !!
          %host  [%.n %.n]
          %user  [%.y %.n]
          %anon  [%.y %.y]
        ==
      [%mod-rule-edit book-id.site rule-edit]
    ::
        %del-book
      [%del-book book-id.site]
    ==
   [%relay our.bowl id.order action]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  deleted=?
    &(success =(%del-book (~(got by (form-data:web order)) 'action')))
  =/  next=@t
    ?.  deleted  url.request.order
    =/  msg=tape  (en-urlt:html "Wiki deleted!")
    (crip "/wiki?msg={msg}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path query=(map @t @t)]  (wiki-url:web url.request.order)
  ?.  ?~  host.site  &
      =(u.host.site our.bowl)
    [%code 403 (crip "You are not the admin for this wiki")]
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  on-page-load
    =/  alert=(unit tape)  (query-msg:web query)
    ?~  alert  ""
    """
    javascript:window.alert('{u.alert}');
    window.history.pushState(\{}, document.title, window.location.pathname);
    """
  ::
  ++  render
    ^-  manx
    |^
    ;html
      ;+  (doc-head:web bowl "Settings - {(trip title.book)}")
      ;body#with-sidebar(onload on-page-load)
        ;+  (global-nav:web bowl order [%| book])
        ;main
          ;+  (search-bar:web `book-id.site host.site)
          ;h1: Wiki Settings
          ;div.column-box
            ;fieldset
              ;legend: Wiki Name
              ;+  setting-book-name
            ==
          ==
          ;div.column-box
            ;fieldset
              ;legend: Visibility
              ;+  setting-rule-read
            ==
          ==
          ;div.column-box
            ;fieldset
              ;legend: Collaboration
              ;+  setting-rule-edit
            ==
          ==
          ;div.column-box
            ;fieldset
              ;legend: Danger Zone
              ;+  setting-delete-book
            ==
          ==
          ;+  (footer:web [%| book])
        ==
      ==
    ==
    ::
    ++  setting-book-name
      ^-  manx
      %+  in-form:web  "Are you sure you want to rename this wiki?"
      ;div
        ;input
          =type      "text"
          =name      "book-name"
          =value     (trip title.book)
          =required  "true"
          ;
        ==
        ;button
          =type   "submit"
          =name   "action"
          =value  "mod-book-name"
          ; Rename
        ==
      ==
    ::
    ++  setting-rule-read
      ^-  manx
      =/  confirm=tape  "Are you sure?"
      %+  in-form:web  confirm
      ;div
        ;div.box-item
          ;+  %+  check-if:web  !public.read.rules.book
              %+  disables-other:web  ~['read-urth' 'read-scry' 'read-goss']
          ;input#read-pub-n(type "radio", name "read-public", value "false");
          ;label(for "read-pub-n"): Private: Only you can view this wiki.
        ==
        ;div.box-item
          ;+  %+  check-if:web  public.read.rules.book
              %+  enables-other:web  ~['read-urth' 'read-scry' 'read-goss']
          ;input#read-pub-y(type "radio", name "read-public", value "true");
          ;label(for "read-pub-y"): Public: Anyone can view this wiki.
        ==
        ;fieldset
          ;div.box-item
            ;+  %+    check-if:web     urth.read.rules.book
                %+  disable-if:web  !public.read.rules.book
            ;input#read-urth(type "checkbox", name "read-urth");
            ;label(for "read-urth"): This wiki can be viewed as a website on the clearweb.
            ;+
            =/  headers=(map @t @t)  (my `(list (pair @t @t))`header-list.request.order)
            =/  web-host=(unit @t)  (~(get by headers) 'host')
            ?~  web-host  stub:web
            %-  info:icon:web
            """
            Wiki will be visible at {(trip u.web-host)}{(base-path:web site)}.
            Visitors can view the site without logging in or using Urbit, but can also log in with their Urbit ID's using EAuth.
            """
          ==
          ;div.box-item
            ;+  %+    check-if:web        scry.read.rules.book
                %+  disable-if:web     !public.read.rules.book
                %+  enables-other:web  ~['read-goss']
            ;input#read-scry(type "checkbox", name "read-scry");
            ;label(for "read-scry"): This wiki can be viewed on Urbit.
            ;+
            %-  info:icon:web
            """
            Urbit users can access this wiki at their own ship's URL at /wiki/~/p/{<our.bowl>}/{(trip book-id.site)}.
            This feature uses remote scry to fetch content from this wiki.
            """
          ==
          ;div.box-item
            ;+  %+    check-if:web     goss.read.rules.book
                %+  disable-if:web    !scry.read.rules.book
                %+  disable-if:web  !public.read.rules.book
            ;input#read-goss(type "checkbox", name "read-goss");
            ;label(for "read-goss"): Share this wiki on the global index so people can discover it.
            ;+
            %-  info:icon:web
            """
            Shares data about this wiki with the rest of the network so it will be easy to find on Urbit.
            Uses the gossip protocol to share data with your pals, pals-of-pals, etc.
            This feature only works if you have %pals installed.
            """
          ==
        ==
        ;button(type "submit", name "action", value "mod-rule-read")
          ; Update
        ==
      ==
    ::
    ++  setting-rule-edit
      ^-  manx
      =/  confirm=tape  "Are you sure?"
      =/  =rule-edit  edit.rules.book
      %+  in-form:web  confirm
      ;div
        ;div.box-item
          ;+
          %+  check-if:web  !public.rule-edit
          %+  disable-if:web  !public.read.rules.book
          ;input#host-edit(type "radio", name "rule-edit", value "host");
          ;label(for "host-edit"): Only you can edit this wiki.
        ==
        ;div.box-item
          ;+
          %+  check-if:web  &(public.rule-edit !comet.rule-edit)
          %+  disable-if:web  !public.read.rules.book
          ;input#user-edit(type "radio", name "rule-edit", value "user");
          ;label(for "user-edit"): Any Urbit user can create or edit pages, except guests (comets).
        ==
        ;div.box-item
          ;+
          %+  check-if:web  &(public.rule-edit comet.rule-edit)
          %+  disable-if:web  !public.read.rules.book
          ;input#anon-edit(type "radio", name "rule-edit", value "anon");
          ;label(for "anon-edit"): Anybody can create or edit pages, even anonymous guests.
        ==
        ;+  %+  disable-if:web  !public.read.rules.book
        ;button(type "submit", name "action", value "mod-rule-edit")
          ; Update
        ==
      ==
    ::
    ++  setting-delete-book
      ^-  manx
      %+  in-form:web  "Are you sure you want to delete this wiki?"
      ;button.delete
        =type   "submit"
        =name   "action"
        =value  "del-book"
        ; Delete Wiki
      ==
    --
  --
--
