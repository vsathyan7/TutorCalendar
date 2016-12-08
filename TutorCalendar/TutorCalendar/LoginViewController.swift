//
//  LoginViewController.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/15/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var buttonImage: UIImageView!
    
    @IBOutlet weak var profilePassword: UITextField!
    @IBOutlet weak var profileNameInput: UITextField!

    @IBOutlet weak var profileIDInput: UITextField!
    @IBOutlet weak var isTutorInput: UISwitch!
    
    var window: UIWindow?
    
    let managedObjectCTX = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let fetchRequest=NSFetchRequest(entityName: "UserProfileObject")

    
    var loggedInUserProfile:[UserProfileObject]=[]
    
    struct loginUser {
        let id: Int
        let name:String
        let email:String
    }
    
    var validLogins:[loginUser] = []
        
//        [loginUser(id:1, name:"Dinesh", email:"Dinesh@fhda.edu"),
//                       loginUser(id:4, name:"Jyothsna", email:"Jyothsna@fhda.edu"),
//                       loginUser(id:2, name:"Sathya", email:"Sathya@fhda.edu"),
//                       loginUser(id:3, name:"Quan", email:"Quan@fhda.edu")]

    
//    @IBOutlet var userNameOutlet: UITextField!
//    @IBOutlet var passwordOutlet: UITextField!
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (util.studentID == 0) || (util.completeOptions.count == 0) {
            validLogins = []
            util.completeIDs = []
            util.completeOptions = []
            let keys = ["studentID"]
            let values = ["0"]
            let payLoad = NSDictionary.init(objects: values , forKeys: keys)
            //        util.debug(2, args: payLoad.allKeys)
            
            let jsonData = util.getData("/student/", payLoad: payLoad)
            util.debug(2, args: jsonData)
            for counter in 0...(jsonData.count - 1){
                validLogins.append(loginUser(id: jsonData[counter].valueForKey("studentID") as! Int,
                    name: jsonData[counter].valueForKey("studentName") as! String,
                    email: jsonData[counter].valueForKey("email") as! String))
                
                util.completeOptions.append(jsonData[counter].valueForKey("studentName") as! String)
                util.completeIDs.append(jsonData[counter].valueForKey("studentID") as! Int)
            }
            //        util.studentID = 1
            util.debug(2, args: "Login VC - ViewDidLoad")
            util.debug(2, args: util.studentID)
        }
        // Do any additional setup after loading the view.
    }
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
    
//        self.buttonImage.image  = UIImage (named: "LogInButton")
//        self.logoImage.image    = UIImage (named: "DeAnzaLogo")
        
        
        //    Moved this to app deliagate. For now keep it commented.

//        if skipLoginPage(){
//            navigateNext()
//        }
//    }
    
    func navigateNext() {
        let secondViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("NewRoot"))! as UIViewController
        
        let window = UIApplication.sharedApplication().windows[0] as UIWindow
        UIView.transitionFromView(
            window.rootViewController!.view,
            toView: secondViewController.view,
            duration: 0.65,
            options: .TransitionCrossDissolve,
            completion: {
                finished in window.rootViewController = secondViewController
        })
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        
        let NewProfile = NSEntityDescription.insertNewObjectForEntityForName("UserProfileObject", inManagedObjectContext: managedObjectCTX) as! UserProfileObject
        
      //  NewProfile.profileName  = profileNameInput.text!
       

        if (Int(profileIDInput.text!)==nil) {
             alertMessage("Invalid Id", body: "Student Id is invalid")
        }
        else {
                let idEntered:Int? =  Int(profileIDInput.text!)!
                
                var matchedUser : Bool = false
                for counter in 0...(util.completeIDs.count - 1){
                    if util.completeIDs[counter] == idEntered {
                        util.studentID = util.completeIDs[counter]
                        NewProfile.profileID   = Int16(idEntered!)
                        NewProfile.profileEmail = validLogins[counter].email
                        NewProfile.profileName = validLogins[counter].name
                        NewProfile.isTutor      = isTutorInput.on ? true : false

                        matchedUser = true
                        
                        var saveErr :NSError?
                        
                        do
                        {
                            try managedObjectCTX.save()
                            
                            // Save this to util class so that it can be used in other places.
                            
//                            util.studentID=Int(NewProfile.profileID)
//                            util.isTutor=NewProfile.isTutor
                            navigateNext()
                            
                        }catch let error as NSError{
                            saveErr = error
                            util.debug(2, args: saveErr!.localizedDescription)
                        }
                        
                        break
                    }
                }
                if !matchedUser {
                    util.studentID = 0
                    profileNameInput.textColor = UIColor.redColor()
                    return 
                }
        }
    }
    
    //If the record is already there in the data store, skip the login page.
    // Moved this logic to AppDelegate. For now keep it commented.
    
//    func skipLoginPage()  -> Bool{
//        var fetchErr:NSError?
//        do{
//            try
//                
//              loggedInUserProfile = managedObjectCTX.executeFetchRequest(fetchRequest) as! [UserProfileObject]
//            
//              util.debug(2, args: "Number of Records in the storage:"+String(loggedInUserProfile.count))
//              return loggedInUserProfile.count>0
//            
//        } catch let error as NSError{
//            fetchErr = error
//            util.debug(2, args: fetchErr!.localizedDescription)
//        }
//        return false
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertMessage(header:String, body:String){
        
        let alertController = UIAlertController(title: header, message:
            body, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

//    @IBAction func signInAction(sender: AnyObject) {
//        var matchedUser : Bool = false
//        for counter in 0...(util.completeIDs.count - 1){
//            if util.completeOptions[counter] == userNameOutlet.text {
//                util.studentID = util.completeIDs[counter]
//                matchedUser = true
//            }
//        }
//        if !matchedUser {
//            util.studentID = 0
//            userNameOutlet.textColor = UIColor.redColor()
//            return 
//        }
//        util.debug(2, args: util.studentID)
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
