//
//  CommentParseObject.swift
//  Hijinnks
//
//  Created by adeiji on 3/26/17.
//  Copyright © 2017 adeiji. All rights reserved.
//
import Parse

import Foundation

class CommentParseObject : PFObject, PFSubclassing {
    
    class func parseClassName () -> String {
        return ParseCustomObjectsClassNames.Comment.rawValue
    }
    
    /**
     * - Description The actual comment message
     */
    var comment : String! {
        get {
            return self[ParseObjectColumns.Comment.rawValue] as! String
        }
        set {
            self[ParseObjectColumns.Comment.rawValue] = newValue
        }
    }
    /**
     * The user who sent the comment message
     */
    var user : PFUser! {
        get {
            return self[ParseObjectColumns.User.rawValue] as! PFUser
        }
        set {
            return self[ParseObjectColumns.User.rawValue] = newValue
        }
    }
    
}
