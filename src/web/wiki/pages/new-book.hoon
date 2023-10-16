::  Wiki creation page
::
/-  *wiki
/+  rudder, web=wiki-web
::
^-  (page:rudder state-0 action)
::
|_  [=bowl:gall =order:rudder state-0]
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
        =/  pub-read=?  (~(has by args) 'public-read')
        [%new-book book-id book-title pub-read]
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
    ;html
      ;+  (doc-head:web bowl "New Wiki")
      ;body
        ;h1: %wiki
        ;h2: New Wiki
        ;table#add-book
          ;form(method "post")
            ;tr
              ;th:"Wiki ID"
              ;th:"Wiki Title"
              ;th:"Public Read Access"
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
              ;td
                ;input(type "checkbox", name "public-read");
              ==
            ==
            ;tr
              ;td
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
        ==
      ==
    ==
  --
--
