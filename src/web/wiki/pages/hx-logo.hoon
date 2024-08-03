::  htmx partial: logo element
::
/-  *wiki
/+  multipart, regex, rudder, server, string, web=wiki-web, *wiki
/$  svg-to-mime  %svg  %mime
::
^-  (page:rudder rudyard relay)
::
|_  [=bowl:gall =order:rudder =rudyard]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  !!
::
++  final  (alert:rudder url.request.order build)
::
++  build
  |=  [arg=(list [k=@t v=@t]) msg=(unit [success=? text=@t])]
  ^-  reply:rudder
  =/  site=wiki-path  wiki-path:(wiki-url:web url.request.order)
  =/  logo=(unit image)
    %+  fall  logo.rudyard
    %+  biff  (~(get by books.rudyard) book-id.site)
    |=  =book
    crest.book
  |^
    ?~  logo  [%full (manx-response:gen:server ;img#logo(src "/wiki/~/assets/logo.svg");)]
    ?-  -.u.logo
      %url  [%full (cached-manx-response ;img#logo(src (trip url.u.logo));)]
    ::
      %svg  [%full (cached-svg-response svg.u.logo)]
    ==
  ::
  ++  cached-manx-response
    |=  =manx
    ^-  simple-payload:http
    %*($ manx-response:gen:server cache &, man manx)
  ::
  ++  cached-svg-response
    |=  svg=@t
    ^-  simple-payload:http
    %*($ svg-response:gen:server cache &, octs +:(svg-to-mime svg))
  --
--
