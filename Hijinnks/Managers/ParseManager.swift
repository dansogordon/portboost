//
//  ParseManager.swift
//  Hijinnks
//
//  Created by adeiji on 2/24/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import Parse

class ParseManager {
    // Save the Parse Object in the background
    class func save (parseObject: PFObject) {
        parseObject.saveInBackground { (success, error) in
            if success {
                NSLog("Parse Object With ID - " + parseObject.objectId! + "Saved Successfully")
            } else {
                NSLog(error.debugDescription)
            }
        }
    }
    
    // Get all the invitations that are near a specific location
    class func getAllInvitationsNearLocation () -> [InvitationParseObject]! {
        let interestsQuery = InvitationParseObject.query()
        let invitedQuery = InvitationParseObject.query()
        let fromSelfQuery = InvitationParseObject.query()
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: today)
        
        if PFUser.current() != nil {
            fromSelfQuery?.whereKey(ParseObjectColumns.FromUser.rawValue, equalTo: PFUser.current()!)
        }
        
        if PFUser.current() != nil && PFUser.current()?.object(forKey: ParseObjectColumns.Interests.rawValue) != nil {
//  - - - - if you share the same interests...
            interestsQuery?.whereKey(ParseObjectColumns.Interests.rawValue, containedIn: DEUserManager.sharedManager.getInterests(user: PFUser.current()!))
// |
            // If this invitation was sent specifically to you
            invitedQuery?.whereKey(ParseObjectColumns.Invitees.rawValue, equalTo: PFUser.current()!)
// |
        }
// |
//  - -> ... and it's a public invitation
//        interestsQuery?.whereKey(ParseObjectColumns.IsPublic.rawValue, equalTo: true)
        
        // If you were invited personally
        // If you share the same interests and the invite is public
        let query = PFQuery.orQuery(withSubqueries: [interestsQuery!, invitedQuery!, fromSelfQuery!])
        query.addDescendingOrder(ParseObjectColumns.StartingTime.rawValue)  // Display the invitations by most recent
        query.whereKey(ParseObjectColumns.StartingTime.rawValue, greaterThan: tomorrow!)
        
        do {
            let invitations = try query.findObjects()
            return invitations as! [InvitationParseObject]
        }
        catch {
            print("Error from Parse - \(error.localizedDescription)")
        }
        
        return nil
    }
}
