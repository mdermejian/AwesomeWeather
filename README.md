# AwesomeWeather

Please open the project using AwesomeWeather.xcworkspace

###Code Challenge: The Weather app###
* You want to develop an iPhone application for weather forecasts using API available at www.worldweatheronline.com. You’ll have to register to their free tier and include the API key in your code challenge.

Here’s a list of wanted features:
• User shall be able to search, select and add a named city to a list
• Items on the list can be selected and a detail screen with the city forecasts should be displayed. • A way to get back to the city list shall be available.

* If in doubt consider the standard iOS weather app as a model.


### Functionality ###
** Screen 1: Locations Screen: ** This page will show a list of all the locations that have been added. Tapping on a location will bring the user to Screen 2 which fetches and displays the weather forecast. 
A user is able to delete any location by swiping on it and tapping the delete button. 

** Screen 1bis: Location Search: **Tapping on the search bar activates the search function which allows the user to add a new location. 

** Screen 2: Forecast Screen: ** This screen will show the weather forecast of a specific location.


### Endpoints ###

Base URL: https://api.worldweatheronline.com/premium/v1

**GET /search.ashx:** Gets a list of locations matching criteria.

**GET /weather.ashx:** Fetches the weather forecast for a set location


### Architecture ###


** NETWORKING **
Networking uses Alamofire. There are 3 layers that distribute the networking workload:

1. **Endpoint:** enum with a separate case for each backend call
2. **Router:** adopts the URLRequestConvertible protocol. This is in charge of building the URLRequest for the API calls from the individual components. It holds a reference to the endpoint enum
3. **Manager:** will make the actual Alamofire network calls and will handle the response
4. **Model:** model object. Implements NSCoding protocol to allow for persistence using NSArchiving in the case of Location objects. Also implements ResponseObjectSerializable protocols.
5. **Generic Response serialisers:** ResponseObjectSerializable and ResponseCollectionSerializable. When adopted, these protocols provide automatic, type-safe response object serialization into corresponding objects and array of objects respectively.



** PERSISTENCE **
Storage was implemented using NSArchiving.
Location model adopts the NSCoding protocol. This capability provides the basis for archiving.

Persistence is handled by the **StorageManager** object

Stored locations are stored in a "locations" file within the app's Documents directory in the app sandbox.


### Setup ###

* Developed using XCode 8.2.1 

* Written in Swift 3

* Tested on iPhone 6 running iOS 9.3.5 and iPhone 5S running iOS 10.1.1 

* Runs on iOS 9.0 and higher 

* Uses size classes and auto layout



### Dependencies ###

1. Alamofire 4.2

2. AlamofireImage 3.2

3. SwiftCommons (https://github.com/mdermejian/SwiftCommons.git)

4. Commons (https://github.com/mdermejian/Commons.git)

5. DZNEmptyDataSet 1.8

