#SIMPS

**Sistem Informasi Manajemen PKL SKRIPSI**

tugas PKL(Praktek Kerja Lapangan)

###Requirements

- Nix / Nux OS
- SSH
- GIT
- PostgreSQL
- Redis
- rvm
- Ruby 2.1.0
- Rails 4.0.2

###Installation

* daftar account pada https://github.com
* install ssh
* configurasikan ssh public key seperti tutorial https://help.github.com/articles/generating-ssh-keys
* instal git seperti tutorial http://git-scm.com/book/en/Getting-Started-Installing-Git
* buka terminal dan clone repository ini dengan mengetikan perintah
  (skip step ini jika repositori sudah ada di komputer lokal anda)
  `git clone git@github.com:fauzanqadri/ti-project.git`
  atau
  `git clone https://github.com/fauzanqadri/ti-project.git`
* ketikan perintah
  `cd ti-project`
* ketikan perintah
  `sudo ./install.sh`
* setelah installasi selesai, install redis seperti tutorial
  http://redis.io/topics/quickstart
* install rvm seperti tutorial https://rvm.io/
* install ruby versi 2.1.0 atau lebih dengan mengetikan perintah
  `rvm install 2.1.0`
  tunggu installasi sampai selesai
* ketikan perintah
  `cd .`
* ketikan perintah
  `bundle install`
  tunggu sampai installasi selesai
* buat file dengan nama `.env` dengan contoh content sebagai berikut
  ```env
  RAILS_ENV="production"
  FAYE_TOKEN="some wierd token"
  WS_URI="http://localhost:9292/faye"
  PAPERCLIP_PATH="$HOME/paperclip"
  REDIS_URL="redis://127.0.0.1:6379/0"
  ```
* buat file dengan nama database.yml dengan contoh content sebagai
  berikut
  ```yaml
  production:
    adapter: postgresql
    database: nama_database
    pool: 5
    reaping_frequency: 10
    host: localhost
    username: username
    password: password
  ```
