# Happenoid
Маленький клон ithappens.me

Для запуска на своей машине:

1. Установить Ruby 4.1.6 и Rails 4.2.3
2. Клонировать репозиторий в локальную папку
3. ```cd happenoid```
4. ```bundle install```
5. По умолчанию проект настроен на работу с sqlite
6. Для интеграции с mysql заменить ```db/database.yml``` на ```db/mysql_database.yml``` и убедиться, что проект будет иметь доступ к БД с указанными там настройками
7. ```rake db:setup``` для создания баз и таблиц

Стандартный пароль администратора - ```123456```

Уот так уот. 
