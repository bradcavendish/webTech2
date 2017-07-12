//
//  VenueTableViewController.swift
//  webTech2
//
//  Created by Bradley Cavendish on 04/04/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VenueTableViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    let CellreuseIdentifier = "VenueTableViewCell"
    
    @IBOutlet weak var maps: MKMapView!
    
    var Venues = [Venue]()
    var mapcenter:CLLocationCoordinate2D?
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map - Venues"
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()                
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Venues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellreuseIdentifier, for: indexPath) 
        
        let venue = Venues[indexPath.row]
        
        // Configure the cell using default labels
        cell.textLabel?.text = venue.Name
        cell.detailTextLabel?.text = venue.Address + ", " + venue.Region + ", " + venue.Country
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVenue = Venues[indexPath.row]
        //set coordinates of selected venue
        let locCoords = CLLocationCoordinate2D(latitude: selectedVenue.latitude, longitude: selectedVenue.longitude)
        mapcenter = CLLocationCoordinate2D(latitude: selectedVenue.latitude, longitude: selectedVenue.longitude)
        let visibleRegion = MKCoordinateRegionMakeWithDistance(mapcenter!, 700, 700)
        maps.setCenter(locCoords, animated: true)
        maps.setRegion(visibleRegion, animated: true)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // required locationManager delegate method - do nothing for now...
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // required locationManager delegate method - do nothing for now...
    }

   

    override func viewWillAppear(_ animated: Bool) {
        
        Venues = VenueList.getBookmarkedVenues2()
        tableView.reloadData()
        
        
        
        locationManager.requestLocation()
        locationManager.stopUpdatingLocation()
        
        if let currentLocation = locationManager.location?.coordinate
        {
            // if current location is available
            // center the map on the current location
            mapcenter = currentLocation
        }
        else
        {
            //otherwise, if no current location is available
            //use location of Closest venue
            let lat = Venues[0].latitude
            let long = Venues[0].longitude
            mapcenter = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        //put pins on map for each venue
        for venue in Venues
        {
            let venueCoordinates = CLLocationCoordinate2D(latitude: venue.latitude, longitude: venue.longitude)
            
            let visibleRegion = MKCoordinateRegionMakeWithDistance(
                mapcenter!, 700, 700)
            
            self.maps.setCenter(venueCoordinates, animated: true)
            self.maps.setRegion(visibleRegion, animated: true)
            
            // create an annotation for each venue to disply on map
            let annot = MKPointAnnotation()
            annot.coordinate = venueCoordinates
            annot.title = venue.Name
            //annot.subtitle = venue.Address
            
            maps.addAnnotation(annot)
        }        
    }
}
