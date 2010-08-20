;; calls google translation api

(load "NuHTTPHelpers")
(load "NuJSON")
(load "NuMongoDB")

(load "site/google.nu")

(set SITE "telephone")
(set mongo (NuMongoDB new))
(mongo connectWithOptions:nil)

(set args ((NSProcessInfo processInfo) arguments))

(unless (set source-text (args 2))
        (set source-text "hello world"))
(puts source-text)
(set source-language "en")

(set source-entry (get-phrase-entry source-text source-language))

(puts (source-entry description))

(set chain (array "el" "nl" "ja" "de" "es"  "it" "sr" "vi" "en"))

(if YES
    (chain each:
           (do (target-language)
               
               ;; do we have an existing translation?
               (set translation
                    (mongo findOne:(dict source_id:(source-entry _id:)
                                         destination_language:target-language)
                           inCollection:"telephone.translations"))
               
               (if translation
                   (then (set target-entry (mongo findOne:(dict _id:(translation destination_id:))
                                                  inCollection:"telephone.phrases"))
                         (puts (+ (target-entry language:) ": " (target-entry text:))))
                   (else (set target-text (google-translate source-language target-language source-text))
                         (set target-entry (get-phrase-entry target-text target-language))
                         (set translation (get-translation-entry source-entry target-entry "google"))
                         (puts (+ target-language ": " target-text))
                         (puts (target-entry description))
                         (puts (translation description))))
               
               (set source-entry target-entry)
               (set source-text (source-entry text:))
               (set source-language (source-entry language:))
               )))
