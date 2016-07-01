//
//  FavoriteComicViewerView.swift
//  WebcomicViewer
//
//  Created by Damonique Thomas on 9/21/15.
//  Copyright © 2015 Damonique Thomas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteComicViewerView: UIViewController {
    
    var favComics:FavoriteComics!
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet var barTitle: UINavigationItem!
    @IBOutlet var imageView: UIImageView!
    var comicNumInput:Int!
    var userInput:String!
    var totalNum:Int!
    var comicNum = 0;
    
    var imageURLText:String!
    var titleText:String!
    var altText:String!
    var month:String!
    var day:String!
    var year:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest(entityName: "CurrentComic")
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [CurrentComic] {
            let update = fetchResults[0] as NSManagedObject
            let num = update.valueForKey("currComicNum")
            let str = num as! String
            self.comicNum = Int(str)!
        }
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("\(error)")
        }
        
        getComic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPressed(longPress: UIGestureRecognizer) {
        let monthText:String = getMonthString(month)
        let alertText = "\(altText) \n\n Comic #\(comicNum) \n\n Date Created: \(monthText) \(day), \(year)"
        let alertController: UIAlertController = UIAlertController(title: titleText, message: alertText, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func getComic(){
        let urlPath = "http://xkcd.com/\(comicNum)/info.0.json"
        let url = NSURL(string: urlPath)
        let data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary {
            self.imageURLText = json["img"] as! NSString as String
            self.day = json["day"] as! NSString as String
            self.month = json["month"] as! NSString as String
            self.titleText = json["title"] as! NSString as String
            self.year = json["year"] as! NSString as String
            self.altText = json["alt"] as! NSString as String
        }
        
        if let imageURL = NSURL(string:imageURLText) {
            if let data = NSData(contentsOfURL: imageURL) {
                imageView.image = UIImage(data: data)
            }
        }
        
        barTitle.title = titleText
        
        //Update Core Data
        let fetchRequest = NSFetchRequest(entityName: "CurrentComic")
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [CurrentComic] {
            let update = fetchResults[0] as NSManagedObject
            let comicString = String(comicNum)
            update.setValue(comicString, forKey: "currComicNum")
        }
        do {
            try managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("\(error)")
        }
    }
    
    
    func getMonthString(monthNum: String) ->String {
        var monthString:String = ""
        switch monthNum {
        case "1":
            monthString = "January"
        case "2":
            monthString = "Feburary"
        case "3":
            monthString = "March"
        case "4":
            monthString = "April"
        case "5":
            monthString = "May"
        case "6":
            monthString = "June"
        case "7":
            monthString = "July"
        case "8":
            monthString = "August"
        case "9":
            monthString = "September"
        case "10":
            monthString = "October"
        case "11":
            monthString = "November"
        case "12":
            monthString = "December"
        default:
            monthString = "Month"
            
        }
        return monthString
    }

}