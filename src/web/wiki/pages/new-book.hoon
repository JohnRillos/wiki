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
        =/  =rule-read
          =/  public=?  =('true' (~(got by args) 'read-public'))
          =/    urth=?  &(public (~(has by args) 'read-urth'))
          =/    scry=?  &(public (~(has by args) 'read-scry'))
          =/    goss=?    &(scry (~(has by args) 'read-goss'))
          [public urth scry goss]
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
    ++  setting-rule-read
      ^-  manx
      ;div
        ;div.box-item
          ;+  %+  disables-other:web  ~['read-urth' 'read-scry' 'read-goss']
          ;input#read-pub-n(type "radio", name "read-public", value "false");
          ;label(for "read-pub-n"): Private: Only you can view this wiki.
        ==
        ;div.box-item
          ;+  %+  enables-other:web  ~['read-urth' 'read-scry' 'read-goss']
          ;input#read-pub-y(type "radio", name "read-public", value "true", checked "true");
          ;label(for "read-pub-y"): Public: Anyone can view this wiki.
        ==
        ;fieldset
          ;div.box-item
            ;input#read-urth(type "checkbox", name "read-urth", checked "true");
            ;label(for "read-urth"): This wiki can be viewed as a website on the clearweb.
            ;+
            =/  headers=(map @t @t)  (my `(list (pair @t @t))`header-list.request.order)
            =/  web-host=(unit @t)  (~(get by headers) 'host')
            ?~  web-host  stub:web
            %-  info:icon:web
            """
            Wiki will be visible at {(trip u.web-host)}/wiki/<Wiki ID>.
            Visitors can view the site without logging in or using Urbit, but can also log in with their Urbit ID's using EAuth.
            """
          ==
          ;div.box-item
            ;+  %+  enables-other:web  ~['read-goss']
            ;input#read-scry(type "checkbox", name "read-scry", checked "true");
            ;label(for "read-scry"): This wiki can be viewed on Urbit.
            ;+
            %-  info:icon:web
            """
            Urbit users can access this wiki at their own ship's URL at /wiki/~/p/{<our.bowl>}/<Wiki ID>.
            This feature uses remote scry to fetch content from this wiki.
            """
          ==
          ;div.box-item
            ;input#read-goss(type "checkbox", name "read-goss", checked "true");
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
      ==
    ::
    ++  setting-rule-edit
      ^-  manx
      ;div
        ;div.box-item
          ;input#host-edit(type "radio", name "rule-edit", value "host", checked "true");
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
