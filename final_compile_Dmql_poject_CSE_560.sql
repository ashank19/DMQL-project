DROP table data, state, district, literacy, profession, population, utilities;


CREATE TABLE Data (
  District_code INTEGER,
  State_name TEXT,
  District_name TEXT,
  Population bigint,
  Male bigint,
  Female bigint,
  Literate bigint,
  Male_Literate bigint,
  Female_Literate bigint,
  Male_Workers bigint,
  Female_Workers bigint,
  Frontline_Workers bigint,
  Industrial_Workers bigint,
  Non_Workers bigint,
  Cultivator_Workers bigint,
  Agricultural_Workers bigint,
  Household_Workers bigint,
  Other_Workers bigint,
  LPG_or_PNG_Households bigint,
  Housholds_with_Electric_Lighting bigint,
  Households_with_Internet bigint,
  Households_with_Computer bigint,
  Rural_Households bigint,
  Urban_Households bigint,
  Below_Primary_Education bigint,
  Primary_Education bigint,
  Middle_Education bigint,
  Secondary_Education bigint,
  Higher_Education bigint,
  Graduate_Education bigint,
  Other_Education bigint,
  Age_Group_0_29 bigint,
  Age_Group_30_49 bigint,
  Age_Group_50 bigint,
  Age_not_stated bigint
);

CREATE TABLE State (
    State_code Serial PRIMARY KEY,
    State_Name VARCHAR(100),
    No_of_District INTEGER);
	
CREATE TABLE District (
    District_code Serial PRIMARY KEY,
	State_code INTEGER,
    District_Name VARCHAR(100),
    Rural_household bigint,
	Urban_household bigint,
	Foreign Key (State_code) references State(State_code) on delete cascade);

CREATE TABLE Literacy (
	Srno Serial PRIMARY KEY,
    District_code INTEGER,
	State_code INTEGER,
    Male_Literate bigint,
    Female_Literate bigint,
	Below_Primary_Education bigint,
	Primary_Education bigint,
	Middle_Education bigint,
	Secondary_Education bigint,
	Higher_Education bigint,
	Graduate_Education bigint,
	Other_Education bigint,
	Foreign Key (State_code) references State(State_code) on delete cascade,
	Foreign Key (District_code) references District(District_code) on delete cascade);

CREATE TABLE Profession (
	Srno Serial PRIMARY KEY,
    District_code INTEGER,
	State_code INTEGER,
    Frontline_Workers bigint,
	Industrial_Workers bigint,
	Non_Workers bigint,
	Cultivator_Workers bigint,
	Agricultural_Workers bigint,
	Household_Workers bigint,
	Other_Workers bigint,
    Foreign Key (State_code) references State(State_code) on delete cascade,
	Foreign Key (District_code) references District(District_code) on delete cascade);

CREATE TABLE Population (
	Srno Serial PRIMARY KEY,
    District_code INTEGER,
	State_code INTEGER,
    Total_Population bigint,
	Male bigint,
	Female bigint,
	Age_Group_0_29 bigint,
	Age_Group_30_49 bigint,
	Age_Group_50 bigint,
	Age_not_stated bigint,
    Foreign Key (State_code) references State(State_code) on delete cascade,
	Foreign Key (District_code) references District(District_code) on delete cascade);

CREATE TABLE Utilities (
	Srno Serial PRIMARY KEY,
    District_code INTEGER,
	State_code INTEGER,
    LPG_or_PNG_Households bigint,
	Housholds_with_Electric_Lighting bigint,
	Households_with_Internet bigint,
	Households_with_Computer bigint,
	Foreign Key (State_code) references State(State_code) on delete cascade,
	Foreign Key (District_code) references District(District_code) on delete cascade);

	
select * from data;

-- insert into state
insert into state(State_Name, No_of_District) select state_name, count(district_name) from data group by state_name;

-- insert into district
insert into district(State_code, district_name,rural_household,urban_household) 
	select state.state_code ,data.district_name,rural_households,urban_households from data, state 
	where data.state_name = state.state_name;

-- insert into Literacy

insert into literacy(district_code,State_code, male_literate,Female_Literate,Below_Primary_Education,primary_education,
					Middle_Education,Secondary_Education, Higher_Education, Graduate_Education,Other_Education  ) 
					select district.district_code, district.state_code, male_literate,female_literate,Below_Primary_Education,
					primary_education, Middle_Education,Secondary_Education,Higher_Education,Graduate_Education,Other_Education from 
					district, data where data.district_name=district.district_name;

-- insert into Profession

insert into profession(district_code,State_code, Frontline_Workers,Industrial_Workers,Non_Workers,
					Cultivator_Workers,Agricultural_Workers, Household_Workers, Other_Workers )
				select district.district_code, district.state_code, Frontline_Workers,Industrial_Workers,
				Non_Workers,Cultivator_Workers, Agricultural_Workers, Household_Workers, Other_Workers from 
				district, data where data.district_name=district.district_name;
--select * from profession
-- insert into utilities 
insert into utilities(district_code,
					  State_code, 
					  LPG_or_PNG_Households,
					  Housholds_with_Electric_Lighting,
					  Households_with_Internet,
					  Households_with_Computer)
	select district.district_code, district.state_code, LPG_or_PNG_Households,
	Housholds_with_Electric_Lighting,
	Households_with_Internet,
	Households_with_Computer from district, data where data.district_name=district.district_name;


-- insert into population

insert into population(district_code,State_code,Total_Population,Male,Female,Age_Group_0_29,
					   Age_Group_30_49,Age_Group_50,Age_not_stated)
						select district.district_code, district.state_code,population,Male,Female,Age_Group_0_29,
						Age_Group_30_49,Age_Group_50,Age_not_stated 
 						from district, data where data.district_name=district.district_name;


select * from state;
select * from district;
select * from literacy;
select * from population;
select * from utilities;

select * from data;


-- 1. Population state wise

SELECT   state_name,
         Sum(total_population) AS population
FROM     state s
JOIN     population p
ON       s.state_code=p.state_code
GROUP BY state_name
ORDER BY state_name 

-- 2. Percentage of literacy gender wise of each state

SELECT   state_name,
         round((Sum(male_literate)  / Sum(male))*100)    AS male_literacy_percentage ,
         round((sum(female_literate)/ sum(female)) *100) AS female_literacy_percentage
FROM     state s
JOIN     population p
ON       s.state_code=p.state_code
JOIN     literacy l
ON       s.state_code=l.state_code
GROUP BY s.state_name
ORDER BY s.state_name 

-- 3. State having maximum population
SELECT   state_name,
         Sum(total_population)
FROM     state s
JOIN     population p
ON       s.state_code=p.state_code
GROUP BY s.state_name
HAVING   Sum(total_population)=
         (
                  SELECT   Sum(total_population)
                  FROM     population p
                  GROUP BY p.state_code
                  ORDER BY Sum(total_population) DESC
			 Limit 1)


-- 4. unemployed people state wise: 
select state.state_name, round(sum(non_workers)*100/(select sum(non_workers) from profession)) as unemployed 
from profession, state where profession.state_code = state.state_code group by profession.state_code, 
state.state_name order by unemployed DESC;

--5. for every state, below 30% and above 30% 
select state.state_name, round(sum(age_group_0_29)*100/(sum(age_group_0_29+age_group_30_49 + age_group_50))) as youth_population, 
round(sum(age_group_30_49 + age_group_50)*100/sum(age_group_0_29+age_group_30_49 + age_group_50)) as old_population 
from population,state where population.state_code = state.state_code 
group by population.state_code, state.state_name ;

--6. state wise % of urban and rural household 
select state.state_name, 
round(sum(rural_household)/(sum(rural_household)+sum(urban_household))*100) as rural_household, 
round(sum(urban_household)/(sum(rural_household)+sum(urban_household))*100) as urban_household 
from district,state where district.state_code = state.state_code 
group by district.state_code, state.state_name;


--7. What is the percentage growth of state given internet and computer as amenities print result 
-- in descending order of percentage growth and sum of internet and computer in the state?

WITH cte1
     AS (SELECT state_code,
                i,
                c,
                ( i + c ) AS sum_u
         FROM   (SELECT state_code,
                        Sum(households_with_internet) AS i,
                        Sum(households_with_computer) AS c
                 FROM   utilities
                 GROUP  BY ( state_code )
                 ORDER  BY state_code)t)
SELECT s.state_name,
       sum_u                    AS sum_internet_computer,
       Round(sum_u * 100 / t.s) AS total_growth_percentage
FROM   cte1 c
       CROSS JOIN (SELECT Sum(sum_u) AS s
                   FROM   cte1) t
       JOIN state s
         ON c.state_code = s.state_code
ORDER  BY sum_internet_computer DESC,
          total_growth_percentage DESC 


--8. What is total population of male and female in country?
SELECT Sum(total_male_in_district)   AS total_male_in_country,
       Sum(total_female_in_district) AS total_female_in_country
FROM   (SELECT d.district_code,
               Sum(male)   AS total_male_in_district,
               Sum(female) AS total_female_in_district
        FROM   district d
               JOIN population po
                 ON d.district_code = po.district_code
        GROUP  BY d.district_code
        ORDER  BY d.district_code)t 


--9. What is state wise number of total agricultural workers and total Cultivator 
-- workers in descending order of sum of all the agricultural and cultivator ?

SELECT s.state_name,
       Sum(agricultural_workers) AS total_agriculture_worker_in_state,
       Sum(cultivator_workers)   AS total_cultivator_workers
FROM   profession ps
       JOIN state s
         ON ps.state_code = s.state_code
GROUP  BY s.state_name
ORDER  BY total_cultivator_workers DESC,
          total_agriculture_worker_in_state DESC