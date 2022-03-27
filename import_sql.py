#import required packages
import pandas as pd
# import psycopg2

#connect to the database
# conn = psycopg2.connect("dbname=DMQL_project user=postgres password=abc@123")

# #read the data from the csv file
# dataframe = pd.read_csv("C:/Users/Mariya/OneDrive/Desktop/Spring22/DMQL/india-districts-census-2011.csv")

#get the DB schema:
# print(pd.io.sql.get_schema(dataframe.reset_index(), 'data'))

#iterate over the data rows in order to get the insert query
#created the blueprint of the query and generated the data to be populated trhough query
for i in range(21):
    insert_str = "INSERT INTO data VALUES("
    insert_str+=str(dataframe['District code'][i])+','+'\''+str(dataframe['State name'][i])\
                +'\',\''+str(dataframe['District name'][i])+'\','+str(dataframe['Population'][i])+\
                    ','+str(dataframe['Male'][i])+','+str(dataframe['Female'][i])+','+str(dataframe['Literate'][i])\
                    +','+str(dataframe['Male_Literate'][i])+','+str(dataframe['Female_Literate'][i])+','+str(dataframe['Male_Workers'][i])\
                    +','+str(dataframe['Female_Workers'][i])+','+str(dataframe['Frontline_Workers'][i])+\
                    ','+str(dataframe['Industrial_Workers'][i])+\
                    ','+str(dataframe['Non_Workers'][i])+','+str(dataframe['Cultivator_Workers'][i])+','+str(dataframe['Agricultural_Workers'][i])\
                    +','+str(dataframe['Household_Workers'][i])+','+str(dataframe['Other_Workers'][i])+','+str(dataframe['LPG_or_PNG_Households'][i])+','+\
                        str(dataframe['Housholds_with_Electric_Lighting'][i])\
                    +','+str(dataframe['Households_with_Internet'][i])+','+str(dataframe['Households_with_Computer'][i])+\
                    ','+str(dataframe['Rural_Households'][i])+','+str(dataframe['Urban_Households'][i])+','+str(dataframe['Below_Primary_Education'][i])\
                    +','+str(dataframe['Primary_Education'][i])+','+str(dataframe['Middle_Education'][i])+','+str(dataframe['Secondary_Education'][i])\
                    +','+str(dataframe['Higher_Education'][i])+','+str(dataframe['Graduate_Education'][i])+','+str(dataframe['Other_Education'][i])+\
                    ','+str(dataframe['Age_Group_0_29'][i])+','+str(dataframe['Age_Group_30_49'][i])+','+str(dataframe['Age_Group_50'][i])\
                    +','+str(dataframe['Age not stated'][i])\
                    +');'
    #pythonic way to generate the queries to be used on Postgres DB data insertion
    print(insert_str)