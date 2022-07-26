#!/bin/bash
# Location to place backups
backup_dir="/mnt/backup/backups"
# String to append to the name of the backup files
backup_date=`date +%Y-%m-%d`
# Numbers of days you want to keep copie of your databases
number_of_days=2
databases=`psql -l -t | cut -d'|' -f1 | grep 'base_name' | sed -e 's/ //g' -e '/^$/d'`
for db in $databases; do  if [ "$db" != "postgres" ] && [ "$db" != "template0" ] && [ "$db" != "template1" ] && [ "$db" != "template_postgis" ]; then
    echo Dumping $db to $backup_dir/$db-$backup_date.gz
    pg_dump -Fc -f $backup_dir/$db-$backup_date.gz $db
  fi
done
find $backup_dir -type f  -mtime +`expr $number_of_days - 1` -exec rm -f {} \;