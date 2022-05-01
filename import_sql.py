#import required packages
import pandas as pd
import psycopg2
import numpy
from psycopg2.extensions import register_adapter, AsIs
def addapt_numpy_float64(numpy_float64):
    return AsIs(numpy_float64)
def addapt_numpy_int64(numpy_int64):
    return AsIs(numpy_int64)
register_adapter(numpy.float64, addapt_numpy_float64)
register_adapter(numpy.int64, addapt_numpy_int64)
# cursor.executemany()

#connect to the database
conn = psycopg2.connect(database='DMQL_project', user='postgres', password='abc@123')
print("connection successful")


cursor = conn.cursor()

# #read the data from the csv file
dataframe = pd.read_csv("C:/Users/Mariya/OneDrive/Desktop/Spring22/DMQL/DMQL-project/india-districts-census-2011.csv")

#get the DB schema:
# print(pd.io.sql.get_schema(dataframe.reset_index(), 'data'))
# print(dataframe.iloc[150:,:])
# exit()
insert_lst = list()
#iterate over the data rows in order to get the insert query
#created the blueprint of the query and generated the data to be populated trhough query
insert_str = "INSERT INTO data VALUES("
insert_list = list()
for i in range(640):
    
    insert_list.append(tuple([str(dataframe['District code'][i]), str(dataframe['State name'][i]),\
                    str(dataframe['District name'][i]),dataframe['Population'][i],\
                    dataframe['Male'][i],dataframe['Female'][i],dataframe['Literate'][i],\
                    dataframe['Male_Literate'][i],dataframe['Female_Literate'][i],dataframe['Male_Workers'][i],\
                    dataframe['Female_Workers'][i],dataframe['Frontline_Workers'][i],\
                    dataframe['Industrial_Workers'][i],\
                    dataframe['Non_Workers'][i],dataframe['Cultivator_Workers'][i],dataframe['Agricultural_Workers'][i],\
                    dataframe['Household_Workers'][i],dataframe['Other_Workers'][i],dataframe['LPG_or_PNG_Households'][i],\
                        dataframe['Housholds_with_Electric_Lighting'][i],\
                    dataframe['Households_with_Internet'][i],dataframe['Households_with_Computer'][i],\
                    dataframe['Rural_Households'][i],dataframe['Urban_Households'][i],dataframe['Below_Primary_Education'][i],\
                    dataframe['Primary_Education'][i],dataframe['Middle_Education'][i],dataframe['Secondary_Education'][i],\
                    dataframe['Higher_Education'][i],dataframe['Graduate_Education'][i],dataframe['Other_Education'][i],\
                    dataframe['Age_Group_0_29'][i],dataframe['Age_Group_30_49'][i],dataframe['Age_Group_50'][i],\
                    dataframe['Age not stated'][i]


                    ]))
    #pythonic way to generate the queries to be used on Postgres DB data insertion
print(insert_list[0])
cursor.executemany("INSERT INTO data VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", insert_list)

conn.commit()
conn.close()