::  file upload
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
  =/  data=(map @t (list part:multipart))  (multipart-map:web order)
  =/  title-option  (~(get by data) 'title-source')
  ?~  title-option  ~
  =/  =title-source  (title-source body:(head u.title-option))
  ?~  parts=(~(get by data) 'file')  ~
  =/  files  (get-md-files:web u.parts)
  [%imp-file book-id.site files title-source]
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
      ;+  (doc-head:web bowl "Import - {(trip title.book)}")
      ;body#with-sidebar
        ;+  (global-nav:web bowl order [book-id.site book])
        ;main
          ;+  (search-bar:web `book-id.site ~)
          ;h1: Import Pages
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
            ;fieldset
              ;legend: Options
              ;label(for "title-source"): Get page title from 
              ;select#title-source
                =name  "title-source"
                ;option(value "filename"): filename
                ;option(value "header"): first header
                ;option(value "front-matter"): front matter
              ==
            ==
            ;button.submit.box-item(type "submit"): Upload
          ==
          ;+  (footer:web book)
        ==
      ==
    ==
  --
--
