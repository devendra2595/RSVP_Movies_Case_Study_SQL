USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) as Num_of_rows from director_mapping;
-- 3867
select count(*) as Num_of_rows from genre;
-- 14662
select count(*) as Num_of_rows from movie;
-- 7997
select count(*) as Num_of_rows from names;
-- 25735
select count(*) as Num_of_rows from ratings;
-- 7997
select count(*) as Num_of_rows from role_mapping;
-- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select count(*) as null_value_count from movie
where id is null; -- 0
select count(*) as null_value_count from movie
where title is null; -- 0
select count(*) as null_value_count from movie
where year is null; -- 0
select count(*) as null_value_count from movie
where date_published is null; -- 0
select count(*) as null_value_count from movie
where duration is null; -- 0
select count(*) as null_value_count from movie
where country is null; -- 20
select count(*) as null_value_count from movie
where worlwide_gross_income is null; -- 3724
select count(*) as null_value_count from movie
where languages is null; -- 194
select count(*) as null_value_count from movie
where production_company is null; -- 528


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- 1)
select year, 
       count(*) as number_of_movies 
from movie
group by year;
-- 2) 
select month(date_published) as month, 
       count(*) as number_of_movies
from movie
group by month
order by number_of_movies desc;

-- avg movies per year = 2666

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(*) as number_of_movies 
from movie
where ((country regexp 'India') or (country regexp 'USA')) and (year = 2019);

-- Ans = 1059

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) as Genre_name from genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select g.genre, 
       count(*) as no_of_movies 
from movie m 
            inner join genre g on m.id = g.movie_id
group by g.genre
order by no_of_movies desc;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with one_genre_movies as 
(
    select m.id, 
           count(genre) as genre_count
    from movie m 
                inner join genre g on m.id = g.movie_id
    group by m.id
    having genre_count = 1
)
select count(*) as single_genre_movie_count from one_genre_movies;

-- Ans = 3289

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre, 
       round(avg(m.duration),2) as avg_duration
from movie m 
            inner join genre g on m.id = g.movie_id
group by g.genre
order by avg_duration desc;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with genre_rank as
(
    select genre, 
           count(genre) as movie_count,
           rank() over(order by count(genre) desc) as genre_rank
    from genre
    group by genre
)
select * from genre_rank
where genre = "Thriller";


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) as minimum_avg_rating, 
       max(avg_rating) as maximum_avg_rating, 
       min(total_votes) as minimum_total_votes, 
       max(total_votes) as maximum_total_votes,
       min(median_rating) as minimum_median_rating, 
       max(median_rating) as maximum_median_rating 
from ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/


-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

with top10_movies as 
(
    select m.title, 
           round(r.avg_rating,1) as avg_rating,
           dense_rank() over(order by r.avg_rating desc) as movie_rank
    from movie m 
                inner join ratings r on m.id = r.movie_id 
)
select * from top10_movies
where movie_rank <=10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating, 
       count(median_rating) as movie_count 
from ratings
group by median_rating
order by movie_count desc;

/*
median     movie
rating     count
1	        94
.           .
.           . 
7	        2257
8	        1030
total ---   7222 ---> 90.30% of total movies.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
with top_production_house as 
(
    select m.production_company, 
           count(m.id) as movie_count,
           dense_rank() over(order by count(m.id) desc) as prod_comp_rank
    from movie m 
                inner join ratings r on m.id = r.movie_id
    where r.avg_rating > 8 and m.production_company is not null    -- (only considering not null values) 
    group by m.production_company
)
select * from top_production_house
where prod_comp_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre, 
       count(m.id) as movie_count
from movie m 
            inner join genre g on m.id = g.movie_id 
            inner join ratings r on m.id = r.movie_id
where (m.country regexp "USA") and 
      (month(m.date_published) = 3) and 
      (year(m.date_published) = 2017) and 
      (r.total_votes>1000)
group by g.genre
order by movie_count desc;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select m.title, 
       r.avg_rating, 
       g.genre 
from movie m
            inner join ratings r on m.id = r.movie_id 
            inner join genre g on m.id = g.movie_id
where avg_rating > 8 and m.title regexp "^The"
order by r.avg_rating desc;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(m.id) as movie_med_rating_8 
from movie m 
            inner join ratings r on m.id = r.movie_id
where (date_published between '2018-04-01' and '2019-04-01') and median_rating = 8;
-- ans 361


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select m.country, 
       sum(r.total_votes) as Country_total_votes
from movie m 
            inner join ratings r on m.id = r.movie_id 
where country in ("Germany","Italy")
group by m.country;

-- verify the query.
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
      sum(case when name is null then 1 else 0 end) as name_nulls,
      sum(case when height is null then 1 else 0 end) as height_nulls,
      sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
      sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_null
from names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_genre as
(
    select g.genre 
    from genre g 
                inner join movie m on g.movie_id = m.id 
                inner join ratings r on m.id = r.movie_id
    where r.avg_rating > 8
    group by g.genre
    order by count(*) desc
    limit 3
),
top_director as 
(
    select n.name, 
           g.genre, 
           count(*) as genrewise_movie_count
    from ratings r 
                  inner join movie m on r.movie_id = m.id 
                  inner join genre g on g.movie_id = m.id 
                  inner join director_mapping d on m.id = d.movie_id
                  inner join names n on d.name_id = n.id
    where r.avg_rating > 8 and g.genre in (select genre from top_genre)
    group by n.name,g.genre
    order by genrewise_movie_count desc
),
top_directors_in_top_genre as 
(
    select name as director_name, 
           sum(genrewise_movie_count) as movie_count,
           rank() over(order by sum(genrewise_movie_count) desc) as dir_rank 
    from top_director
    group by name
)
select director_name, 
       movie_count 
from top_directors_in_top_genre
where dir_rank <=3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_actors as 
(
    select n.name as actor_name, 
           count(m.id) as movie_count,
           dense_rank() over(order by count(m.id) desc) as actor_rank
    from movie m 
                 inner join ratings r on m.id = r.movie_id 
                 inner join role_mapping rm on m.id = rm.movie_id 
                 inner join names n on rm.name_id = n.id
    where rm.category = "actor" and r.median_rating >= 8 
    group by n.name
)
select actor_name, 
       movie_count 
from top_actors
where actor_rank<=2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, 
       sum(r.total_votes) as vote_count,
       rank() over(order by sum(r.total_votes) desc) as prod_comp_rank
from movie m 
            inner join ratings r on m.id = r.movie_id
group by m.production_company
limit 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is 
-- at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total 
-- number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select n.name as actor_name, 
       sum(r.total_votes) as total_votes, 
       count(m.id) as movie_count,
       round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as actor_avg_rating,   -- weighted average
       rank() over(order by round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) desc) as actor_rank     -- ordered by weighted average
from movie m 
             inner join ratings r on m.id = r.movie_id 
             inner join role_mapping rm on m.id = rm.movie_id 
             inner join names n on rm.name_id = n.id
where rm.category = "actor" and m.country = "India"
group by n.name
having movie_count>=5
order by actor_avg_rating desc,total_votes desc;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actress_name, 
       sum(r.total_votes) as total_votes, 
       count(m.id) as movie_count,
       round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as actress_avg_rating,      -- weighted average
       rank() over(order by round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) desc) as actress_rank         -- ordered by weighted average
from movie m inner join ratings r on m.id = r.movie_id 
             inner join role_mapping rm on m.id = rm.movie_id 
             inner join names n on rm.name_id = n.id
where rm.category = "actress" and m.country = "India" and m.languages regexp "Hindi"
group by n.name
having movie_count>=3
order by actress_avg_rating desc,total_votes desc
limit 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with thriller_movies as 
(
    select m.id, 
           m.title,
           r.avg_rating 
    from movie m 
                inner join ratings r on m.id = r.movie_id 
                inner join genre g on m.id = g.movie_id
    where g.genre = "Thriller"
)
select *,
        case 
            when avg_rating > 8 then "Superhit movies"
            when avg_rating >=7 then "Hit movies"
            when avg_rating >=5 then "One-time-watch movies"
            else "Flop movies"
        end as "Movie_Category"
from thriller_movies;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

with genre_summary as 
(
    select g.genre, 
           round(avg(m.duration),2) as avg_duration 
    from movie m inner join genre g on m.id = g.movie_id
    group by g.genre
)
select *,
        round(sum(avg_duration) over w,2) as running_total_duration,   -- w is the window
        round(avg(avg_duration) over w,2) as moving_avg_duration       -- w is the window
from genre_summary
window w as (order by genre);

/* ANSWER
genre,      avg_duration,  running_total_duration,  moving_avg_duration
Action,         112.88,         112.88,               112.88
Adventure,      101.87,         214.75,               107.37
Comedy,         102.62,         317.37,               105.79
Crime,          107.05,         424.42,               106.10
Drama,          106.77,         531.20,               106.24
Family,         100.97,         632.17,               105.36
Fantasy,        105.14,         737.31,               105.33
Horror,         92.72,          830.03,               103.75
Mystery,        101.80,         931.83,               103.53
Others,         100.16,         1031.99,              103.19
Romance,        109.53,         1141.52,              103.77
Sci-Fi,         97.94,          1239.47,              103.28
Thriller,       101.58,         1341.04,              103.15
*/
-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

/* After observing the worldwide_gross_income column, it is seen that the values are not standardised,
i.e. some of the income are in INR and some in "$". Although these are the represented as income, their
data type is string which will definitly produce wrong results if any operation is performed on it.
So, let's first convert the INR income to $ income by dividing income by 80, and then convert all the 
values to number format.
*/

-- Let's create a view with corrected worldwide income
-- and use it for further analysis.
create view corrected_worldwide_gross_income as 
(
select id, 
       worlwide_gross_income,
        case 
            when worlwide_gross_income like "INR%" 
                then convert(right(worlwide_gross_income,length(worlwide_gross_income)-locate(' ',worlwide_gross_income)),float)/80
                -- first located index of " " with locate function, then subtracted that index 
                -- from length of string and then used right function to extract actual number  
                -- in form of string and then used convert function to convert string to number  
                -- and divided by 80 to convert INR to $.
            when worlwide_gross_income like "$%"
                then convert(right(worlwide_gross_income,length(worlwide_gross_income)-locate(' ',worlwide_gross_income)), float)
                -- same steps are followed only division by 80 is skipped 
                -- because the values are already in dollars
        end as worldwide_gross_income_in_dollars
from movie
);
-- Let's verify if the income values are converted properly.
select * from corrected_worldwide_gross_income;
-- Yes, The worldwide_gross_income values are corrected

-- Let's start with the answer to our question.

with top3_genre as
(
    select g.genre 
    from genre g 
                inner join movie m on g.movie_id = m.id
    group by g.genre
    order by count(*) desc
    limit 3
),
yearwise_top_movies as 
(
    select g.genre, 
           m.year, 
           m.title as movie_name, 
           worldwide_gross_income_in_dollars,
           dense_rank() over(partition by m.year order by worldwide_gross_income_in_dollars desc) as movie_rank
    from movie m 
                inner join genre g on m.id = g.movie_id 
                inner join corrected_worldwide_gross_income ci on ci.id = m.id
    where g.genre in (select genre from top3_genre)
)
select * from yearwise_top_movies
where movie_rank <=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, 
       count(*) as movie_count,
       rank() over(order by count(*) desc) as prod_comp_rank
from movie m 
            inner join ratings r on m.id = r.movie_id
where m.languages like"%,%" and m.production_company is not null and r.median_rating >=8  -- only not null values are considered.
group by m.production_company
order by movie_count desc
limit 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actress_name, 
       sum(r.total_votes) as total_votes, 
       count(m.id) as movie_count, 
       round(sum(r.avg_rating*r.total_votes)/sum(r.total_votes),2) as actress_avg_rating, 
       dense_rank() over(order by count(m.id) desc) as actress_rank
from movie m 
            inner join ratings r on m.id = r.movie_id 
            inner join genre g on m.id = g.movie_id
            inner join role_mapping rm on m.id = rm.movie_id 
            inner join names n on rm.name_id = n.id
where g.genre = "Drama" and r.avg_rating > 8 and rm.category = "actress"
group by n.name
limit 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|  	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

with next_date_summary as    -- next date summary
(       
        select m.id as movie_id, 
               dm.name_id as director_id, 
               n.name as director_name,
               r.avg_rating, 
               r.total_votes, 
               m.duration, 
               m.date_published,
               lead(date_published,1) over(partition by dm.name_id order by date_published) as next_date 
        from movie m 
                    inner join ratings r on m.id = r.movie_id
                    inner join director_mapping dm on m.id = dm.movie_id
                    inner join names n on dm.name_id = n.id
),
inter_movie_days_summary as    -- date difference summary
(
        select *,
                datediff(next_date,date_published) as inter_movie_days
        from next_date_summary
)
select director_id, 
       director_name, 
       count(movie_id) as number_of_movies,
       round(avg(inter_movie_days)) as avg_inter_movie_days,
       round(sum(avg_rating*total_votes)/sum(total_votes),2) as avg_rating,  -- weighted average
       sum(total_votes) as total_votes,
       min(avg_rating) as min_rating, 
       max(avg_rating) as max_rating,
       sum(duration) as total_duration
from inter_movie_days_summary
group by director_id, director_name
order by number_of_movies desc, avg_rating desc
limit 9;