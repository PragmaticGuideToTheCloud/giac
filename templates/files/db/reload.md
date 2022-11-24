
# RELOAD DATABASE ON BASTION

```
mysql -h <<< db.database_host >>> -u <<< db.database_user >>> -p<<< db.database_password >>> -D <<< db.database_name >>> < db-backups/prod-current.sql
```
