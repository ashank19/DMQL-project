create function get_male_count(user_state_code int)
returns int
language plpgsql
as 
$male_count$
declare male_count integer;
begin
select sum(male)
into male_count
from population 
where state_code = user_state_code;
return male_count;
end;
$male_count$;


select get_male_count(10);
select sum(male) from population 
where state_code = 6;

CREATE INDEX idx_state_code 
ON population(state_code);


CREATE INDEX idx_state_code_utilities 
ON utilities(state_code);