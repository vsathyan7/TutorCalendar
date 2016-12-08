//
//  CalendarViewController.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/14/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit


class CalendarViewController: UIViewController {
    
//    @IBOutlet var monthNameOutlet: UINavigationBar!
    var days : [day] = []
    var currentSelectedIndex = -1
    
//    @IBOutlet var ipLabel: UILabel!
    
    let numberOfDays = 42
    let numberOfRows = 6
    let numberOfColumns = 7
    
    
    @IBOutlet var monthBarOutlet: UINavigationBar!

    func randomNumber(start: Int, to end: Int) -> Int {
        return Int(arc4random_uniform(UInt32(end - start + 1))) + start
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        var currentDate = NSDate() //.addHours(-8)
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startOfMonth = currentDate.startOfMonth()
        let currentComponents = calendar.components([.Weekday, .Month, .NSMonthCalendarUnit], fromDate: startOfMonth!)
        
        let day1WeekDay = currentComponents.weekday
        
        
        monthBarOutlet?.topItem!.title = "\(currentDate.fullMonth), \(currentDate.year)"
        currentDate = startOfMonth!.addDays((day1WeekDay - 1) * -1)!
        
        
        var buttonY = 44
        var buttonX = 0
        
        let viewWidth =  Int(self.view.frame.width)
        let viewHeight = viewWidth * 13 / 21 // Int(self.view.frame.height)
        
        let buttonWidth = viewWidth / numberOfColumns // number of days per row
        let buttonHeight = viewHeight / numberOfRows // 6 rows
        var dayNumber = 1
        let keys = ["date", "studentID"]
        let values = [currentDate.JSDateFormat, NSString(format: "%d", util.studentID)]
        let payLoad = NSDictionary.init(objects: values as! [String], forKeys: keys)

        let jsonData = util.getData("/", payLoad: payLoad)
        
        if jsonData.count < numberOfRows {
            print ("Server is down")
        }
        for _ in 1...numberOfRows {
            buttonX = 0
            for _ in 1...numberOfColumns {
                
                let morning = jsonData[dayNumber - 1].valueForKey("morning_busy") as! Int
                let evening = jsonData[dayNumber - 1].valueForKey("evening_busy") as! Int
                let afternoon = jsonData[dayNumber - 1].valueForKey("afternoon_busy") as! Int

                let aDay = day(date: currentDate, index: dayNumber, morningBusy: morning >= 1, afternoonBusy: afternoon >= 1, eveningBusy: evening >= 1, selectedDay: (currentDate.JSDateFormat == NSDate().JSDateFormat) )
                if currentDate.JSDateFormat == NSDate().JSDateFormat {
                    currentSelectedIndex = dayNumber 
                }
                let dayButton = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))

                dayButton.titleLabel?.text = "\(dayNumber)"
                dayButton.adjustsImageWhenHighlighted = false
                dayButton.setImage(aDay.image, forState: .Normal)
                dayButton.addTarget(self, action: #selector(CalendarViewController.dayButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                aDay.button = dayButton
                days += [aDay]
                
                self.view.addSubview(days[dayNumber - 1].button)
                buttonX += buttonWidth
                dayNumber += 1
                currentDate = currentDate.addDays(1)!
            }
            buttonY += buttonHeight
        }
        
    }
    
        
    
    func dayButton(sender:UIButton!) {
        let index = Int((sender.titleLabel?.text)!)
        
        if sender.titleLabel?.text != nil {
            if currentSelectedIndex > 0 {
                days[currentSelectedIndex - 1].selectedDay = false
                days[currentSelectedIndex - 1].image = days[currentSelectedIndex - 1].createImage()
                days[currentSelectedIndex - 1].button.setImage(days[currentSelectedIndex - 1].image, forState: .Normal)
            }
            currentSelectedIndex = index!
            days[currentSelectedIndex - 1].selectedDay = true
            days[currentSelectedIndex - 1].image = days[currentSelectedIndex - 1].createImage()
            days[currentSelectedIndex - 1].button.setImage(days[currentSelectedIndex - 1].image, forState: .Normal)
            util.currentSelectedDate = days[currentSelectedIndex - 1].date
        
          //Once the the date is clicked, call the registered notification in AppointmentTableViewConrtoller. See viewDidLoad () in AppointmentTableViewConrtoller
            
           let newDate = days[currentSelectedIndex - 1].date
           NSNotificationCenter.defaultCenter().postNotificationName("reload", object: newDate)
        } else {
            
            util.debug(2, args: "Nowhere to go :/")
            
        }
    }
    
    @IBAction func cancelAdd(segue:UIStoryboardSegue){
        
        util.debug(2, args: "Cancel in add Pressed")
    }
    
    //TODO implemente call to add the appointment
    
    @IBAction func saveAdd(segue:UIStoryboardSegue){
        
        util.debug(2, args: "Save in add Pressed")
        
        let addAppointmentVC = segue.sourceViewController as! AddAppointmentViewController
//        util.debug(2, args: addAppointmentVC.appointment.LocationName)
        addAppointmentVC.appointment.addAppointment()
        for i in 0...days.count - 1{
//            util.debug(2, args: "saveAdd", days[i].date.USDateFormat, addAppointmentVC.appointment.FromTime.USDateFormat)
            if days[i].date.USDateFormat == addAppointmentVC.appointment.FromTime.USDateFormat {
                util.debug(2, args: "matched")
                switch (addAppointmentVC.appointment.TimeBlock){
                case "morning" :
                    days[i].morningBusy = true
                    break
                case "afternoon" :
                    days[i].afternoonBusy = true
                    break
                case "evening" :
                    days[i].eveningBusy = true
                    break
                default:
                    days[i].morningBusy = true                    
                }
                util.debug(2, args: days[i].date)
                if days[i].selectedDay {
                    util.debug(2, args: "notification raised")
                    NSNotificationCenter.defaultCenter().postNotificationName("reload", object: days[i].date)
                }

                days[i].image = days[i].createImage()
                days[i].button.setImage(days[i].image, forState: .Normal)

            }
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
