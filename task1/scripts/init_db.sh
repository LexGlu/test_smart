# bash script to create database, tables and insert sample data into tables
# to run this script, run the following command in the terminal:
# docker exec -it sqlserver bash /usr/src/app/scripts/init_db.sh

# set variables
SA_PASSWORD='VeryStrongPassword123'
DB_NAME='sports_web_portal'


# create database
/opt/mssql-tools/bin/sqlcmd -S db -U sa -P $SA_PASSWORD -d master -Q "CREATE DATABASE $DB_NAME"

# create tables
/opt/mssql-tools/bin/sqlcmd -S db -U sa -P $SA_PASSWORD -d $DB_NAME -i /usr/src/app/scripts/create_tables.sql

# insert data into tables from csv files
/opt/mssql-tools/bin/sqlcmd -S db -U sa -P $SA_PASSWORD -d $DB_NAME -i /usr/src/app/scripts/insert_data.sql

# register stored procedures in the database
/opt/mssql-tools/bin/sqlcmd -S db -U sa -P $SA_PASSWORD -d $DB_NAME -i /usr/src/app/scripts/stored_procedures.sql