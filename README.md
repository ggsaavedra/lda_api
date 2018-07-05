# lda_api

This api had the following parameters:

1. text_data = If datatype is dataframe. This is for raw text input in json format.
		example: ["erwin tulfo is bashing abs-cbn news","ben tulfo and erwin tulfo are brothers","harry roque has an issue with indiana pacers","abs-cbn news talkes about the discrepancy in the department of tourism","people's television network inc. file a case against los angeles lakers"]


2. tablename = If data type is database. This should contain table name from mysql db. This should beuse when the data desired to analyse is stored in the db

3. fieldname = If data type is database. This should be used only when tablename is specified. Thi refers to the field which contains the desired text data fromt table

4. type = "dataframe" or "database"

5. k=5 = number of topics

6. maxterms = maximum terms to out put per topic. This should contain the top most relevant terms per topic
