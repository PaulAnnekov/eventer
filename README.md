Если Vagrant не запустится, то пробуйте How to run. Если запустится, то будет
доступен по адресу 10.0.0.2

# How to run

- Установить 64-битный Dart с офф. сайта https://www.dartlang.org/
- Установить MongoDB.
- Начать раздачу файлов клиент. Запустить "pub serve" с папки ev_client.
- Запустить демон mongod на порту 27017 или изменить настройки подключения в ev_common/configs/config.yaml.
- Запустить сервер. Запустить "pub run server.dart" с папки ev_server.
- Перейти в браузере Dartium (в папке с установленным dart sdk есть папка chromium) по ссылке 127.0.0.1:8081
- Админка находится по ссылке /admin. Авторизацию сделать не успел.

# Why 64-bit?

1. Because I have not tested 32-bit version :).
2. Go to step 1.

# Workarounds

- Angular's transformer needs path to Dart's SDK folder. It can fail only in linux.
Try to uncomment one of 'dart_sdk' parameters in ev_client/pubspec.yaml

# Speed up Vagrant

- Set CPUs number. Default value is 1 :(.
- Set memory value.