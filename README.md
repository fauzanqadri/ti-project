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
* configurasikan ssh public key seperti tutorial [disini](https://help.github.com/articles/generating-ssh-keys)
* instal git seperti tutorial [disini](http://git-scm.com/book/en/Getting-Started-Installing-Git)
* buka applikasi `terminal` dan clone repository ini dengan mengetikan perintah
  (skip step ini jika repositori sudah ada di komputer lokal anda)
  ```shell
  $ git clone git@github.com:fauzanqadri/ti-project.git
  ```
  atau
  ```shell
  $ git clone https://github.com/fauzanqadri/ti-project.git
  ```
* ketikan perintah
  ```shell
  $ cd ti-project
  ```
* ketikan perintah
  ```shell
  $ sudo ./install.sh
  ```
* setelah installasi selesai, install redis seperti tutorial [disini](http://redis.io/topics/quickstart)
* install rvm seperti tutorial [disini](https://rvm.io/)
* install ruby versi 2.1.0 atau lebih dengan mengetikan perintah
  ```shell
  $ rvm install 2.1.0
  ```
  tunggu installasi sampai selesai
* ketikan perintah
  ```shell
  $ cd .
  ```
* ketikan perintah
  ```shell
  $ bundle install
  ```
  tunggu sampai installasi selesai
* buat file dengan nama `.env` dengan contoh content sebagai [berikut](https://gist.github.com/fauzanqadri/010cab3d86d3d356caf9)
* buat file dengan nama database.yml pada direktori config dengan contoh content sebagai [berikut](https://gist.github.com/fauzanqadri/10229111)
