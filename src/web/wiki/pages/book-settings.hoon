::  wiki settings
::
::  to-do:
::  * option to add logo
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder state-0 action)
::
|_  [=bowl:gall =order:rudder state-0]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  args=(map @t @t)  (form-data:web order)
  ?+  (~(got by args) 'action')  !!
      %mod-book-name
    [%mod-book-name book-id.site (~(got by args) 'book-name')]
  ::
      %mod-rule-read
    [%mod-rule-read book-id.site =('public' (~(got by args) 'rule-read'))]
  ::
      %del-book
    [%del-book book-id.site]
  ==
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
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;+  (search-bar:web `book-id.site ~)
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
              ;legend: Danger Zone
              ;+  setting-delete-book
            ==
          ==
          ;+  (footer:web bowl url.request.order)
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
      =/  get-value-js=tape  "document.getElementById('rule-read').value"
      =/  confirm=tape
        "Are you sure you want to make this wiki $\{{get-value-js}}?"
      %+  in-form:web  confirm
      ;div
        ;div.box-item
          ;+  %+  check-if:web  public-read.rules.book
          ;input#public-read(type "radio", name "rule-read", value "public");
          ;label(for "public-read"): Only you can view this wiki.
        ==
        ;div.box-item
          ;+  %+  check-if:web  !public-read.rules.book
          ;input#private-read(type "radio", name "rule-read", value "private");
          ;label(for "private-read")
            ; Anyone with the URL can view this wiki.
          ==
        ==
        ;button(type "submit", name "action", value "mod-rule-read")
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
