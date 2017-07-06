//
//  Invitation.swift
//  Hijinnks
//
//  Created by adeiji on 2/24/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

class Invitation : NSObject {

    var eventName:String
    var location:CLLocation
    var address:String!
    var message:String!
    var startingTime:Date
    var duration:String!
    var invitees:Array<PFUser>!
    var interests:Array<String>!
    var fromUser:PFUser
    var dateInvited:Date
    var rsvpCount:Int!
    var invitationParseObject:InvitationParseObject!
    var rsvpUsers:Array<String>!
    var comments:Array<CommentParseObject>!
    
    init(eventName: String, location: CLLocation, address: String!, message: String!, startingTime: Date, duration: String!, invitees: Array<PFUser>!, interests: Array<String>!, fromUser: PFUser, dateInvited: Date, rsvpCount: Int!, rsvpUsers: Array<String>!, comments: Array<CommentParseObject>!, invitationParseObject: InvitationParseObject!) {
        self.eventName = eventName
        self.location = location
        self.address = address
        self.message = message
        self.startingTime = startingTime
        self.duration = duration
        self.invitees = invitees
        self.interests = interests
        self.fromUser = fromUser
        self.dateInvited = dateInvited
        if rsvpCount != nil {
            self.rsvpCount = rsvpCount
        } else {
            self.rsvpCount = 0
        }
        self.rsvpUsers = rsvpUsers
        super.init()
        self.comments = comments
        self.setParseObject(parseObject: invitationParseObject)
    }
    
    func setComments (comments: Array<CommentParseObject>) {
        self.comments = comments
        self.invitationParseObject.comments = comments
    }
    
    func incrementRsvpCount (user: PFUser) {
        self.rsvpCount = self.rsvpCount + 1
        invitationParseObject.rsvpCount = self.rsvpCount
        invitationParseObject.rsvpUsers.append(user.objectId!)
    }
    func decrementRsvpCount (user: PFUser) {
        self.rsvpCount = self.rsvpCount - 1
        invitationParseObject.rsvpCount = self.rsvpCount
        invitationParseObject.rsvpUsers = invitationParseObject.rsvpUsers.filter {
            $0 != user.objectId
        }
    }
    
    /**
     * - Description Create a Parse Object from the current NSObject. We do this so that we can manipulate both the NSObject and the Parse Object seperately.  There are specific fields that we don't want to manipulate in the Parse Object and therefore we keep these two objects seperated so that manipulations can be made to each object seperately
     */
    func setParseObject (parseObject: InvitationParseObject!) {
        if (parseObject == nil) {
            let invitationParseObject = InvitationParseObject()
            invitationParseObject.eventName = self.eventName
            invitationParseObject.location = PFGeoPoint(location: self.location)
            invitationParseObject.address = self.address
            invitationParseObject.message = self.message
            invitationParseObject.startingTime = self.startingTime
            invitationParseObject.dateInvited = self.dateInvited
            invitationParseObject.duration = self.duration
            
            if self.invitees == nil {
                invitationParseObject.invitees = [PFUser]()
            } else {
                invitationParseObject.invitees = self.invitees
            }
            
            if self.comments == nil {
                invitationParseObject.comments = Array<CommentParseObject>()
            } else {
                invitationParseObject.comments = self.comments
            }
            
            invitationParseObject.interests = self.interests
            invitationParseObject.fromUser = self.fromUser
            invitationParseObject.rsvpCount = self.rsvpCount
            invitationParseObject.rsvpUsers = self.rsvpUsers
            
            self.invitationParseObject = invitationParseObject
        } else {
            self.invitationParseObject = parseObject
        }
    }
    
    func getParseObject () -> InvitationParseObject {
        return self.invitationParseObject
    }
}
