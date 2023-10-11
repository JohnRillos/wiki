::  wiki overview
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
  =/  [site=(pole knot) *]  (sane-url:web url.request.order)
  ?>  ?=([%wiki book-id=@ta ~] site)
  =/  args=(map @t @t)  (form-data:web order)
  ?^  del-book=(~(get by args) 'del-book')
    [%del-book book-id.site]
  =/  data=(map @t (list part:multipart))  (multipart-map:web order)
  =/  header-as-title=?  (~(has by data) 'header-as-title')
  ?~  parts=(~(get by data) 'file')  ~
  =/  files  (get-md-files:web u.parts)
  [%imp-file book-id.site files header-as-title]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  back=?  &(success (~(has by (form-data:web order)) 'del-book'))
  =/  next=@t
    ?.  back  url.request.order
    =/  msg=tape  (en-urlt:html "Wiki deleted!")
    (crip "/wiki?msg={msg}")
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=(pole knot) query=(map @t @t)]  (sane-url:web url.request.order)
  ?>  ?=([%wiki book-id=@ta ~] site)
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
  ++  file-import  :: todo: move this to its own page
    ^-  manx
    ?.  =(src.bowl our.bowl)  stub:web
    ;form(method "post", enctype "multipart/form-data")
      ;div
        ;label(for "upload"): Upload Markdown folder
        ;input#upload
          =type  "file"
          =name  "file"
          =directory  ""
          =webkitdirectory  ""
          =mozdirectory  ""
          ;
        ==
      ==
      ;div
        ;label(for "header-title-check"): Use First Header as Title
        ;input#header-title-check(type "checkbox", name "header-as-title");
      ==
      ;div
        ;button(type "submit"): Submit
      ==
    ==
  ::
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: {(trip title.book)}
        ;style: {(style:web bowl)}
      ==
      ;body#with-sidebar(onload on-page-load)
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;h1#wiki-title: {(trip title.book)}
          ;nav#wiki-controls
            ;a/"/wiki/{(trip book-id.site)}/~/new"
              ;button(type "button"): New Page
            ==
            ;+
            ?.  =(src.bowl our.bowl)  stub:web
            %+  in-form:web  "Are you sure you want to delete this wiki?"
            ;button.delete
              =type   "submit"
              =name   "del-book"
              =value  "{(trip book-id.site)}"
              ; Delete Wiki
            ==
          ==
          ;+  file-import
          ;h2: Pages
          ;ul
            ;*  %+  turn  ~(tap by tales.book)
                |=  [=path =tale]
                ^-  manx
                =/  =page  page:(latest tale)
                ;li
                  ;form(method "post")
                    ;a/"/wiki/{(trip book-id.site)}{(spud path)}"
                      ; {(trip title.page)}
                    ==
                  ==
                ==
          ==
          ;+  (footer:web bowl url.request.order)
        ==
      ==
    ==
  --
--
