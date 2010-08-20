(set all-codes <<-END
 Abkhazian ab
 Afar aa
 Afrikaans af
 Albanian sq
 Amharic am
 Arabic ar
 Armenian hy
 Assamese as
 Aymara ay
 Azerbaijani az
 Bashkir ba
 Basque eu
 Bengali bn
 Bhutani dz
 Bihari bh
 Bislama bi
 Breton br
 Bulgarian bg
 Burmese my
 Byelorussian be
 Cambodian km
 Catalan ca
 Chinese zh
 Corsican co
 Croatian hr
 Czech cs
 Danish da
 Dutch nl
 English en
 Esperanto eo
 Estonian et
 Faeroese fo
 Fiji fj
 Finnish fi
 French fr
 Frisian fy
 Galician gl
 Georgian ka
 German de
 Greek el
 Greenlandic kl
 Guarani gn
 Gujarati gu
 Hausa ha
 Hebrew he
 Hindi hi
 Hungarian hu
 Icelandic is
 Indonesian id
 Interlingua ia
 Interlingue ie
 Inupiak ik
 Inuktitut iu
 Irish ga
 Italian it
 Japanese ja
 Javanese jw
 Kannada kn
 Kashmiri ks
 Kazakh kk
 Kinyarwanda rw
 Kirghiz ky
 Kirundi rn
 Korean ko
 Kurdish ku
 Laothian lo
 Latin la
 Latvian lv
 Lingala ln
 Lithuanian lt
 Macedonian mk
 Malagasy mg
 Malay ms
 Malayalam ml
 Maltese mt
 Maori mi
 Marathi mr
 Moldavian mo
 Mongolian mn
 Nauru na
 Nepali ne
 Norwegian no
 Occitan oc
 Oriya or
 Pashto ps
 Persian fa
 Polish pl
 Portuguese pt
 Punjabi pa
 Quechua qu
 Rhaeto-Romance rm
 Romanian ro
 Russian ru
 Language ISO
 Samoan sm
 Sangro sg
 Sanskrit sa
 Scots Gaelic gd
 Serbian sr
 Serbo-Croatian sh
 Sesotho st
 Setswana tn
 Shona sn
 Sindhi sd
 Singhalese si
 Siswati ss
 Slovak sk
 Slovenian sl
 Somali so
 Spanish es
 Sudanese su
 Swahili sw
 Swedish sv
 Tagalog tl
 Tajik tg
 Tamil ta
 Tatar tt
 Tegulu te
 Thai th
 Tibetan bo
 Tigrinya ti
 Tonga to
 Tsonga ts
 Turkish tr
 Turkmen tk
 Twi tw
 Uigur ug
 Ukrainian uk
 Urdu ur
 Uzbek uz
 Vietnamese vi
 Volapuk vo
 Welch cy
 Wolof wo
 Xhosa xh
 Yiddish yi
 Yoruba yo
 Zhuang za
 Zulu zu
END)

;; these languages can be cross-translated using Google Translate
;; http://code.google.com/apis/ajaxlanguage/documentation/#SupportedPairs
(set code-string <<-END
 Afrikaans af
 Albanian sq
 Arabic ar
 Bulgarian bg
 Catalan ca
 Chinese zh
 Croatian hr
 Czech cs
 Danish da
 Dutch nl
 English en
 Estonian et
 Finnish fi
 French fr
 Galician gl
 German de
 Greek el
 Hebrew he
 Hindi hi
 Hungarian hu
 Icelandic is
 Indonesian id
 Irish ga
 Italian it
 Japanese ja
 Korean ko
 Latvian lv
 Lithuanian lt
 Macedonian mk
 Malay ms
 Maltese mt
 Norwegian no
 Persian fa
 Polish pl
 Portuguese pt
 Romanian ro
 Russian ru
 Serbian sr
 Slovak sk
 Slovenian sl
 Spanish es
 Swahili sw
 Thai th
 Turkish tr
 Ukrainian uk
 Vietnamese vi
 Welch cy
 Yiddish yi
END)

(set languages
     ((code-string lines) map:
      (do (line)
          ((line stringByTrimmingCharactersInSet:
                 (NSCharacterSet whitespaceCharacterSet))
           componentsSeparatedByString:" "))))

(set languages
     (languages map:
          (do (code)
              (dict name:(code 0) code:(code 1)))))

(load "NuJSON")

((languages JSONRepresentation) writeToFile:"languages.json" atomically:NO)

