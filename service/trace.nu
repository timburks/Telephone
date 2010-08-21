(load "NuHTTPHelpers")
(load "NuJSON")
(load "NuMongoDB")

(load "site/google.nu")

(set SITE "telephone")
(set mongo (NuMongoDB new))
(mongo connectWithOptions:nil)

(set _spaces (dict 0 ""))
(function spaces (n)
     (if (set value (_spaces n))
         (then value)
         (else (set value (+ "=>" (spaces (- n 1))))
               (_spaces setObject:value forKey:n)
               value)))

(set args ((NSProcessInfo processInfo) arguments))
(unless (set text (args 2))
        (set text "Act your age, not your shoe size."))
(set language "en")

(set phrase (mongo findOne:(dict text:text language:language) inCollection:"telephone.phrases"))

(function trace (phrase languages level)
     (set translations (mongo findArray:(dict source_id:(phrase _id:)) inCollection:"telephone.translations"))
     (translations each:
          (do (translation)
              (set next (mongo findOne:(dict _id:(translation destination_id:)) inCollection:"telephone.phrases"))
              (puts (+ (spaces level) (next language:) " " (next text:)))
              (unless (languages containsObject:(translation destination_language:))
                      (set newlanguages (languages mutableCopy))
                      (newlanguages addObject:(translation destination_language:))
                      (trace next newlanguages (+ level 1)))
              )))

(function traceback (phrase languages level)
     (set translations (mongo findArray:(dict destination_id:(phrase _id:)) inCollection:"telephone.translations"))
     (translations each:
          (do (translation)
              (set previous (mongo findOne:(dict _id:(translation source_id:)) inCollection:"telephone.phrases"))
              (puts (+ (spaces level) (previous language:) " " (previous text:)))
              (unless (languages containsObject:(translation source_language:))
                      (set newlanguages (languages mutableCopy))
                      (newlanguages addObject:(translation source_language:))
                      (traceback previous newlanguages (+ level 1)))
              )))

(puts (+ language " " text))
(traceback phrase (NSSet set) 1)
