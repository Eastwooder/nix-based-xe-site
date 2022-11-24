let xesite = ../types/package.dhall

let Author = xesite.Author

in  Author::{
    , name = "Xe Iaso"
    , handle = "xe"
    , image = Some "https://xeiaso.net/static/img/avatar.png"
    , url = Some "https://xeiaso.net"
    , sameAs =
      [ "https://pony.social/@cadey"
      , "https://github.com/Xe"
      , "https://www.linkedin.com/in/xe-iaso-87a883254/"
      , "https://www.youtube.com/user/shadowh511"
      , "https://patreon.com/cadey"
      ]
    , jobTitle = "Archmage of Infrastructure"
    , inSystem = True
    }
