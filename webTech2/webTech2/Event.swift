//
//  Event.swift
//  webTech2
//
//  Created by Bradley Cavendish on 16/03/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import Foundation
import CoreData

class Event{
    
    //attributes for class
    private (set)var eventID:String
    private (set)var Name:String
    private (set)var Venue:String
    private (set)var VenueId:String
    private (set)var Location:String
    private (set)var Date:String
    private (set)var ImageURL:String
    private (set)var eventURL: String
    
    var isBookmarked:Bool
    
    // main initialiser - checks if main attributes have values, otherwise return nil
    init?(_ e:String, _ n:String, _ v:String, _ vid: String, _ l:String, _ d:String, _ i:String, _ u: String){
        
        
        eventID = e
        Name = n
        Venue = v
        VenueId = vid
        Location = l
        Date = d
        eventURL = u
        //not bookmarked by default
        isBookmarked = false
        
        
        //if no image available
        if (i != "N/A"){
            ImageURL = i
        }
        else{
            ImageURL = "Unknown.jpg"
        }
       
    }
    
    // this (overloaded) initlaiser parses the incoming JSON object
    convenience init(_ JSONObject:[String:Any])
    {
        //use if let statements in case the json object returns nil
        
        var id = "N/A"
        if let i = JSONObject["id"] as? NSNull{
            print("id null: ", i)
        }
        if let i = JSONObject["id"] as? String{
            id = i
        }
        
        var name = "N/A"
        if let n = JSONObject["title"] as? NSNull{
            print("Event name null: ", n)
        }
        if let n = JSONObject["title"] as? String{
            name = n
        }
        
        var venue = "N/A"
        if let v = JSONObject["venue_name"] as? NSNull{
            print("venue name null: ", v)
        }
        if let v = JSONObject["venue_name"] as? String{
            venue = v
        }
        
        var venueID = "N/A"
        if let v = JSONObject["venue_id"] as? NSNull{
            print("venue id null: ", v)
        }
        if let v = JSONObject["venue_id"] as? String{
            venueID = v
        }
        
        
        var location = "N/A"
        if let l = JSONObject["city_name"] as? NSNull{
            print("location null: ", l)
        }
        if let l = JSONObject["city_name"] as? String{
            location = l
        }
        
        var date = "N/A"
        if let d = JSONObject["start_time"] as? NSNull{
            print("date null: ", d)
        }
        if let d = JSONObject["start_time"] as? String{
            

            date = d
            
        }
        
        
        // open up the json to get image url
        var imageURL = "N/A"
        
        if let images = JSONObject["image"] as? NSNull{
            print("no images", images)
        }
        if let images = JSONObject["image"] as? [String: Any]{
            
            if let mediumImage = images["medium"] as? NSNull{
                print("no medium image", mediumImage)
            }
            if let mediumImage = images["medium"] as? [String: Any]{
                
                if let URL = mediumImage["url"] as? NSNull{
                    print("no url", URL)
                }
                if let URL = mediumImage["url"] as? String{
                    imageURL = URL
                }
            }
        }
        
        
        //set default url if event has no url
        var eventURL = "http://www.google.com"
        
        if let url = JSONObject["ur"] as? NSNull{
            print("no event url", url)
        }
        if let url = JSONObject["url"] as? String{
            eventURL = url
        }
        
        //create the Event object
        self.init(id, name, venue, venueID, location, date, imageURL, eventURL)!
    }
    
    
    func BookMark(_ save: Bool){
        // get the (only) managed context...
        let managedContext = DataBaseHelper.persistentContainer.viewContext
        
                        
        if (save) // save this Event in core data
        {
            
            // ... get the Entity (table) description for the only entity
            let entity = NSEntityDescription.entity(forEntityName: "BookMarkedEvent", in: managedContext)!
            // ... retrieve the associated Managed Object for this entity
            let bookMarkedEvent = NSManagedObject(entity: entity, insertInto: managedContext)
            
            // put Event object members into matching attributes in the Managed Object
            bookMarkedEvent.setValue(self.Name, forKey: "name")
            bookMarkedEvent.setValue(self.Venue, forKey: "venue")
            bookMarkedEvent.setValue(self.VenueId, forKey: "venueId")
            bookMarkedEvent.setValue(self.Location, forKey: "location")
            bookMarkedEvent.setValue(self.Date, forKey: "date")
            bookMarkedEvent.setValue(self.eventID, forKey: "id")
            bookMarkedEvent.setValue(self.ImageURL, forKey: "image")
            bookMarkedEvent.setValue(self.eventURL, forKey: "url")
            
            //use event's venue id to create venue object to store in core data
            let venue = VenueList.getVenuefromWebService(id: self.VenueId)
            
            let entity2 = NSEntityDescription.entity(forEntityName: "BookMarkedVenue", in: managedContext)
            
            let bookMarkedVenue = NSManagedObject(entity: entity2!, insertInto: managedContext)
            
            bookMarkedVenue.setValue(venue.VenueID, forKey: "venueId")
            bookMarkedVenue.setValue(venue.Name, forKey: "name")
            bookMarkedVenue.setValue(venue.Address, forKey: "address")
            bookMarkedVenue.setValue(venue.Country, forKey: "country")
            bookMarkedVenue.setValue(venue.latitude, forKey: "latitude")
            bookMarkedVenue.setValue(venue.longitude, forKey: "longitude")
            bookMarkedVenue.setValue(venue.Region, forKey: "region")
            
            // need to account for exptions if saving fails
            do
            {
                // commit the prepares Managed Object in the Managed Context
                try managedContext.save()
                // set flag to say the object has been saved to DB
                isBookmarked = true
                print("Event: \(Name) was ADDED!")
            }
            catch let error as NSError
            {
                print("Could not save \(Name) . Reason: \(error), \(error.userInfo)")
            }
        }
        else //delete from core data
        {
            
            // create a fetchrequest to associate with the BookMarkedEvent entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMarkedEvent")
            // set a predicate (query) to only select a unique record
            fetchRequest.predicate = NSPredicate(format: "id == %@", eventID) // use id
            //delete the related venue also
            let fetchrequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "BookMarkedVenue")
            fetchrequest2.predicate = NSPredicate(format: "venueId == %@", VenueId)
            
            do
            {
                // run the query to get the resultset (can be more than one record)
                let resultData = try managedContext.fetch(fetchRequest) as! [BookMarkedEvent]
                print("Found \(resultData.count) event records to delete...")
                
                let resultData2 = try managedContext.fetch(fetchrequest2) as! [BookMarkedVenue]
                print("Found \(resultData2.count) venue records to delete...")
                // iterate through all the found records...
                for object in resultData
                {   //... to delete each record
                    managedContext.delete(object)
                    print("Event: \(Name) was REMOVED from Bookmarks Database!")
                }
                for object in resultData2{
                    managedContext.delete(object)
                    print("Venue: \(object.name) was REMOVED from Bookmarks Database!")
                }
                
                try! managedContext.save() // commit changes to context
                self.isBookmarked = false // set bookmarked flag to false
            }
            catch
            {
                print("Could not find any records to delete...")
            }
        }
    }
    
    
    
    //get image data from URL
    func getImageDataFromURL()->Data{
        
        var imageData:Data
        
        //download if its from a URL
        if (ImageURL.contains("https://") || ImageURL.contains("http://")){
            imageData = try! Data(contentsOf: (URL(string: ImageURL))!)
        }
            //otherwise it is local
        else{
            // need to get a reference to the application bundle
            let bundle = Bundle.main
            //... get the full path for the image file using the bundle reference
            let path = bundle.path(forResource: ImageURL, ofType: nil)
            // try to get binary data back from the image file
            imageData = try! NSData(contentsOfFile: path!) as Data
        }
        return imageData
    }
}//end of Event class





class EventList{
    
    private static var listOfEvents = [Event]()
    
    static var eventService:EventService?
    //create dummy events
    static func getSampleEvents()->[Event]{
        
        let image1 = "http://s2.evcdn.com/images/edpborder500/I0-001/000/129/317-4.jpg_/neyo-17.jpg"
        let image2 = "http://s4.evcdn.com/images/edpborder500/I0-001/002/321/955-4.jpeg_/tony-bennett-55.jpeg"
        let image3 = "http://s4.evcdn.com/images/edpborder500/I0-001/004/042/495-9.jpeg_/foreigner-95.jpeg"
        
        listOfEvents.append(Event("ID1","Event1","Venue1","V0-001-010857176-8","Location1","2017-05-05 12:00:00", image1, "http://www.google.com")!)
        listOfEvents.append(Event("ID2","Event2","Venue2","V0-001-010626019-6","Location2","2017-06-02 13:00:00", image2, "http://www.google.com")!)
        listOfEvents.append(Event("ID3","Event3","Venue3","V0-001-001596751-3","Location3","2017-07-08 14:00:00", image3, "http://www.google.com")!)
        listOfEvents.append(Event("ID4","Event4","Venue4","V0-001-005581093-8","Location4","2017-10-04 15:00:00", "N/A", "http://www.google.com")!)
        
        showEvents()
        
        return listOfEvents
    }
    
    static func getBookmarkedEvents()->[Event]{
        //hold array of events
        var bookMarkedEvents:[Event] = [Event]()
        //hold retrieved events from core database to turn into event objects
        var retrievedEvents:[BookMarkedEvent]
        
        // get the (only) managed context from the database helper class
        let managedContext = DataBaseHelper.persistentContainer.viewContext
        // create a fetchrequest that will retireve all the entities (like: "Select * from BookMarkedEvents"]
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookMarkedEvent")
        
        do{
            // run the fetchrequest to get all the records into the array of BookMarkedEvent records
            retrievedEvents = try managedContext.fetch(fetchRequest) as! [BookMarkedEvent]
            
            // debug message to indicate succes and say how many records were retieved
            print ("\(retrievedEvents.count) bookmarked events retrieved from the Database...")
            
            // iterate through the retieved Bookmarked event records to pass data to the Event attributes
            for eachRetrieved in retrievedEvents{
                
                let n = eachRetrieved.name
                let v = eachRetrieved.venue
                let vid = eachRetrieved.venueId
                let l = eachRetrieved.location
                let d = eachRetrieved.date
                let id = eachRetrieved.id
                let i = eachRetrieved.image
                let u = eachRetrieved.url
                
                //add each event found to array of events
                bookMarkedEvents.append(Event(id!,n!,v!,vid!,l!,d!,i!,u!)!)
            }
        }
        catch{
            print ("FAILED to fetch bookmarked events, reason: \(error)")
            bookMarkedEvents.append(Event("<<No Bookmarked Events>>","nil","nil","nil","nil","nil","N/A", "nil")!)
        }
        return bookMarkedEvents
    }
    
    //get data from api
    static func getEventsFromWebService(_ siteURL:String, _ searchTerm:String, _ category: String) ->[Event]{
        
        // construct the complete URL endpoint ot be called
        let searchURL = "\(siteURL)&c=\(category)&q=\(searchTerm)"
        
        print ("Web Service call = \(searchURL)")
        
        eventService = EventService(searchURL)
        
        // create an operation queue - to allow the web service to be called on a secondary thread...
        let operationQ = OperationQueue()
        //... will only allow one task at a time in queue...
        operationQ.maxConcurrentOperationCount = 1
        //...queue that web service object as the operation object to be run on this thread
        operationQ.addOperation(eventService!)
        //... wait for the operation to complete [Synchronous] - better to use delegation, for [Asynchronous]
        operationQ.waitUntilAllOperationsAreFinished()
        
        //remove all events from list
        listOfEvents.removeAll()
        
        // get the raw JSON back from the completed service call [complete dataset]
        let returnedJSON = eventService!.jsonFromResponse
        
        // extract the array of events from the events attribute
        let JSONEvents = returnedJSON?["events"] as! [String: Any]?
        let JSONObjects = JSONEvents?["event"] as! [[String:Any]]
        
        for eachJSONObject in JSONObjects{
            //print("event:")
            //print("\(eachJSONObject)")
            let event = Event(eachJSONObject)
            print("New event: ", event.Name)
            print("Venue: ", event.Venue)
            print("location: ", event.Location)
            listOfEvents.append(event)
        }   
        return listOfEvents
    }
    
    private static func showEvents(){
        for event in listOfEvents{
            print(event.Name)
        }
    }
    
}//end of EventList


protocol MovieServiceDelegate{
    //this protocol only requires one method to be implemented
    func serviceFinished(_ service:EventService, _ error:Bool)
}


class EventService: Operation{
    
    // class recieves a URL object to call service...
    var urlRecieved: URL?
    //... and creates a JSON object as it's response
    var jsonFromResponse: [String:Any]?
    
    var delegate:MovieServiceDelegate?
    
    init(_ incomingURLString:String)
    {
        // use addingPercentEncoding to deal with spaces (etc) in the URL String
        urlRecieved = URL(string: incomingURLString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!)
    }
    
    override func main() {
        
        var responseData:Data?
        
        // call the web service to get the data object
        do
        {
            // try to get the (binary) data back from the service call
            responseData = try Data(contentsOf: urlRecieved!)
            print("Service call (request) succesful! Returned: \(responseData!)")
        }
        catch
        {
            print("Service call (request) failed!!")
        }
        
        // parse the overall JSON from the returned data object
        do
        {
            // try to convert the returned data to JSON
            jsonFromResponse = try JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as? [String:Any]
            print("JSON Parser succesful! Returned: \(jsonFromResponse!)")
        }
        catch
        {
            print("JSON Parser failed!!")
        }
        
    }
    
}


































