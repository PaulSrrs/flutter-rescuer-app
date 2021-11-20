# Rescuer API

## Language and framework used

To build our API we decided to use Python 3.8 with Django and Django Rest Framework.

## How to launch the API

The API is available online on https://rescuer.emiliendelevoye.fr

To launch the api locally, you can use the command docker-compose up at the root of the api/ folder.

The docker-compose.yml file is set up to start the web server and expose the port 8000 for the HTTP requests.

## How to use the API

Get all the rescues by using the request GET on the route /rescues/

This request return the basic data of each rescue (the rescue uuid, the creation timestamp, the alert_date, the alert_time and the total_victims number).


Create a new rescue by using the request POST on the route /rescues/

This request allows to fill the following fields (even if, default are set up) : alert_date, alert_time, total_victims, accident_date, accident_time, resources, place and circumstances


Get rescue detail by using the request GET on the route /rescue/{rescue uuid}/

This request return all the rescue detailed data : uuid, alert_date, alert_time, total_victims, accident_date, accident_time, resources, place, circumstances


Update rescue details by using the request POST on the route /rescue/{rescue uuid}/

This request allows to update the same following fields as the request POST on the route /rescues/


Delete a rescue by using the rescue DELETE on the route /rescue/{rescue uuid}/


## Date and Time formats

The API accepts the following date format : YEAR-MONTH-DATE (ex: 2000-12-31) and the following time format : HOUR-MINUTE (ex: 23:59)
