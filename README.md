# Job Board 2

**Job board 2** uses Ruby on Rails 3.2.3 version

It's a popular job board in Japan known as **ShigotoDoko**

Primarily developed focusing on brazilians living in Japan.

It allows companys to directly publish their jobs announces into the website
for a limited period of time without any cost.

It also allow registered users to create and publish their curriculum vitae. (not available yet in this version)


## Instalation

Clone the repository:

`git clone https://github.com/klebershimabuku/job_board2.git`

Create the `config/database.yml` file and configure it accordly your ORM.

`touch config/database.yml`

Create the databases:

`bundle exec rake db:create:all`

Run the migrations:

`bundle exec rake db:migrate`

Populate the prefectures:

`bundle exec rake db:populate:prefectures`

Also, optionally you can populate with sample users:

`bundle exec rake db:populate:users`

Make sure to edit the `lib/sample_data.rake` to set your admin login/password BEFORE run it.

## Maintainers

* Kleber Shimabuku (https://github.com/klebershimabuku) 
* Marcelo Mogami (https://github.com/celo)