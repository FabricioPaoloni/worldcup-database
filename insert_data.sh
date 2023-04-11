#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #if is the first line, ignore.
  if [[ $YEAR -ne 'year' ]]
  then
    #search for teams ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    #if WINNER_ID is not found, add to teams table
    if [[ -z $WINNER_ID ]]
    then 
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      #search for new team ID
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi   

    #if OPPONENT_ID is not found, add to teams table
    if [[ -z $OPPONENT_ID ]]
    then 
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      #search for new team ID
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi  
    #insert data into games
    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
  fi
done
