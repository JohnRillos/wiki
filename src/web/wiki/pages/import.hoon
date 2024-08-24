::  file upload
::
/-  *wiki
/+  multipart, rudder, web=wiki-web, *wiki
/*  helper-js  %js  /web/wiki/file-import-helper/js
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder relay)
  =/  [site=wiki-path *]  (wiki-url:web url.request.order)
  =/  data=(map @t (list part:multipart))  (multipart-map:web order)
  =/  paths=(list part:multipart)  (fall (~(get by data) 'paths') ~)
  =/  title-option  (~(get by data) 'title-source')
  ?~  title-option  ~|('No title option in request' !!)
  =/  =title-source  (title-source body:(head u.title-option))
  ?~  files=(~(get by data) 'file')  ~|('No file in request' !!)
  =/  md-files  (get-md-files:web u.files paths)
  ?~  md-files  ~|('No .md files in request' !!)
  =/  del-missing  (~(has by data) 'del-missing')
  [%relay our.bowl id.order [%imp-file book-id.site md-files title-source del-missing]]
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
  =/  =cover  (book-to-cover book-id.site book)
  ::
  |^  [%page render]
  ::
  ++  render
    ^-  manx
    ;html
      ;+  (doc-head:web bowl "Import - {(trip title.book)}")
      ;script: {(disable-on-submit:web "upload" `"Uploading...")}
      ;body#with-sidebar(onload (trip helper-js))
        ;+  (link-theme:web bowl host.site cover)
        ;+  (global-nav:web bowl order [%| book])
        ;main
          ;+  (topbar:web bowl order cover)
          ;h1: Import Pages
          ;form#file-form.column-box(method "post", enctype "multipart/form-data")
            ;div.file-upload.box-item
              ;p.box-item: Select a folder of markdown (.md) files
              ;input#file-input
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
              ;+  ?.  =(src.bowl our.bowl)  stub:web
              ;div
                ;br;
                ;label
                  =for  "del-missing"
                  ; Delete all pages that are not in these files?
                ==
                ;input#del-missing(type "checkbox", name "del-missing");
              ==
            ==
            ;button#upload.submit.box-item(type "submit"): Upload
          ==
          ;+  (footer:web (fall host.site our.bowl) [%| book])
        ==
      ==
    ==
  --
--
