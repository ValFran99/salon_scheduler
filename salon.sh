#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n ~~~~~ MY SALON ~~~~~\n"

SERVICES_LIST(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
  echo -e "\nWelcome to My Salon, how can I help you?"
  echo -e "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) RESERVE_SERVICE $SERVICE_ID_SELECTED ;;
    2) RESERVE_SERVICE $SERVICE_ID_SELECTED ;;
    3) RESERVE_SERVICE $SERVICE_ID_SELECTED ;;
    4) RESERVE_SERVICE $SERVICE_ID_SELECTED ;;
    5) RESERVE_SERVICE $SERVICE_ID_SELECTED ;;
    *) SERVICES_LIST "I could not find that service. What would you like today?" ;;
  esac

}

RESERVE_SERVICE(){

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # here check if we have the phone number
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")
  if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]
  then
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi

}

SERVICES_LIST