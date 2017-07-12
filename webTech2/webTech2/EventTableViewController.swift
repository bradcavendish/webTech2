//
//  EventTableViewController.swift
//  webTech2
//
//  Created by Bradley Cavendish on 16/03/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController, UISearchBarDelegate {

    
    let reuseIdentifier = "EventTableViewCell"
    
    var Events = EventList.getSampleEvents()
    
    //hold index of last selected event
    var tableIndex: IndexPath?
    
    //link the search bar
    @IBOutlet weak var eventSearch: UISearchBar!
    
    var category: String?
    var categoryForURL: String?
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // get the search term, cut off trailing whitespace to avoid errors
        let searchTerm = searchBar.text?.trimmingCharacters(in: .whitespaces)
       
        Events = EventList.getEventsFromWebService("http://api.eventful.com/json/events/search?...&l=England&app_key=fP3kbKdQRdt4Sw4w&page_size=25", searchTerm!, categoryForURL!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
       
    }
    
    //open category screen
    @IBAction func advancedSearch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "search", sender: self)
    }
    
    //set the category sleceted when unwinding
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? advancedSearch {
            category = sourceViewController.category
            categoryForURL = sourceViewController.categoryForURL
            self.tableIndex = IndexPath(item: 0, section: 0)
            self.tableView.scrollToRow(at: tableIndex!, at: .none, animated: true)
        }
    }
    
    
    //long press gesture
    var timeOfLastPress = Date()
    func longPressForFavourite(_ sender: UILongPressGestureRecognizer){
        
        if Date().timeIntervalSince(timeOfLastPress) > 1{
            timeOfLastPress = Date() // reset the time
            let touchPoint = sender.location(in: self.view)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint)
            {
                if !(Events[indexPath.row].isBookmarked) // ignore if already bookmarked...
                {
                    print("Selected item: \(Events[indexPath.row].Name)")
                    Events[indexPath.row].BookMark(true)
                    bookmarkedEventsList = EventList.getBookmarkedEvents()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    return
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        category = "Music"
        categoryForURL = "music"
        
        eventSearch.delegate = self
        
        tableIndex = IndexPath(row: 0, section: 0)
        
        // create and register the long press recogniser
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(EventTableViewController.longPressForFavourite(_:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        
        findFavouritedEvents()
    }
    
    func findFavouritedEvents() {
        //find all events in core data(bookmarked ones)
        let eventList = EventList.getBookmarkedEvents()
        //set table view events to not booked marked
        for count in 0...Events.count-1{
            Events[count].isBookmarked = false
        }
        
        //compare each event in table list to events in bookmarked list
        for eventCount in 0...Events.count-1
        {
            if (eventList.count > 0){
                for eventCount2 in 0...eventList.count-1{
                    //if the event on the table is also in the booked marked list, set to boomarked
                    if Events[eventCount].eventID == eventList[eventCount2].eventID{
                        Events[eventCount].isBookmarked = true
                    }
                }
            }
        }
    }
    
    var bookmarkedEventsList: [Event]?
    
    //find if any events in table view are favourited
    func findIfFavourited(event: Event) -> Bool{
        
        var isFavourite = false
        
        if (bookmarkedEventsList?.count)! > 0{
            for i in 0...(bookmarkedEventsList?.count)!-1 {
                
                if event.eventID == bookmarkedEventsList?[i].eventID{
                    isFavourite = true
                }
            }
        }
        return isFavourite
    }

    override func viewWillAppear(_ animated: Bool) {
        bookmarkedEventsList = EventList.getBookmarkedEvents()
        findFavouritedEvents()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            self.tableView.scrollToRow(at: self.tableIndex!, at: .top, animated: true)
        }
        
        self.tableView.scrollsToTop = false
        //set title with category
        navigationItem.title = "Search - " + category!
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        
        //configure cell
        cell.eventImage.image = UIImage(data: Events[indexPath.row].getImageDataFromURL())
        cell.eventName.text = Events[indexPath.row].Name
        cell.eventLocation.text = Events[indexPath.row].Location
        cell.eventDate.text = Events[indexPath.row].Date
        
        if findIfFavourited(event: Events[indexPath.row]){
            cell.favouriteLabel.isHidden = false
        }else{
            cell.favouriteLabel.isHidden = true
        }
       
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "search"{
        
        }else{
            let destVC = segue.destination as! DetailViewController
            
            let selectedEventIndex = self.tableView.indexPathForSelectedRow?.row
            //send selected event to detail view
            destVC.selectedEvent = Events[selectedEventIndex!]
        }
        
        
    }

}
