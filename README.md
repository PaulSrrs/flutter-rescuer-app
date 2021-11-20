# Rescuer App

<img alt="rescuer logo" src="./assets/logo.png" width="120" height="120" title="logo">

A school project where the aim is to create a Flutter application using REST API.<br />
Inside the app, a BLoC pattern has to be present without using any external library (like bloc_provider).<br />
Moreover, a ready to be published to pub.dev widget has to be created.<br />

## Aim of the project

Flutter App with:

Screens:
1. Screen with List showing data from API. Animated when rendering the list.<br />
   a. Only get data from the API showed on the list.<br />
2. Screen with Detail Data redirected from List Screen. Animated with transition from List Page.<br />
   a. Get the full data of the record by API.<br />
3. Define Handling when the API is not available.<br />
   a. Show Page when the Network is not available.<br />
   b. Show Message when the API Server is not available.<br />
   c. Show message when the full Record Data is missing.<br />
4. Create your own Widget and export as package.<br />
5. Create tests for each screen and main functions with mock data.<br />
6. Research BLoC Patterns Usage. Prepare One Slide with:<br />
   a. Why it's needed ?<br />
   b. When it's needed ?<br />
7. Implement your BLoC pattern without using existing external packages.<br />

## Our idea

Our application is designed for the rescuer in mountain. With this application, they can report
any rescue they gave to people. They can precise the accident date and time, the place, the resources
used and the circumstances of the rescue.

## The API

Our API has been designed by Emilien Delevoye with DJANGO framework (Python).<br />

It can run locally thanks to the following command executed from the /api folder:<br />

> docker-compose up

The API will then run on the 8000 port (localhost '127.0.0.1', of course).<br />

Here is the different routes which can be used for our project:<br />

GET :<br />
    *- https://rescuer.emiliendelevoye.fr/rescues/?limit=20&offset=0*<br />
        Get all the basic information about rescues.<br />
        'limit' will be the maximum number of rescues which can be got.<br />
        'offset' will be number of rescue which will be passed in the database for the request.<br />
    *- https://rescuer.emiliendelevoye.fr/rescue/uuid/*<br />
        Get more information about a rescue. This request needs the unique uuid of the rescue.<br />

POST:<br />
    *- https://rescuer.emiliendelevoye.fr/rescue/:*<br />
        Create a new rescue. The body can be null but you can submit the following field:<br />
            - accident_date<br />
            - accident_time<br />
            - victims<br />
            - place<br />
            - resources<br />
            - circumstances<br />
        The uuid, alert_date and alert_time will be filled automatically by the API.<br />

PUT:<br />
    *- https://rescuer.emiliendelevoye.fr/rescue/uuid/:*<br />
        Modify an existing rescue. You can submit the following field in the body:<br />
        - accident_date<br />
        - accident_time<br />
        - victims<br />
        - place<br />
        - resources<br />
        - circumstances<br />
        The uuid, alert_date and alert_time cannot be modified.<br />

PUT:<br />
    *- https://rescuer.emiliendelevoye.fr/rescue/uuid/:*<br />
        Delete an existing rescue. No body is required.<br />

*For the rescues GET request, the API will respond with a RescueInfo List in case of success, an error otherwise.*<br />
*For EACH rescue request, the API will respond with a RescueInfoData in case of success, an error otherwise.*<br />

## App architecture

Pages :<br />
    - First page: A page which displays an error if the user is not connected to internet,<br />otherwise it will redirect to the main page.<br />
    - Main page: A page which displays an error if the first server request failed. <br />
    It can be a server error or a timeout error. (too weak internet connection). <br />
    If there is no error, it will redirect to the Rescue List Page.<br />
    - Rescue List Page: A page where the user can find each of his signaled rescue as card. <br />
    *He can slide the card to the right to edit it, or to the left to delete it.*<br />
    By clicking on it, it will be redirected to the Rescue Item Page.<br />
    - Rescue item page: A page where the user can find more information about the rescue.<br />
    - Add a rescue page: By clicking on the '+' icon at the top right of the screen, the user can <br />
    add a new rescue.
    - Put or Post a rescue page: A page where the user can edit an existing rescue or post a new one.<br />

BLoC:<br />
    - Rescue Item BLoC: A BLoC which is useful to deal with rescue item request. (GET/POST/PUT/DELETE)<br />
    - Rescue List BLoC: A BLoC which is useful to deal with rescue list request. (GET)<br />

Models:<br />
    - RescueInfoResource: A simple model which will be inherited. Only have 'String uuid' as field.<br />
    - RescueInfo (Inherited from RescueInfoResource) : A model with part of the full data of a rescue. Just alert date, alert time and victim number.<br />
    - RescueInfoData (Inherited from RescueInfo) : A model with all the data of a rescue.<br />

## Our widget for pub.dev

See ez_connectivity folder.

## Documentation

To generate our documentation, we used dartdoc.<br />
To install it, you can use the following command :

> dart pub global activate dartdoc

Then, you just have to type ```dartdoc``` at the root of the repository.

The documentation will be accessible with an index.html file situated in /doc/api folder.

## Tests

In order to test our project, we have written above 750 lines of tests (27 tests at all).<br />
Our tests combine testWidgets and classic test with mocked data (thanks to mockito package).<br />

To test our project you can run the following command at the root of the project :<br />

> flutter test

To test our project and see the tests coverage, you can run the following command in the /test folder:<br />

> ./test.sh

We have a coverage of 99.1 %.<br />

## Bonus

- No use of 'provider' package. Instead, we rewrote our templated BlocProvider by ourselves thanks to findAncestorWidgetOfExactType flutter method.<br />
- Own logo design with Figma software.<br />
- IOS dialog support.<br />
- Multiapp page combined with our providers.<br />
- Tablet support thanks to Flutter media query.<br />

## Authors
* **Paul Surrans** _alias_ [@PaulSrrs](https://github.com/PaulSrrs)
* **Emilien Delevoye** _alias_ [@Emilien-Delevoye](https://github.com/Emilien-Delevoye)





