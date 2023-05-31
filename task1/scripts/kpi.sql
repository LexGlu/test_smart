-- KPI 1: Total number of teams in the database
SELECT COUNT(*) AS 'Total number of teams'
FROM dbo.Teams;

-- KPI 2: Teams from the Premier League 
SELECT t.team_name, l.league_name
FROM dbo.Teams t
INNER JOIN dbo.Leagues l ON t.league_id = l.league_id
WHERE l.league_name = 'Premier League';

-- KPI 3: Article with the most comments
SELECT TOP 1 a.article_id, a.title, COUNT(*) AS 'Number of comments'
FROM dbo.Articles a
INNER JOIN dbo.Comments c ON a.article_id = c.article_id
GROUP BY a.article_id, a.title
ORDER BY COUNT(*) DESC;

-- KPI 4: Article with the most views
SELECT TOP 1 a.article_id, a.title, COUNT(*) AS number_of_views
FROM dbo.Articles a
INNER JOIN dbo.ArticleViews av ON a.article_id = av.article_id
GROUP BY a.article_id, a.title
ORDER BY COUNT(*) DESC;

-- KPI 5: Team with the most goals scored at home
SELECT TOP 1 t.team_id, t.team_name, SUM(g.home_team_score) AS total_goals_home
FROM dbo.Teams t
INNER JOIN dbo.Games g ON t.team_id = g.home_team_id
GROUP BY t.team_id, t.team_name
ORDER BY total_goals_home DESC;

-- KPI 6: Team with the most goals scored away
SELECT TOP 1 t.team_id, t.team_name, SUM(g.away_team_score) AS total_goals_away
FROM dbo.Teams t
INNER JOIN dbo.Games g ON t.team_id = g.away_team_id
GROUP BY t.team_id, t.team_name
ORDER BY total_goals_away DESC;

-- KPI 7: Team with the most goals scored in total (home + away)
SELECT TOP 1
    t.team_name,
    SUM(g.goals) AS total_goals
FROM
    (
        SELECT
            home_team_id AS team_id,
            home_team_score AS goals
        FROM
            dbo.Games
        UNION ALL
        SELECT
            away_team_id AS team_id,
            away_team_score AS goals
        FROM
            dbo.Games
    ) AS g
JOIN
    dbo.Teams AS t ON t.team_id = g.team_id
WHERE
    g.team_id IS NOT NULL
GROUP BY
    t.team_name
ORDER BY
    total_goals DESC;

-- KPI 8: Player with the most goals scored
SELECT TOP 1
    p.player_name,
    COUNT(*) total_goals
FROM
    dbo.Players p
JOIN
    dbo.EventPlayers ep ON ep.player_id = p.player_id
JOIN
    dbo.Events e ON e.event_id = ep.event_id
JOIN
    dbo.PlayerActions pa ON pa.player_action = ep.player_action
WHERE
    pa.player_action = 'Goal'
GROUP BY
    p.player_name
ORDER BY
    total_goals DESC;

-- KPI 9: Rank of teams by total goals scored (top 5)
SELECT
    team_name,
    SUM(goals) AS total_goals,
    RANK() OVER (ORDER BY SUM(goals) DESC) AS rank
FROM
    (
        SELECT
            home_team_id AS team_id,
            home_team_score AS goals
        FROM
            dbo.Games
        UNION ALL
        SELECT
            away_team_id AS team_id,
            away_team_score AS goals
        FROM
            dbo.Games
    ) AS g
JOIN
    dbo.Teams AS t ON t.team_id = g.team_id
WHERE
    g.team_id IS NOT NULL
GROUP BY
    t.team_name;

-- KPI 10: Average number of goals per game in all leagues
SELECT CAST((AVG(goals) * 2) AS DECIMAL(5, 2)) AS avg_goals_per_game
FROM (
    SELECT
        game_id,
        CAST(home_team_score AS DECIMAL(5, 2)) AS goals
    FROM
        dbo.Games
    UNION ALL
    SELECT
        game_id,
        CAST(away_team_score AS DECIMAL(5, 2)) AS goals
    FROM
        dbo.Games
) AS g;

-- KPI 11: Average number of goals per game in the Premier League
SELECT CAST((AVG(goals) * 2) AS DECIMAL(5, 2)) AS avg_goals_per_game
FROM (
    SELECT
        g.game_id,
        CAST(g.home_team_score AS DECIMAL(5, 2)) AS goals
    FROM
        dbo.Games g
    INNER JOIN dbo.Teams t ON t.team_id = g.home_team_id
    WHERE
        t.league_id = 1 
    UNION ALL
    SELECT
        g.game_id,
        CAST(g.away_team_score AS DECIMAL(5, 2)) AS goals
    FROM
        dbo.Games g
    INNER JOIN dbo.Teams t ON t.team_id = g.away_team_id
    WHERE
        t.league_id = 1
) AS g;






