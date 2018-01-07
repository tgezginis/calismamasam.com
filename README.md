![Build Status](https://circleci.com/gh/calismamasam/calismamasam.com.svg?style=svg)
[![Code Climate](https://codeclimate.com/github/calismamasam/calismamasam.com.svg)](https://codeclimate.com/github/calismamasam/calismamasam.com)

![Çalışma Masam](https://calismamasam.com/logo-240w.png)

[Çalışma Masam](https://calismamasam.com), teknoloji ile iç içe olan, sektöründeki yenilikleri takip eden ve aynı zamanda bunları paylaşmaktan keyif alan profesyonellerin; kullandığı cihazlar ve yazılımları, dinlediği müzikleri ve diğer merak edilen soruları cevapladığı bir röportaj sitesidir.

## Kullanılan teknolojiler
* [Ruby on Rails](https://github.com/rails/rails)
* [PostgreSQL](https://www.postgresql.org/)
* [Redis](https://redis.io/)

*Ek olarak birçok Ruby Gem paketi kullanıyoruz. Tüm listeye [Gemfile](https://github.com/calismamasam/calismamasam.com/blob/master/Gemfile) dosyasından erişebilirsiniz.*

Kurulum
-------------------

Projeyi klonla;

	git clone git@github.com:calismamasam/calismamasam.com.git
	cd calismamasam.com

Bağımlı olunan gem paketlerini kur;

	bundle install

.env dosyasını düzenle;

	cp .env.example .env

*Dikkat: .env dosyasında yer alan DATABASE_HOST, DATABASE_USERNAME, DATABASE_PASSWORD değişkenlerini güncellenmelidir*

Database migration dosyalarını çalıştır;

	rake db:migrate

Seed data oluştur (opsiyonel);

	rake db:seed

Sunucuyu çalıştır;

	rails server


**Testleri çalıştırma**

Çalışma Masam olarak deployment öncesi testleri çalıştırmak için [CircleCI](https://circleci.com/) kullanıyoruz.

Çalışma anında yapacağınız testler için rspec komutunu kullanabilirsiniz;

	bundle exec rspec

## Sen de katkıda bulun
Çalışma Masam tamamen açık kaynak olarak geliştirilmektedir. Siz de bizlere öneri ya da şikayetlerinizi [bildirebilir](https://github.com/calismamasam/calismamasam.com/issues), yapacağınız geliştirmeler ile bize katkıda bulunabilirsiniz.

## Katkıda bulunanlar
* Tolga Gezginiş
