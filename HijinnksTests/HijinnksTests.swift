//
//  HijinnksTests.swift
//  HijinnksTests
//
//  Created by adeiji on 2/19/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import XCTest
import Parse
@testable import Hijinnks

class HijinnksTests: XCTestCase {
    
    var quickInviteView:QuickInviteView!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // When the user presses public on the Quick Invite screen than isPublic must be true
    func testQuickInvitePublicButtonPressed () {
        let createInvitationViewController = CreateInvitationViewController()
        createInvitationViewController.invitation.isPublic = false
        createInvitationViewController.publicButtonPressed()
        XCTAssertTrue(createInvitationViewController.invitation.isPublic)
        XCTAssertFalse(createInvitationViewController.isAllFriends)
        
        createInvitationViewController.invitation.isPublic = true
        createInvitationViewController.publicButtonPressed()
        XCTAssertFalse(createInvitationViewController.invitation.isPublic)
    }
    
    // When the user presses All Friends on the Quick Invite page than isPublic must be false
    func testQuickInviteAllFriendsButtonPressed () {
        let createInvitationViewController = CreateInvitationViewController()
        createInvitationViewController.invitation.isPublic = false
        createInvitationViewController.isAllFriends = false
        createInvitationViewController.allFriendsButtonPressed()
        XCTAssertFalse(createInvitationViewController.invitation.isPublic)
        XCTAssertTrue(createInvitationViewController.isAllFriends)
        
        createInvitationViewController.isAllFriends = true
        createInvitationViewController.allFriendsButtonPressed()
        XCTAssertFalse(createInvitationViewController.isAllFriends)
    }
    
}
