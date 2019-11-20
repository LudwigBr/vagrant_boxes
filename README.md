# vagrant_phalcon

this repository delivers a vagrant enviroment with the following software:
- ubuntu 14.04
- nginx             
- php 7.09          
- phalcon 3.0
- postgresql        


forwarded ports (can be changed in vagrantfile):
- 80 - nginx
- 9000 - php-fpm
- 5432 - postgres

change password for postgres and create database:
- psql postgres postgres
- \password postgres
- \q
- createdb -U postgres athlete_manager (outside of psql!)
- psql -U postgres -d athlete_manager -a -1 -f PATH_TO_SQL/DDL_FILE 
- psql -U postgres athlete_manager < db_dump_data_only 



You can access your repository via "localhost/name_of_github_repository"

# database postgres
To access the database via command line use the following command:
```
psql "postgresql://$DB_USER:$DB_PASSWORD@localhost/$DB_NAME"
```
To run a SQL script use:
```
psql "postgresql://$DB_USER:$DB_PASSWORD@localhost/$DB_NAME" -f $FILENAME
```
To create schema (-s) or data (-a) file (.ddl) use:
```
pg_dump "postgresql://$DB_USER:$DB_PASSWORD@localhost/$DB_NAME" -f $FILENAME -s/-a
```
When running SQL commands remember to finish every command with a ";".

