(load "NuMongoDB")

(set DATABASE "telephones")

(set mongo (NuMongoDB new))
(mongo connectWithOptions:nil)

(set tables (array "phrases" "translations"))
(tables each:
        (do (table)
	    (puts table)
            (mongo dropCollection:table inDatabase:DATABASE)))

