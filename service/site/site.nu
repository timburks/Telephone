(load "NuHTTPHelpers")
(load "NuMarkup:xhtml")
(load "NuMongoDB")
(load "NuJSON")
(load "NuUUID")

(set SITE "telephone")

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

(set languages-by-code (dict))
(languages each:
     (do (language)
         (languages-by-code setObject:language forKey:(language code:))))

(puts (languages-by-code description))

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
     (set account (get-account SITE))
     (+ (&div id:"header"
              (if (and (defined account) account)
                   (then (&span style:"float:right"
                                (account username:) " | "
                                (&a href:"/signout" "sign out")))
                   (else (&span style:"float:right"
                                (&a href:"/signin" "sign in")
                                " or "
                                (&a href:"/signup" "sign up"))))
              (&span (&a href:"/" SITE)))))

(macro navbar ()
     (&div id:"nav"
           (&ul (&li (&a href:"/" "home"))
                (&li (&a href:"/about" "about " SITE)))))

(macro sidebar ()
     (&div id:"sidebar"
           (&h1 "Telephone")
           (&p "The world-wide message passing game.")
           (&p
              (languages map:
                   (do (language)
                       (+ (language name:) " "))
                   
                   ))))

(function footer ()
     (&div id:"footer"
           (&span style:"float:left" "Copyright ©2010, " (&a href:"http://radtastical.com" "Radtastical, Inc.") " All rights reserved.")
           (&span style:"float:right" (&a href:"mailto:tim@radtastical.com" "Contact us."))))

(macro webpage (title main)
     `(progn (REQUEST setContentType:"text/html")
             (&html (head-with-title ,title)
                    (&body (header)
                           (&div id:"content"
                                 ,main
                                 (sidebar))
                           (footer)))))

(get "/"
     (set account (get-account SITE))
     (puts (account description))
     (webpage "Telephone"
              (&div id:"main"
                    (if account
                        (then
                             (&div
                                  (&h1 "Choose a language")
                                  (&ul (languages map:
                                            (do (language)
                                                (&li (&a href:(+ "/" (language code:))
                                                         (language name:))))))))
                        (else
                             (&h1 "Please "
                                  (&a href:"/signin" "sign in")
                                  " or "
                                  (&a href:"/signup" "sign up")
                                  " to play Telephone."))))))

(get "/about"
     (webpage "About Telephone"
              (&div id:"main"
                    (&h1 "About Telephone")
                    (&p "We just thought this would be fun."))))

(get "/code:"
     (set code ((REQUEST bindings) code:))
     (set language (languages-by-code code))
     (unless language (return nil))
     (webpage "Telephone"
              (&div id:"main"
                    (&h1 (language name:))
                    (&ul (&li (&a href:(+ "/" code "/translate-in")
                                  "Translate a phrase into " (language name:)))
                         (&li (&a href:(+ "/" code "/translate-out")
                                  "Translate a " (language name:) " phase into another language"))
                         (&li (&a href:(+ "/" code "/enter")
                                  "Enter a phrase"))
                         (&li (&a href:(+ "/" code "/compare")
                                  "Compare phrases"))))))

(get "/code:/translate-in"
     (set code ((REQUEST bindings) code:))
     
     (set targets
          (languages select:
               (do (language)
                   (!= (language code:) code))))
     
     (set source-phrase "Let's get lunch!")
     
     (webpage "Translate"
              (&div id:"main"
                    (&h1 "Translate this " ((languages-by-code code) name:) " phrase:")
                    (&p (&em source-phrase))
                    (&form action:(+ "/" code "/translate") method:"POST"
                           (&table (&tr (&td "Choose a destination language: "
                                             (select "language" targets "name" "code" "")))
                                   (&tr (&td "Enter your translation:"))
                                   (&tr (&td (&textarea name:"translation" rows:10 cols:80)))
                                   (&tr (&td (&input type:"submit" value:"submit"))))))))

(post "/code:/translate"
      (webpage "Translation Submitted"
               (&div id:"main"
                     (&h1 "Thank you!")
                     (&pre ((REQUEST post) description)))))

;; ======= USER SIGNIN SYSTEM ========

(set signin-form
     '(webpage "Sign In"
               (&div id:"main"
                     (&div id:"main"
                           (&h1 message)
                           (&form id:"email-form" method:"post" action:"/signin"
                                  (&table (&tr (&td (&label for:"username" "Username " style:"margin-right:2em"))
                                               (&td (&input id:"username" type:"text" name:"username" title:"username" value:username width:20 )))
                                          (&tr (&td (&label for:"password" "Password " style:"margin-right:2em"))
                                               (&td (&input id:"password" type:"password" name:"password" title:"password" value:password width:20)))
                                          (&tr (&td)
                                               (&td (&button type:"submit" "Sign in")))))))))

(set signup-form
     '(webpage "Sign Up"
               (&div id:"main"
                     (&h1 message)
                     (&form id:"email-form" method:"post" action:"/signup"
                            (&table (&tr (&td (&label for:"username" "Username " style:"margin-right:2em"))
                                         (&td (&input id:"username" type:"text" name:"username"
                                                      title:"username" width:20 )))
                                    (&tr (&td (&label for:"password" "Password " style:"margin-right:2em"))
                                         (&td (&input id:"password" type:"password" name:"password"
                                                      title:"password"  width:20)))
                                    (&tr (&td (&label for:"password2" "Password (again) " style:"margin-right:2em"))
                                         (&td (&input id:"password2" type:"password" name:"password2"
                                                      title:"password"  width:20)))
                                    (&tr (&td)
                                         (&td (&button type:"submit" "Add user"))))))))

(set PASSWORD_SALT SITE)

;; DEVELOPMENT ONLY: add default admin password
(mongo updateObject:(dict username:"admin"
                          password:("callme" md5HashWithSalt:PASSWORD_SALT))
       inCollection:(+ SITE ".accounts")
       withCondition:(dict username:"admin")
       insertIfNecessary:YES
       updateMultipleEntries:NO)

(function create-cookie (name)
     (dict name:name
           value:((NuUUID new) stringValue)
           expiration:(NSDate dateWithTimeIntervalSinceNow:(* 24 3600))))

(function display-cookie (cookie)
     (+ (cookie name:) "=" (cookie value:) "; Path=/; Expires=" ((cookie expiration:) rfc1123) ";"))

(macro get-account (name)
     `(cond ((eq nil (set cookie ((REQUEST cookies) ,name))) nil)
            ((eq nil (set session (mongo findOne:(dict cookie:cookie) inCollection:(+ SITE ".sessions")))) nil)
            (t (mongo findOne:(dict _id:(session account_id:)) inCollection:(+ SITE ".accounts")))))

(macro require-account ()
     (unless (set account (get-account SITE)) (return nil)))

(get "/signin"
     (REQUEST setContentType:"text/html")
     (set username "")
     (set password "")
     (set message "Please sign in.")
     (eval signin-form))

(post "/signin"
      (REQUEST setContentType:"text/html")
      (set ip-address ((REQUEST requestHeaders) "X-Forwarded-For"))
      (set username ((REQUEST post) "username"))
      (set password ((REQUEST post) "password"))
      
      (cond ((or (not username) (not password))
             (set message "WTFBBQ? Try that again.")
             (eval signin-form))
            
            ((set account (mongo findOne:(dict username:username password:(password md5HashWithSalt:PASSWORD_SALT))
                                 inCollection:(+ SITE ".accounts")))
             
             (set session-cookie (create-cookie SITE))
             (REQUEST setValue:(display-cookie session-cookie) forResponseHeader:"Set-Cookie")
             
             (set session (dict account_id:(account _id:) cookie:(session-cookie value:)))
             (mongo updateObject:session
                    inCollection:(+ SITE ".sessions")
                    withCondition:(dict account_id:(account _id:))
                    insertIfNecessary:YES
                    updateMultipleEntries:NO)
             (REQUEST redirectResponseToLocation:"/"))
            
            (else
                 (set message "WTFBBQ? Try that again.")
                 (eval signin-form))))

(get "/signout"
     (if (set cookie ((REQUEST cookies) SITE))
         (mongo removeWithCondition:(dict cookie:cookie) fromCollection:(+ SITE ".sessions")))
     (REQUEST redirectResponseToLocation:"/"))

(get "/whoami"
     (set account (get-account SITE))
     (REQUEST setContentType:"text/plain")
     (account description))

(get "/signup"
     (set message "Sign up to play Telephone.")
     (eval signup-form))

(post "/signup"
      (set ip-address ((REQUEST requestHeaders) X-Forwarded-For:))
      (set username ((REQUEST post) username:))
      (set password ((REQUEST post) password:))
      (set confirmation ((REQUEST post) password2:))
      
      (cond ((or (not username) (eq (username length) 0))
             (set message "Please specify a username.")
             (eval signup-form))
            ((or (not password) (< (password length) 4))
             (set message "Passwords must be at least 4 characters.")
             (eval signup-form))
            ((!= password confirmation)
             (set message "Password and password confirmation entries must match.")
             (eval signup-form))
            (else ;; create the account
                  (set account (dict username:username password:(password md5HashWithSalt:PASSWORD_SALT)))
                  (mongo updateObject:account
                         inCollection:(+ SITE ".accounts")
                         withCondition:(dict username:username)
                         insertIfNecessary:YES
                         updateMultipleEntries:NO)
                  (set account (mongo findOne:(dict username:username) inCollection:(+ SITE ".accounts")))
                  (set session-cookie (create-cookie SITE))
                  (REQUEST setValue:(display-cookie session-cookie) forResponseHeader:"Set-Cookie")
                  (set session (dict account_id:(account _id:) cookie:(session-cookie value:)))
                  (mongo updateObject:session
                         inCollection:(+ SITE ".sessions")
                         withCondition:(dict account_id:(account _id:))
                         insertIfNecessary:YES
                         updateMultipleEntries:NO)
                  (REQUEST redirectResponseToLocation:"/"))))

