/*Add the reviewer Roger Ebert to your database, with an rID of 209. */

insert into Reviewer values(209, 'Roger Ebert');


/*Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.  */

UPDATE Rating
	SET stars = 5
	WHERE Rating.mID in
	(SELECT *
	FROM Movie JOIN Rating USING(mID)
	WHERE Movie.director = 'James Cameron');


/*For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
(Update the existing tuples; don't insert new tuples.)   */

UPDATE Movie
SET year = year + 25
WHERE Movie.mID IN
  (SELECT Movie.mID
  FROM Movie JOIN Rating USING(mID)
  GROUP BY Movie.title
  HAVING AVG(Rating.stars) >= 4);


/*Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
*/

  DELETE
   FROM Rating
   WHERE Rating.stars < 4
   AND
   Rating.mID IN
   (SELECT Movie.mID
   FROM Movie JOIN Rating USING(mID)
   WHERE Movie.year < 1970 OR Movie.year > 2000)
   AND
   Rating.rID IN
   (SELECT Rating.rID
   FROM Movie JOIN Rating USING(mID)
   WHERE Movie.year < 1970 OR Movie.year > 2000)
