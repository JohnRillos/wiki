::  wiki settings
::
::  to-do:
::  * option to change public <-> private
::  * option to add logo
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
::
^-  (page:rudder (map @ta book) action)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  args=(map @t @t)  (form-data:web order)
  ?+  (~(got by args) 'action')  !!
    %mod-book-name  [%mod-book-name book-id.site (~(got by args) 'book-name')]
    %del-book       [%del-book book-id.site]
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
    ;html
      ;head
        ;title: Settings - {(trip title.book)}
        ;style: {(style:web bowl)}
      ==
      ;body#with-sidebar(onload on-page-load)
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;h1: Wiki Settings
          ;+
          %+  in-form:web  "Are you sure you want to rename this wiki?"
          ;div.column-box
            ;fieldset.box-item
              ;legend: Wiki Name
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
          ==
          ;+
          %+  in-form:web  "Are you sure you want to delete this wiki?"
          ;div.column-box
            ;fieldset.box-item
              ;legend: Danger Zone
              ;button.delete
                =type   "submit"
                =name   "action"
                =value  "del-book"
                ; Delete Wiki
              ==
            ==
          ==
          ;+  (footer:web bowl url.request.order)
        ==
      ==
    ==
  --
--
