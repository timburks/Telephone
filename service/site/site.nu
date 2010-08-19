(load "NuHTTPHelpers")
(load "NuMarkup:xhtml")
(load "NuMongoDB")
(load "NuJSON")
(load "NuUUID")

(set DATABASE "telephone")
(set mongo (NuMongoDB new))
(mongo connectWithOptions:nil)

(function oid (string)
     ((NuMongoDBObjectID alloc) initWithString:string))

((set date-formatter
      ((NSDateFormatter alloc) init))
 setDateFormat:"EEEE MMMM d, yyyy")

((set rss-date-formatter
      ((NSDateFormatter alloc) init))
 setDateFormat:"EEE, d MMM yyyy hh:mm:ss ZZZ")

(function nonempty (s)
     (and s (> (s length) 0)))

;; language codes
;; http://en.wikipedia.org/wiki/ISO_639-1

(set languages
     (array (dict name:"English" code:"en")
            (dict name:"French" code:"fr")
            (dict name:"German" code:"de")
            (dict name:"Japanese" code:"ja")
            (dict name:"Portugese" code:"pt")
            (dict name:"Spanish" code:"es")
            (dict name:"Catalan" code:"ca")))

;; this helper function generates a <select> element
(function select (name choices display-key value-key current)
     (&select name:name
              (&option value:"" "")
              (choices map:
                       (do (choice)
                           (if (eq (choice objectForKey:value-key) current)
                               (then (&option value:(choice objectForKey:value-key)
                                              selected:"yes"
                                              (choice display-key)))
                               (else (&option value:(choice objectForKey:value-key)
                                              (choice display-key))))))))

(function head-with-title (title)
     (&head (&meta http-equiv:"Content-Type" content:"text/html; charset=utf-8")
            (&title title)
            (&link rel:"stylesheet" href:"/simple.css" type:"text/css" media:"screen")))

(macro header ()
     (&div (&div id:"header"
                 (if (and (defined account) account)
                      (then (&span style:"float:right"
                                   (account username:) " | "
                                   (&a href:"/manage" "manage") " | "
                                   (&a href:"/signout" "sign out")))
                      (else (&span style:"float:right"
                                   (&a href:"/signin" "sign in"))))
                 (&span (&a href:"/" "telephone")))
           (&div id:"nav"
                 (&ul (&li (&a href:"/" "home"))
                      (&li (&a href:"/about" "about telephone"))))))

(macro sidebar ()
     (&div id:"sidebar"
           (&p "The world-wide language game.")))

(function footer ()
     (&div id:"footer"
           (&span style:"float:left" "Copyright ©2010, " (&a href:"http://radtastical.com" "Radtastical, Inc.") " All rights reserved.")
           (&span style:"float:right" "Telephone. " (&a href:"mailto:tim@radtastical.com" "Contact us."))))

(macro webpage (title main)
     `(progn (REQUEST setContentType:"text/html")
             (&html (head-with-title ,title)
                    (&body (header)
                           (&div id:"content"
                                 ,main
                                 (sidebar))
                           (footer)))))

(get "/"
     (webpage "Telephone"
              (&div id:"main"
                    (&h1 "Telephone")
                    (&p "let's play")
                    (&form action:"/translate" method:"POST"
                           (&table (&tr (&td "Phrase to translate:"))
                                   (&tr (&td (&em "Let's get lunch!")))
                                   (&tr (&td "Choose a destination language: "
                                             (select "language" languages "name" "code" "")))
                                   (&tr (&td "Enter your translation below:"))
                                   (&tr (&td (&textarea name:"translation" rows:10 cols:80)))
                                   (&tr (&td (&input type:"submit" value:"submit"))))))
              
              
              ))

(get "/about"
     (webpage "About Telephone"
              (&div id:"main"
                    (&h1 "About Telephone")
                    (&p "We just thought this would be fun."))))

(get "/signin"
     (webpage "Sign In"
              (&div id:"main"
                    (&h1 "Not yet.")
                    )))

(post "/translate"
      (webpage "Translation Submitted"
               (&div id:"main"
                     (&pre ((REQUEST post) description))
                     
                     )))
