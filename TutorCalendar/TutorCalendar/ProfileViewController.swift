//
//  ProfileViewController.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 12/4/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var studentNameOutlet: UITextField!
    @IBOutlet var emailOutlet: UITextField!
    @IBOutlet var tutorOutlet: UISwitch!
    @IBOutlet var subject1Outlet: UITextField!
    @IBOutlet var subject1RatingOutlet: RatingControl!
    @IBOutlet var subject2Outlet: UITextField!
    @IBOutlet var subject2RatingOutlet: RatingControl!
    @IBOutlet var subject3Outlet: UITextField!
    @IBOutlet var subject3RatingOutlet: RatingControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        util.debug(1, "prepare for segue in Profile VC", args: segue.identifier, segue, sender!)
        if segue.identifier == "saveLogin" {
          
            util.debug(1, args: "Student", studentNameOutlet.text, emailOutlet.text)
            
            let keys = ["studentName", "studentEmail", "tutor", "subject1", "subject1Rating",
                        "subject2", "subject2Rating", "subject3", "subject3Rating"]
            let values = [studentNameOutlet.text!, emailOutlet.text!, tutorOutlet.on ? "1" : "0",
                          subject1Outlet.text!, String(subject1RatingOutlet.rating),
                          subject2Outlet.text!, String(subject2RatingOutlet.rating),
                          subject3Outlet.text!, String(subject3RatingOutlet.rating)
                          ]
            let payLoad = NSDictionary.init(objects: values, forKeys: keys)
            util.debug(1, args: payLoad)
            util.postJSON("/createStudent", payLoad: payLoad, completion: {jsonData in util.debug(1, args: "Create Student", jsonData) })
//            util.debug(1, args: studentID)

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
