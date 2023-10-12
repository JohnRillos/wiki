::  file upload
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
  =/  data=(map @t (list part:multipart))  (multipart-map:web order)
  =/  header-as-title=?  (~(has by data) 'header-as-title')
  ?~  parts=(~(get by data) 'file')  ~
  =/  files  (get-md-files:web u.parts)
  [%imp-file book-id.site files header-as-title]
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  next=@t   ?:(success '..' url.request.order)
  ((alert:rudder next build))
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  ::
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  ?~  buuk=(~(get by books) book-id.site)
    [%code 404 (crip "Wiki {<book-id.site>} not found")]
  =/  =book  u.buuk
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ;html
      ;head
        ;title: Import - {(trip title.book)}
        ;style: {(style:web bowl)}
      ==
      ;body#with-sidebar
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;h1#wiki-title: Import Pages
          ;form.column-box(method "post", enctype "multipart/form-data")
            ;div.file-upload.box-item
              ;p.box-item: Select a folder of markdown (.md) files
              ;input
                =type  "file"
                =name  "file"
                =directory  ""
                =webkitdirectory  ""
                =mozdirectory  ""
                ;
              ==
            ==
            ;fieldset.box-item
              ;legend: Options
              ;label(for "header-title-check"): Use first header as title
              ;input#header-title-check
                =type  "checkbox"
                =name  "header-as-title"
                ;
              ==
            ==
            ;button.submit.box-item(type "submit"): Upload
          ==
          ;+  (footer:web bowl url.request.order)
        ==
      ==
    ==
  --
--
