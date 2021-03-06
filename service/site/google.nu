
(function google-translate (source destination phrase)
     (NSLog (+ "translating " phrase " from " source " to " destination))

     (set REFERER "http://www.radtastical.com")
     (set SERVICE "http://ajax.googleapis.com/ajax/services/language/translate")
     (set args (dict v:"1.0"
                     q:phrase
                     langpair:(+ source "|" destination)))
     ;; The Xmachine sandboxing rules do not allow curl.
     ;(set command (+ "curl -s -e " REFERER " '" SERVICE "?" (args urlQueryString) "'"))
     ;(set response ((NSString stringWithShellCommand:command) JSONValue))
     ;; it would be nice to set the REFERER header, 
     ;; but I don't see how to do this with the API we use below
     (set path (+ SERVICE "?" (args urlQueryString)))
     (set url (NSURL URLWithString:path))
     (set responseData (NSData dataWithContentsOfURL:url))
     (set responseString ((NSString alloc) initWithData:responseData encoding:NSUTF8StringEncoding))
     (set response (responseString JSONValue))

     (if (eq (response responseStatus:) 200)
         (then (((response responseData:) translatedText:) stringByDecodingXMLEntities))
         (else nil)))

(function get-phrase-entry (text language)
     (set phrase (dict text:text
                       language:language))
     (unless (set entry (mongo findOne:phrase inCollection:"telephone.phrases"))
             (phrase created_at:(NSDate date))
             (mongo insertObject:phrase intoCollection:"telephone.phrases")
             (set entry (mongo findOne:phrase inCollection:"telephone.phrases")))
     entry)

(function get-translation-entry (source-phrase destination-phrase translator)
     (set translation (dict source_id:(source-phrase _id:)
                            source_language:(source-phrase language:)
                            destination_id:(destination-phrase _id:)
                            destination_language:(destination-phrase language:)
                            translator:translator))
     (unless (set entry (mongo findOne:translation inCollection:"telephone.translations"))
             (translation created_at:(NSDate date))
			 (translation source_text:(source-phrase text:))
			 (translation destination_text:(destination-phrase text:))
             (mongo insertObject:translation intoCollection:"telephone.translations")
             (set entry (mongo findOne:translation inCollection:"telephone.translations")))
     entry)
