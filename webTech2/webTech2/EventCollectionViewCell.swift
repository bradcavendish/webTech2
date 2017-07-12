//
//  EventCollectionViewCell.swift
//  webTech2
//
//  Created by Bradley Cavendish on 23/03/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    
    override func layoutSubviews() {
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        eventName.translatesAutoresizingMaskIntoConstraints = false
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        
        eventImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        eventImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
        eventImage.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        eventName.textAlignment = .center
        
        
        eventName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        eventName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        eventName.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: 10).isActive = true
        
        
    }
    
    
}



