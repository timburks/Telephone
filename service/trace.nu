(load "NuHTTPHelpers")
(load "NuJSON")
(load "NuMongoDB")

(function oid (string)
     ((NuMongoDBObjectID alloc) initWithString:string))


(load "site/google.nu")

(set SITE "telephone")
(set mongo (NuMongoDB new))
(mongo connectWithOptions:nil)


(set args ((NSProcessInfo processInfo) arguments))
(unless (set phraseid (args 2))
        (set phraseid "4c7080514672bf0819c85ac8"))

(set phrase (mongo findOne:(dict _id:(oid phraseid)) inCollection:"telephone.phrases"))

(function trace (phrase languages level path info)
     (set translations (mongo findArray:(dict source_id:(phrase _id:)) inCollection:"telephone.translations"))
     (translations each:
          (do (translation)
              (set next (mongo findOne:(dict _id:(translation destination_id:)) inCollection:"telephone.phrases"))
              (unless (languages containsObject:(translation destination_language:))
                      (set newlanguages (languages mutableCopy))
                      (newlanguages addObject:(translation destination_language:))
                      (set newpath (path mutableCopy))
                      (newpath addObject:(dict text:(translation destination_text:)
                                               language:(translation destination_language:)))
                      (if (> (newpath count) ((info longestforward:) count))
                          (info longestforward:newpath))
                      (trace next newlanguages (+ level 1) newpath info)))))

(function traceback (phrase languages level path info)
     (set translations (mongo findArray:(dict destination_id:(phrase _id:)) inCollection:"telephone.translations"))
     (translations each:
          (do (translation)
              (set previous (mongo findOne:(dict _id:(translation source_id:)) inCollection:"telephone.phrases"))
              (unless (languages containsObject:(translation source_language:))
                      (set newlanguages (languages mutableCopy))
                      (newlanguages addObject:(translation source_language:))
                      (set newpath (path mutableCopy))
                      (newpath insertObject:(dict text:(translation source_text:)
                                                  language:(translation source_language:)) atIndex:0)
                      (if (> (newpath count) ((info longestback:) count))
                          (info longestback:newpath))
                      (traceback previous newlanguages (+ level 1) newpath info)))))


(puts (phrase description))
(set info (dict longestforward:(array (dict text:(phrase text:) language:(phrase language:))) 
                longestback:(array (dict text:(phrase text:) language:(phrase language:)))))


(trace phrase (NSSet set) 1 (array (dict text:(phrase text:) language:(phrase language:))) info)
(traceback phrase (NSSet set) 1 (array (dict text:(phrase text:) language:(phrase language:))) info)
(puts (info description))
