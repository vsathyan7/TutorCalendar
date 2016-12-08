//
//  PersonAppointments.swift
//  TutorCalendar
//
//  Created by Sathya Venkataraman on 11/17/16.
//

import Foundation

/* This object contains list of appointments for a given person. 
 
*/

class PersonAppointments {

    // Array of appointments for a given person.
    
    var appointmentList:[Appointment]=[]
    var appointmentViewDate:NSDate=NSDate()
    
    func getAppointmentsForGivenDate(viewDate:NSDate){
        
        appointmentList=[]        
        
        let keys = ["date", "studentID"]
        let values = [viewDate.JSDateFormat, NSString(format: "%d", util.studentID)]
        var payLoad = NSDictionary.init(objects: values as! [String], forKeys: keys)
        util.debug(2, args: payLoad.allKeys)
        
        let jsonData = util.getData("/appt/", payLoad: payLoad)
        util.debug(1, args: "Appointments Data")
        util.debug(1, args: jsonData.count)
        let rowCount = jsonData.count - 1
        util.debug(1, args: jsonData)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.appointmentViewDate=viewDate

        if rowCount > -1 {
            for counter in 0...rowCount {
                appointmentList.append(Appointment(id:jsonData[counter].valueForKey("appointmentID") as! Int,
                    studentId: jsonData[counter].valueForKey("studentID") as! Int,
                    facultyId: jsonData[counter].valueForKey("facultyID") as! Int,
                    facultyName: jsonData[counter].valueForKey("facultyName") as! String,
                    title: jsonData[counter].valueForKey("title") as! String,
                    fromTime: dateFormatter.dateFromString(jsonData[counter].valueForKey("scheduleDateTime") as! String)!,
                    details:jsonData[counter].valueForKey("notes") as! String,
                    locationName:jsonData[counter].valueForKey("location") as! String,
                    subject: jsonData[counter].valueForKey("subject") as! String,
                    timeBlock:dateFormatter.dateFromString(jsonData[counter].valueForKey("scheduleDateTime") as! String)!.timeBlock
                    ))
                util.debug(2, args: appointmentList[counter].FromTime)
            }
        }
        appointmentList.sortInPlace({ $0.FromTime.timeIntervalSince1970 < $1.FromTime.timeIntervalSince1970 })
        
    }
    
    func getAllAppointments(){
        
        //TODO : This will give all appointments for a given person.  There is no date range. To be implemented later.
    }
        
}
