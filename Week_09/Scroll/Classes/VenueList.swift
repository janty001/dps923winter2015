//
//  VenueList.swift
//  Toronto 2015
//
//  Created by Peter McIntyre on 2015-03-14.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit
import CoreData

class VenueList: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Private properties
    
    var frc: NSFetchedResultsController!
    
    // MARK: - Properties
    
    // Passed in by the app delegate during app initialization
    var model: Model!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 55.0
        
        // Configure and load the fetched results controller (frc)
        
        frc = model.frc_venue
        
        // This controller will be the frc delegate
        frc.delegate = self
        // No predicate (which means the results will NOT be filtered)
        frc.fetchRequest.predicate = nil
        
        // Create an error object
        var error: NSError? = nil
        // Perform fetch, and if there's an error, log it
        if !frc.performFetch(&error) { println(error?.description) }
    }
    
    // MARK: - Table view methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.frc.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.frc.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let item = frc.objectAtIndexPath(indexPath) as Venue
        cell.textLabel!.text = item.venueName
        cell.detailTextLabel?.text = item.location

        // This is interesting
        //cell.backgroundView = UIImageView(image: UIImage(data: item.photo))
        //cell.backgroundView?.alpha = 0.2
        
        /*
        // The following works well
        let newSize = CGSize(width: 80, height: 40)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let image = UIImage(data: item.photo)
        image?.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.imageView?.image = newImage
        */
        
        // Works OK, but slow
        //cell.imageView?.image = UIImage(data: item.photo)

        // For now, show an empty white-coloured icon
        cell.imageView?.image = model.venueIconEmpty

        /*
        // The following works OK, but slow on first load
        // Will have to experiment more to speed up image loading in a table view
        var image = model.venueImageCache[item.venueName]
        
        if image == nil {
            
            let cdImage = UIImage(data: item.photo)
            model.venueImageCache[item.venueName] = cdImage
            cell.imageView?.image = cdImage
        }
        else {
            
            // Serve from cache
            cell.imageView?.image = image
        }
        */
    }
    
    // New method, to configure a section title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionInfo = self.frc.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.name
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toVenueDetail" {
            
            // Get a reference to the destination view controller
            let vc = segue.destinationViewController as VenueDetail
            
            // From the data source (the fetched results controller)...
            // Get a reference to the object for the tapped/selected table view row
            let item = frc.objectAtIndexPath(self.tableView.indexPathForSelectedRow()!) as Venue
            
            // Pass on the objects
            vc.detailItem = item
            
            // Configure the view if you wish
            vc.title = item.venueName
        }
        
    }
    
}
