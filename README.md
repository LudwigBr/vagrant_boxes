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


You need to create a "github_login.sh"-file in which you enter your github credentials to clone from private repositories and the url to the repository.
use the following structure:
name="github_login_name"
pw="github_login_password"
giturl="url_to_github_repository"

You can access your repository via "localhost/name_of_github_repository"