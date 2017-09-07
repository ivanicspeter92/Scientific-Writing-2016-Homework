# Introduction to Data Science (DATA11001)
# University of Helsinki
# Peter Ivanics
# Task 3 - Baseball 

# 2

SELECT * FROM [baseball.player] player 
INNER JOIN [baseball.hall_of_fame] hall
ON hall.player_id = player.player_id 
WHERE inducted = true

# 3
SELECT
  player.player_id,
  college.college_id,
  COUNT(*) AS years
FROM (
  SELECT
    *
  FROM
    [baseball.player] player
  INNER JOIN
    [baseball.hall_of_fame] hall
  ON
    hall.player_id = player.player_id
  INNER JOIN
    [baseball.player_college] college
  ON
    college.player_id = player.player_id
  WHERE
    inducted = TRUE )
GROUP BY
  player.player_id,
  college.college_id

# 4
SELECT
  college.college_id,
  COUNT(DISTINCT player.player_id) AS alumni_count
FROM (
  SELECT
    *
  FROM
    [baseball.player] player
  INNER JOIN
    [baseball.hall_of_fame] hall
  ON
    hall.player_id = player.player_id
  INNER JOIN
    [baseball.player_college] college
  ON
    college.player_id = player.player_id
  WHERE
    inducted = TRUE )
GROUP BY
  college.college_id

# 4b
SELECT
  college.college_id,
  college.name_full,
  COUNT(DISTINCT player.player_id) AS alumni_count
FROM (
  SELECT
    *
  FROM
    [baseball.player] player
  INNER JOIN
    [baseball.hall_of_fame] hall
  ON
    hall.player_id = player.player_id
  INNER JOIN
    [baseball.player_college] player_college
  ON
    player_college.player_id = player.player_id
  INNER JOIN
    [baseball.college] college
  ON
    college.college_id = player_college.college_id
  WHERE
    inducted = TRUE )
GROUP BY
  college.college_id,
  college.name_full

  # EXTRA: Player years at college
  SELECT
  player.player_id,
  college.college_id,
  COUNT(*) AS years
FROM (
  SELECT
    *
  FROM
    [baseball.player] player
  INNER JOIN
    [baseball.hall_of_fame] hall
  ON
    hall.player_id = player.player_id
  INNER JOIN
    [baseball.player_college] college
  ON
    college.player_id = player.player_id
  WHERE
    inducted = TRUE )
GROUP BY
  player.player_id,
  college.college_id