#!/bin/bash

# Backup MariaDB databases
docker exec -it supernote-mariadb bash -c 'mysqldump -u root -p$MYSQL_ROOT_PASSWORD supernotedb' | dd of=/data/supernote/mariadb_backup/$(date +%Y-%m-%d_%H-%M-%S)_db_backup.sql

# Backup note files from Supernote device to mounted storage
rsync -a /data/supernote/supernote_data/ /mnt/supernote-files/
rsync -a /data/supernote/mariadb_backup/ /mnt/supernote-files/mariadb_backup/



