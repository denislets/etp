Ansible

Папка ansible содержит плейбуки для 3 задания.

bootstrap.yml установка докера и сертификата

docker.yml запуск rabbitmq

rabbitmq_remove.yml для задания в принципе не нужен, но для проверки понадобится. Удаляет установленный и запущенный rabbitmq

Файл в hosts содержит адреса хостов, в remote поменять на выданную машину

В files/ca лежит сертификат нужный для выполнения плейбука.

Health-check сервис находится в Source.

В проекте везде поменять мои данные denis.lets на свои!
