//
//  ProfileView.swift
//  Hijinnks
//
//  Created by adeiji on 3/10/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse
import SnapKit

// FIXME: Need to comment this code
class ProfileView : UIScrollView {
    
    weak var usernameLabel:UILabel!
    weak var editProfileButton:UIButton!
    weak var optionsButton:UIButton!
    weak var bioTextView:UITextView!
    weak var interestsView:InterestsView!
    weak var followersLabel:UILabel!
    weak var followingLabel:UILabel!
    weak var inviteesLabel:UILabel!
    weak var rsvpLabel:UILabel!
    var interestsContainerView:UIView!
    weak var viewInvitationsTableView:UITableView!
    weak var profileImageView:UIImageView!
    weak var addFriendButton:UIButton!
    var imageViewTapRecognizer:UITapGestureRecognizer!
    var tableViewDataSourceAndDelegate:UIViewController!
    weak var user:PFUser!
    weak var wrapperView:UIView!
    var likeButton:HijinnksButton!
    weak var likeLabel:UILabel!
    var isFriend:Bool
    
    weak var menuView:UIView!
    weak var invitationsButton:HijinnksButton!
    weak var interestsButton:HijinnksButton!
    weak var profileDetailsButton:HijinnksButton!
    
    weak var interestsListView:InterestsListView!
    weak var profileDetailsView:ProfileDetailsView!
    
    var heightConstraint:Constraint!
    
    init(myUser: PFUser, myTableViewDataSourceAndDelegate: UIViewController) {
        self.user = myUser
        self.tableViewDataSourceAndDelegate = myTableViewDataSourceAndDelegate
        self.isFriend = false
        if PFUser.current()?.value(forKey: ParseObjectColumns.Friends.rawValue) != nil {
            let friends = PFUser.current()?.value(forKey: ParseObjectColumns.Friends.rawValue) as! [String]
            if friends.contains(self.user.objectId!) {
                self.isFriend = true
            }
        }
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        self.backgroundColor = .white
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(self.superview!)
        }
        self.wrapperView = self.setWrapperView()
        self.setProfileImageView()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    // Dismiss the keyboard
    func dismissKeyboard () {
        self.endEditing(true)
    }
    
    func setWrapperView () -> UIView {
        let view = UIView()
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        return view
    }
    
    func setMenuView () -> UIView {
        
        let menuView = UIView()
        
        self.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.top.equalTo(self.followersLabel.snp.bottom)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(34)
        }
        
        return menuView
    }
    
    func setInvitationsButton () -> HijinnksButton {
        let screenWidth = UIScreen.main.bounds.width / 3.0
        let invitationsButton = HijinnksButton(customButtonType: .Invitations)
        self.menuView.addSubview(invitationsButton)
        
        invitationsButton.backgroundColor = Colors.grey.value
        invitationsButton.setTitleColor(.white, for: .normal)
        
        invitationsButton.snp.makeConstraints { (make) in
            make.left.equalTo(menuView)
            make.top.equalTo(menuView)
            make.bottom.equalTo(menuView)
            make.width.equalTo(screenWidth)
        }
        
        return invitationsButton
    }
    
    func setInterestsButton () -> HijinnksButton {
        let screenWidth = UIScreen.main.bounds.width / 3.0
        let interestsButton = HijinnksButton(customButtonType: .Interests)
        interestsButton.layer.borderColor = Colors.VeryLightGray.value.cgColor
        interestsButton.layer.borderWidth = 1.0
        
        menuView.addSubview(interestsButton)
        interestsButton.snp.makeConstraints { (make) in
            make.left.equalTo(invitationsButton.snp.right)
            make.top.equalTo(menuView)
            make.bottom.equalTo(menuView)
            make.width.equalTo(screenWidth)
        }
        
        return interestsButton
    }
    
    func setProfileDetailsButton () -> HijinnksButton {
        let profileDetailsButton = HijinnksButton(customButtonType: .More)
        profileDetailsButton.layer.borderColor = Colors.VeryLightGray.value.cgColor
        profileDetailsButton.layer.borderWidth = 1.0
        menuView.addSubview(profileDetailsButton)
        profileDetailsButton.snp.makeConstraints { (make) in
            make.left.equalTo(interestsButton.snp.right)
            make.top.equalTo(menuView)
            make.bottom.equalTo(menuView)
            make.right.equalTo(menuView)
        }
        
        return profileDetailsButton
    }
    
    
    func setProfileImageView () {
        let profileImageView = UIImageView()
        profileImageView.image = nil
        profileImageView.backgroundColor = Colors.invitationTextGrayColor.value
        profileImageView.layer.cornerRadius = 50
        self.wrapperView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.wrapperView)
            make.top.equalTo(self.wrapperView).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        self.profileImageView = profileImageView
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = 5
        
        self.imageViewTapRecognizer = UITapGestureRecognizer()
        self.imageViewTapRecognizer.numberOfTapsRequired = 1
        self.profileImageView.addGestureRecognizer(imageViewTapRecognizer)
        self.profileImageView.isUserInteractionEnabled = true
        setUsernameLabel(myProfileImageView: self.profileImageView)
        loadProfileImage()
    }
    
    // Get the image from the server and display it
    func loadProfileImage () {
        if (user.value(forKey: ParseObjectColumns.Profile_Picture.rawValue) != nil) {
            let imageData = user.value(forKey: ParseObjectColumns.Profile_Picture.rawValue) as! PFFile
            imageData.getDataInBackground { (data: Data?, error: Error?) in
                if data != nil {
                    let image = UIImage(data: data!)
                    if image != nil {
                        self.profileImageView.image = image
                    }
                }
            }
        }
    }

    func setUsernameLabel (myProfileImageView: UIImageView) {
        let myUsernameLabel = UILabel()
        
        let canonicalUsername = user.value(forKey: ParseObjectColumns.Canonical_Username.rawValue) as? String
        if  canonicalUsername == nil {
            myUsernameLabel.text = user.username
        }
        else {
            myUsernameLabel.text = canonicalUsername
        }
        myUsernameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        self.wrapperView.addSubview(myUsernameLabel)
        myUsernameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.wrapperView)
            make.top.equalTo(myProfileImageView.snp.bottom).offset(25)
        }
        
        self.usernameLabel = myUsernameLabel
        setLikeView(myUsernameLabel: self.usernameLabel)
    }
    
    func setLikeView (myUsernameLabel: UILabel) {
        let likeButton = HijinnksButton(customButtonType: .LikeFilled)
        self.addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-10)
            make.top.equalTo(myUsernameLabel.snp.bottom).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(likeButton.snp.width)
        }
        
        let likeCounterLabel = UILabel()
        self.addSubview(likeCounterLabel)
        likeCounterLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(10)
            make.centerY.equalTo(likeButton)
        }
        likeCounterLabel.textColor = .red
        let likes = self.user.value(forKey: ParseObjectColumns.NumberOfLikes.rawValue) as? Int
        if likes != nil {
            likeCounterLabel.text = "\(likes!)"
        } else {
            likeCounterLabel.text = "0"
        }
        
        self.likeButton = likeButton
        self.likeLabel = likeCounterLabel
        
        if UtilityFunctions.isCurrent(user: self.user) == false {
            setAddFriendButton()
        } else {
            self.setBioTextField()
        }
    }
    
    func setAddFriendButton () {
        let addFriendButton = UIButton()
        
        // If the user is not already a friend
        if self.isFriend == false {
            addFriendButton.setTitle("Add Friend", for: .normal)
        }
        else {
            // FIXME: Make sure that we use String constants for this
            addFriendButton.setTitle("Unfriend", for: .normal)
        }
        
        addFriendButton.backgroundColor = .white
        addFriendButton.setTitleColor(.black, for: .normal)
        addFriendButton.layer.borderColor = Colors.invitationTextGrayColor.value.cgColor
        addFriendButton.layer.borderWidth = 1
        self.wrapperView.addSubview(addFriendButton)
        addFriendButton.layer.cornerRadius = 5
        addFriendButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.wrapperView)
            make.top.equalTo(self.likeButton.snp.bottom).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(UIConstants.ProfileViewButtonHeights.rawValue)
        }
        self.addFriendButton = addFriendButton
        setBioTextField()
    }
    
    func setBioTextField ()
    {
        let bioTextView = UITextView()
        bioTextView.text = DEUserManager.sharedManager.getBio(user: self.user)
        bioTextView.textColor = .black
        bioTextView.isUserInteractionEnabled = false
        bioTextView.returnKeyType = .done
        bioTextView.font = UIFont.systemFont(ofSize: 15)
        bioTextView.textAlignment = .center
        
        if UtilityFunctions.isCurrent(user: self.user) == true {
            if bioTextView.text.isEmpty {
                bioTextView.text = "Enter Your Bio"
                bioTextView.textColor = .lightGray
            }
            bioTextView.isUserInteractionEnabled = true
            bioTextView.delegate = self
        }
        self.wrapperView.addSubview(bioTextView)
        bioTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.wrapperView).offset(UIConstants.ProfileViewHorizontalSpacing.rawValue)
            if self.addFriendButton == nil {
                make.top.equalTo(self.likeButton.snp.bottom).offset(UIConstants.ProfileViewVerticalSpacing.rawValue)
            }
            else
            {
                make.top.equalTo(self.addFriendButton.snp.bottom).offset(UIConstants.ProfileViewVerticalSpacing.rawValue)
            }
            make.right.equalTo(self.wrapperView).offset(-UIConstants.ProfileViewHorizontalSpacing.rawValue)
            if DEUserManager.sharedManager.getBio(user: self.user) != nil || UtilityFunctions.isCurrent(user: self.user) == true {
                make.height.equalTo(65)
            }
            else {
                make.height.equalTo(0)
            }
        }
        
        self.bioTextView = bioTextView
        setInterestsView(myBioTextView: self.bioTextView)
    }
    
    func setInterestsView (myBioTextView: UITextView) {
        let interestsView = InterestsView()
        self.wrapperView.addSubview(interestsView)
//        self.showInterests()
        
        interestsView.snp.makeConstraints { (make) in
            make.left.equalTo(myBioTextView)            
            make.top.equalTo(self.bioTextView.snp.bottom).offset(UIConstants.ProfileViewVerticalSpacing.rawValue)
            make.right.equalTo(myBioTextView).offset(UIConstants.ProfileViewHorizontalSpacing.rawValue)
            make.height.equalTo(60)
        }
        
        self.interestsView = interestsView
        let followers = self.user.value(forKey: ParseObjectColumns.Followers.rawValue) as? [String]
        var count = 0
        if followers != nil {
            count = (followers?.count)!
        }
        
        let followersString = NSMutableAttributedString()
        _ = followersString.bold("\(count)").normal("\nFollowers")
        
        self.followersLabel = setUserDetailCountLabels(myInterestsView: self.interestsView, text: followersString, labelOnLeft: nil, isLastLabelOnRight: false)
        
        let following = self.user.value(forKey: ParseObjectColumns.Friends.rawValue) as? [String]
        
        if following != nil {
            count = (following?.count)!
        }
        
        let followingString = NSMutableAttributedString()
        _ = followingString.bold("\(count)").normal("\nFollowing")
        self.followingLabel = setUserDetailCountLabels(myInterestsView: self.interestsView, text:followingString, labelOnLeft: self.followersLabel, isLastLabelOnRight: false)
        
        var inviteCount = self.user.value(forKey: ParseObjectColumns.InviteCount.rawValue) as? Int
        if inviteCount == nil {
            inviteCount = 0
        }
        let invitesString = NSMutableAttributedString()
        _ = invitesString.bold("\(inviteCount!)").normal("\nInvites")
        self.inviteesLabel = setUserDetailCountLabels(myInterestsView: self.interestsView, text: invitesString, labelOnLeft: self.followingLabel, isLastLabelOnRight: false)
        var rsvpCount = self.user.value(forKey: ParseObjectColumns.RSVPCount.rawValue) as? Int
        if rsvpCount == nil {
            rsvpCount = 0
        }
        let rsvpsString = NSMutableAttributedString()
        _ = rsvpsString.bold("\(rsvpCount!)").normal("\nRSVPs")
        self.rsvpLabel = setUserDetailCountLabels(myInterestsView: self.interestsView, text: rsvpsString, labelOnLeft: self.inviteesLabel, isLastLabelOnRight: true)
        
        self.getUserDetails()
        self.menuView = self.setMenuView()
        self.invitationsButton = self.setInvitationsButton()
        self.interestsButton = self.setInterestsButton()
        self.profileDetailsButton = self.setProfileDetailsButton()
        self.setViewInvitationsTableView(viewAbove: self.menuView)
    }
    
    /**
     * - Description Display the amount of RSVPs this user has currently
     * - Parameter userDetails: UserDetailsParseObject - The object which contains the details for the user, ex. rsvpCount, likeCount etc
     */
    func displayRSVPCount (userDetails: UserDetailsParseObject) {
        let rsvpsString = NSMutableAttributedString()
        if userDetails.rsvpCount != nil {
            _ = rsvpsString.bold("\(userDetails.rsvpCount!)").normal("\nRSVPs")
        }
        else {
            _ = rsvpsString.bold("0").normal("\nRSVPs")
        }
        self.rsvpLabel.attributedText = rsvpsString
    }
    
    /**
     * - Description Display the amount of likes this user has currently
     * - Parameter userDetails: UserDetailsParseObject - The object which contains the details for the user, ex. rsvpCount, likeCount etc
     */
    func displayLikeCount (userDetails: UserDetailsParseObject) {
        if userDetails.likeCount != nil {
            self.likeLabel.text = "\(userDetails.likeCount!)"
        }
        else {
            self.likeLabel.text = "0"
        }
    }
    
    func displayUserDetails (userDetails: UserDetailsParseObject) {
        self.displayRSVPCount(userDetails: userDetails)
        self.displayLikeCount(userDetails: userDetails)
    }
    
    func getUserDetails () {
        DEUserManager.sharedManager.getUserDetails(user: self.user) { (userDetails) in
            if userDetails != nil {
                self.displayUserDetails(userDetails: userDetails as! UserDetailsParseObject)
            }
        }
    }
    
    func setUserDetailCountLabels (myInterestsView: InterestsView, text: NSMutableAttributedString, labelOnLeft: UILabel!, isLastLabelOnRight: Bool) -> UILabel {
        let detailLabel = UILabel()
        detailLabel.attributedText = text
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 2
        self.wrapperView.addSubview(detailLabel)
        let applicationWindow = UIApplication.shared.delegate?.window!
        let screenWidth = applicationWindow?.frame.size.width
        detailLabel.snp.makeConstraints { (make) in
            if labelOnLeft == nil {
                make.left.equalTo(self.wrapperView)
            }
            else {
                make.left.equalTo(labelOnLeft.snp.right)
            }
            make.top.equalTo(myInterestsView).offset(UIConstants.ProfileViewVerticalSpacing.rawValue)
            make.width.equalTo(screenWidth! / CGFloat(UIConstants.ProfileViewNumberOfLabelColumns.rawValue)) // Set a temp width
            if isLastLabelOnRight {
                make.right.equalTo(self.wrapperView)
            }
            
            make.height.equalTo(UIConstants.ProfileViewUserDetailCountsHeight.rawValue)
        
        }
        return detailLabel
    }
    
    func setViewInvitationsTableView (viewAbove: UIView) {
        let viewInvitationsTableView = UITableView()
        viewInvitationsTableView.separatorStyle = .none
        self.wrapperView.addSubview(viewInvitationsTableView)
        viewInvitationsTableView.snp.makeConstraints { (make) in
            make.left.equalTo(self.wrapperView)
            make.top.equalTo(self.menuView.snp.bottom).offset(UIConstants.ProfileViewVerticalSpacing.rawValue) // This is also needed to be set in the ProfileViewController
            make.right.equalTo(self.wrapperView)
            make.bottom.equalTo(self.wrapperView).offset(-50)
        }
        self.viewInvitationsTableView = viewInvitationsTableView
        self.viewInvitationsTableView.isUserInteractionEnabled = false
        
        let interestsListView = InterestsListView()
        interestsListView.isHidden = true
        self.wrapperView.addSubview(interestsListView)
        interestsListView.snp.makeConstraints { (make) in
            make.left.equalTo(self.wrapperView)
            make.right.equalTo(self.wrapperView)
            make.top.equalTo(self.viewInvitationsTableView)
        }
        interestsListView.setupUI(user: self.user)
        self.interestsListView = interestsListView
        
        let profileDetailsView = ProfileDetailsView(user: self.user)
        profileDetailsView.setupUI(user: self.user)
        profileDetailsView.isHidden = true
        self.wrapperView.addSubview(profileDetailsView)
        profileDetailsView.snp.makeConstraints { (make) in
            make.left.equalTo(self.wrapperView)
            make.right.equalTo(self.wrapperView)
            make.top.equalTo(self.viewInvitationsTableView)
            
        }
        
        self.profileDetailsView = profileDetailsView
    }
}

// Text View Delegate Methods for BioTextView
extension ProfileView : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your bio"
            textView.textColor = .lightGray
        }
        else {
            DEUserManager.sharedManager.setBio(bio: textView.text)            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // User pressed enter
        if text.rangeOfCharacter(from: .newlines) != nil {
            textView.resignFirstResponder()
            return false
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        
        return numberOfChars < 100;
    }
}

class InterestsView : UIView {
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NSMutableAttributedString {
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String)->NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSForegroundColorAttributeName : Colors.invitationTextGrayColor.value]
        let normal =  NSAttributedString(string: text, attributes: attrs)
        
        self.append(normal)
        return self
    }
}

