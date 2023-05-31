from pyspark.sql import SparkSession
from pyspark.sql.functions import udf, count, round
import os


def main():
    
    # create a Spark session
    spark = SparkSession.builder.appName("task2").getOrCreate()

    script_name = __file__.split('/')[-1]
    path_to_files = __file__.split(script_name)[0]

    # get all csv files
    data_files = [os.path.join(path_to_files, file) for file in os.listdir(path_to_files) if file.startswith('Data_part') and file.endswith('.csv')]
    data_files.sort() # sort files by name to get them in correct order for union later (since header is only in first file)

    # read only first file into df (DataFrame)
    df = spark.read.option('delimiter', ';').csv(data_files[0], header=True, inferSchema=True)

    # get schema from df for further use in union
    schema = df.schema 

    # add all other files to df with same schema as first file but without header
    for file in data_files[1:]:
        df = df.union(spark.read.option('delimiter', ';').csv(file, header=False, schema=schema))
        
    # define a user-defined function (UDF) to extract the domain from an email address
    def extract_domain(email):
        if email and '@' in email:
            return email.split('@')[1]
        else:
            return None
        
    # register the UDF
    extract_domain_udf = udf(extract_domain)

    # apply the UDF to create a new column 'domain'
    df = df.withColumn('domain', extract_domain_udf(df['email']))

    total_rows_with_domain = df.filter(df['domain'].isNotNull()).count() # within these files all rows have a domain (no null values)

    # create new df with count of rows for each domain (sorted by count descending)
    df_domain_fraction = df.groupBy('domain').agg(count('domain').alias('count')).sort('count', ascending=False)
    # add new column with fraction of rows for each domain (rounded to 4 decimal places for better readability)
    df_domain_fraction = df_domain_fraction.withColumn('fraction', round(df_domain_fraction['count'] / total_rows_with_domain, 4))
    df_domain_fraction.show()

    # create new df with company_name and count of people for each company_name and sort by count descending
    df_people_count_by_company = df.groupBy('company_name').agg(count('company_name').alias('count')).sort('count', ascending=False)
    df_people_count_by_company.show()

    # write data from df_domain_fraction to csv file (only domain and fraction)
    df_domain_fraction.select('domain', 'fraction').write.csv(os.path.join(path_to_files, 'task2_domain_fraction'), header=True, sep=';', mode='overwrite')

    # write data from df_people_count_by_company to csv file
    df_people_count_by_company.write.csv(os.path.join(path_to_files, 'task2_people_count_by_company'), header=True, sep=';', mode='overwrite')

    # Stop the Spark session
    spark.stop()
    

if __name__ == "__main__":
    main()