<!-- readme for  -->

## Setup and requirements
- Clone the repository
- Create a virtual environment by running `python3 -m venv venv`
- Activate the virtual environment by running `source venv/bin/activate`
- Run `pip install -r requirements.txt` to install the dependencies for task2

## Task 1

### Description of the database and scripts in accordance with the task1
- Task1 description is available in the task1 directory [task1.docx](./task1/task1.docx)
- ER diagram is available in the task1 directory [ERD.pdf](./task1/ERD.pdf) and via link (interactive): https://dbdiagram.io/d/64773a59722eb774942440cb
- DB schema is available in the task1 directory [db_schema.png](./task1/db_schema.png)
- SQL scripts that create tables, keys, and constraints in the database are here [create_tables.sql](./task1/scripts/create_tables.sql)
- SQL scripts that populate the tables with sample data are here [insert_data.sql](./task1/scripts/insert_data.sql)
- SQL scripts for the stored procedures are here [stored_procedures.sql](./task1/scripts/stored_procedures.sql)
- SQL scripts for 10 KPIs are here [kpi.sql](./task1/scripts/kpi.sql)

### Deploying the database via docker-compose
1. Navigate to the task1 directory by running `cd task1`
2. Run `docker-compose up -d` to start the database container
3. Execute `docker exec -it sqlserver bash /usr/src/app/scripts/init_db.sh` to initialize the database, this will create the database (sports_web_portal) and tables (DDL scripts) and populate them with sample data (DML scripts).
4. The database is now ready to be used, the connection parameters are:
    - Host: localhost (or db if running from a docker container)
    - Port: 1433
    - Username: sa
    - Password: VeryStrongPassword123
5. To stop the database container, run `docker-compose down -v`


## Task 2

- Task2 description is available in the task2 directory [task2.docx](./task2/task2.docx)
- Python script that reads data from CSV files via pyspark dataframe is here [task2.py](./task2/task2.py)

### Running the script
1. Navigate to the task2 directory by running `cd task2`
2. Run `python3 task2.py` to run the script
3. The script will write results CSV files located in subdirectories of task2 (task2/task2_domain_fraction and task2/task2_people_count_by_company).












