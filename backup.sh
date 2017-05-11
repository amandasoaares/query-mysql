#!/bin/sh
backup="/backup/lumis/full"
cd $backup
NOW=$(date +"%d-%m-%Y")

MUSER=backup_agent
MPASS="manager1"
MHOST="172.30.113.80"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
GZIP="$(which gzip)"
MAIL="infra.db@buscapecompany.com","infra.operacao@buscapecompany.com"
MAILER="$(which mail)"
STATUSFILE="/backup/lumis/full/statusfile.$NOW"

echo "Backup report from $NOW" > $STATUSFILE ','
#DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
#for db in $DBS
#do
#FILE=$backup/jira-$db.$NOW.sql.gz
#mkdir -p $BACKUP/$NOW

$MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS --all-databases --single-transaction --routines --triggers | $GZIP > $backup/lumis-.$NOW.sql.gz
 if [ "$?" -eq "0" ]; then
   echo "all-databases backup is OK" >> $STATUSFILE

else

   echo "##### WARNING: #####  $all-databases backup failed" >> $STATUSFILE ','
 fi
done
$MAILER -s "Backup report for $NOW" -- $MAIL < $STATUSFILE
rm $STATUSFILE
