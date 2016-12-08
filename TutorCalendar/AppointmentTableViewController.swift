//
//  AppointmentTableViewController.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/14/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit
extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    if httpResponse.statusCode == 404 {
                        self.image = UIImage(named:"person.png")
                    }
                    else {
                
                        if let imageData = data as NSData? {
                            self.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}


class AppointmentTableViewController: UITableViewController {
    
    var appointmentDate : NSDate = NSDate()
    var appointments=PersonAppointments()

    @IBOutlet var appointmentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //The belowline register an observer so that when the date is clicked in calendarview, notification will be sent to this instance of the table view. 
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppointmentTableViewController.reloadTableData(_:)), name: "reload", object:nil)
        appointments.getAppointmentsForGivenDate(NSDate())

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appointments .appointmentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let myRole="Student"
        
        let cellID = "AppointmentCell"
//        var loadImage : UIImageView
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AppointmentTableViewCell
        
        
        let appointment = appointments.appointmentList[indexPath.row]
        
        let localDate = appointment.FromTime 
        
        let calendar = NSCalendar.currentCalendar()
        let apptTime = calendar.components(([.Year, .Month, .Day, .Hour, .Minute, .Second,.Weekday]), fromDate: localDate)
        

        if appointment.TimeBlock == "morning" {
            cell.backgroundColor = UIColor(red: 246 / 255, green: 179 / 255, blue: 82 / 255, alpha: 1)
            cell.AppointmentTimeOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
            cell.AppointmentNotesOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
            cell.AppointmentLocationOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
            cell.AppointmentTitleOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
        } else if appointment.TimeBlock == "afternoon" {
            cell.backgroundColor = UIColor(red: 246 / 255, green: 134 / 255, blue: 87 / 255, alpha: 1)
            cell.AppointmentTimeOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
            cell.AppointmentNotesOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
            cell.AppointmentLocationOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
            cell.AppointmentTitleOutlet.textColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 56 / 255, green: 58 / 255, blue: 63 / 255, alpha: 1)
            cell.AppointmentTimeOutlet.textColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
            cell.AppointmentNotesOutlet.textColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
            cell.AppointmentLocationOutlet.textColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
            cell.AppointmentTitleOutlet.textColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
        }

        cell.AppointmentTitleOutlet.text = appointment.Title
        
        cell.AppointmentTimeOutlet.text = (NSString(format: "%02d", apptTime.hour) as String) + ":" + ((NSString(format: "%02d", apptTime.minute)) as String)
        cell.AppointmentLocationOutlet.text = appointment.LocationName
        cell.AppointmentNotesOutlet.text = appointment.Details
        
        cell.AppointmentInviteeImageOutlet.imageFromUrl("http://localhost:8000/image/studentID/" + String(appointment.StudentId))
        cell.AppointmentInviteeImageOutlet.layer.cornerRadius = cell.AppointmentInviteeImageOutlet.frame.size.width / 2
        cell.AppointmentInviteeImageOutlet.clipsToBounds=true
        cell.AppointmentInviteeImageOutlet.layer.cornerRadius=20.0

        cell.AppointmentInviteeImageOutlet.layer.borderWidth = 2.0
        cell.AppointmentInviteeImageOutlet.layer.borderColor = UIColor.whiteColor().CGColor

        cell.facultyImageOutlet.imageFromUrl("http://localhost:8000/image/studentID/" + String(appointment.FacultyId))

        // To show rounded image.
        cell.facultyImageOutlet.layer.cornerRadius = cell.AppointmentInviteeImageOutlet.frame.size.width / 2
        cell.facultyImageOutlet.clipsToBounds=true
        cell.facultyImageOutlet.layer.cornerRadius=20.0
        
        cell.facultyImageOutlet.layer.borderWidth = 2.0
        cell.facultyImageOutlet.layer.borderColor = UIColor.whiteColor().CGColor

        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        util.debug(2, "prepare for segue in ATVC", args: segue, sender!, segue.identifier)
        
        if (segue.identifier == "editAppointment"){
            
            if let indPath = self.tableView.indexPathForSelectedRow{
                let detailViewController = segue.destinationViewController as! EditAppointmentViewController
                detailViewController.appointment = appointments.appointmentList[indPath.row]
            }
        }
    }
    
    func reloadTableData(notification: NSNotification) {
        util.debug(2, args: "reload")
        let viewDate = notification.object as! NSDate
        util.debug(2, args: viewDate)
        appointments.getAppointmentsForGivenDate(viewDate)
        tableView.reloadData()
    }
    
    @IBAction func cancelEdit(segue:UIStoryboardSegue){
        
        util.debug(2, args: "Cancel in Edit Pressed")
    }
    
    @IBAction func saveEdit(segue:UIStoryboardSegue){
        
        let editAppointmentVC = segue.sourceViewController as! EditAppointmentViewController
        util.debug(1, args: "Save in Edit Pressed")
        util.debug(1, args: editAppointmentVC.appointment.Title)
        editAppointmentVC.appointment.editAppointment()
    }

}
