//
//  Appointment.swift
//  collectionViewExample
//
//  Created by Sathya Venkataraman on 11/16/16.
//

import Foundation


class Appointment: NSObject {
    
    //TODO: Sathya -  Later clean up this and remove name fields. Studentname and FacultyName can be derived from person object. But for simiplicity I have it here.
    
    var Id: Int
    var StudentId: Int
    var FacultyId: Int
    var FacultyName:String
    var Title:String
    var FromTime: NSDate
    var Details:String
    var LocationName:String
    var Subject:String
    var TimeBlock:String
    
    init(id:Int, studentId:Int, facultyId:Int, facultyName:String, title:String, fromTime:NSDate, details:String, locationName:String, subject:String, timeBlock : String) {
        self.Id = id
        self.StudentId = studentId
        self.FacultyId = facultyId
        self.FacultyName = facultyName
        self.Title = title
        self.FromTime = fromTime
        self.Details = details
        self.LocationName = locationName
        self.Subject = subject
        self.TimeBlock = timeBlock
        
    }
    
    func addAppointment(){
        
        let appointment: Appointment = self
        
        util.debug(1, args: "addAppointment", appointment.FromTime)
        
        util.debug(2, args: "Add Appointment in person appoinments")
        appointment.TimeBlock = appointment.FromTime.timeBlock
        
        let keys = ["appointmentID", "studentID", "facultyID", "facultyName", "title", "scheduleDateTime", "details", "location", "subject", "timeBlock"]
        let values = [NSString(format: "%d", 0), NSString(format: "%d", appointment.StudentId), NSString(format: "%d", appointment.FacultyId),
                      appointment.FacultyName, appointment.Title, appointment.FromTime.JSDateTimeFormat,
                      appointment.Details, appointment.LocationName, appointment.Subject, appointment.TimeBlock]
        let payLoad = NSDictionary.init(objects: values as! [String], forKeys: keys)
        util.debug(1, args: payLoad)
        let _ = util.postJSON("/createAppt", payLoad: payLoad)
        
    }
    
    func editAppointment(){
        let appointment: Appointment = self

        util.debug(1, args: "editAppointment in PersonAppoinment")
        util.debug(1, args: appointment.LocationName)
        appointment.TimeBlock = appointment.FromTime.timeBlock
        
        let keys = ["appointmentID", "studentID", "facultyID", "facultyName", "title", "scheduleDateTime", "details", "location", "subject", "timeBlock"]
        let values = [NSString(format: "%d", appointment.Id), NSString(format: "%d", appointment.StudentId), NSString(format: "%d", appointment.FacultyId),
                      appointment.FacultyName, appointment.Title, appointment.FromTime.JSDateTimeFormat,
                      appointment.Details, appointment.LocationName, appointment.Subject, appointment.TimeBlock]
        let payLoad = NSDictionary.init(objects: values as! [String], forKeys: keys)
        util.debug(1, args: payLoad)
        let _ = util.postJSON("/createAppt", payLoad: payLoad)
    }
    
    func deleteAppointment(){
        
        let appointment: Appointment = self
        
        util.debug(1, args: "deleteAppointment in PersonAppoinment")
        util.debug(1, args: appointment.Id)
        
        let keys = ["appointmentID"]
        let values = [NSString(format: "%d", appointment.Id)]
        let payLoad = NSDictionary.init(objects: values as! [String], forKeys: keys)
        util.debug(1, args: payLoad)
        let responseAppt = util.deleteJSON("/deleteAppt", payLoad: payLoad)
        util.debug(1, args: responseAppt)
        //        return responseAppt
    }
    

    
}