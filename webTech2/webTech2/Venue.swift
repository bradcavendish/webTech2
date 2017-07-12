//
//  Venue.swift
//  webTech2
//
//  Created by Bradley Cavendish on 04/04/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import CoreData

class VenueList{
    
    private static var listOfVenues = [Venue]()
    
    static var venueService:VenueService?

    
    static func getDummyVenues()->[Venue]{
        listOfVenues.append(Venue("V0-001-010857176-8", "name 1","address 1","region 1","country1", 51.1833, -0.6)!)
        
        return listOfVenues
    }
    
    
    
    static func getBookmarkedVenues2()->[Venue]{
        //hold array of events
        var bookMarkedVenues:[Venue] = [Venue]()
        //hold retrieved events from core database to turn into event objects
        var retrievedVenues:[BookMarkedVenue]
        
        // get the (only) managed context from the database helper class
        let managedContext = DataBaseHelper.persistentContainer.viewContext
        // create a fetchrequest that will retireve all the entities (like: "Select * from BookMarkedEvents"]
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookMarkedVenue")
        
        do{
            // run the fetchrequest to get all the records into the array of BookMarkedEvent records
            retrievedVenues = try managedContext.fetch(fetchRequest) as! [BookMarkedVenue]
            
            // debug message to indicate succes and say how many records were retieved
            print ("\(retrievedVenues.count) bookmarked events retrieved from the Database...")
            
            // iterate through the retieved Bookmarked event records to pass data to the Event attributes
            for eachRetrieved in retrievedVenues{
                
                let vid = eachRetrieved.venueId
                let n = eachRetrieved.name
                let a = eachRetrieved.address
                let r = eachRetrieved.region
                let c = eachRetrieved.country
                let lat = eachRetrieved.latitude
                let long = eachRetrieved.longitude
                
                //add each event found to array of events
                bookMarkedVenues.append(Venue(vid!,n!,a!,r!,c!,lat,long)!)
            }
        }
        catch{
            print ("FAILED to fetch bookmarked events, reason: \(error)")
            bookMarkedVenues.append(Venue("<<No Bookmarked Events>>","nil","nil","nil","nil",0, 0)!)
        }
        
        return bookMarkedVenues
    }
    
    
    
    //getBookmarkedVenues() works but changed so the venue gets downloaded when the event is favourited, not when the map tab is clicked.
    //makes it much more efficient
    
    
    /*
    //get the venues from each event in bookmarked events
    static func getBookmarkedVenues() -> [Venue]{
        
        listOfVenues.removeAll()
        
        let bookMarkedEvents = EventList.getBookmarkedEvents()
        
        if bookMarkedEvents.count > 0{
            for each in bookMarkedEvents{
                let id = each.VenueId
                let venue = getVenuefromWebService(id: id)
                listOfVenues.append(venue)
            }
        }else{
            listOfVenues = getDummyVenues()
        }
        
        
        return listOfVenues
    }
    */
    
    
    
    //use each venue id to get venue info from web service
    static func getVenuefromWebService(id: String) -> Venue{
        
        let searchURL = "http://api.eventful.com/json/venues/get?...&app_key=fP3kbKdQRdt4Sw4w&id=\(id)"
        print(searchURL)
        
        venueService = VenueService(searchURL)
        
        let operationQ = OperationQueue()
        //... will only allow one task at a time in queue...
        operationQ.maxConcurrentOperationCount = 1
        //...queue that web service object as the operation object to be run on this thread
        operationQ.addOperation(venueService!)
        //... wait for the operation to complete [Synchronous] - better to use delegation, for [Asynchronous]
        operationQ.waitUntilAllOperationsAreFinished()
        
        let returnedJSON = venueService!.jsonFromResponse
        
        let JSONObject = returnedJSON as? [String:Any]
        
        //pass json data to venue initialiser
        let venue = Venue(JSONObject!)
        
        return venue
    }
 
}


class Venue{
    private (set)var VenueID:String
    private (set)var Name:String
    private (set)var Address:String
    private (set)var Region:String
    private (set)var Country:String
    
    private (set)var latitude:Double
    private (set)var longitude:Double
    
    
    init?(_ v: String, _ n:String, _ a: String, _ r: String, _ c: String, _ lat: Double, _ long: Double){
        VenueID = v
        Name = n
        Address = a
        Region = r
        Country = c
        latitude = lat
        longitude = long
        
        
    }
    
    convenience init(_ JSONObject:[String:Any])
    {
        // extract attributres from each of the Key:Value pairs in the JSON 'leaf' object
        let venueId = JSONObject["id"] as! String
        
        //protect against null values
        var name = "N/A"
        if let n = JSONObject["name"] as? NSNull{
            print("name null: ", n)
        }
        if let n = JSONObject["name"] as? String{
            name = n
        }
        
        var address = "N/A"
        if let a = JSONObject["address"] as? NSNull{
            print("name address: ", a)
        }
        if let a = JSONObject["address"] as? String{
            address = a
        }
        
        var region = "N/A"
        if let r = JSONObject["region"] as? NSNull{
            print("name region: ", r)
        }
        if let r = JSONObject["region"] as? String{
            region = r
        }
        
        var country = "N/A"
        if let c = JSONObject["country"] as? NSNull{
            print("name country: ", c)
        }
        if let c = JSONObject["country"] as? String{
            country = c
        }
        
        var long = "0"
        if let l = JSONObject["longitude"] as? NSNull{
            print("name long: ", l)
        }
        if let l = JSONObject["longitude"] as? String{
            long = l
        }
        
        var lat = "0"
        if let la = JSONObject["latitude"] as? NSNull{
            print("name lat: ", la)
        }
        if let la = JSONObject["latitude"] as? String{
            lat = la
        }
        
        
        self.init(venueId, name, address, region, country, Double(lat)!, Double(long)!)!
    }
    
}



class DataBaseHelper
{
    // MARK: - Core Data stack
    // make the persistentContainer a class attribute - so it can be used to access the managed context
    static var persistentContainer: NSPersistentContainer =
        {
            let container = NSPersistentContainer(name: "BookmarkedEvents")
            
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
    }()
    // MARK: - Core Data Saving support
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}




class VenueService:Operation
{
    // class recieves a URL object to call service...
    var urlRecieved: URL?
    //... and creates a JSON object as it's response
    var jsonFromResponse:Any?
    
    // constructor to allow the URL string to be recieved and converted to the required URL object
    init(_ incomingURLString:String)
    {
        // use addingPercentEncoding to deal with spaces (etc) in the URL String
        urlRecieved = URL(string: incomingURLString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!)
    }
    
    // override the main method to do the work of the service
    override func main()
    {
        var responseData:Data?
        
        // call the web service to get the data object
        do
        {
            // try to get the (binary) data back from the service call
            responseData = try Data(contentsOf: urlRecieved!)
            print("VenueService: Service call to \(urlRecieved!) succesful! Returned: \(responseData!)")
        }
        catch
        {
            print("VenueService: Service call to \(urlRecieved!) failed!!")
        }
        
        // parse the overall JSON from the returned data object
        do
        {
            // try to convert the returned data to JSON
            jsonFromResponse = try JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers) as? [String:Any]
            print("VenueService: JSON Parser succesful! Returned: \(jsonFromResponse!)")
        }
        catch
        {
            print("VenueService: JSON Parser failed!!")
        }
    }
}


