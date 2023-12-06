import uuid
import random
import psycopg2
import psycopg2.extras
from random_word import RandomWords
import time 
import random_name
import decimal


# Database connection parameters
db_params = {
    'dbname': 'tome_updated_uuid',
    'user': 'tome_cdc_sink',
    'password': 'bNJenBCHz3OOQXfsa0XikQ',
    'host': 'shand-sue-tome-m35.aws-us-west-2.cockroachlabs.cloud',
    'port': '26257',
    'sslmode' : 'verify-full',
    'sslrootcert' : '/Users/Shand/Library/CockroachCloud/certs/277cd25a-97f3-467b-8bf1-1e7f6fa69840/shand-sue-tome-ca.crt'
}

psycopg2.extras.register_uuid()


# Connect to the database    
conn = psycopg2.connect(**db_params)
#conn = psycopg2.connect()
print (conn)
cursor = conn.cursor()
try:


    # Insert 10000 rows
    numofrows = 100
    i = 1
    while i < numofrows:
        org_id = uuid.uuid4()
        user_id = uuid.uuid4()
        tome_id = uuid.uuid4()
        page_id = uuid.uuid4()
        typefamily_id = uuid.uuid4()
        font_id = uuid.uuid4()
        userreferralcode_id = uuid.uuid4()
        creditaccount_id = uuid.uuid4()
        auth0id_id = uuid.uuid4()
        theme_id = uuid.uuid4()

        
        r=RandomWords()
   
        #insert_query = "INSERT INTO Organization (id, auth0Id, slug, name ) VALUES (%s,%s,%s,%s)"
        #val = ()
        #cursor.execute(insert_query, (random_uuid, random_name, random_address))
        #user_insert_query =         """ INSERT INTO "User" (id,email,"updatedAt","auth0Id") VALUES (%s,%s,now(),%s);"""
        organization_insert_query = """ INSERT INTO "Organization" (id, "auth0Id", slug, name) VALUES (%s,%s,%s,%s);
                                        INSERT INTO "User" (id,email,"updatedAt", "auth0Id") VALUES (%s,%s,now(),%s);
                                        INSERT INTO "Tome" (id,"orgId","authorId",title,"updatedAt") VALUES (%s,%s,%s,%s,now());
                                        INSERT INTO "TypeFamily" (id,"name") VALUES (%s,%s);
                                        INSERT INTO "Font" (id,weight,italic,"typeFamilyId") VALUES (%s,%s,%s,%s);
                                        INSERT INTO "Theme" (id,"orgId",colors,"headingFontId","paragraphFontId") VALUES (%s,%s,%s,%s,%s);
                                        INSERT INTO "Page" (id,"tomeId","order","themeId","updatedAt") VALUES (%s,%s,%s,%s,now());
                                        INSERT INTO "UserReferralCode" (id,"updatedAt","userId",code,status) VALUES (%s,now(),%s,%s,'ACTIVE');
                                        INSERT INTO "CreditsAccount" (id,"updatedAt","userId") VALUES (%s,now(),%s);


                            """
                    
        organization_record_to_insert = (org_id,auth0id_id,r.get_random_word(),r.get_random_word(),
                                         user_id,r.get_random_word(),auth0id_id,
                                         tome_id,org_id,user_id,r.get_random_word(),
                                         typefamily_id,r.get_random_word(),
                                         font_id,random.randint(0,9999),False,typefamily_id,
                                         theme_id,org_id,"{}",font_id,font_id,
                                         page_id,tome_id,decimal.Decimal(random.randrange(155, 389))/100,theme_id,
                                         userreferralcode_id,user_id,r.get_random_word(),
                                         creditaccount_id,user_id

                                     
                                     
                                        )
   
    #user_record_to_insert = (user_id,r.get_random_word(),auth0id_id)
        cursor.execute(organization_insert_query,organization_record_to_insert)
    #cursor.execute(user_insert_query,user_record_to_insert)
        conn.commit()
    #conn.commit()
        print(i)
        i+=1
    print("Inserted",numofrows,"rows successfully!")

except (psycopg2.Error, Exception) as e:
    print("Error:", e)

finally:
    if cursor:
        cursor.close()
    if conn:
        conn.close()
