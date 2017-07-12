//
//  TableViewCell.swift
//  webTech2
//
//  Created by Bradley Cavendish on 16/03/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    
    @IBOutlet weak var eventImage: UIImageView!
    
    let favouriteLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourite"
        label.font = label.font.withSize(12)
        label.textColor = UIColor.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    override func layoutSubviews() {
        
        self.addSubview(favouriteLabel)
        
        eventName.textColor = UIColor.orange
        
        eventLocation.font = eventLocation.font.withSize(15)
        eventDate.font = eventDate.font.withSize(15)
        
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        eventImage.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventImage.widthAnchor.constraint(equalToConstant: 99).isActive = true
        eventImage.heightAnchor.constraint(equalToConstant: 99).isActive = true
        
        
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventName.leftAnchor.constraint(equalTo: eventImage.rightAnchor, constant: 12).isActive = true
        eventName.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        eventName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        eventLocation.translatesAutoresizingMaskIntoConstraints = false
        eventLocation.topAnchor.constraint(equalTo: eventName.bottomAnchor, constant: 8).isActive = true
        eventLocation.leftAnchor.constraint(equalTo: eventImage.rightAnchor, constant: 12).isActive = true
        eventLocation.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        eventDate.translatesAutoresizingMaskIntoConstraints = false
        eventDate.topAnchor.constraint(equalTo: eventLocation.bottomAnchor, constant: 8).isActive = true
        eventDate.leftAnchor.constraint(equalTo: eventImage.rightAnchor, constant: 12).isActive = true
        
        favouriteLabel.centerYAnchor.constraint(equalTo: eventDate.centerYAnchor).isActive = true
        favouriteLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
    }
    
}
