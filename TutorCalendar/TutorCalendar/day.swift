import UIKit

class day {
    var date :NSDate = NSDate()
    var day : Int = 0
    var index : Int = 0
    var morningBusy : Bool = false
    var afternoonBusy : Bool = false
    var eveningBusy : Bool = false
    var today : Bool = false
    var selectedDay : Bool = false
    var button : UIButton = UIButton()
    var image : UIImage = UIImage(named: "Box.png")!
    
    init(date: NSDate, index: Int, morningBusy: Bool, afternoonBusy: Bool, eveningBusy: Bool, selectedDay: Bool){
        
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currentComponents = calendar.components([.Day , .Month , .Year], fromDate: currentDate)
        
        let dateComponents = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        if (dateComponents.day == currentComponents.day) && (dateComponents.month == currentComponents.month) {
            self.today = true
        }
        self.date = date
        self.morningBusy = morningBusy
        self.afternoonBusy = afternoonBusy
        self.eveningBusy = eveningBusy
        self.selectedDay = selectedDay
        self.day = dateComponents.day
        self.index = index
        self.image = createImage()
        
    }
    
    func createImage() -> UIImage {


//        util.debug(2, args: "Creating an image")
        let boxImage = UIImage(named: "Box.png")
        
        let size = CGSize(width: boxImage!.size.width * 2, height: boxImage!.size.height * 2)

        // Top part 25%

        let dayCenterPoint : CGPoint = CGPoint(x: boxImage!.size.width, y: size.height / 2 + size.height * 0.25 / 2)
        let dayRect : CGRect = CGRect(origin: dayCenterPoint, size: CGSize(width: size.width / 2, height: size.height * 0.75))

        let legendsPoint : CGPoint = CGPoint(x: 40,y: 16)
        let legendsOffset = CGPoint(x: 5, y: 0)
        let legendRadius : CGFloat = 18.0
        let circleRadius = dayRect.width / 2
        
        var legendRect : [CGRect] = [
            CGRect(x:legendsPoint.x, y: legendsPoint.y,
                width: legendRadius, height: legendRadius),
            CGRect(x:legendsPoint.x + legendRadius + legendsOffset.x, y: legendsPoint.y,
                width: legendRadius, height: legendRadius),
            CGRect(x:legendsPoint.x + (legendRadius + legendsOffset.x) * 2, y: legendsPoint.y,
                width: legendRadius, height: legendRadius),
]
        
//        util.debug(2, args: size)
//        util.debug(2, args: dayPoint)
//        util.debug(2, args: dayCenterPoint)
//        util.debug(2, args: legendRect)
    
        
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let textBox = CGRect(x: dayCenterPoint.x - circleRadius * 0.80, y: dayCenterPoint.y - circleRadius * 0.80, width: circleRadius * 1.8, height:  circleRadius * 1.8)
        
        
        let morningImage = morningBusy ? UIImage(named: "Morning Busy") : UIImage(named: "Free Time")
        let afternoonImage = afternoonBusy ? UIImage(named: "Afternoon Busy") : UIImage(named: "Free Time")
        let eveningImage = eveningBusy ? UIImage(named: "Evening Busy") : UIImage(named: "Free Time")
        
        
        let selectedImage = UIImage(named: "Selected Day")
        let todayImage = UIImage(named: "Today")
        
        boxImage?.drawInRect(areaSize, blendMode: .Normal, alpha: 1.0)
        
        morningImage!.drawInRect(legendRect[0], blendMode: .Normal, alpha: 1.0)
        afternoonImage!.drawInRect(legendRect[1], blendMode: .Normal, alpha: 1.0)
        eveningImage!.drawInRect(legendRect[2], blendMode: .Normal, alpha: 1.0)
        var color : UIColor = UIColor.blackColor()
        if self.selectedDay {
            selectedImage!.drawInRect(CGRect(x: dayCenterPoint.x - circleRadius, y: dayCenterPoint.y - circleRadius, width: circleRadius * 2, height:  circleRadius * 2), blendMode: .Normal, alpha: 0.75)
            color = UIColor.whiteColor()
        }
        if self.today {
            todayImage!.drawInRect(CGRect(x: dayCenterPoint.x - circleRadius, y: dayCenterPoint.y - circleRadius, width: circleRadius * 2, height:  circleRadius * 2), blendMode: .Normal, alpha: 0.75)
        }

        var newImage: UIImage = textToImage(self.day, inImage: boxImage!, color: color)

        newImage.drawInRect(textBox)

        newImage = UIGraphicsGetImageFromCurrentImageContext()
        //        imageOutlet.image = newImage
        UIGraphicsEndImageContext()
        return newImage
        
    }
    func textToImage(drawText: Int, inImage: UIImage, color: UIColor)->UIImage{
        
        let imageText = String(drawText)
        let offset : CGFloat = drawText < 10 ? 20.0 : 9.0
        let textFontAttributes = [
            NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 40)!,
            NSForegroundColorAttributeName: color,
            
            ]
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        
        //Put the image into a rectangle as large as the original image.
        let rect: CGRect = CGRectMake(offset, 0, inImage.size.width, inImage.size.height)
        imageText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
}
