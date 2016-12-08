//
//  RatingControl.swift
//  ListViewApp_DineshArora
//
//  Created by Dinesh Arora on 10/20/16.
//  Copyright © 2016 Dinesh AroraDeAnza. All rights reserved.
//

import UIKit 

class RatingControl: UIView {

    // MARK: Properties
    
    var rating = 0{
        didSet {
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    let spacing = 0
    let starCount = 5

    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")

        for _ in 0..<starCount {
            let button = UIButton()

            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])

            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
            ratingButtons += [button]

            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        let buttonHeight = Int(frame.size.height)
        let buttonWidth = Int(frame.size.width) / 5
//        let buttonWidth = Int(frame.size.height) / starCount

        var buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        
        // Set the button's width and height to a square the size of the frame's height.
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonWidth + spacing))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }

    
//    override func intrinsicContentSize() -> CGSize {
//        let buttonSize = 10 //Int(frame.size.height)
//        let width = 10 //Int((superview?.frame.size.width)!) //Int(frame.size.width) //(buttonSize * starCount) + (spacing * (starCount - 1))
//        
//        return CGSize(width: width, height: buttonSize)
//    }
    
    func ratingButtonTapped(button: UIButton) {
        rating = ratingButtons.indexOf(button)! + 1

        updateButtonSelectionStates()

    }

    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < rating
        }

    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
