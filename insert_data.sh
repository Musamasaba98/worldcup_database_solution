#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
#ADD TEAMS
if [[ $WINNER != "winner" ]]
then
#GET TEAM ID
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
#IF WINNER NOT FOUND
if [[ -z $WINNER_ID ]]
then
  WINNER_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ")
  if [[ $WINNER_INSERT_RESULT == 'INSERT 0 1' ]]
  then
  echo Inserted into teams, $WINNER 
  fi
fi
fi
#IF OPPONENT NOT FOUND
if [[ $OPPONENT != "opponent" ]]
then
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then 
  OPPONENT_INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ")
  if [[ $OPPONENT_INSERT_RESULT == 'INSERT 0 1' ]]
  then
    echo Inserted into teams, $OPPONENT 
  fi
  fi
  #GET NEW WINNER ID
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi  
#ADD GAMES DETAILS
if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNERGOALS != 'winner_goals'&& $OPPONENTGOALS != 'opponent_goals' ]]
then
GAMES_INSERT_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id, winner_goals,opponent_goals) 
VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNERGOALS,$OPPONENTGOALS)")
if [[ $GAMES_INSERT_RESULT == 'INSERT 0 1' ]]
then
  echo Inserted into games, $YEAR $ROUND
fi  
fi
done
