-- to run this script from terminal use the following command (@username and @newAccessLevel are parameters that you can change):
-- docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S db -U sa -P VeryStrongPassword123 -d sports_web_portal -Q "EXEC dbo.UpdateUserAccess @username='monty_python', @newAccessLevel='admin'"
CREATE PROCEDURE dbo.UpdateUserAccess
    @username VARCHAR(255),
    @newAccessLevel VARCHAR(255)
AS
BEGIN
    UPDATE dbo.Users
    SET access_level = @newAccessLevel
    WHERE username = @username;
END

