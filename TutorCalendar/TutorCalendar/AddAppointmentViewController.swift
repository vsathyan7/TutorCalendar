//
//  AddAppointmentViewController.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/15/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit

class AddAppointmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var appointment: Appointment!
    
    @IBOutlet var locationOutlet: UITextField!
    @IBOutlet var titleOutlet: UITextField!
    @IBOutlet var classOutlet: UITextField!
    @IBOutlet var apptDateOutlet: UITextField!
    
    @IBOutlet var timeOutlet: UITextField!
    @IBOutlet var durationOutlet: UITextField!
    
    @IBOutlet var inviteeOutlet: UITextField!
    @IBOutlet var notesOutlet: UITextView!
    
    @IBOutlet var autocompleteTableView: UITableView!
    
//    var autocompleteTableView: UITableView!
    var autocompleteOptions = [String]()
    var facultyID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let keys = ["studentID"]
//        let values = ["0"]
//        let payLoad = NSDictionary.init(objects: values , forKeys: keys)
////        util.debug(2, args: payLoad.allKeys)
//        
//        let jsonData = util.getData("/student/", payLoad: payLoad)
//        util.debug(2, args: jsonData)
        for counter in 0...(util.completeOptions.count - 1){
//            util.completeOptions.append(jsonData[counter].valueForKey("studentName") as! String)
            autocompleteOptions.append(util.completeOptions[counter])
        }

        apptDateOutlet.text = NSDate().USDateFormat
        
        inviteeOutlet.delegate = self
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        
        autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.view.addSubview(autocompleteTableView)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "saveAddSegue"{
            
            let strDate = apptDateOutlet.text! + "T" + timeOutlet.text! + ":00"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy'T'HH:mm:ss"
            let date = dateFormatter.dateFromString(strDate)
            util.debug(1, args: "prepare for segue in AddAppointmentVC date: \(date!)")
            
            appointment = Appointment(
                id:0,
                studentId: util.studentID,
                facultyId: facultyID,
                facultyName: inviteeOutlet.text!,
                title: titleOutlet.text!,
                fromTime: date!,
                details: notesOutlet.text!,
                locationName:locationOutlet.text!,
                subject: classOutlet.text!,
                timeBlock: date!.timeBlock)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        autocompleteTableView.hidden = false
        let substring = (self.inviteeOutlet.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        return true      // not sure about this - could be false
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        autocompleteTableView.hidden = false
        textField.textColor = UIColor.blackColor()
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        var matchedFaculty : Bool = false
        for counter in 0...(util.completeIDs.count - 1){
            if util.completeOptions[counter] == textField.text {
                facultyID = util.completeIDs[counter]
                matchedFaculty = true
            }
        }
        if !matchedFaculty {
            facultyID = 0
            textField.textColor = UIColor.redColor()
        }
        util.debug(2, args: facultyID)
        autocompleteTableView.hidden = true
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String){
        autocompleteOptions.removeAll(keepCapacity: false)
        
        for curString in util.completeOptions{
            let myString:NSString! = curString as NSString
            
            let substringRange :NSRange! = myString.rangeOfString(substring)
            
            if (substringRange.location  == 0){
                autocompleteOptions.append(curString)
            }
        }
        if ((autocompleteOptions.count == 0) && (substring == "")) {
            autocompleteOptions.appendContentsOf(util.completeOptions)
        }
        autocompleteTableView.reloadData()
        //autocompleteTableView.hidden = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteOptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let autoCompleteRowIdentifier = "cell"
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier, forIndexPath: indexPath) as UITableViewCell
        let index = indexPath.row as Int
        
        cell.textLabel!.text = autocompleteOptions[index]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        inviteeOutlet.text = self.autocompleteOptions[indexPath.row]
        self.autocompleteTableView.hidden = true
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
