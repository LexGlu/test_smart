-- DML script for inserting data into the tables of the Sports Web Portal database

-- Sport data
INSERT INTO Sports (sport_name)
VALUES ('Football'), ('Basketball');

-- Country data
INSERT INTO Countries (country_name)
VALUES ('England'), ('Spain'), ('Germany'), ('Italy'), ('France'), ('USA'), ('Ukraine'), ('Netherlands'), ('Greece'), ('Europe');

-- City data
INSERT INTO Cities (city_name, country_id)
VALUES ('London', 1), ('Barcelona', 2), ('Munich', 3), ('Milan', 4), ('Paris', 5), ('Milwaukee', 6), ('Kyiv', 7);

-- League data
INSERT INTO Leagues (league_name, league_country_id, sport_id)
VALUES ('Premier League', 1, 1), ('La Liga', 2, 1), ('Bundesliga', 3, 1), ('Serie A', 4, 1), ('Ligue 1', 5, 1),
       ('NBA', 6, 2), ('USL', 7, 2), ('Champions League', 10, 1);

-- Team data
INSERT INTO Teams (team_name, team_city_id, league_id)
VALUES ('Arsenal', 1, 1), ('Chelsea', 1, 1), 
       ('Barcelona', 2, 2), ('Bayern Munich', 3, 3), 
       ('AC Milan', 4, 4), ('Inter Milan', 4, 4), ('Paris Saint-Germain', 5, 5),
       ('Milwaukee Bucks', 6, 6), ('Budivelnyk', 7, 7);

-- Player data
INSERT INTO Players (player_name, team_id, sport_id, player_country_id)
VALUES ('Oleksandr Zinchenko', 1, 1, 7), ('Frenkie de Jong', 3, 1, 8), ('Joshua Kimmich', 4, 1, 3),
       ('Sandro Tonali', 5, 1, 4), ('Kylian Mbappe', 7, 1, 5), ('Giannis Antetokounmpo', 8, 2, 9), ('Michael Jordan', NULL, 2, 6),
       ('Bogdan Bliznyuk', 9, 2, 7);

-- Article data
INSERT INTO Articles (title, content, team_id, league_id)
VALUES ('Arsenal lost the title', 'Some text here', 1, NULL), ('NBA schedule for 2023-2024', 'Some text here', NULL, 6);

-- Game data
INSERT INTO Games (home_team_id, away_team_id, home_team_score, away_team_score, league_id)
VALUES (1, 2, 3, 1, NULL), (3, 4, 1, 1, 8), (1, 2, 2, 5, NULL)

-- PlayerAction data (football only just for simplicity)
INSERT INTO PlayerActions (player_action)
VALUES ('Goal'), ('Assist'), ('Own goal'), ('Subbed in'), ('Subbed out'), ('Yellow card issued'),
       ('Red card issued'), ('Penalty scored'), ('Penalty missed'), ('Penalty saved'), ('Penalty conceded'), ('Penalty won'),
       ('Offside'), ('Foul committed'), ('Foul suffered');

-- EventType data
INSERT INTO EventTypes (event_type)
VALUES ('Goal'), ('Yellow card'), ('Red card'), ('Substitution'),
       ('Penalty'), ('Offside') , ('Foul');

-- Event data
INSERT INTO Events (game_id, event_type)
VALUES (1, 'Goal'), (1, 'Yellow card'), (2, 'Red card'),
       (2, 'Penalty'), (3, 'Goal'), (3, 'Goal'), (2, 'Goal');

-- EventPlayer data
INSERT INTO EventPlayers (event_id, player_id, player_action)
VALUES (1, 1, 'Goal'), (2, 1, 'Yellow card issued'), (3, 3, 'Red card issued'),
       (4, 2, 'Penalty scored'), (4, 3, 'Penalty conceded'), (5, 1, 'Goal'), (6, 3, 'Goal')

-- User data
INSERT INTO Users (username, email, password)
VALUES ('monty_python', 'mpython@gmail.com', 'hashed_password1'), ('ivasiuk1949', 'ivasiuk1949@ruta.ua', 'hashed_password2');

-- ArticleViews data
INSERT INTO ArticleViews (username, article_id)
VALUES ('monty_python', 1), ('ivasiuk1949', 1), ('ivasiuk1949', 2), ('monty_python', 2), ('monty_python', 1);

-- Comment data
INSERT INTO Comments (username, article_id, comment_text)
VALUES ('monty_python', 1, 'COYG!!!'), ('ivasiuk1949', 1, 'Arsenal is the BEST team in the world!'),
       ('ivasiuk1949', 2, 'I love NBA!'), ('monty_python', 2, 'wen NBA?'), ('monty_python', 1, 'Arsenal is the WORST team in the world!');

-- Advertisement data
INSERT INTO Advertisements (ad_content)
VALUES ('Buy tickets for the next game with Chelsea!'), ('Buy jersey of Giannis!'), ('Buy season tickets for the next seaso of NBA!');

-- AdEntity data
INSERT INTO AdEntities (ad_id, team_id, league_id)
VALUES (1, 1, NULL), (2, 8, NULL), (3, NULL, 6);

-- MediaTypes data
INSERT INTO MediaTypes (media_type)
VALUES ('Image'), ('Video'), ('GIF');

-- Media data
INSERT INTO Media (media_name, media_type, media_url, article_id, ad_id)
VALUES ('image of Zinchenko', 'Image', '/media/images/zinchenko_11.png', NULL, 1), ('video with EPL title', 'Video', '/media/images/epl_title_23.mp4', 1, NULL);
    