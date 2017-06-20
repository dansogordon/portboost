//
//  InterestsGroupParseObject.swift
//  Hijinnks
//
//  Created by adeiji on 3/13/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import Parse

class InterestsGroupParseObject : PFObject, PFSubclassing {
    
    class func parseClassName () -> String {
        return ParseCustomObjectsClassNames.InterestsGroup.rawValue
    }
    
    // The name of this interests that the friends are affiliated with
    var name : String {
        get {
            return self[ParseObjectColumns.Name.rawValue] as! String
        }
        set {
            self[ParseObjectColumns.Name.rawValue] = newValue
        }
    }
    
    // The list of friends that are affiliated with this interests group.  We store them as strings so that when the user has a great deal of friends they're not all pulled down from the server
    var friend : PFUser {
        get {
            return self[ParseObjectColumns.Friends.rawValue] as! PFUser
        }
        set {
            self[ParseObjectColumns.Friends.rawValue] = newValue
        }
    }
    
    var owner : PFUser {
        get {
            return self[ParseObjectColumns.Owner.rawValue] as! PFUser
        }
        set {
            self[ParseObjectColumns.Owner.rawValue] = newValue
        }
    }
}
    
