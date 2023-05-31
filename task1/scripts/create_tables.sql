-- Create Sports table
CREATE TABLE dbo.Sports (
  sport_id INT PRIMARY KEY IDENTITY(1,1),
  sport_name VARCHAR(255) NOT NULL,
);

-- Create Countries table
CREATE TABLE dbo.Countries (
  country_id INT PRIMARY KEY IDENTITY(1,1),
  country_name VARCHAR(255) NOT NULL,
);

-- Create Cities table
CREATE TABLE dbo.Cities (
  city_id INT PRIMARY KEY IDENTITY(1,1),
  city_name VARCHAR(255) NOT NULL,
  country_id INT NOT NULL,
  CONSTRAINT FK_Cities_Countries FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);


-- Create Leagues table
CREATE TABLE dbo.Leagues (
  league_id INT PRIMARY KEY IDENTITY(1,1),
  league_name VARCHAR(255) NOT NULL,
  league_country_id INT NOT NULL,
  sport_id INT NOT NULL,
  CONSTRAINT FK_Leagues_Sports FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
  CONSTRAINT FK_Leagues_Countries FOREIGN KEY (league_country_id) REFERENCES Countries(country_id)
);

-- Create Teams table
CREATE TABLE dbo.Teams (
  team_id INT PRIMARY KEY IDENTITY(1,1),
  team_name VARCHAR(255) NOT NULL,
  team_city_id INT NOT NULL,
  league_id INT NOT NULL,
  CONSTRAINT FK_Teams_Leagues FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
  CONSTRAINT FK_Teams_Cities FOREIGN KEY (team_city_id) REFERENCES Cities(city_id)
);

-- Create Games table
CREATE TABLE dbo.Games (
  game_id INT PRIMARY KEY IDENTITY(1,1),
  game_date DATE default GETDATE(),
  home_team_id INT NOT NULL,
  away_team_id INT NOT NULL,
  league_id INT, -- if league_id is NOT null, then it is an international game (e.g. Champions League)
  home_team_score INT NOT NULL,
  away_team_score INT NOT NULL,
  CONSTRAINT FK_Games_HomeTeam FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
  CONSTRAINT FK_Games_AwayTeam FOREIGN KEY (away_team_id) REFERENCES Teams(team_id),
  CONSTRAINT FK_Games_Leagues FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
  CONSTRAINT CHK_Games CHECK (home_team_id != away_team_id) -- teams can't play against themselves
);

-- Create Players table
CREATE TABLE dbo.Players (
  player_id INT PRIMARY KEY IDENTITY(1,1),
  player_name VARCHAR(255) NOT NULL,
  player_country_id INT NOT NULL,
  team_id INT,
  sport_id INT, -- may be helpful for retired players or free agents (where relation to a team is not known)
  CONSTRAINT FK_Players_Teams FOREIGN KEY (team_id) REFERENCES Teams(team_id),
  CONSTRAINT FK_Players_Sports FOREIGN KEY (sport_id) REFERENCES Sports(sport_id),
  CONSTRAINT FK_Players_Countries FOREIGN KEY (player_country_id) REFERENCES Countries(country_id),
  CONSTRAINT CHK_Players CHECK (team_id IS NOT NULL OR sport_id IS NOT NULL) -- player must be related to a team or a sport
);

-- Create Articles table
CREATE TABLE dbo.Articles (
  article_id INT PRIMARY KEY IDENTITY(1,1),
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  date_published DATE default GETDATE(),
  team_id INT,
  league_id INT,
  game_id INT, -- article may be about a specific game
  player_id INT, -- article may be about a specific player
  CONSTRAINT FK_Articles_Teams FOREIGN KEY (team_id) REFERENCES Teams(team_id),
  CONSTRAINT FK_Articles_Leagues FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
  CONSTRAINT FK_Articles_Games FOREIGN KEY (game_id) REFERENCES Games(game_id),
  CONSTRAINT FK_Articles_Players FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

-- Create EventTypes table
CREATE TABLE dbo.EventTypes (
  event_type VARCHAR(255) PRIMARY KEY
);

-- Create Events table
CREATE TABLE dbo.Events (
  event_id INT PRIMARY KEY IDENTITY(1,1),
  game_id INT NOT NULL,
  event_type VARCHAR(255) NOT NULL,
  event_time TIME default GETDATE(),
  CONSTRAINT FK_Events_Games FOREIGN KEY (game_id) REFERENCES Games(game_id),
  CONSTRAINT FK_Events_EventTypes FOREIGN KEY (event_type) REFERENCES EventTypes(event_type)
);

-- Create PlayerActions table
CREATE TABLE dbo.PlayerActions (
  player_action VARCHAR(255) PRIMARY KEY
);

-- Create EventPlayers table
CREATE TABLE dbo.EventPlayers (
  event_player_id INT PRIMARY KEY IDENTITY(1,1),
  event_id INT NOT NULL,
  player_id INT NOT NULL,
  player_action VARCHAR(255) NOT NULL,
  CONSTRAINT FK_EventPlayers_Events FOREIGN KEY (event_id) REFERENCES Events(event_id),
  CONSTRAINT FK_EventPlayers_Players FOREIGN KEY (player_id) REFERENCES Players(player_id),
  CONSTRAINT FK_EventPlayers_PlayerActions FOREIGN KEY (player_action) REFERENCES PlayerActions(player_action)
);

-- Create Users table
CREATE TABLE dbo.Users (
  username VARCHAR(255) PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  access_level VARCHAR(255) default 'user',
);

-- Create ArticleViews table
CREATE TABLE dbo.ArticleViews (
  view_id INT PRIMARY KEY IDENTITY(1,1),
  username VARCHAR(255),
  article_id INT,
  view_date DATE default GETDATE(),
  CONSTRAINT FK_ArticleViews_Users FOREIGN KEY (username) REFERENCES Users(username),
  CONSTRAINT FK_ArticleViews_Articles FOREIGN KEY (article_id) REFERENCES Articles(article_id)
);

-- Create Comments table
CREATE TABLE dbo.Comments (
  comment_id INT PRIMARY KEY IDENTITY(1,1),
  username VARCHAR(255),
  article_id INT,
  comment_text TEXT,
  comment_date DATE default GETDATE(),
  CONSTRAINT FK_Comments_Users FOREIGN KEY (username) REFERENCES Users(username),
  CONSTRAINT FK_Comments_Articles FOREIGN KEY (article_id) REFERENCES Articles(article_id)
);

-- Create Advertisements table
CREATE TABLE dbo.Advertisements (
  ad_id INT PRIMARY KEY IDENTITY(1,1),
  ad_content TEXT NOT NULL,
);

-- Create AdEntities table
CREATE TABLE dbo.AdEntities (
  ad_entity_id INT PRIMARY KEY IDENTITY(1,1),
  ad_id INT NOT NULL,
  team_id INT,
  league_id INT, 
  CONSTRAINT FK_AdEntities_Advertisements FOREIGN KEY (ad_id) REFERENCES Advertisements(ad_id),
  CONSTRAINT FK_AdEntities_Teams FOREIGN KEY (team_id) REFERENCES Teams(team_id),
  CONSTRAINT CHK_AdEntities CHECK (team_id IS NOT NULL OR league_id IS NOT NULL) -- ad must be related to a team or a league
);

-- Create MediaTypes table
CREATE TABLE dbo.MediaTypes (
  media_type VARCHAR(255) PRIMARY KEY
);

-- Create Media table
CREATE TABLE dbo.Media (
  media_id INT PRIMARY KEY IDENTITY(1,1),
  media_name VARCHAR(255),
  article_id INT,
  team_id INT,
  league_id INT,
  game_id INT,
  ad_id INT,
  media_type VARCHAR(255) NOT NULL,
  media_url VARCHAR(255) NOT NULL,
  CONSTRAINT FK_Media_Articles FOREIGN KEY (article_id) REFERENCES Articles(article_id),
  CONSTRAINT FK_Media_Teams FOREIGN KEY (team_id) REFERENCES Teams(team_id),
  CONSTRAINT FK_Media_Leagues FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
  CONSTRAINT FK_Media_Games FOREIGN KEY (game_id) REFERENCES Games(game_id),
  CONSTRAINT FK_Media_Advertisements FOREIGN KEY (ad_id) REFERENCES Advertisements(ad_id),
  CONSTRAINT FK_Media_MediaTypes FOREIGN KEY (media_type) REFERENCES MediaTypes(media_type),
  CONSTRAINT CHK_Media CHECK (article_id IS NOT NULL OR team_id IS NOT NULL OR league_id IS NOT NULL OR game_id IS NOT NULL OR ad_id IS NOT NULL)
  -- at least one of the foreign keys is not null (article_id, team_id, league_id, game_id, ad_id)
);