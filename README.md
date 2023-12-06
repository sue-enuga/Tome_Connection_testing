# Tome_Connection_testing
Tome_connection_testing - There are two apps both of them written in Node.js with Prisma client ORM equipped to do connections with CRDB. 


#Connection_testing_NoPooling
1. This module has the app setup to go direct to CockroachDB. 
2. There is also `app_nopooling.js` file which can be used to run insert using in a single connection.

#Connection_testing_pgbouncer
1. This module has the app setup to go through PGBOUNCER and then CockroachDB.
2. The equivalent for a single connection insert for pgbouncer is in `app_pgbouncer.js` file. 

#Changes to the App
1. Change the CockraochDB URL in 'schema.prisma' files.
2. Change the Pgbouncer URL in the 'schema.prisma' files.
3. Change the InsertRandomNumbers(XXXX) values. XXXX is the configurable number.

#Changes to the Schema
1. Change your `schema.prisma` with data models

#Pgbouncer
1. Set up Pgbouncer and make sure the pgbouncer.ini has the same configuraitons as the one on the Homedirectory in our system. 
2. Replace Pgbouncer.ini's DB URL with CockroachDB's URL
3. Make sure to start pgbouncer before you start running the app.

#Helpful PGBPOUNCER commands
```
Connect to pgbouncer
psql -h localhost -p 6432 -U sue
Restart pgbouncer
pgbouncer -R pgbouncer.ini
Connect to PGbouncer schema
psql -p 6432 -U pgbouncer
SHOW SERVERS; SHOW STATS; SHOW POOLS; SHOW CLIENTS;
```
#Helpful prisma commands
```
make changes to schema file and push the changes.
Prisma db push
run app
node <nameoftheappfile>.js
```g
