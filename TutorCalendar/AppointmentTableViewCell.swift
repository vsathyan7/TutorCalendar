//
//  AppointmentTableViewCell.swift
//  TutorCalendar
//
//  Created by Dinesh Arora on 11/15/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {


    @IBOutlet var AppointmentTimeOutlet: UILabel!
    @IBOutlet weak var AppointmentTitleOutlet: UILabel!
 
    @IBOutlet weak var AppointmentNotesOutlet: UILabel!

    @IBOutlet weak var AppointmentLocationOutlet: UILabel!

    @IBOutlet var facultyImageOutlet: UIImageView!
    
    @IBOutlet weak var AppointmentInviteeImageOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
