//
//  userProfile.swift
//  TutorCalendar
//
//  Created by Quan Bach  on 11/21/16.
//  Copyright © 2016 edu.deanza.darora. All rights reserved.
//

import UIKit
import CoreData

class UserProfileObject: NSManagedObject {
    
    @NSManaged var profileName  : String
    @NSManaged var profileID    : Int16
    @NSManaged var profileEmail : String
    @NSManaged var isTutor      : Bool
    
    //    var profileName     = " "
    //    var profileID       = 0
    //    var profileEmail    = " "
    //    var isTutor         = false
    //
    //    init (profileName : String, profileID : Int, profileEmail : String, isTutor: Bool)
    //    {
    //        self.profileName    = profileName
    //        self.profileID      = profileID
    //        self.profileEmail   = profileEmail
    //        self.isTutor        = isTutor
    //    }
    
    
}
