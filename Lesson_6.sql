use vk;
# запрос 1
select 
	us.firstname,
	us.lastname,
	pr.hometown as city,
	me.filename as main_photo
from 
	users us,
    profiles pr,
    media me
 where 
	us.id = 2
    and pr.user_id = us.id
    and me.user_id = pr.photo_id;

# запрос 2

select 
	me.filename
from
	media me,
    users us,
    media_types mt
where 
	me.user_id = us.id
    and mt.id = me.media_type_id
    and lower(us.email) = 'giles.dare@example.net' # like медленный оператор так быстрее работает
    and lower(mt.name) = 'photo'
    ;
	
# запрос 3
select 
	me.* 
from
	media me,
    media_types mt
where 
	me.user_id = 2
    and mt.id = me.media_type_id
    and lower(mt.name) = 'video';
    
# запрос 4
select 
	count(me.id) # ид никогда не может быть null
from
	media me,
    media_types mt
where 
	me.user_id = 2
    and mt.id = me.media_type_id
    and lower(mt.name) = 'video';
    
    # запрос 5
select 
	count(me.id)  as post ,
    monthname(me.created_at) as month_name 
from
	media me
group by month_name
order by post;




# задание 2_____________________________
select 
	me.from_user_id,
    count(me.from_user_id) as res,
    us.firstname,
    us.lastname,
    us.email

from 
	messages me
	right join friend_requests fr on fr.target_user_id = me.to_user_id and fr.initiator_user_id = me.from_user_id
    left join users us on me.from_user_id = us.id
where 
	me.to_user_id = 1
	and fr.status = 'approved'
group by me.from_user_id
order by res desc
limit 1;

# задение 3
select sum(res.count_likes) from(
select 
	us.*,
	pr.*,
	(select count(id) from likes where user_id = us.id) as count_likes,
	l.id as like_id
from 
	users us
	join profiles pr on us.id = pr.user_id
	join likes l on us.id = l.user_id
order by pr.birthday desc
limit 10) res

# задание 4 (в базе 1 - мужчины, пусто женщины)
select 
	pr.gender
    ,count(pr.user_id) as count_likes
from 
	profiles pr
    join likes l on l.user_id = pr.user_id
group by pr.gender
order by count_likes desc
limit 1;

# задение 5

select 
res.id, (res.count_likes + res.count_messages) as count_activity 
from
(select 
	us.id
  ,(select count(id) from likes where user_id = us.id) as count_likes
  ,(select count(id) from messages where from_user_id = us.id) as count_messages
from 
	users us) res
order by count_activity 
limit 10