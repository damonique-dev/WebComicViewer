
//
//  ViewController.swift
//  WebcomicViewer
//
//  Created by Damonique Thomas on 9/9/15.
//  Copyright (c) 2015 Damonique Thomas. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {

    @IBOutlet var todayButton: UIButton!
    @IBOutlet var byNumButton: UIButton!
    @IBOutlet var randomButton: UIButton!
    @IBOutlet var lastViewedButton: UIButton!
    @IBOutlet var favoritesButton: UIButton!
    var buttonPressed:Int!
    var currComic: CurrentComic!
    var menuInput: String!
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func todayComicPressed(sender: UIButton) {
    }
    @IBAction func byNumberPressed(sender: UIButton) {
    }
    @IBAction func randomPressed(sender: UIButton) {
    }
    @IBAction func lastComicPressed(sender: UIButton) {
    }
    @IBAction func favoritesPressed(sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up CoreData
        currComic = NSEntityDescription.insertNewObjectForEntityForName("CurrentComic", inManagedObjectContext: self.managedObjectContext!) as! CurrentComic
        var error: NSError?
        do {
            try managedObjectContext?.save()
        } catch let error1 as NSError {
            error = error1
        }
        if let err = error {
            NSLog("\(err)")
        }
        
        //Check if currentComic is empty
        let fetchRequest = NSFetchRequest(entityName: "CurrentComic")
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [CurrentComic] {
            let update = fetchResults[0] as NSManagedObject
            let num = update.valueForKey("currComicNum")
            if (num == nil) {
                lastViewedButton.hidden = true
            }
            else {
                lastViewedButton.hidden = false
            }
            
        }
        
        //Change radius of home screen buttons
        todayButton.layer.cornerRadius = 5
        byNumButton.layer.cornerRadius = 5
        randomButton.layer.cornerRadius = 5
        lastViewedButton.layer.cornerRadius = 5
        favoritesButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

