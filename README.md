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

1 daftar account pada https://github.com
2 install ssh
3 configurasikan ssh public key seperti tutorial [disini](https://help.github.com/articles/generating-ssh-keys)
4 instal git seperti tutorial [disini](http://git-scm.com/book/en/Getting-Started-Installing-Git)
5 buka applikasi `terminal` dan clone repository ini dengan mengetikan perintah
  (skip step ini jika repositori sudah ada di komputer lokal anda)

  ```sh
  $ git clone git@github.com:fauzanqadri/ti-project.git
  ```
  atau

  ```sh
  $ git clone https://github.com/fauzanqadri/ti-project.git
  ```
6 ketikan perintah

  ```sh
  $ cd ti-project
  ```
7 ketikan perintah

  ```sh
  $ sudo ./install.sh
  ```
8 setelah installasi selesai, install redis seperti tutorial [disini](http://redis.io/topics/quickstart)
9 install rvm seperti tutorial [disini](https://rvm.io/)
10 install ruby versi 2.1.0 atau lebih dengan mengetikan perintah

  ```sh
  $ rvm install 2.1.0
  ```
  tunggu installasi sampai selesai
11 ketikan perintah

  ```sh
  $ cd .
  ```
12 ketikan perintah

  ```sh
  $ bundle install
  ```
  tunggu sampai installasi selesai
13 buat file dengan nama `.env` dengan contoh content sebagai [berikut](https://gist.github.com/fauzanqadri/010cab3d86d3d356caf9)
14 buat file dengan nama `database.yml` pada direktori `config` dengan contoh content sebagai [berikut] (https://gist.github.com/fauzanqadri/10229111)
* setelah konfigurasi database telah selesai ketikan perintah berikut

  ```sh
  $ rake deploy:nginx_template
  ```
15 ketikan perintah berikut (pastikan server postgresql sudah berjalan)

  ```sh
  $ rake db:create && rake db:migrate && rake db:seed && rake assets:precompile
  ```
  perintah diatas hanya untuk pertama kali installasi untuk backup dan restore akan dijelaskan pada seksi dibawah

16 ketikan perintah berikut untuk menjalankan server pada saat startup(pastikan nginx berjalan juga pada saat start up)

  ```sh
  rvmsudo foreman export --app simps --user $(whoami) upstart /etc/init
  ```
  setelah melakukan langkah diatas seharus nya web server sudah berjalan coba kunjungi halaman web pada browser anda

###Backup and Restore
Applikasi ini memiliki unsur penting yang harus diperhatikan yaitu
- database dan
- directory penyimpanan file PKL dan Skripsi yang telah di set pada
  `.env` file pada bagian `PAPERCLIP_PATH`

#### Backup
- backup database postgresql dengan tutorial dengan tutorial yang berada [disini](http://www.postgresql.org/docs/9.1/static/backup-dump.html)
- simpan file backup pada hardisk external atau semacamnya
- Copy directory `PAPERCLIP_PATH` yang telah diset pada `.env` pada hardisk external atau
  semacamnya


#### Restore
- restore database dump file dengan tutorial yang berada [disini](http://www.postgresql.org/docs/9.1/static/backup-dump.html)
- simpan kembali directory `PAPERCLIP_PATH` dan konfigurasi ulang `.env` untuk menyesuaikan aplikasi
- lakukan step pada installasi tetapi skip step ke-15
- ketikan perintah berikut pada terminal
  ```sh
  rake assets:precompile
  ```
- lanjutkan pada step 16 pada seksi installasi jika diperlukan


###Keterangan
####.env File
`RAILS_ENV`

environment applikasi akan digunakan `development`, `test`, `production`
penggantian environment mengakibatkan penggantian pada konfigurasi
database.

`FAYE_TOKEN`

token untuk authentikasi websocket gunakan perintah `rake secret` untuk
menggenerate token

`WS_URI`

URL Web socket pada aplikasi konfigurasi port tetap pada port `9292`
(pastikan port tersebut tidak ada yang menggunakan) sedangkan pada host
sesuaikan dengan domain yang digunakan

`PAPERCLIP_PATH`

lokasi direktori penyimpanan file berkas Pkl, Skripsi dan Avatar

`REDIS_URL`

NoSQL database yang digunakan oleh aplikasi konfigurasi tetap pada
`redis://127.0.0.1:6379/0` jika redis berada pada server yang sama



###Kontribusi
* Fork Repositori
* Buat branch baru
* Hack Hack Hack
* buat pull-request pada github
