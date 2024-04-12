::  Wiki creation page
::
/-  *wiki
/+  rudder, web=wiki-web
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder relay)
  =/  args=(map @t @t)  (form-data:web order)
  ?~  what=(~(get by args) 'action')  ~
  |^  ?+  u.what  'Invalid post body'
      ::
          %new-book
        =/  book-id=@ta
          ~|  'Invalid wiki ID'  (tie (~(got by args) 'book-id'))
        =/  book-title=@t  (~(got by args) 'book-title')
        =/  pub-read=?  =('public' (~(got by args) 'rule-read'))
        =/  =rule-read
          ?+  (~(got by args) 'rule-read')  !!
            %priv  [%| %| %|]
            %urth  [%& %| %|]
            %scry  [%& %& %|]
            %goss  [%& %& %&]
          ==
        =/  =rule-edit
          ?+  (~(got by args) 'rule-edit')  !!
            %host  [%| %|]
            %user  [%& %|]
            %anon  [%& %&]
          ==
        [%relay our.bowl id.order [%new-book book-id book-title [rule-read rule-edit]]]
      ==
    ::
    ++  tie
      |=  =knot
      ^-  @ta
      (slav %ta (cat 3 '~.' knot))
  --
::
++  final
  |=  [success=? msg=brief:rudder]
  ^-  reply:rudder
  =/  next=@t
    ?.  success  url.request.order
    =/  bid=@t  (~(got by (form-data:web order)) 'book-id')
    (crip "/wiki/{(trip bid)}")
  ((alert:rudder next build))
::
++  build
  |=  $:  arg=(list [k=@t v=@t])
          msg=(unit [o=? =@t])
      ==
  ^-  reply:rudder
  ::
  |^  [%page render]
  ::
  ++  knot-regex  "[0-9a-z\\-_~\\.]+"
  ::
  ++  knot-explain
    %-  trip
    'Lowercase letters, numbers, hyphen (-), underscore (_), period (.), \
    /and tilde (~)'
  ::
  ++  render
    ^-  manx
    |^
    ;html
      ;+  (doc-head:web bowl "New Wiki")
      ;body#new-wiki-container
        ;h1: New Wiki
        ;form(method "post")
          ;table#add-book
            ;tr
              ;th: Wiki ID
              ;th: Wiki Title
            ==
            ;tr
              ;td
                ;input
                  =type         "text"
                  =name         "book-id"
                  =placeholder  "my-wiki"
                  =required     "true"
                  =pattern      knot-regex
                  =title        knot-explain
                  ;
                ==
              ==
              ;td
                ;input
                  =type         "text"
                  =name         "book-title"
                  =placeholder  "My Wiki"
                  =required     "true"
                  ;
                ==
              ==
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
          ;button.submit
            =type   "submit"
            =name   "action"
            =value  "new-book"
            ; Create Wiki
          ==
          ;a(href "/wiki"): Cancel
        ==
      ==
    ==
    ::
    ++  setting-rule-read :: todo: improve this layout
      ^-  manx
      ;div
        ;div.box-item
          ;input#priv-read(type "radio", name "rule-read", value "priv");
          ;label(for "priv-read"): Only you can view this wiki.
        ==
        ;div.box-item
          ;input#urth-read(type "radio", name "rule-read", value "urth");
          ;label(for "urth-read"): Anyone with the URL can view this wiki.
        ==
        ;div.box-item
          ;input#scry-read(type "radio", name "rule-read", value "scry");
          ;label(for "scry-read"): Can be viewed on the web and on Urbit, but is not listed in the global index.
        ==
        ;div.box-item
          ;input#goss-read(type "radio", name "rule-read", value "goss");
          ;label(for "goss-read"): Can be viewed on the web and on Urbit, and is publicly listed in the global index.
        ==
      ==
    ::
    ++  setting-rule-edit
      ^-  manx
      ;div
        ;div.box-item
          ;input#host-edit(type "radio", name "rule-edit", value "host");
          ;label(for "host-edit"): Only you can edit this wiki.
        ==
        ;div.box-item
          ;input#user-edit(type "radio", name "rule-edit", value "user");
          ;label(for "user-edit")
            ; Any Urbit user can create or edit pages, except guests (comets).
          ==
        ==
        ;div.box-item
          ;input#anon-edit(type "radio", name "rule-edit", value "anon");
          ;label(for "anon-edit")
            ; Anybody can create or edit pages, even anonymous guests.
          ==
        ==
      ==
    --
  --
--
