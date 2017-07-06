//
//  QuickInviteView.swift
//  Hijinnks
//
//  Created by adeiji on 4/16/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import Parse

class QuickInviteView : UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var cancelButton:HijinnksButton!
    weak var headerLabel:UILabel!
    weak var timeView:UIView!
    weak var timeIcon:CustomHijinnksView!
    weak var timeTextField:UITextField!
    weak var nowLabel:UILabel!
    weak var nowSwitch:UISwitch!
    weak var locationView:UIView!
    weak var locationIcon:CustomHijinnksView!
    weak var locationTextField:UITextField!
    weak var currentLocationLabel:UILabel!
    weak var currentLocationSwitch:UISwitch!
    weak var publicButton:UIButton!
    weak var allFriendsButton:UIButton!
    weak var invitedTableView:UITableView!
    weak var sendButton:UIButton!
    weak var orLabel:UILabel!
    weak var addDetailsButton:UIButton!
    weak var invitedTableViewGrayOverlay:UIView!
    
    let friends = DEUserManager.sharedManager.friends
    
    let ICONS_HORIZONTAL_SPACING_TO_SUPERVIEW = 10
    let OUTERVIEWS_HORIZONTAL_SPACING_TO_SUPERVIEW = 10
    let OUTERVIEWS_HEIGHT = 52
    let TEXTFIELDS_HORIZONTAL_SPACING_SIBLING = 10
    let SWITCH_OFFSET_TO_CENTER = 5
    let SWITCH_LABEL_OFFSET_TO_CENTER = 17
    let SWITCH_HORIZONTAL_SPACING_TO_SUPERVIEW = -20
    let ICONS_DIMENSIONS = 25
    let BUTTON_WIDTH = 110
    let BUTTON_HEIGHT = 30
    let BUTTON_CORNER_RADIUS = 4
    let BUTTON_OFFSET_TO_CENTER = 65
    let HIJINNKS_USER = "- Hijinnks User"
    
    let kPhoneContactSection = 1
    let kUsersSection = 0
    
    let buttonFont = UIFont.systemFont(ofSize: 14)
    
    var contacts = ContactsController.getContacts()
    
    
    func setupUI () {        
        self.backgroundColor = .white
        self.layer.borderColor = Colors.CommentButtonBlue.value.cgColor
        self.layer.borderWidth = 2.0
        self.setHeaderElements()
        self.setTimeViewElements()
        self.setLocationElements()
        self.setFinishingElements()
        self.setInviteesElements()
    }
    
    func setFinishingElements() {
        self.sendButton = self.setSendButton()
        self.orLabel = self.setOrLabel()
        self.addDetailsButton = self.setAddDetailsButton()
    }
    
    func setSendButton () -> UIButton {
        let sendButton = UIButton()
        self.addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-BUTTON_OFFSET_TO_CENTER)
            make.bottom.equalTo(self).offset(-15)
            make.width.equalTo(BUTTON_WIDTH)
            make.height.equalTo(BUTTON_HEIGHT)
        }
        sendButton.layer.cornerRadius = CGFloat(BUTTON_CORNER_RADIUS)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = Colors.CommentButtonBlue.value
        sendButton.titleLabel?.font = buttonFont
        
        return sendButton
    }
    
    func setOrLabel () -> UILabel {
        let orLabel = UILabel()
        orLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.addSubview(orLabel)
        orLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.sendButton)
        }
        
        orLabel.text = "or"
        return orLabel
    }
    
    func setAddDetailsButton () -> UIButton {
        let addDetailsButton = UIButton()
        self.addSubview(addDetailsButton)
        addDetailsButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(BUTTON_OFFSET_TO_CENTER)
            make.centerY.equalTo(self.sendButton)
            make.width.equalTo(BUTTON_WIDTH)
            make.height.equalTo(BUTTON_HEIGHT)
        }
        addDetailsButton.layer.cornerRadius = CGFloat(BUTTON_CORNER_RADIUS)
        addDetailsButton.setTitle("Add Details", for: .normal)
        addDetailsButton.backgroundColor = Colors.CommentButtonBlue.value
        addDetailsButton.titleLabel?.font = buttonFont
        return addDetailsButton
    }
    
    func setHeaderElements () {
        self.cancelButton = self.setCancelButton()
        self.headerLabel = self.setHeaderLabel()
    }
    
    func setTimeViewElements () {
        self.timeView = self.setTimeView()
        self.timeIcon = self.setTimeIcon()
        self.nowSwitch = self.setNowSwitch()
        self.nowLabel = self.setNowLabel()
        self.timeTextField = self.setTimeTextField()
    }
    
    // Cancel button on the upper left hand side of the view
    func setCancelButton () -> HijinnksButton {
        let cancelButton = HijinnksButton(customButtonType: .Cancel)
        cancelButton.setNeedsLayout()
        self.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.top.equalTo(self).offset(20)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        return cancelButton
    }
    
    // Label that goes top at the top of the screen
    func setHeaderLabel () -> UILabel {
        let headerLabel = UILabel()
        self.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.cancelButton)
        }
        
        headerLabel.text = "Quick Invite"
        headerLabel.textColor = Colors.TextGrayColor.value
        headerLabel.font = UIFont.systemFont(ofSize: 18.0)
        headerLabel.textAlignment = .center
        return headerLabel
    }
    
    // View that goes outside of the Location Text Field
    func setTimeView () -> UIView {
        let timeView = UIView()
        self.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(OUTERVIEWS_HORIZONTAL_SPACING_TO_SUPERVIEW)
            make.right.equalTo(self).offset(-OUTERVIEWS_HORIZONTAL_SPACING_TO_SUPERVIEW)
            make.height.equalTo(OUTERVIEWS_HEIGHT)
        }
        
        timeView.layer.borderWidth = 0.30
        timeView.layer.borderColor = UIColor.black.cgColor
        
        return timeView
    }
    
    // The icon that appears to the left of the Location Text Field but within the outer location view
    func setTimeIcon () -> CustomHijinnksView {
        let timeIcon = CustomHijinnksView(customViewType: .Clock)
        timeIcon.clearsContextBeforeDrawing = true
        timeIcon.backgroundColor = .white
        self.timeView.addSubview(timeIcon)
        timeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.timeView).offset(ICONS_HORIZONTAL_SPACING_TO_SUPERVIEW)
            make.height.equalTo(ICONS_DIMENSIONS)
            make.width.equalTo(ICONS_DIMENSIONS)
            make.centerY.equalTo(self.timeView)
        }
        
        return timeIcon
    }
    
    // The label that appears to the left of the time icon
    func setTimeTextField () -> UITextField {
        let timeTextField = UITextField()
        timeTextField.font = UIFont.systemFont(ofSize: 14)
        self.timeView.addSubview(timeTextField)
        timeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.timeIcon.snp.right).offset(TEXTFIELDS_HORIZONTAL_SPACING_SIBLING)
            make.centerY.equalTo(self.timeView)
            make.right.equalTo(self.nowSwitch.snp.left).offset(-TEXTFIELDS_HORIZONTAL_SPACING_SIBLING)
        }
        
        timeTextField.attributedPlaceholder = NSAttributedString(string: "Time", attributes: [NSForegroundColorAttributeName : UIColor.black])        
        return timeTextField
    }
    
    
    // The switch that appears on the right of the location view
    func setNowSwitch () -> UISwitch {
        let nowSwitch = UISwitch()
        self.timeView.addSubview(nowSwitch)
        nowSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.centerY.equalTo(self.timeView).offset(5)
        }
        
        return nowSwitch
    }
    
    // The label that appears above the switch in the location view.
    func setNowLabel () -> UILabel {
        let nowLabel = UILabel()
        self.timeView.addSubview(nowLabel)
        nowLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.nowSwitch)
            make.centerY.equalTo(self.timeView).offset(-SWITCH_LABEL_OFFSET_TO_CENTER)
        }
        nowLabel.text = "Now"
        nowLabel.textAlignment = .center
        nowLabel.font = UIFont.systemFont(ofSize: 12.0)
        return nowLabel
    }
}

// Location View Elements
extension QuickInviteView {
    
    func setLocationElements() {
        
        self.locationView = self.setLocationView()
        self.locationIcon = self.setLocationIcon()
        self.currentLocationSwitch = self.setCurrentLocationSwitch()
        self.currentLocationLabel = self.setCurrentLocationLabel()
        self.locationTextField = self.setLocationTextField()
    }
    
    // Location View holds the other UI elements necessary for gathering location information from the user
    func setLocationView () -> UIView {
        let locationView = UIView()
        self.addSubview(locationView)
        locationView.snp.makeConstraints { (make) in
            make.left.equalTo(self.timeView)
            make.top.equalTo(self.timeView.snp.bottom).offset(10)
            make.right.equalTo(self.timeView)
            make.height.equalTo(self.timeView)
        }
        
        locationView.layer.borderWidth = 0.30
        locationView.layer.borderColor = UIColor.black.cgColor
        return locationView
    }
    // Icon to the far left of the location view which is simply a map pin
    func setLocationIcon () -> CustomHijinnksView {
        let locationIcon = CustomHijinnksView(customViewType: .Map)
        locationIcon.backgroundColor = .white
        self.locationView.addSubview(locationIcon)
        locationIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.timeIcon)
            make.centerY.equalTo(self.locationView)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        
        return locationIcon
    }
    
    func setLocationTextField () -> UITextField {
        let locationTextField = UITextField()
        self.locationView.addSubview(locationTextField)
        locationTextField.font = UIFont.systemFont(ofSize: 14)
        locationTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.locationIcon.snp.right).offset(10)
            make.centerY.equalTo(self.locationView)
            make.right.equalTo(self.currentLocationLabel.snp.left).offset(-20)
        }
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Location", attributes: [NSForegroundColorAttributeName : UIColor.black])
        return locationTextField
    }
    // The switch the allows the user to use the current location.  To the right of the location view
    func setCurrentLocationSwitch () -> UISwitch {
        let currentLocationSwitch = UISwitch()
        self.locationView.addSubview(currentLocationSwitch)
        currentLocationSwitch.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.nowSwitch)
            make.centerY.equalTo(self.locationView).offset(5)
        }
        
        return currentLocationSwitch
    }
    // The label that says 'Current Location' above the current location switch
    func setCurrentLocationLabel () -> UILabel {
        let currentLocationLabel = UILabel()
        self.locationView.addSubview(currentLocationLabel)
        currentLocationLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.currentLocationSwitch)
            make.centerY.equalTo(self.locationView).offset(-SWITCH_LABEL_OFFSET_TO_CENTER)
        }
        
        currentLocationLabel.text = "Current Location"
        currentLocationLabel.font = UIFont.systemFont(ofSize: 12.0)
        return currentLocationLabel
    }
}

// Invited View Elements
extension QuickInviteView {
    // Elements involved in setting who is invited.  ie - All Friends Button, Public Button, Invited Table View
    func setInviteesElements () {
        self.allFriendsButton = self.setAllFriendsButton()
        self.publicButton = self.setPublicButton()
        self.invitedTableView = self.setTableView()
        self.invitedTableViewGrayOverlay = self.setTableViewGrayOverlay()
    }
    
    func setAllFriendsButton () -> UIButton {
        let allFriendsButton = UIButton()
        self.addSubview(allFriendsButton)
        allFriendsButton.backgroundColor = Colors.CommentButtonBlue.value
        allFriendsButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.locationView.snp.bottom).offset(20)
            make.centerX.equalTo(self).offset(BUTTON_OFFSET_TO_CENTER)
            make.width.equalTo(BUTTON_WIDTH)
            make.height.equalTo(BUTTON_HEIGHT)
        }
        allFriendsButton.setTitle("All Friends", for: .normal)
        allFriendsButton.layer.cornerRadius = CGFloat(BUTTON_CORNER_RADIUS)
        allFriendsButton.titleLabel?.font = buttonFont
        return allFriendsButton
    }
    
    func setPublicButton () -> UIButton {
        let publicButton = UIButton()
        publicButton.backgroundColor = Colors.CommentButtonBlue.value
        self.addSubview(publicButton)
        publicButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-BUTTON_OFFSET_TO_CENTER)
            make.width.equalTo(BUTTON_WIDTH)
            make.height.equalTo(BUTTON_HEIGHT)
            make.centerY.equalTo(self.allFriendsButton)
        }
        publicButton.setTitle("Public", for: .normal)
        publicButton.layer.cornerRadius = CGFloat(BUTTON_CORNER_RADIUS)
        publicButton.titleLabel?.font = buttonFont
        
        return publicButton
    }
    
    func setTableView () -> UITableView {
        let tableView = UITableView()
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self.sendButton.snp.top).offset(-10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self.publicButton.snp.bottom).offset(10)
        }
        
        tableView.allowsSelectionDuringEditing = true
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        
        return tableView
    }
    
    func setTableViewGrayOverlay () -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.15
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.invitedTableView)
        }
        view.isHidden = true
        return view
    }
}

// Table View Data Source
extension QuickInviteView {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == kPhoneContactSection {
            return self.contacts.count
        }
        else {
            if self.friends != nil {
                return self.friends!.count
            }
            
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == kPhoneContactSection {
            return "Phone Contacts"
        } else {
            return "Friends"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == kPhoneContactSection {
            let contactTableViewCell = ContactTableViewCell(contact: contacts[indexPath.row])
            return contactTableViewCell
        }
        else {
            let userTableViewCell = UserCell(user: self.friends![indexPath.row])
            userTableViewCell.setupUI()
            return userTableViewCell
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timeTextField.resignFirstResponder()
        self.locationTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class ContactTableViewCell : UITableViewCell {
    
    var profileImageView:UIImageView!
    var nameAndUserStatusLabel:UILabel!
    var telephoneNumberLabel:UILabel!
    let contact:CNContact
    
    init(contact: CNContact) {
        self.contact = contact
        super.init(style: .default, reuseIdentifier: nil)
        self.setupUI()
    }
    
    func setupUI () {
        self.profileImageView  = self.setProfileImageView()
        self.telephoneNumberLabel = self.setTelephoneNumberLabel()
        self.nameAndUserStatusLabel = self.setNameAndUserStatusLabel()
    }
    
    /**
     * - Description The Image View on the left hand side of the table view which will display the user's profile image
     * - Returns UIImageView - the UIImageView object
     */
    func setProfileImageView () -> UIImageView {
        let profileImageView = UIImageView()
        self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(profileImageView.snp.width)
            make.centerY.equalTo(self.contentView)
        }
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        // Check to see if this contact has a profile image
        if self.contact.imageDataAvailable {
//            profileImageView.image = UIImage(data: self.contact.thumbnailImageData!)
        }
        else {
            
            var tempProfileImageLabel:UILabel!
                        
            if self.contact.givenName != "" {
                tempProfileImageLabel = DEUserManager.sharedManager.getTempProfileImageLabel(name: self.contact.givenName, fontSize: 12)
            } else if self.contact.familyName != "" {
                tempProfileImageLabel = DEUserManager.sharedManager.getTempProfileImageLabel(name: self.contact.familyName, fontSize: 12)
            } else if self.contact.middleName != "" {
                tempProfileImageLabel = DEUserManager.sharedManager.getTempProfileImageLabel(name: self.contact.middleName, fontSize: 12)
            } else if self.contact.organizationName != "" {
                tempProfileImageLabel = DEUserManager.sharedManager.getTempProfileImageLabel(name: self.contact.organizationName, fontSize: 12)
            } else if self.contact.departmentName != "" {
                tempProfileImageLabel = DEUserManager.sharedManager.getTempProfileImageLabel(name: self.contact.departmentName, fontSize: 12)
            }
            
            if tempProfileImageLabel != nil {
                self.contentView.addSubview(tempProfileImageLabel)
                tempProfileImageLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(self.contentView).offset(10)
                    make.width.equalTo(40)
                    make.height.equalTo(tempProfileImageLabel.snp.width)
                    make.centerY.equalTo(self.contentView)
                }
                tempProfileImageLabel.layer.cornerRadius = 20
                tempProfileImageLabel.clipsToBounds = true
            }
        }
        return profileImageView
    }
    
    /**
     * - Description The UILabel that is on the right hand side of the tableViewCell which contains the phone number of the contact
     * - Returns UILabel = the UILabel object
     */
    func setTelephoneNumberLabel () -> UILabel {
        let telephoneNumberLabel = UILabel()
        self.contentView.addSubview(telephoneNumberLabel)
        telephoneNumberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(180)
        }
        
        if contact.phoneNumbers.count != 0 {
            telephoneNumberLabel.text = contact.phoneNumbers[0].value.stringValue
        }
        
        telephoneNumberLabel.textAlignment = .right
        return telephoneNumberLabel
    }
    
    /**
     * - Description The UILabel next to the profileImageView which contains the name of the user and their status ex. John McDermit - Hijinnks User. self.profileImageView must be set first, as the UILabel will rely on that object for it's left position.  self.telephoneNumberLabel must also be set as the UILabel will rely on that object for it's right position
     * - Returns UILabel - The UILabel object
     */
    func setNameAndUserStatusLabel() -> UILabel {
        let nameUserStatusLabel = UILabel()
        self.contentView.addSubview(nameUserStatusLabel)
        nameUserStatusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageView.snp.right).offset(10)
            make.right.equalTo(self.telephoneNumberLabel.snp.left).offset(-10)
            make.centerY.equalTo(self.contentView)
        }
        nameUserStatusLabel.text = "\(contact.givenName) \(contact.familyName) "
        return nameUserStatusLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
