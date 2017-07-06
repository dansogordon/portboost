//
//  QuickInviteController.swift
//  Hijinnks
//
//  Created by adeiji on 4/23/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import Parse
import GooglePlaces
import Contacts
import MessageUI

extension CreateInvitationViewController : MFMessageComposeViewControllerDelegate {
    
    func showQuickInviteView () {
        
        self.quickInviteView = QuickInviteView()
        self.sendButton.isHidden = true
        let outerView = UIView()
        outerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        self.view.addSubview(outerView)
        outerView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        
        outerView.addSubview(self.quickInviteView)
        self.quickInviteView.snp.makeConstraints { (make) in
            make.left.equalTo(outerView).offset(25)
            make.right.equalTo(outerView).offset(-25)
            make.centerY.equalTo(outerView).offset(-20)
            make.height.equalTo(450)
        }
        
        self.quickInviteView.setupUI()
        self.quickInviteView.publicButton.addTarget(self, action: #selector(publicButtonPressed), for: .touchUpInside)
        self.quickInviteView.publicButton.addTarget(self, action: #selector(updateInvitationViewScopeButtonLayouts), for: .touchUpInside)
        self.quickInviteView.allFriendsButton.addTarget(self, action: #selector(allFriendsButtonPressed), for: .touchUpInside)
        self.quickInviteView.allFriendsButton.addTarget(self, action: #selector(updateInvitationViewScopeButtonLayouts), for: .touchUpInside)
        self.quickInviteView.locationTextField.delegate = self
        self.quickInviteView.currentLocationSwitch.addTarget(self, action: #selector(locationSwitchPressed(sender:)), for: .valueChanged)
        self.quickInviteView.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        self.quickInviteView.nowSwitch.addTarget(self, action: #selector(nowSwitchChanged(sender:)), for: .valueChanged)
        self.quickInviteView.addDetailsButton.addTarget(self, action: #selector(addDetailsButtonPressed), for: .touchUpInside)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        let date = NSDate.init() // gets me the current date and time
        datePicker.minimumDate = date as Date // make sure the minimum time they can choose is the current time
        datePicker.minuteInterval = 10
        self.quickInviteView.timeTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(startTimePickerDateChanged(sender:)), for: .valueChanged)        
    }
    
    /**
     * - Description When the Add Details button is pressed then this view will be removed from the screen and the Create Invitation Screen will then be seen
     */
    func addDetailsButtonPressed () {        
        self.quickInviteView.superview?.isHidden = true
        self.sendButton.isHidden = false
        self.quickMode = false
        self.locationTextField.text = self.quickInviteView.locationTextField.text
        self.startingTimeTextField.text = self.quickInviteView.timeTextField.text
        // Set the invited textField to show the selected individuals
        self.inviteesTextField.text = getListOfInvitedUsers()
    }
    
    /**
     * - Description Gets a string representation of who is invited to for this invitation
     * - Returns String - The string representation of who is invited
     */
    func getListOfInvitedUsers () -> String! {
        let indexPaths = self.quickInviteView.invitedTableView.indexPathsForSelectedRows
        var names:String! = ""
        
        if self.isPublic {
            return PUBLIC_STRING
        }
        else if self.isAllFriends {
            return ALL_FRIENDS_STRING
        }
        else if indexPaths != nil {
            for indexPath in indexPaths! {
                let contact = self.quickInviteView.contacts[indexPath.row]
                names = names + "\(contact.givenName) \(contact.familyName) "
            }
        }
        
        return names
    }
    
    func nowSwitchChanged (sender: UISwitch) {
    
        if sender.isOn {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let startDateAndTime = dateFormatter.string(from: Date())
            self.startingTime = Date()
            self.quickInviteView.timeTextField.text = startDateAndTime
        }
        else {
            self.quickInviteView.timeTextField.text = ""
            self.startingTime = nil
        }
    }
    
    /**
     * - Description - When the public button is pressed, sets the invitations view scope to public
     */
    func publicButtonPressed () {
        if self.isPublic == false {
            self.invitation.isPublic = true
            self.isPublic = true
            self.isAllFriends = false
            self.selectedFriends = NSArray()
        }
        else {
            self.invitation.isPublic = false
            self.isPublic = false
        }
    }
    
    /**
     * - Description When the user presses the All Friends button.  Handles if the user has or does not have friends
     */
    func allFriendsButtonPressed () {
        // Get all the user's friends' object ids
        let friends = DEUserManager.sharedManager.friends
        if friends != nil {
            self.invitation.invitees = friends!
            self.selectedFriends = friends as NSArray!
            if self.isAllFriends == false {
                self.invitation.isPublic = false
                self.isPublic = false
                self.isAllFriends = true
            }
            else {
                self.isAllFriends = false
            }
        } else {
            
            let alertController = UIAlertController(title: "Friends?", message: "Sorry, it seems you don't have any friends within the app yet.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.quickInviteView.superview?.isHidden = false
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func updateInvitationViewScopeButtonLayouts () {
        if self.isPublic {
            self.quickInviteView.publicButton.backgroundColor = .white
            self.quickInviteView.publicButton.layer.borderColor = Colors.blue.value.cgColor
            self.quickInviteView.publicButton.layer.borderWidth = 2
            self.quickInviteView.publicButton.setTitleColor(Colors.blue.value, for: .normal)
        }
        else {
            self.quickInviteView.publicButton.layer.borderWidth = 0
            self.quickInviteView.publicButton.backgroundColor = Colors.blue.value
            self.quickInviteView.publicButton.setTitleColor(.white, for: .normal)
        }
        
        if self.isAllFriends {
            self.quickInviteView.allFriendsButton.backgroundColor = .white
            self.quickInviteView.allFriendsButton.layer.borderColor = Colors.blue.value.cgColor
            self.quickInviteView.allFriendsButton.layer.borderWidth = 2
            self.quickInviteView.allFriendsButton.setTitleColor(Colors.blue.value, for: .normal)
        }
        else {
            self.quickInviteView.allFriendsButton.layer.borderWidth = 0
            self.quickInviteView.allFriendsButton.backgroundColor = Colors.blue.value
            self.quickInviteView.allFriendsButton.setTitleColor(.white, for: .normal)
        }
        
        if !self.isPublic && !self.isAllFriends {
            // Set the table view to allow interactions
            self.updateTableViewEnabledStatus(enabled: true)
        }
        else {
            // Set the table view to not allow interactions
            self.updateTableViewEnabledStatus(enabled: false)
        }
    }
    
    func updateTableViewEnabledStatus (enabled: Bool) {
        if enabled {
            // Enable the invited table view and remove the gray overlay
            self.quickInviteView.invitedTableViewGrayOverlay.isHidden = true
            self.quickInviteView.invitedTableView.isUserInteractionEnabled = true
        }
        else {
            // Disable the invited table view and add the gray overlay
            self.quickInviteView.invitedTableViewGrayOverlay.isHidden = false
            self.quickInviteView.invitedTableView.isUserInteractionEnabled = false
        }
    }
    
    func sendButtonPressed () {
        if self.quickInviteView.timeTextField.text == "" || self.locationTextField.text != ""
        {
            let alertController = UIAlertController(title: "Invitation", message: "Please enter data into all fields", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if (self.isPublic == false && self.isAllFriends == false && self.quickInviteView.invitedTableView.indexPathsForSelectedRows == nil)
        {
            let alertController = UIAlertController(title: "Invitation", message: "Please make sure you invite someone. Or select 'Public' or 'All Friends'", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.quickInviteView.superview?.isHidden = true
            let contacts = self.getInvitedContacts()
            
            if contacts.count != 0 {
                self.sendInviteToContacts(contacts: contacts, time: self.quickInviteView.timeTextField.text!)
            }
            if self.selectedFriends.count != 0 {
                self.createInvitationAndSend(location: self.location, invitees: self.selectedFriends as! Array<PFUser>)
                if contacts.count == 0 {
                    self.promptPostToFacebook()
                }
            } else if self.isPublic {
                self.createInvitationAndSend(location: self.location, invitees: self.selectedFriends as! Array<PFUser>)
            }
            // TODO: Put this into a method of its own
            self.quickMode = true
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
            self.sendInviteToContacts(contacts: self.selectedContacts, time: self.startingTimeTextField.text!)
            self.reset()
            
        }
    }
    
    func getInvitedContacts () -> [CNContact] {
        var contacts = [CNContact]()
        let indexPaths = self.quickInviteView.invitedTableView.indexPathsForSelectedRows
        var selectedFriends = [PFUser]()
        if indexPaths != nil {
            for indexPath in indexPaths! {
                if indexPath.section == self.quickInviteView.kPhoneContactSection {
                    let contact = self.quickInviteView.contacts[indexPath.row]
                    contacts.append(contact)
                } else {
                    selectedFriends.append((self.quickInviteView.friends?[indexPath.row])! )
                }
            }
        }
        
        self.selectedFriends = selectedFriends as NSArray!
        return contacts
    }
    
    /**
     * - Description Send an invitation in the form of a text message to all the contacts you invited that are not users of the app
     * - Code
     ````
        self.sendInviteToContacts()
     ````
     */
    func sendInviteToContacts (contacts: [CNContact]!, time: String) {
        if contacts != nil {
            var phoneNumbers:[String] = [String]()
            
            for contact in contacts {
                if contact.phoneNumbers.count != 0 {
                    phoneNumbers.append(contact.phoneNumbers[0].value.stringValue)
                }
            }
            
            // Check to make sure this device can send text messages
            if !MFMessageComposeViewController.canSendText() {
                print("SMS services are not available")
            }
            else {
                let composeMessageViewController = MFMessageComposeViewController()
                composeMessageViewController.messageComposeDelegate = self
                composeMessageViewController.recipients = phoneNumbers
                composeMessageViewController.body = "You are invited to \(self.quickInviteView.locationTextField.text!) @ \(time)\n\nRespond 1 to reply YES\nRespond 0 to reply NO\nSent from Hijinnks App"
                composeMessageViewController.navigationBar.isHidden = true
                
                self.navigationController?.present(composeMessageViewController, animated: true, completion: nil)
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if result == .sent {
            self.saveAndSendInvitation(currentLocation: self.location)
            self.quickInviteView.superview?.removeFromSuperview()
        } else {
            if self.quickInviteView != nil {
                self.quickInviteView.superview?.isHidden = false
            }
        }
                
        self.dismiss(animated: true, completion: nil)
        self.promptPostToFacebook()
    }
}
