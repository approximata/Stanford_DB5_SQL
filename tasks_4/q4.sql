/*It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
*/
DELETE
FROM Highschooler
WHERE Highschooler.grade = 12;


/* If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.*/

DELETE
FROM likes
WHERE id1 IN (SELECT  likes.id1
              FROM friend JOIN likes USING (id1)
              WHERE friend.id2 = likes.id2)
      AND NOT id2 IN (SELECT likes.id1
                      FROM friend JOIN likes USING (id1)
                      WHERE friend.id2 = likes.id2)


/* For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships,
friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) */

INSERT INTO Friend
SELECT F1.ID1, F2.ID2
FROM Friend F1 JOIN Friend F2
ON F1.ID2 = F2.ID1
WHERE F1.ID1 <> F2.ID2
EXCEPT
SELECT * FROM Friend
