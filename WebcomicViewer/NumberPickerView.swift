//
//  DatePickerView.swift
//  WebcomicViewer
//
//  Created by Damonique Thomas on 9/9/15.
//  Copyright (c) 2015 Damonique Thomas. All rights reserved.
//


import UIKit
import CoreData

class NumberPickerView: UIViewController {

    @IBOutlet var textField: UITextField!
    var input: String = "";
    var totalNum:Int!
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Get Total Number of Comics
        let urlPath = "http://xkcd.com/info.0.json"
        let url = NSURL(string: urlPath)
        let data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary {
            if let num: AnyObject? = json["num"] {
                let str:String = num!.stringValue!
                self.totalNum = Int(str)
            }
        }
        self.textField.keyboardType = UIKeyboardType.PhonePad
        self.textField.returnKeyType = UIReturnKeyType.Done
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterPressed(sender: UIButton) {
        input = textField.text!
        //check for valid comic num
        let num = Int(input)
        if (num > totalNum){
            let alertText = "Comic #\(num!) doesn't exist. Enter a different number."
            let alertController: UIAlertController = UIAlertController(title: "", message: alertText, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            //save to currentcomic
            let fetchRequest = NSFetchRequest(entityName: "CurrentComic")
            if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [CurrentComic] {
                let update = fetchResults[0] as NSManagedObject
                update.setValue(input, forKey: "currComicNum")
            }
            do {
                try managedObjectContext!.save()
            } catch let error as NSError {
                NSLog("\(error)")
            }
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    

}

