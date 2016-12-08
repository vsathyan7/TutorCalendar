//
//  util.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/25/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    func startOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components([.Year, .Month], fromDate: self) else { return nil }
        return cal.dateFromComponents(comp)!
    }
    func endOfPrevMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = NSDateComponents() else { return nil }
        comp.day = -1
        return cal.dateByAddingComponents(comp, toDate: self.startOfMonth()!, options: [])!
    }
    func endOfMonth() -> NSDate? {
        guard
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = NSDateComponents() else { return nil }
        comp.month = 1
        comp.day = -1
        return cal.dateByAddingComponents(comp, toDate: self.startOfMonth()!, options: [])!
    }
    func addDays(days : Int) -> NSDate? {
        let today = self
        let tomorrow = NSCalendar.currentCalendar()
            .dateByAddingUnit(
                .Day,
                value: days,
                toDate: today,
                options: []
        )
        return tomorrow
    }
    func addHours(duration: Int) -> NSDate? {
        util.debug(2, args: "called addhours")
        let today = self
        let newDate = NSCalendar.currentCalendar()
            .dateByAddingUnit(
                .Hour,
                value: duration,
                toDate: today,
                options: []
        )
        return newDate
    }
    var day: String {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day , .Month , .Year], fromDate: self)
        let day = NSString(format: "%02d",dateComponents.day)
        return String(day)
    }
    var shortMonth: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.stringFromDate(self).uppercaseString
    }
    var fullMonth: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Month"
        let months = dateFormatter.monthSymbols
        let monthSymbol = months[Int(dateFormatter.stringFromDate(self))!-1] // month - from your date components
        return monthSymbol
    }
    var year: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.stringFromDate(self)
    }
    var JSDateFormat: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(self)
        
    }
    var JSDateTimeFormat: String {
        //        util.debug(2, args: "JSDATETIMEFORMAT")
        //        util.debug(2, args: self)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        util.debug(2, args: dateFormatter.stringFromDate(self))
        return dateFormatter.stringFromDate(self)
        
    }
    var USDateFormat: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(self)
        
    }
    var timeHHMM: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(self)
    }
    var timeBlock: String{
        var returnValue: String = ""
        let calendar = NSCalendar.currentCalendar()
        let apptTime = calendar.components(([.Year, .Month, .Day, .Hour, .Minute, .Second,.Weekday]), fromDate: self)
        let hour = apptTime.hour
        util.debug(2, args: "timeBlock")
        util.debug(2, args: self, hour)
        if (hour > 0) && (hour <= 12) {
            if (hour == 12) && (apptTime.minute > 0) {
                returnValue = "afternoon"
            }
            else {
                returnValue = "morning"
            }
        }
        else if (hour > 12) && (hour <= 16) {
            returnValue =  "afternoon"
        }
        else {
            returnValue =  "evening"
        }
        
        util.debug(2, args: returnValue)
        
        return returnValue

    }
    
}

class util {
    static var studentID:Int=0
    static var completeOptions = [String]()
    static var completeIDs = [Int]()
    static var isTutor = false
    static var currentSelectedDate = NSDate()

    static func getData(route : String, payLoad : NSDictionary) -> [NSDictionary]
    {
        let url = buildURL(route, payLoad: payLoad)
        //        util.debug(2, args: url)
        var data = getJSON(url)
        //        util.debug(2, args: data)
        if data == nil{
            switch(route) {
            case "/":
                data = getFileJSON("day_summary")
            case "/appt/":
                data = getFileJSON("appointments")
            case "/student/":
                data = getFileJSON("students")
            default:
                util.debug(2, args: "Unhandled Route")
                break
            }
        }
        //        util.debug(2, args: data)
        return data!
    }
    static func buildURL(route : String, payLoad : NSDictionary?) -> String {
        var serverName = "http://localhost:8000" + route
        if let realPayLoad = payLoad {
            //            util.debug(2, args: realPayLoad.count)
            let keys = realPayLoad.allKeys
            let values = realPayLoad.allValues
            for counter in 0...(realPayLoad.count - 1){
                //            util.debug(2, args: keys[counter])
                //            util.debug(2, args: values[counter])
                
                serverName = serverName + (keys[counter] as! String) + "/" + (values[counter] as! String) + "/"
            }
        }
        
//        util.debug(2, args: serverName)
        return serverName
    }
    
    static func getJSON(urlToRequest:String) -> [NSDictionary]?
    {
        var dataJSON : [NSDictionary]
        //        util.debug(2, args: urlToRequest)
        do {
            let data = NSData(contentsOfURL: NSURL(string: urlToRequest)!)
            //            print (data)
            if data == nil {
                util.debug(2, args: "No data from server")
                return nil
            }
            dataJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [NSDictionary]
            //            util.debug(2, args: "Get JSON")
            return dataJSON
        } catch {
            print(error)
        }
        return [NSDictionary()]
    }
    static func getFileJSON(file : String) -> [NSDictionary]{
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                do {
                    if let jsonResult: [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? [NSDictionary]
                    {
                        return (jsonResult)
                    }
                }
                catch {
                    print ("error")
                }
                
            }
        }
        return [NSDictionary()]
    }
    static func postJSON(route : String, payLoad : NSDictionary?, completion: (NSDictionary) -> ()){
        // Setup the session to make REST POST call
        let url = NSURL(string: buildURL(route, payLoad: nil))
        let session = NSURLSession.sharedSession()
        var returnValue: AnyObject = NSDictionary()
        //        let postParams : [String: AnyObject] = ["hello": "Hello POST world"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(payLoad!, options: NSJSONWritingOptions())
            util.debug(2, args: payLoad!)
        } catch {
            util.debug(2, args: "bad things happened")
            let payLoad = NSDictionary.init(objects: [401], forKeys: ["Status"])

            completion(payLoad)
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            if let realResponse = response as? NSHTTPURLResponse {
                util.debug(2, args: realResponse)
                if realResponse.statusCode == 200 {
                    util.debug(2, args: realResponse)
                }
            }
            else {
                util.debug(2, args: "Not a 200 response")
                returnValue = NSDictionary.init(objects: [400], forKeys: ["Status"])
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String
                where error == nil {
                // Print what we got from the call
                util.debug(1, args: "POST: " + postString)
                completion(convertStringToDictionary(postString)!)
            }
            
        }).resume()
    }

    static func deleteJSON(route : String, payLoad : NSDictionary?) -> Int{
        // Setup the session to make REST POST call
        util.debug(1, args: "deleteJSON", route, payLoad)
        let url = NSURL(string: buildURL(route, payLoad: nil))
        let session = NSURLSession.sharedSession()
        //        let postParams : [String: AnyObject] = ["hello": "Hello POST world"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(payLoad!, options: NSJSONWritingOptions())
            util.debug(2, args: payLoad!)
        } catch {
            util.debug(1, args: "bad things happened")
            return 401
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            if let realResponse = response as? NSHTTPURLResponse {
                util.debug(1, args: realResponse)
                if realResponse.statusCode == 200 {
                    util.debug(2, args: realResponse)
                }
            }
            else {
                util.debug(1, args: "Not a 200 response")
                return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                util.debug(2, args: "POST: " + postString)
            }
            
        }).resume()
        return 0
    }
    
    static func postImage(route : String, image : UIImage, student_id : Int) -> AnyObject {
        
        let url = buildURL(route, payLoad: nil)
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let imageData = UIImageJPEGRepresentation(image, 0.9)
        let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) // encode the image
        
//        let err: NSError? = nil
        let params = ["image":[ "content_type": "image/jpeg", "filename":"\(student_id).jpg", "file_data": base64String]]
        do {
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
        }
        catch {
            util.debug(1, args: "Error in postImage")
            return 1
            
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let err: NSError?
            
            if let realResponse = response as? NSHTTPURLResponse {
                util.debug(1, args: realResponse)
                if realResponse.statusCode == 200 {
                    util.debug(2, args: "postimage", realResponse)
                }
            }
            else {
                util.debug(1, args: "postimage", "Not a 200 response")
                return
            }

            
            // process the response
        })
        
        task.resume() // this is needed to start the task
        
        return 0
    }


    static func debug(level:Int, args:AnyObject?...) {
        if level < 2 {
            for arg in args {
                print(arg, terminator:"\t")
            }
        print("\n")
        }
    }
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            } catch {return nil}
        }
        return nil
    }
    
    
}