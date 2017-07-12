//
//  DetailViewController.swift
//  webTech2
//
//  Created by Bradley Cavendish on 23/03/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import UIKit
import Social
import SafariServices
import EventKit

class DetailViewController: UIViewController {
    
    
    //create all views and labels
    let image: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "Unknown.jpg")
        i.translatesAutoresizingMaskIntoConstraints = false
        i.isUserInteractionEnabled = true
        return i
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name:"
        label.textColor = UIColor.orange
        
        return label
    }()
    
    let nameLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false       
        label.numberOfLines = 3
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let venueLabel: UILabel = {
        let label = UILabel()
        label.text = "Venue:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.orange
        return label
    }()
    
    let venueLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.orange
        return label
    }()
    
    let locationLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.orange
        return label
    }()
    
    let dateLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Time:"
        label.textColor = UIColor.orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //create buttons
    let twitterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"twitter.png"), for: .normal)
        button.layer.cornerRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(twitterButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let fbButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "facebook.png"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(facebookButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let calenderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add To Calender", for: .normal)
        button.tintColor = UIColor.blue
        button.addTarget(self, action: #selector(addToCalender), for: .touchUpInside)
        return button
    }()
    
    var serviceType:String?
    var service:String?
    
    func addToCalender(){
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if granted && error == nil{
                
                print("granted \(granted)")
                print("error \(error)")
                
                let event = EKEvent(eventStore: eventStore)
                event.title = (self.selectedEvent?.Name)!
                
                let d = self.selectedEvent?.Date
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                //print(formatter.date(from: date!)!)
                
                let startDate = formatter.date(from: d!)!
                
                event.notes = self.selectedEvent?.Venue
                event.startDate = startDate
                event.endDate = startDate
                event.location = self.selectedEvent?.Location
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError{
                    print("failed to save event with error : \(error)")
                    return
                }
                print("Event saved")
                
                let alert = UIAlertController(title: "Event added to calender", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil) 
            }
        }
    }
    
    func facebookButtonClicked(){
        print("facebook")
        serviceType = SLServiceTypeFacebook
        service = "Facebook"
        
        if (SLComposeViewController.isAvailable(forServiceType: serviceType))
        {
            //create socail media service view controller object
            let socialController = SLComposeViewController(forServiceType: serviceType)
            
            socialController?.setInitialText("I am going to " + nameLabel2.text! + " at " + venueLabel2.text! + " on the " + dateLabel2.text! + "!")
            present(socialController!, animated: true, completion: nil)
        }else{
            print("Sevice: \(serviceType) is not available")
            
            let settingsPath = "App-Prefs:root=" + (service?.uppercased())!
            print(settingsPath)
            
            let alert = UIAlertController(title: "Not logged in", message: ("Please log in to your " + service! + " account through your phone's settings"), preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Go to settings", style: .default, handler: { (action) in
                UIApplication.shared.open(URL(string: settingsPath)!)
            })
            let action2 = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func twitterButtonClicked(){
        print("twitter")
        serviceType = SLServiceTypeTwitter
        service = "Twitter"
        if (SLComposeViewController.isAvailable(forServiceType: serviceType))
        {
            //create socail media service view controller object
            let socialController = SLComposeViewController(forServiceType: serviceType)
            
            socialController?.setInitialText("I am going to " + nameLabel2.text! + "on the " + dateLabel2.text!)
            present(socialController!, animated: true, completion: nil)
        }else{
            print("Sevice: \(serviceType) is not available")
            
            let settingsPath = "App-Prefs:root=" + (service?.uppercased())!
            print(settingsPath)
            
            let alert = UIAlertController(title: "Not logged in", message: ("Please log in to your " + service! + " account through your phone's settings"), preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Go to settings", style: .default, handler: { (action) in
                UIApplication.shared.open(URL(string: settingsPath)!)
            })
            let action2 = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.groupTableViewBackground
       
        
        view.addSubview(image)
        view.addSubview(nameLabel)
        view.addSubview(venueLabel)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(nameLabel2)
        view.addSubview(venueLabel2)
        view.addSubview(locationLabel2)
        view.addSubview(dateLabel2)
        view.addSubview(twitterButton)
        view.addSubview(fbButton)
        view.addSubview(calenderButton)
        view.addSubview(timeLabel)
        view.addSubview(timeLabel2)
        constraints()
        
        image.image = UIImage(data: (selectedEvent?.getImageDataFromURL())!)
        nameLabel2.text = selectedEvent?.Name
        venueLabel2.text = selectedEvent?.Venue
        locationLabel2.text = selectedEvent?.Location
        
        //get the date from the objects start date/time
        let date = selectedEvent?.Date
        let index = date?.index((date?.startIndex)!, offsetBy: 10)
        
        dateLabel2.text = date?.substring(to: index!)
        
        //get the time
        let index2 = date?.index((date?.startIndex)!, offsetBy: 11)
        
        timeLabel2.text = date?.substring(from: index2!)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tapImage)
        
    }
    
    func imageTapped(){
        
        let alert = UIAlertController(title: "Go to Event's website?", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.goToSite()
        }
        let action2 = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
    
    func goToSite(){
        print("go to site")
        if let url = URL(string: (selectedEvent?.eventURL)!){
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
   
    func constraints(){
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        image.widthAnchor.constraint(equalToConstant: 180).isActive = true
        image.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15).isActive = true
        
        nameLabel2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        nameLabel2.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        nameLabel2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
        
        venueLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        venueLabel.topAnchor.constraint(equalTo: nameLabel2.bottomAnchor, constant: 15).isActive = true
        
        venueLabel2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        venueLabel2.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 8).isActive = true
        venueLabel2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
        
        locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        locationLabel.topAnchor.constraint(equalTo: venueLabel2.bottomAnchor, constant: 15).isActive = true
        
        locationLabel2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        locationLabel2.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8).isActive = true
        locationLabel2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        dateLabel.topAnchor.constraint(equalTo: locationLabel2.bottomAnchor, constant: 15).isActive = true
        
        dateLabel2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        dateLabel2.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        timeLabel2.centerYAnchor.constraint(equalTo: dateLabel2.centerYAnchor).isActive = true
        timeLabel2.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fbButton.topAnchor.constraint(equalTo: dateLabel2.bottomAnchor, constant: 25).isActive = true
        fbButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -80).isActive = true
        fbButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fbButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        twitterButton.topAnchor.constraint(equalTo: dateLabel2.bottomAnchor, constant: 25).isActive = true
        twitterButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
        twitterButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        twitterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        calenderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calenderButton.centerYAnchor.constraint(equalTo: fbButton.centerYAnchor).isActive = true
        
    }

   

}
