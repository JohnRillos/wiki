::  Wiki creation page
::
/-  *wiki
/+  rudder
::
^-  (page:rudder (map @ta book) action)
::
=<
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
+*  help  ~(. +> [bowl order books])
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder action)
  =/  args=(map @t @t)  args:help
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
    =/  bid=@t  (~(got by args:help) 'book-id')
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
  ++  style  ""
  ::
  ++  knot-regex  "[0-9a-z\\-_~\\.]+"
  ::
  ++  knot-explain
    """
    Lowercase letters, numbers, hyphen (-), underscore (_), period (.),
    and tilde (~)
    """
  ::
  ++  render
    ^-  manx
    ;html
      ;head
        ;title:"%wiki"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
        ;style:"{style}"
      ==
      ;body
        ;h1: %wiki
        ;h2: New Wiki
        ;table#add-book
          ;form(method "post")
            ;tr(style "font-weight: bold")
              ;td:"Wiki ID"
              ;td:"Wiki Title"
              ;td:"Public Read Access"
            ==
            ;tr
              ;td
                ;input(type "text", name "book-id", placeholder "my-wiki", pattern knot-regex, title knot-explain);
              ==
              ;td
                ;input(type "text", name "book-title", placeholder "My Wiki");
              ==
              ;td
                ;input(type "checkbox", name "public-read");
              ==
            ==
            ;tr
              ;td
                ;button(type "submit", name "action", value "new-book"):"Create Wiki"
              ==
            ==
          ==
        ==
      ==
    ==
  --
--
::
::  helper core (help)
::
|_  [=bowl:gall =order:rudder books=(map @ta book)]
::
++  args  ~+
  ^-  (map @t @t)
  ?~  body.request.order  ~
  (frisk:rudder q.u.body.request.order)
--
