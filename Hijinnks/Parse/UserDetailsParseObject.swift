//
//  UserDetailsParseObject.swift
//  Hijinnks
//
//  Created by adeiji on 5/16/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import Parse

class UserDetailsParseObject : PFObject, PFSubclassing {
    class func parseClassName () -> String {
        return ParseCustomObjectsClassNames.UserDetails.rawValue
    }
    
    var rsvpCount : Int! {
        get {
            return self[ParseObjectColumns.RSVPCount.rawValue] as! Int!
        }
        set {
            self[ParseObjectColumns.RSVPCount.rawValue] = newValue
        }
    }
    
    var likeCount : Int! {
        get {
            return self[ParseObjectColumns.LikeCount.rawValue] as! Int!
        }
        set {
            self[ParseObjectColumns.LikeCount.rawValue] = newValue
        }
    }
    
    var userId : String {
        get {
            return self[ParseObjectColumns.UserId.rawValue] as! String!
        }
        set {
            self[ParseObjectColumns.UserId.rawValue] = newValue
        }
    }
}
