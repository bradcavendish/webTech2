//
//  CollectionViewController.swift
//  webTech2
//
//  Created by Bradley Cavendish on 16/03/2017.
//  Copyright © 2017 Bradley Cavendish. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EventCollectionViewCell"

class EventCollectionViewController: UICollectionViewController {
    
    
    var bookMarkedEvents = EventList.getBookmarkedEvents()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favourites"
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressForUnBookMark(_:)))
        // add the gesture recogniser to the collection view
        collectionView?.addGestureRecognizer(longPressRecognizer)

    }
    
    var timeofLastPress = Date()
    
    func longPressForUnBookMark(_ sender: UILongPressGestureRecognizer)
    {
        
        if Date().timeIntervalSince(timeofLastPress) > 1
        {
            timeofLastPress = Date() // reset the time
            
            let touchPoint = sender.location(in: self.view)
            
            if let indexPath = collectionView?.indexPathForItem(at: touchPoint)
            {
                
                bookMarkedEvents[indexPath.row].BookMark(false)
                
                bookMarkedEvents = EventList.getBookmarkedEvents()
                
                self.collectionView?.reloadData()
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        bookMarkedEvents = EventList.getBookmarkedEvents()
        print("bookmarked events = \(bookMarkedEvents)")
        self.collectionView?.reloadData()
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return bookMarkedEvents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EventCollectionViewCell
    
        cell.eventImage.image = UIImage(data: bookMarkedEvents[indexPath.row].getImageDataFromURL())
        cell.eventName.text = bookMarkedEvents[indexPath.row].Name
            
        return cell
    }

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destVC = segue.destination as! DetailViewController
        let selectedMovieIndex = self.collectionView?.indexPathsForSelectedItems?[0].row
        // pass the selected Movie object forward to the detail view
        destVC.selectedEvent = bookMarkedEvents[selectedMovieIndex!]
    }

}
