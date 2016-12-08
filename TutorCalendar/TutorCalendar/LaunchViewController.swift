//
//  LaunchViewController.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/14/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit
import CoreData

class LaunchViewController: UIViewController {
    
    @IBOutlet var monthNav: UINavigationItem!
    let managedObjectCTX = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let fetchRequest=NSFetchRequest(entityName: "UserProfileObject")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthNav.title = NSDate().fullMonth + ", " + NSDate().year
//        monthNav.title.
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        util.debug(1, args: "Prepare for segue in Launch", segue.identifier, segue, segue.sourceViewController)
        if (segue.identifier == "addEvent") && (util.completeOptions.count == 0){
//            let destVC = segue.destinationViewController as! AddAppointmentViewController
//            let sourceVC = segue.sourceViewController as! CalendarViewController
//            util.debug(1, args: sourceVC.days[sourceVC.currentSelectedIndex - 1])
//            util.debug(1, args: destVC)
            util.completeIDs = []
            util.completeOptions = []
            let keys = ["studentID"]
            let values = ["0"]
            let payLoad = NSDictionary.init(objects: values , forKeys: keys)
            //        util.debug(2, args: payLoad.allKeys)
            
            let jsonData = util.getData("/student/", payLoad: payLoad)
            util.debug(2, args: jsonData)
            for counter in 0...(jsonData.count - 1){
                util.completeOptions.append(jsonData[counter].valueForKey("studentName") as! String)
                util.completeIDs.append(jsonData[counter].valueForKey("studentID") as! Int)
            }
            //        util.studentID = 1
            util.debug(2, args: "prepare for segue - ViewDidLoad")
            util.debug(2, args: util.studentID)
            
        }
        if (segue.identifier == "reLogin"){
            util.studentID = 0
            util.currentSelectedDate = NSDate()
            clearStoredValues()
        }
    }
    
    func clearStoredValues(){
        
        var fetchErr:NSError?
        var loggedInUserProfile:[UserProfileObject]=[]
        
        do{
            try loggedInUserProfile = managedObjectCTX.executeFetchRequest(fetchRequest) as! [UserProfileObject]
            for userProfile in loggedInUserProfile{
                managedObjectCTX.deleteObject(userProfile)
            }
        } catch let error as NSError{
            fetchErr = error
            util.debug(2, args: "Fetch in LaunchViewController.ClearStoreValues Failed. "+fetchErr!.localizedDescription)
        }
        
        do{
            try managedObjectCTX.save()
            
        } catch let fetchErr as NSError {
            
            util.debug(2, args: "Save in delete errored "+(fetchErr.localizedDescription))
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
