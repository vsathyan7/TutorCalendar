//
//  EditAppointmentViewController.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/15/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit

class EditAppointmentViewController: UIViewController {

    @IBOutlet var titleOutlet: UITextField!
    @IBOutlet var locationOutlet: UITextField!
    @IBOutlet var classOutlet: UITextField!
    @IBOutlet var dateOutlet: UITextField!
    @IBOutlet var timeOutlet: UITextField!
    @IBOutlet var durationOutlet: UITextField!
    @IBOutlet var inviteeOutlet: UITextField!
    @IBOutlet var notesOutlet: UITextView!
    var appointment:Appointment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        util.debug(1, args: appointment!.Title)
        titleOutlet.text = appointment.Title
        locationOutlet.text = appointment.LocationName
        classOutlet.text = appointment.Subject
        dateOutlet.text = appointment.FromTime.USDateFormat
        timeOutlet.text = appointment.FromTime.timeHHMM
        inviteeOutlet.text = appointment.FacultyName
        notesOutlet.text = appointment.Details
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteAppointmentAction(sender: AnyObject) {
        util.debug(1, args: "deleteAppointmentAction")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        util.debug(1, args: "prepareForSegue in EAVC", segue.identifier, appointment.Id)
        if segue.identifier == "saveEditSeque"{
            let strDate = dateOutlet.text! + "T" + timeOutlet.text! + ":00"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy'T'HH:mm:ss"
            let date = dateFormatter.dateFromString(strDate)

            appointment.Title = titleOutlet.text!
            appointment.LocationName = locationOutlet.text!
            appointment.Subject = classOutlet.text!
            appointment.FromTime = date!
            appointment.FacultyName = inviteeOutlet.text!
            appointment.Details = notesOutlet.text!
        }
        else if segue.identifier == "deleteEvent" {
            appointment.deleteAppointment()
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
