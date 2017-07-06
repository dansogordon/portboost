//
//  DEUserManager+PFUser.swift
//  Hijinnks
//
//  Created by adeiji on 4/2/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import Parse

typealias parseDataReceieved = (PFObject!) -> ()

extension DEUserManager {
    
    /**
     * - Description Get a list of all the friends user objects
     * - Parameter The user of which to get the friends from
     * - Returns [String] - The list of friends' object ids
     ```
        DEUserManager.sharedManager.getFriends(self.user!)
     ```
     */
    func getFriends (user: PFUser) -> [String]! {
        return user.value(forKey: ParseObjectColumns.Friends.rawValue) as? [String]
    }
    
    /**
     * - Description Get the Interests of a user
     * - Parameter user - The user of which to get the interests from
     * - Returns [String] - The interests of the user
     ```
        DEUserManager.sharedManager.getBio(self.user!)
     ```
     */
    func getInterests (user: PFUser) -> [String]! {
        return user.value(forKey: ParseObjectColumns.Interests.rawValue) as? [String]
    }
    
    /**
     * - Description Get the bio for a user
     * - Parameter user PFUser - the user of which to get the interests from
     * - Returns User bio
     ```
        DEUserManager.sharedManager.getBio(self.user!)
     ```
     */
    func getBio (user: PFUser) -> String! {
        return user.value(forKey: ParseObjectColumns.UserBio.rawValue) as? String
    }
    
    /**
     * - Description Set the bio for the current user
     * - Parameter bio String - The bio that will be set
     ```
      q  DEUserManager.sharedManager.setBio("The bio for the user")
     ```
     */
    func setBio (bio: String) {
        if PFUser.current() != nil {
            PFUser.current()?.setValue(bio, forKey: ParseObjectColumns.UserBio.rawValue)
            PFUser.current()?.saveInBackground { (success, error) in
                if error != nil {
                    print("Error saving the user in the background - \(error?.localizedDescription)")
                }
            }
        }
    }
    
    /**
     * - Description Get a UserDetails object from the server for the user
     * - Parameter user: PFUser - The user in which to get the details for from the server
     * - Parameter success: @esscaping parseDataReceieved - The callback if the retrieval was successful
     ```
        getUserDetails (user: self.user, success {
            // Do stuff
        }
     ```
     */
    func getUserDetails (user: PFUser, success: @escaping parseDataReceieved) {
        
        // Get the user details from the server using the user's object id as a reference
        let query = UserDetailsParseObject.query()
        query?.whereKey(ParseObjectColumns.UserId.rawValue, equalTo: user.objectId!)
        query?.getFirstObjectInBackground(block: { (userDetailsObject, error) in
            if error == nil {
                success(userDetailsObject)
            }
        })
    }
}
