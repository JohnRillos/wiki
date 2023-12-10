::  Wiki creation page
::
/-  *wiki
/+  rudder, web=wiki-web
::
^-  (page:rudder rudyard action)
::
|_  [=bowl:gall =order:rudder rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)  (form-data:web order)
  ?~  what=(~(get by args) 'action')  ~
  |^  ?+  u.what  'Invalid post body'
      ::
          %new-book
        =/  book-id=@ta
          ~|  'Invalid wiki ID'  (tie (~(got by args) 'book-id'))
        =/  book-title=@t  (~(got by args) 'book-title')
        =/  pub-read=?  =('public' (~(got by args) 'rule-read'))
        =/  =rule-edit
          ?+  (~(got by args) 'rule-edit')  !!
            %host  [%.n %.n]
            %user  [%.y %.n]
            %anon  [%.y %.y]
          ==
        [%new-book book-id book-title [pub-read rule-edit]]
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
    ++  setting-rule-read
      ^-  manx
      ;div
        ;div.box-item
          ;input#public-read(type "radio", name "rule-read", value "public");
          ;label(for "public-read"): Anyone with the URL can view this wiki.
        ==
        ;div.box-item
          ;input#private-read(type "radio", name "rule-read", value "private");
          ;label(for "private-read"): Only you can view this wiki.
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
