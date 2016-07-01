//
//  FavoritesTableViewerView.swift
//  WebcomicViewer
//
//  Created by Damonique Thomas on 9/21/15.
//  Copyright © 2015 Damonique Thomas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesTableViewerView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet var barTitle: UINavigationItem!
    @IBOutlet var table: UITableView!
    var items: [String] = ["We", "Heart", "Swift"]
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var favs = [FavoriteComics]()
    var deleteComicIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "favCell")
        
        table.delegate = self
        table.dataSource = self
        barTitle.title = "Favorite Comics"
        
        //Get Favorites from Core Data
        let fetchRequest = NSFetchRequest(entityName: "FavoriteComics")
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [FavoriteComics] {
            favs = fetchResults
        }
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("\(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favs.count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favCell", forIndexPath: indexPath) as UITableViewCell
        let favItems = favs[indexPath.row]
        cell.textLabel?.text = "#\(favItems.favs!) - \(favItems.title!)"
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let favItems = favs[indexPath.row]
        let fetchRequest = NSFetchRequest(entityName: "CurrentComic")
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [CurrentComic] {
            let update = fetchResults[0] as NSManagedObject
            update.setValue(favItems.favs!, forKey: "currComicNum")
        }
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("\(error)")
        }

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteComicIndexPath = indexPath
            let comicToDelete = favs[indexPath.row].favs
            confirmDelete(comicToDelete!)
        }
    }
    
    func confirmDelete(comicNum: String) {
        let alert = UIAlertController(title: "Delete Favorite Comic", message: "Are you sure you want to delete comic #\(comicNum) from your favorites?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: deleteComic)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDelete)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteComic(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteComicIndexPath {
            //Delete from core data
            let fetchRequest = NSFetchRequest(entityName: "FavoriteComics")
            let favItems = favs[indexPath.row]
            fetchRequest.predicate = NSPredicate(format: "favs == %@", favItems.favs!)
            if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [FavoriteComics] {
                let entityToDelete = fetchResults[0]
                managedObjectContext!.deleteObject(entityToDelete)
            }
            do {
                try managedObjectContext!.save()
            } catch let error as NSError {
                NSLog("\(error)")
            }
            
            //Delete from Table
            table.beginUpdates()
            favs.removeAtIndex(indexPath.row)
            table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            deleteComicIndexPath = nil
            table.endUpdates()
            
            
            
            

        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        deleteComicIndexPath = nil
    }
    
}