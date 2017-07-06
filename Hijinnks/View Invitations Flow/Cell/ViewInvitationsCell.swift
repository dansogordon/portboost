//
//  ViewInvitationsCell.swift
//  Hijinnks
//
//  Created by adeiji on 3/3/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Parse

class ViewInvitationsCell : UITableViewCell {
    
    
    // Profile Image and Event Name Section
    weak var profileImageAndEventNameView:UIView!
    weak var profileImageView:UIImageView!
    weak var eventNameLabel:UILabel!
    
    
    // Time Section
    weak var timeView:UIView!
    weak var timeIcon:CustomHijinnksView!
    weak var startTimeLabel:UILabel!
    
    
    // Location Section
    weak var locationView:UIView!
    weak var locationIcon:CustomHijinnksView!
    weak var locationLabel:UILabel!
    
    
    // Message Section
    weak var messageView:UIView!
    weak var messageIcon:CustomHijinnksView!
    weak var messageLabel:UILabel!
    
    
    // Footer Section
    weak var footerView:UIView!
    weak var mapButton:HijinnksButton!
    weak var likeButton:HijinnksButton!
    weak var rsvpButton:UIButton!
    weak var commentButton:UIButton!
    
    // Interests Section
    weak var interestView:UIView!
    weak var interestScrollView:UIView!
    
    // RSVP Section
    weak var rsvpView:UIView!
    weak var viewRsvpdButton:UIButton!
    
    weak var mapView:UIView!
    var invitation:InvitationParseObject
    var isMapShown:Bool = false
    
    // Constants
    let VIEW_BORDER_WIDTH = 0.50
    let VIEW_BORDER_COLOR = Colors.TextGrayColor.value.cgColor
    let VIEW_TOP_OFFSET = -0.5
    
    let delegate:PassDataBetweenViewControllersProtocol // View Controller Handling the View - View Invitations View Controller
    var imageTapGestureRecognizer:UITapGestureRecognizer! // Must keep a reference to this object otherwise the tap gesture recognizer will not work
    
    // User
    var userDetails:UserDetailsParseObject!
    
    let profileImageDimensions = CGFloat(40.0)
    
    // Methods
    required init(invitation: InvitationParseObject, delegate: PassDataBetweenViewControllersProtocol) {
        self.invitation = invitation
        self.delegate = delegate
        super.init(style: .default, reuseIdentifier: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI () {        
        self.contentView.autoresizingMask = .flexibleHeight
        self.autoresizingMask = .flexibleHeight
        // Set the very large sized content view so that the contentView will shrink.  There seems to be an iOS bug with it growing in size
        self.contentView.bounds = CGRect(x: 0, y: 0, width: 9999, height: 9999)
        self.selectionStyle = .none
        self.backgroundColor = .white
        _ = UIFont.systemFont(ofSize: 14)
        
        self.getUserDetails()
        self.profileImageAndEventNameView = self.setProfileImageAndEventNameView()
        self.timeView = self.setTimeView()
        self.locationView = self.setLocationView()
        self.messageView = self.addSection(sectionAbove: self.locationView, iconType: .Comment)
        self.interestView = self.setInterestsView()
        self.rsvpView = self.setRsvpView()
        self.addGestureTapToProfileImageView(imageView: self.profileImageView)
        self.footerView = setFooterView()
        var toUserText:String!
        let invitees:Array<PFUser>! = self.invitation.invitees
        
        if self.invitation.isPublic {
            toUserText = "Anyone"
        } else {
            var inviteesCount = 0
            if invitees != nil {
                inviteesCount = invitees.count
            }
            toUserText = "You and \(inviteesCount - 1) others"
        }
        
    }
    
    // Takes the array of interests and turns it into a string with the interests seperated by commas
    func getInterestsAsString () -> String {
        var interestString:String = String()
        for interest in invitation.interests {
            if interest != invitation.interests.last {
                interestString = interestString + "\(interest), "
            }
            else {
                interestString = interestString + "\(interest)"
            }
        }
        return interestString
    }
    
    func setInvitationDetailLabel (viewToLeft: UIView, text: String) -> UILabel {
        let myInvitationDetailLabel = UILabel()
        myInvitationDetailLabel.text = text
        myInvitationDetailLabel.font = UIFont.systemFont(ofSize: 14)
        myInvitationDetailLabel.textColor = Colors.invitationTextGrayColor.value
        myInvitationDetailLabel.numberOfLines = 0
        self.contentView.addSubview(myInvitationDetailLabel)
        myInvitationDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(viewToLeft.snp.right).offset(UIConstants.ProfileViewHorizontalSpacing.rawValue)
            make.top.equalTo(viewToLeft)
            make.right.equalTo(self.contentView).offset(-UIConstants.ProfileViewHorizontalSpacing.rawValue)
        }
        
        return myInvitationDetailLabel
    }
}

// Extension handling displaying the message for the invitation
extension ViewInvitationsCell {
    
    func addSection (sectionAbove: UIView!, iconType: HijinnksViewTypes) -> UIView {
        let view = UIView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageAndEventNameView)
            make.right.equalTo(self.profileImageAndEventNameView)
            
            if sectionAbove != nil
            {
                make.top.equalTo(sectionAbove.snp.bottom).offset(VIEW_TOP_OFFSET)
            }
            else {
                make.top.equalTo(self.contentView)
            }
        }
        view.layer.borderColor = VIEW_BORDER_COLOR
        view.layer.borderWidth = CGFloat(VIEW_BORDER_WIDTH)
        self.messageIcon = self.setIcon(superview: view, hijinnksViewType: iconType)
        self.messageLabel = self.setLabel(superview: view, message: self.invitation.message)
        return view
    }
    
    func setIcon (superview: UIView, hijinnksViewType: HijinnksViewTypes) -> CustomHijinnksView {
        let icon = CustomHijinnksView(customViewType: hijinnksViewType)
        superview.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.profileImageView)
            make.centerY.equalTo(superview)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        return icon
    }
    
    func setLabel (superview: UIView, message: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.text = message
        if message == "" {
            label.text = "No message for invitation"
        }
        superview.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(superview).offset(50)
            make.right.equalTo(superview).offset(-5)
            make.top.equalTo(superview).offset(20)
            make.bottom.equalTo(superview).offset(-20)
        }
        
        return label
    }
}

// Extension handling displaying the location
extension ViewInvitationsCell {
    func setLocationView () -> UIView {
        
        let view = UIView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageAndEventNameView)
            make.right.equalTo(self.profileImageAndEventNameView)
            make.top.equalTo(self.timeView.snp.bottom).offset(VIEW_TOP_OFFSET)
        }
        
        view.layer.borderWidth = CGFloat(VIEW_BORDER_WIDTH)
        view.layer.borderColor = VIEW_BORDER_COLOR
        self.locationIcon = self.setLocationIcon(superview: view)
        self.locationLabel = self.setLocationLabel(superview: view)
        return view
    }
    
    func setLocationIcon (superview: UIView) -> CustomHijinnksView {
        let mapIcon = CustomHijinnksView(customViewType: .Map)
        superview.addSubview(mapIcon)
        mapIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.profileImageView)
            make.centerY.equalTo(superview)
            make.width.equalTo(15)
            make.height.equalTo(20)
        }
        
        return mapIcon
    }
    
    func setLocationLabel (superview: UIView) -> UILabel {
        let locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 14.0)
        locationLabel.numberOfLines = 0
        superview.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.eventNameLabel)
            make.top.equalTo(superview).offset(20)
            make.bottom.equalTo(superview).offset(-20)
            make.right.equalTo(superview).offset(-10)
        }
        
        locationLabel.text = self.invitation.address
        return locationLabel
    }
}
// Extension which handles displaying and handling of the profile image and event name
extension ViewInvitationsCell {
    
    // Methods for Displaying Profile Image and Event Name Label
    
    func setProfileImageAndEventNameView () -> UIView {
        let view = UIView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.height.equalTo(53)
            make.top.equalTo(self.contentView).offset(10)
        }
        view.layer.borderWidth = CGFloat(VIEW_BORDER_WIDTH)
        view.layer.borderColor = VIEW_BORDER_COLOR
        self.profileImageView = self.setProfileImageView(superview: view)
        self.eventNameLabel = self.setEventNameLabel(font: UIFont.systemFont(ofSize: 14.0), superview: view)
        return view
    }
    // Display the data the user was invited
    func setEventNameLabel (font: UIFont, superview: UIView) -> UILabel {
        let label = UILabel()
        label.font = font
        label.text =  self.invitation.eventName
        
        if self.invitation.eventName == "" {
            label.text = "No Event Name"
        }
        
        label.textAlignment = .left
        superview.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageView.snp.right).offset(5)
            make.right.equalTo(superview).offset(-5)
            make.centerY.equalTo(superview)
        }
        
        return label
    }
    // Profile view which will display the profile image of the person who invited you on the top left of the table view cell
    func setProfileImageView (superview: UIView) -> UIImageView {
        let imageView = UIImageView()
        superview.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(superview).offset(5)
            make.centerY.equalTo(superview)
            make.width.equalTo(profileImageDimensions)
            make.height.equalTo(profileImageDimensions)
        }
        
        // make sure that we display the image in a circle
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = profileImageDimensions / 2
        self.loadProfileImage(imageView: imageView)
        return imageView
    }
    // When the profile image is pressed
    func profileImagePressed () {
        delegate.profileImagePressed!(user: self.invitation.fromUser)
    }
    // Get the image from the server and display it
    func loadProfileImage (imageView: UIImageView) {
        if invitation.fromUser.value(forKey: ParseObjectColumns.Profile_Picture.rawValue) != nil {
            let imageData = invitation.fromUser.value(forKey: ParseObjectColumns.Profile_Picture.rawValue) as! PFFile
            imageData.getDataInBackground { (data: Data?, error: Error?) in
                let image = UIImage(data: data!)
                if image != nil {
                    imageView.image = image
                }
            }
        }
    }
    func addGestureTapToProfileImageView (imageView: UIImageView) {
        self.imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImagePressed))
        self.imageTapGestureRecognizer.numberOfTapsRequired = 1
        self.imageTapGestureRecognizer.delegate = self
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(self.imageTapGestureRecognizer)
    }
    
}
//  Extension Which Handles Displaying the Starting Time
extension ViewInvitationsCell {
    
    func setTimeView () -> UIView {
        let view = UIView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageAndEventNameView)
            make.top.equalTo(self.profileImageAndEventNameView.snp.bottom).offset(VIEW_TOP_OFFSET)
            make.right.equalTo(self.profileImageAndEventNameView)
            make.height.equalTo(53)
        }
        view.layer.borderWidth = CGFloat(VIEW_BORDER_WIDTH)
        view.layer.borderColor = VIEW_BORDER_COLOR
        self.timeIcon = self.setTimeIcon(superview: view)
        self.startTimeLabel = self.setTimeLabel(superview: view)
        
        return view
    }
    
    func setTimeIcon (superview: UIView) -> CustomHijinnksView {
        let timeIconView = CustomHijinnksView(customViewType: .Clock)
        superview.addSubview(timeIconView)
        timeIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.profileImageView)
            make.centerY.equalTo(superview)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        return timeIconView
    }
    
    func setTimeLabel (superview: UIView) -> UILabel {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14.0)
        superview.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.eventNameLabel)
            make.centerY.equalTo(superview)
        }
        
        timeLabel.text = StyledDate.getDateAsString(date: self.invitation.startingTime)
        return timeLabel
    }
}
// Extension which handles everything within the footer view.  Commenting, Liking, and Viewing the Map
extension ViewInvitationsCell {
    // View at the bottom that contains the map, like and rsvp buttons
    func setFooterView () -> UIView {
        let view = UIView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageAndEventNameView)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.profileImageAndEventNameView)
            make.top.equalTo(self.rsvpView.snp.bottom).offset(VIEW_TOP_OFFSET)
            make.height.equalTo(53)
        }
        
        view.layer.borderWidth = CGFloat(VIEW_BORDER_WIDTH)
        view.layer.borderColor = VIEW_BORDER_COLOR
        
        self.mapButton = setMapButton(superview: view)
        self.likeButton = setLikeButton(superview: view)
        let font = UIFont.systemFont(ofSize: 14.0)
        self.rsvpButton = setRSVPButton(font: font, superview: view)
        self.commentButton = setCommentButton(superview: view)
        
        return view
    }
    
    // Button that will display the map to the user when pressed
    func setMapButton (superview: UIView) -> HijinnksButton {
        let button = HijinnksButton(customButtonType: .Map)
        superview.addSubview(button)
        button.addTarget(self, action: #selector(displayMap), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(superview).offset(15)
            make.bottom.equalTo(superview).offset(-11)
            make.width.equalTo(button.snp.height).offset(-5)
        }
        return button
    }
    
    func displayMap () {
        if self.isMapShown {
            self.mapView.removeFromSuperview()
        }
        else {
            let camera = GMSCameraPosition.camera(withLatitude: invitation.location.latitude, longitude: invitation.location.longitude, zoom: 15)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: invitation.location.latitude, longitude: invitation.location.longitude))
            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            marker.map = mapView
            self.mapView = UIView()
            self.mapView = mapView
            self.addSubview(self.mapView)
            self.mapView.snp.makeConstraints { (make) in
                make.left.equalTo(self)
                make.top.equalTo(self.contentView)
                make.bottom.equalTo(self.footerView.snp.top)
                make.right.equalTo(self)
            }
        }
        self.isMapShown = !self.isMapShown
    }
    
    // This is the like button which is shaped as a heart that they can click on to like the invitation
    func setLikeButton (superview: UIView) -> HijinnksButton {
        let button = HijinnksButton(customButtonType: .LikeEmpty)
        button.addTarget(self, action: #selector(likeButtonPressed(likeButton:)), for: .touchUpInside)
        superview.addSubview(button)
        
        // If the user has already liked this invitation than displaly that
        let likedInvitations = PFUser.current()?.value(forKey: ParseObjectColumns.LikedInvitations.rawValue) as? [String]
        if likedInvitations != nil {
            if likedInvitations?.contains(self.invitation.objectId!) == true {
                button.customButtonType = .LikeFilled
                button.setNeedsDisplay()
                
            }
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(self.mapButton)
            make.bottom.equalTo(self.mapButton)
            make.width.equalTo(button.snp.height)
            make.left.equalTo(self.mapButton.snp.right).offset(20)
        }
        
        return button
    }
    func setRSVPButton (font: UIFont, superview: UIView) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: font.pointSize, weight: UIFontWeightBold)
        
        if invitation.rsvpCount >= invitation.maxAttendees && invitation.maxAttendees != InvitationConstants.NoMaxAttendeesNumber.rawValue
        {
            button.setTitleColor(.red, for: .normal)
            button.setTitle("MAXED\nOUT", for: .normal) // Display the number of people who have RSVP'd
        }
        else
        {
            button.setTitleColor(Colors.CommentButtonBlue.value, for: .normal)
            button.setTitle("RSVP", for: .normal) // Display the number of people who have RSVP'd
        }
        
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(updateRSVPCountButtonPressed), for: .touchUpInside)
        superview.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalTo(superview).offset(-35)
            make.centerY.equalTo(self.mapButton)
        }
        
        return button
    }
    
    func setCommentButton (superview: UIView) -> UIButton {
        let button = HijinnksButton(customButtonType: .Comment)
        button.addTarget(self, action: #selector(commentButtonPressed), for: .touchUpInside)
        superview.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(self.likeButton.snp.right).offset(20)
            make.top.equalTo(self.mapButton)
            make.bottom.equalTo(self.mapButton)
            make.width.equalTo(button.snp.height)
        }
        return button
    }
    
    func commentButtonPressed () {
        delegate.showInvitationCommentScreen!(invitation: self.invitation) // View Invitations View Controller        
    }
    
    // TODO: Figure out a way to make sure that this method must be called, if it's not called then the app will crash on click of the RSVP button
    func getUserDetails () {
        DEUserManager.sharedManager.getUserDetails(user: invitation.fromUser, success: { (userDetails) in
            if userDetails != nil {
                self.userDetails = userDetails as? UserDetailsParseObject
            }
        })
    }
    
    func updateRSVPCountButtonPressed () {
        
        // If the invitation is from the current user than don't show the confirmation view, otherwise show it.
        if !UtilityFunctions.isCurrent(user: self.invitation.fromUser) && self.invitation.rsvpUsers.contains((PFUser.current()?.objectId!)!) == false {
        }
        
        // Make sure the user can not press the RSVP button again until the process is completed
        self.rsvpButton.isUserInteractionEnabled = false
        if self.userDetails != nil {
            self.updateRSVPCount()
        } else {
            DEUserManager.sharedManager.getUserDetails(user: invitation.fromUser, success: { (userDetails) in
                if userDetails != nil {
                    self.userDetails = userDetails as? UserDetailsParseObject
                    self.updateRSVPCount()
                } else {
                    // Allow the user to press the RSVP button again
                    self.rsvpButton.isUserInteractionEnabled = true
                }
            })
        }
    }
    
    /**
     * - Description Increase or decrease the count of those who have RSVP'd and update the users who have RSVP'd
     */
    func updateRSVPCount () {
        if self.userDetails != nil {
            delegate.rsvpButtonPressed!(invitation: self.invitation, invitationCell: self, userDetails: self.userDetails) // Delegate is ViewInvitationsViewController
            self.invitation.saveInBackground()
            if invitation.rsvpCount == invitation.maxAttendees && invitation.maxAttendees != 0 {
                self.rsvpButton.setTitleColor(.red, for: .normal)
                self.rsvpButton.setTitle("MAXED\nOUT", for: .normal) // Display the number of people who have RSVP'd
            }
            else {
                self.rsvpButton.setTitleColor(Colors.CommentButtonBlue.value, for: .normal)
//                self.rsvpButton.setTitle("\(invitation.rsvpCount!)\nRSVP'd", for: .normal) // Display the number of people who have RSVP'd
            }
        }
    }
    
    func likeButtonPressed (likeButton: HijinnksButton) {
        
        var likedInvitations = PFUser.current()?.value(forKey: ParseObjectColumns.LikedInvitations.rawValue) as? [String]
        if likedInvitations == nil {
            likedInvitations = [String]()
        }
        
        if likedInvitations?.contains(self.invitation.objectId!) == false {
            likeButton.customButtonType = .LikeFilled
            likeButton.setNeedsDisplay()
            likedInvitations?.append(self.invitation.objectId!)
            PFUser.current()?.setValue(likedInvitations, forKey: ParseObjectColumns.LikedInvitations.rawValue)
            self.updateLikeCount(likedInvitations: likedInvitations!, increment: 1)
        }
        else {
            likeButton.customButtonType = .LikeEmpty
            likeButton.setNeedsDisplay()
            likedInvitations = likedInvitations?.filter {
                $0 != self.invitation.objectId
            }
            PFUser.current()?.setValue(likedInvitations, forKey: ParseObjectColumns.LikedInvitations.rawValue)
            self.updateLikeCount(likedInvitations: likedInvitations!, increment: -1)
        }
        
    }
    
    func updateUserDetailsLikeCount (userDetails: UserDetailsParseObject, increment: NSNumber) {
        
        self.userDetails.incrementKey(ParseObjectColumns.LikeCount.rawValue, byAmount: increment)
        self.userDetails.saveInBackground { (success, error) in
            if error != nil {
                print("Error updating user like count on the server - \(error?.localizedDescription)")
            } else {
                print(userDetails)
            }
        }
    }
    
    func updateLikeCount (likedInvitations: [String], increment: NSNumber) {
        // If the userDetails object has already been loaded then update ethe like count, otherwise get the userDetails object for the user from the server
        if self.userDetails != nil {
            self.updateUserDetailsLikeCount(userDetails: self.userDetails, increment: increment)
        } else {
            DEUserManager.sharedManager.getUserDetails(user: self.invitation.fromUser , success: { (userDetails) in
                if userDetails != nil {
                    self.userDetails = userDetails as! UserDetailsParseObject!
                    self.updateUserDetailsLikeCount(userDetails: self.userDetails, increment: increment)
                }
            })
        }
    }
}
// Show the interests
extension ViewInvitationsCell {
    func setInterestsView () -> UIView {
        let interestView = UIView()
        self.contentView.addSubview(interestView)
        interestView.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageAndEventNameView)
            make.right.equalTo(self.profileImageAndEventNameView)
            if self.invitation.interests.count != 0 {
                make.top.equalTo(self.messageView.snp.bottom).offset(VIEW_TOP_OFFSET)
                make.height.equalTo(60)
                interestView.layer.borderWidth = CGFloat(VIEW_BORDER_WIDTH)
            } else {
                make.top.equalTo(self.messageView.snp.bottom).offset(-VIEW_BORDER_WIDTH)
                make.height.equalTo(0)
                interestView.layer.borderWidth = 0
            }
        }
        interestView.layer.borderColor = VIEW_BORDER_COLOR
        
        
        if self.invitation.interests.count != 0 {
            _ = self.setInterestsScrollView(superview: interestView)
        }
        return interestView
    }
    
    func setInterestsScrollView (superview: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        superview.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(superview)
        }
        
        let view = UIView()
        scrollView.addSubview(view)
        
        var xPos = 0
        for interest in self.invitation.interests {
            let interestView = UtilityFunctions.getInterestIcon(interest: interest)
            view.addSubview(interestView!)
            interestView?.frame = CGRect(x: xPos, y: 0, width: 75, height: 75)
            xPos += 75
        }
        
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(xPos)
            make.height.equalTo(scrollView.snp.height)
        }
        
        scrollView.contentSize = CGSize(width: xPos, height: 75)
        return scrollView
    }
    
    
    func getInterestView (icon: InterestIcons) {
        
    }
}

// Show who has RSVP'd
extension ViewInvitationsCell {
    
    // FIXME: There's autolayout constraints when this method is called
    func resetRsvpView () {
        self.rsvpView.snp.remakeConstraints { (make) in
            make.left.equalTo(self.profileImageAndEventNameView)
            make.right.equalTo(self.profileImageAndEventNameView)
            
            // If no users have rsvp'd than we need to make sure that the view displays that properly
            if self.invitation.rsvpUsers.count != 0 {
                make.height.equalTo(95)
            }
            else {
                make.height.equalTo(50)
            }
            make.top.equalTo(self.interestView.snp.bottom).offset(VIEW_TOP_OFFSET)
        }
        
        self.viewRsvpdButton.removeFromSuperview()
        self.viewRsvpdButton = self.setRsvpdButton(superview: self.rsvpView)
        self.displayInvitedPeople(superview: self.rsvpView)
        self.rsvpView.layoutIfNeeded()
    }
    
    func setRsvpView () -> UIView {
        let view = UIView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalTo(self.profileImageAndEventNameView)
            make.right.equalTo(self.profileImageAndEventNameView)
            
            // If no users have rsvp'd than we need to make sure that the view displays that properly
            if self.invitation.rsvpUsers.count != 0 {
                make.height.equalTo(95)
            }
            else {
                make.height.equalTo(55)
            }
            make.top.equalTo(self.interestView.snp.bottom).offset(VIEW_TOP_OFFSET)
        }
        
        view.layer.borderWidth = CGFloat(VIEW_BORDER_WIDTH)
        view.layer.borderColor = VIEW_BORDER_COLOR
        
        self.viewRsvpdButton = self.setRsvpdButton(superview: view)
        self.displayInvitedPeople(superview: view)
        
        return view
    }
    
    func setRsvpdButton (superview: UIView) -> UIButton {
        let button = UIButton()
        button.backgroundColor = Colors.CommentButtonBlue.value
        button.layer.cornerRadius = 5
        button.setTitle("\(self.invitation.rsvpCount!) RSVP'd", for: .normal)
        superview.addSubview(button )
        button.snp.makeConstraints { (make) in
            make.centerX.equalTo(superview)
            make.top.equalTo(superview).offset(15)
            make.width.equalTo(110)
            make.height.equalTo(25)
        }
        
        button.addTarget(self, action: #selector(rsvpdButtonPressed), for: .touchUpInside)
        
        return button
    }
    
    /**
     * - Description When the user presses the Rsvp'd button then the ViewInvitationsViewController delegate method viewRsvpListButtonPressed is called
     */
    func rsvpdButtonPressed () {
        delegate.viewRsvpListButtonPressed!(invitation: self.invitation)
    }
    
    func startActivitySpinnerInRSVPView (activitySpinner: UIActivityIndicatorView) {
        activitySpinner.hidesWhenStopped = true
        activitySpinner.color = Colors.DarkGray.value
        self.contentView.addSubview(activitySpinner)
        activitySpinner.snp.makeConstraints { (make) in
            make.center.equalTo(self.rsvpButton)
        }
        activitySpinner.startAnimating()
    }
    
    func displayInvitedPeople (superview: UIView) {
        var profileImages = [UIView]()
        let activitySpinner = UIActivityIndicatorView()
        if self.rsvpButton != nil {
            self.startActivitySpinnerInRSVPView(activitySpinner: activitySpinner)
            self.rsvpButton.isEnabled = false
            self.rsvpButton.alpha = 0
        }
        
        // If there are specific users of the application that have been invited to this event
        if self.invitation.rsvpUsers.count != 0 {
            let parseQueue = DispatchQueue(label: "com.parse.hijinnks")
            parseQueue.async {
                // Display each user's profile image
                for userId in self.invitation.rsvpUsers {
                    do
                    {
                        let query = PFUser.query()
                        query?.whereKey(ParseObjectColumns.ObjectId.rawValue, equalTo: userId)
                        let user = try query?.getFirstObject() as! PFUser
                        try user.fetchIfNeeded()
                        if user.object(forKey: ParseObjectColumns.Profile_Picture.rawValue) != nil
                        {
                            let profileImageFile = user.object(forKey: ParseObjectColumns.Profile_Picture.rawValue) as! PFFile
                            do {
                                let imageData = try profileImageFile.getData()
                                let profileImage = ProfileImage(image: UIImage(data: imageData))
                                profileImages.append(profileImage)
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            let tempProfileImageLabel = DEUserManager.sharedManager.getTempProfileImageLabel(name: user.username!, fontSize: 20.0)
                            profileImages.append(tempProfileImageLabel)
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.displayProfileImages(profileImages: profileImages, superview: superview)
                    if self.rsvpButton != nil {
                        self.rsvpButton.isEnabled = true
                        self.rsvpButton.alpha = 1
                        activitySpinner.stopAnimating()
                    }
                })
            }
        }
    }
    
    func displayProfileImages (profileImages: [UIView], superview: UIView) {
        
        for subview in superview.subviews {
            if (subview is UIButton) == false {
                subview.removeFromSuperview()
            }
        }
        
        var margin:CGFloat!
        
        if UIScreen.main.bounds.width > 400 {
            margin = (UIScreen.main.bounds.width - (6 * 40)) / 8
        }
        else {
            margin = (UIScreen.main.bounds.width - (5 * 40)) / 7
        }
        
        var xPos:CGFloat = margin
        for profileImage in profileImages {
            superview.addSubview(profileImage)
            profileImage.snp.makeConstraints({ (make) in
                make.left.equalTo(xPos)
                make.height.equalTo(profileImageDimensions)
                make.width.equalTo(profileImageDimensions)
                make.top.equalTo(superview).offset(45)
            })
            profileImage.layer.cornerRadius = profileImageDimensions / 2.0
            profileImage.clipsToBounds = true
            xPos += margin + profileImageDimensions
            
            if xPos + profileImageDimensions > self.frame.width {
                break
            }
        }
//        self.rsvpView = superview
    }
}

class StyledDate {
    class func getDateAsString (date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a EEEE, MMM d, yyyy"
        let formattedDateString = dateFormatter.string(from: date)
        
        return formattedDateString
    }
}

class ProfileImage : UIImageView {
    
    var user:PFUser!
    
}
