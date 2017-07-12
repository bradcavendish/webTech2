//
//  advancedSearch.swift
//  webTech2
//
//  Created by Bradley Cavendish on 05/04/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import UIKit

class advancedSearch: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var category: String?
    var categoryForURL: String?
    
    @IBOutlet weak var button: UIButton!
    
    //http://api.eventful.com/json/categories/list?...&app_key=fP3kbKdQRdt4Sw4w
    //would have used this list for categories but text formatting was unusable
    
    
    let pickerData = ["Music", "Conference", "Comedy", "Education", "Kids & Family", "Festivals", "Film", "Food & Wine", "Fundraising & Charity", "Art Galleries & Exhibits", "Health & Wellness", "Holiday", "Literacy & Books", "Museums & Attractions", "Community", "Business & Networking", "Nightlife & Singles", "University & Alumni", "Organisations & Meetups", "Outdoors & Recreation", "Performing Arts", "Pets", "Politics & Activism", "Sales & Retail", "Science", "Religion & Spirituality", "Sports", "Technology", "Other"]
    
    //create picker
    let picker: UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "Select Category"
        l.textColor = UIColor.orange
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.groupTableViewBackground
        
        category = "Music"
        categoryForURL = "music"
        
        picker.dataSource = self
        picker.delegate = self
        
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(picker)
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        picker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        picker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10).isActive = true
        
    }

  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        category = pickerData[row]
        
        switch category!{
        case "Music":
            categoryForURL = "music"
        case "Conference":
            categoryForURL = "conference"
        case "Comedy":
            categoryForURL = "comedy"
        case "Education":
            categoryForURL = "learning_education"
        case "kids & Family":
            categoryForURL = "family_fun_kids"
        case "Festivals":
            categoryForURL = "festivals_parades"
        case "Film":
            categoryForURL = "movies_film"
        case "Food & Wine":
            categoryForURL = "food"
        case "Fundraising & Charity":
            categoryForURL = "fundraisers"
        case "Art Galleries & Exhibits":
            categoryForURL = "art"
        case "Health & Wellness":
            categoryForURL = "support"
        case "Holiday":
            categoryForURL = "holiday"
        case "Literacy & Books":
            categoryForURL = "books"
        case "Museums & Attractions":
            categoryForURL = "attractions"
        case "Community":
            categoryForURL = "community"
        case "Business & Networking":
            categoryForURL = "business"
        case "Nightlife & Singles":
            categoryForURL = "singles_socail"
        case "University & Alumni":
            categoryForURL = "schools_alumni"
        case "Organisations & Meetups":
            categoryForURL = "clubs_associations"
        case "Outdoors & Recreation":
            categoryForURL = "outdoors_recreation"
        case "Performing Arts":
            categoryForURL = "performing_arts"
        case "Pets":
            categoryForURL = "animals"
        case "Politics & Activism":
            categoryForURL = "politics_activism"
        case "Sales & Retail":
            categoryForURL = "sales"
        case "Science":
            categoryForURL = "science"
        case "Religion & Spirituality":
            categoryForURL = "religion_spirituality"
        case "Sports":
            categoryForURL = "sports"
        case "Technology":
            categoryForURL = "technology"
        case "Other":
            categoryForURL = "other"
        default :
            categoryForURL = "music"
        }
    }
}
