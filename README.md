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

change password for postgres:
- psql postgres postgres
- \password postgres
- \q

You can access your repository via "localhost/name_of_github_repository"