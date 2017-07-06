//
//  CreateInvitationViewController.swift
//  Hijinnks
//
//  Created by adeiji on 2/23/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import GooglePlaces
import Parse
import FBSDKShareKit
import Contacts

class CreateInvitationViewController : UIViewController, PassDataBetweenViewControllersProtocol {
    
    // UI Elements
    weak var wrapperView:UIView! // This is so that we can have one view in which the Scroll View will have as it's indicator for scrolling
    weak var headerLabel:UILabel! // This label displays the short description for this page -- Create Invitation
    weak var nameTextField:UITextField!
    weak var locationTextField:UITextField!
    weak var inviteMessageTextField:UITextField!
    weak var startingTimeTextField:UITextField!
    weak var durationTextField:UITextField!
    weak var inviteesTextField:UITextField!
    weak var inviteInterestsTextField:UITextField! // Change this in production
    weak var maxNumberOfAttendeesTextField:UITextField!
    weak var locationSwitch:UISwitch!
    weak var scrollView:UIScrollView!
    weak var weeklyButton:UIButton!
    weak var monthlyButton:UIButton!
    weak var sendButton:UIButton!
    
    // Arrays that store interests, friends, and contacts
    var selectedInterests:Array<String>!
    var selectedFriends:NSArray!
    var selectedContacts:[CNContact]!
    
    // Invitation Details
    var name:String!
    var address:String!
    var locationCoordinates:CLLocation!
    var inviteMessage:String!
    var startingTime:Date!
    var duration:String!
    var place:GMSPlace!
    var location:PFGeoPoint!
    var durations:Array<String>!
    var isPublic:Bool = false
    var isAllFriends:Bool = false
    var invitationSendScope:InvitationSendScope!
    
    var delegateViewInvitationsViewController:PassDataBetweenViewControllersProtocol!
    
    // Quick Invite
    let invitation:InvitationParseObject = InvitationParseObject()
    var quickInviteView:QuickInviteView!
    var quickMode:Bool = true
    
    // These should be set to false by default.  User should have to set either of these values to true
    var isWeekly:Bool = false
    var isMonthly:Bool = false
    
    enum InvitationSendScope {
        case Everyone
        case AllFriends
        case SomeFriends
    }
    
    weak var selectedTextField:UITextField!
    let PUBLIC_STRING = "Public to Anyone"
    let ALL_FRIENDS_STRING = "All Your Friends"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        self.scrollView = createScrollView()
        self.scrollView.contentSize = scrollView.frame.size
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification: )), name: NSNotification.Name.UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification: )), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.quickInviteView == nil {
            self.sendButton.isHidden = false
            self.showQuickInviteView()
            self.quickInviteView.cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
            self.quickMode = true
        }
        
        if self.quickMode == true {
            self.sendButton.isHidden = true
            self.quickInviteView.superview?.isHidden = false
            self.quickInviteView.invitedTableView.reloadData()
        }
    }
    
    // Dismiss the keyboard
    func dismissKeyboard () {
        self.view.endEditing(true)
    }
    
    func monthlyButtonPressed (_ sender: UIButton) {
        if self.isMonthly == true {
            self.isMonthly = false
        }
        else {
            self.isMonthly = true
        }
        
        self.isWeekly = false
        self.showRecurringButtonHighlighted(button: sender)
    }
    
    func weeklyButtonPressed (_ sender: UIButton) {
        if self.isWeekly == true {
            self.isWeekly = false
        } else {
            self.isWeekly = true
        }
        
        self.isMonthly = false
        self.showRecurringButtonHighlighted(button: sender)
    }
    
    func showRecurringButtonHighlighted (button: UIButton) {
        if self.isWeekly == true {
            self.weeklyButton.backgroundColor = Colors.grey.value
        }
        else {
            self.weeklyButton.backgroundColor = .white
        }
        
        if self.isMonthly == true {
            self.monthlyButton.backgroundColor = Colors.grey.value
        }
        else {
            self.monthlyButton.backgroundColor = .white
        }
    }
    
    func reset () {
        setupUI()
        self.selectedInterests = nil
        self.selectedFriends = nil
        self.name = nil
        self.address = nil
        self.locationCoordinates = nil
        self.inviteMessage = nil
        self.startingTime = nil
        self.duration = nil
        self.place = nil
        self.isPublic = true
        self.invitationSendScope = nil
        self.isWeekly = false
        self.isMonthly = false
        self.selectedContacts = [CNContact]()           
        self.quickInviteView = nil
    }
    
    func setRecurringView () {
        
        let recurringView = UIView()
        recurringView.backgroundColor = .white
        self.wrapperView.addSubview(recurringView)
        recurringView.snp.makeConstraints { (make) in
            make.left.equalTo(self.wrapperView)
            make.right.equalTo(self.wrapperView)
            make.top.equalTo(self.locationTextField.snp.bottom).offset(20)
        }
        
        let recurringLabel = UILabel(text: "Would you like this to be a recurring event?")
        recurringLabel.font = UIFont.systemFont(ofSize: 14.0)
        recurringLabel.textColor = Colors.DarkGray.value
        recurringView.addSubview(recurringLabel)
        recurringLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.wrapperView).offset(20)
            make.top.equalTo(recurringView).offset(10)
        }
        
        
        let weeklyButton = UIButton()
        weeklyButton.layer.borderWidth = 0.25
        weeklyButton.layer.borderColor = Colors.DarkGray.value.cgColor
        weeklyButton.setTitleColor(Colors.DarkGray.value, for: .normal)
        weeklyButton.setTitle("Weekly", for: .normal)
        weeklyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        weeklyButton.backgroundColor = .white
        recurringView.addSubview(weeklyButton)
        weeklyButton.snp.makeConstraints { (make) in
            make.left.equalTo(recurringView).offset(20)
            make.right.equalTo(recurringView.snp.centerX)
            make.top.equalTo(recurringLabel.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
        
        let monthlyButton = UIButton()
        monthlyButton.layer.borderColor = Colors.DarkGray.value.cgColor
        monthlyButton.layer.borderWidth = 0.25
        monthlyButton.setTitle("Monthly", for: .normal)
        monthlyButton.setTitleColor(Colors.DarkGray.value, for: .normal)
        monthlyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        monthlyButton.backgroundColor = .white
        recurringView.addSubview(monthlyButton)
        monthlyButton.snp.makeConstraints { (make) in
            make.left.equalTo(recurringView.snp.centerX)
            make.right.equalTo(recurringView).offset(-20)
            make.top.equalTo(weeklyButton)
            make.height.equalTo(35)
            make.bottom.equalTo(recurringView).offset(-10)
        }
        
        self.monthlyButton = monthlyButton
        self.weeklyButton = weeklyButton
        
        self.monthlyButton.addTarget(self, action: #selector(monthlyButtonPressed(_:)), for: .touchUpInside)
        self.weeklyButton.addTarget(self, action: #selector(weeklyButtonPressed(_:)), for: .touchUpInside)
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGray
        self.wrapperView.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(0.25)
            make.top.equalTo(recurringView.snp.bottom)
        }
    }
    
    func getRecurringButton () -> UIButton {
        return UIButton()
    }
    
    func setSelectedInterests(mySelectedInterest: Array<String>) {
        selectedInterests = mySelectedInterest
        var interestsString = String()
        
        for interest in selectedInterests {
            if interest != selectedInterests.last {
                interestsString += interest + ", "
            }
            else {
                interestsString += interest
            }
        }
        
        inviteInterestsTextField.text = interestsString
    }
    
    func removePublicStringFromTextField () {
        if self.inviteesTextField.text == PUBLIC_STRING {
            self.inviteesTextField.text = ""
        }
    }
    
    func setSelectedContacts(mySelectedContacts: NSArray) {
        self.removePublicStringFromTextField()
        self.selectedContacts = mySelectedContacts as! [CNContact]
        for contact in selectedContacts {
            if self.inviteesTextField.text == "" {
                self.inviteesTextField.text = "\((contact).givenName)"
            } else {
                self.inviteesTextField.text = self.inviteesTextField.text! + ", \((contact).givenName)"
            }
        }
    }
    
    func setSelectedFriends(mySelectedFriends: NSArray) {
        self.inviteesTextField.text = ""
        self.selectedContacts = nil
        self.selectedFriends = mySelectedFriends
        let selectedFriendsUserObjects = mySelectedFriends as! [PFUser]
        for user in selectedFriendsUserObjects {
            if user != selectedFriendsUserObjects.last {
                self.inviteesTextField.text = self.inviteesTextField.text! + "\(user.username!), "
            } else {
                self.inviteesTextField.text = self.inviteesTextField.text! + "\(user.username!)"
            }
        }
        self.invitationSendScope = InvitationSendScope.SomeFriends
    }
    
    func setSelectedFriendsToEveryone() {
        if PFUser.current()?.object(forKey: ParseObjectColumns.Friends.rawValue) != nil {
            self.selectedFriends = PFUser.current()?.object(forKey: ParseObjectColumns.Friends.rawValue) as! NSArray
            self.inviteesTextField.text = ALL_FRIENDS_STRING
            self.invitationSendScope = InvitationSendScope.AllFriends
        } else {
            // Inform the user that he is a loser and has no friends
            let alertController = UIAlertController(title: "No Friends", message: "Sorry, doesn't seem like you have any friends yet.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setSelectedFriendsToAnyone() {
        self.selectedFriends = [PFUser]() as NSArray!
        self.inviteesTextField.text = PUBLIC_STRING
        self.invitationSendScope = InvitationSendScope.Everyone
        self.isPublic = true
    }
    
    func locationSwitchPressed (sender: UISwitch) {
        if sender.isOn {
            _ = getLocation()
        }
        else {
            self.address = nil
            self.place = nil
            self.locationTextField.text = ""
        }
    }
    
    func getLocation () {
        // If the user did not select a place using the Google Maps Autocomplete feature, than we need to use his current location
        // So we need to get the current location from the Location Manager and than we need to get an address using the Lat/Long coordinates returned
        
        let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
        self.locationCoordinates = locationManager!.currentLocation
    
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.locationCoordinates, completionHandler: { (placemarks : [CLPlacemark]?, error: Error?) in
            let placemark = placemarks?.first
            let addressNumber = placemark?.subThoroughfare
            let address = placemark?.thoroughfare
            let city = placemark?.locality
            let state = placemark?.administrativeArea
            let zipCode = placemark?.postalCode
            
            let fullAddress = String("\(addressNumber!) \(address!), \(city!), \(state!) \(zipCode!)")
            self.address = fullAddress
            // Check to see if the user is on the quick invite screen or not and update the corresponding textField
            if self.quickMode == false {
                self.locationTextField.text = self.address
            }
            else {
                self.quickInviteView.locationTextField.text = self.address
            }
            self.location = PFGeoPoint(location: placemark?.location)
            return
        })
        
    }
    
    func saveAndSendInvitation (currentLocation: PFGeoPoint) {
        // Check to make sure all the data entered is valid
        var invitees:NSArray!
        if validateTextFields() {
            if invitationSendScope == InvitationSendScope.SomeFriends // If the user has selected some friends
            {
                invitees = self.selectedFriends
                createInvitationAndSend(location: currentLocation, invitees: invitees as! Array<PFUser>)
            }
            else if invitationSendScope == InvitationSendScope.AllFriends { // If the user has selected all friends
                let friends = DEUserManager.sharedManager.friends
                self.createInvitationAndSend(location: currentLocation, invitees: friends!)
            }
            else {  // If the user has made the invitation public
                createInvitationAndSend(location: currentLocation, invitees: Array<PFUser>())
            }
            self.quickMode = true
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
            self.sendInviteToContacts(contacts: self.selectedContacts, time: self.startingTimeTextField.text!)
            self.reset()
        }
    }
    
    // Check to make sure that the information that needs to be entered is entered correctly
    func validateTextFields () -> Bool
    {
        if nameTextField.text == "" || self.address == nil || self.inviteMessageTextField.text == "" || self.startingTime == nil || self.durationTextField.text == nil || self.inviteesTextField.text == "" || self.selectedInterests == nil {
            
            let alertController = UIAlertController(title: "Invitation", message: "Please enter data into all fields", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    /**
     * - Description Create the invitation and than save on the server
     * - Parameter location CLLocation - The location that the user is currently at
     * - Parameter invitees Array<PFUser> - The array of PFUser(s) that the user has invited
     * - Returns nil
     */
    func createInvitationAndSend (location: PFGeoPoint, invitees: Array<PFUser>) {
        // Create an invitation object with all the specified data entered by the user
        var newInvitation:InvitationParseObject!
        // Set the default maximum number of attendees
        if self.maxNumberOfAttendeesTextField.text == "" {
            self.maxNumberOfAttendeesTextField.text = "0"
        }
        
        if self.quickMode == false {
            newInvitation = InvitationParseObject( eventName: self.nameTextField.text!,
                                                   location:  location,
                                                   address: self.address,
                                                   message: self.inviteMessageTextField.text!,
                                                   startingTime: self.startingTime!,
                                                   duration: self.durationTextField.text!,
                                                   invitees: invitees,
                                                   interests: self.selectedInterests,
                                                   fromUser: PFUser.current()!,
                                                   dateInvited: Date(),
                                                   rsvpCount: 0,
                                                   rsvpUsers: Array<String>(),
                                                   comments: Array<CommentParseObject>(),
                                                   isWeekly: self.isWeekly,
                                                   isMonthly: self.isMonthly,
                                                   maxAttendees: Int(self.maxNumberOfAttendeesTextField.text!)!,
                                                   isPublic: self.isPublic)
        }
        else {
            newInvitation = InvitationParseObject( eventName: "",
                                                   location: location,
                                                   address: self.address,
                                                   message: "",
                                                   startingTime: self.startingTime!,
                                                   duration: "",
                                                   invitees: invitees,
                                                   interests: Array<String>(),
                                                   fromUser: PFUser.current()!,
                                                   dateInvited: Date(),
                                                   rsvpCount: 0,
                                                   rsvpUsers: Array<String>(),
                                                   comments: Array<CommentParseObject>(),
                                                   isWeekly: false,
                                                   isMonthly: false,
                                                   maxAttendees: 0,
                                                   isPublic: self.isPublic)
            
            
        }
        
        newInvitation.setValue(UUID().uuidString , forKey: ParseObjectColumns.TempId.rawValue)
        newInvitation.saveInBackground { (success, error) in
            if error == nil {
                // On the view invitations view controller, add this new invitation object
                self.delegateViewInvitationsViewController.addInvitation!(invitation: newInvitation)
                PFUser.current()?.incrementKey(ParseObjectColumns.InviteCount.rawValue)
                PFUser.current()?.saveInBackground()
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        Animations.showConfirmationView(type: .Circle, message: "You sent an invitation!", backgroundColor: Colors.blue.value, superView: appDelegate.window!, textColor: .white)
        self.tabBarController?.selectedIndex = 3
    }
    
    // Ask the user if they would like to post the invitation to Facebook for others to see
    func promptPostToFacebook () {
        let alertController = UIAlertController(title: "Share", message: "Would you like to share this invitation to Facebook?", preferredStyle: .actionSheet)
        let postToFacebookAction = UIAlertAction(title: "Post to Facebook", style: .default) { (action) in
            self.postToFacebook()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(postToFacebookAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Send an invitation to facebook users
    func postToFacebook () {
        let content = FBSDKShareLinkContent()
        content.contentTitle = self.name
        content.contentURL = NSURL(string: "http://hijinnks.com") as URL!
        content.contentDescription = self.inviteMessage
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }
    
    // Save the invitation to the server and update the View Invitations View Controller with the new invitation
    func sendInvite () {        
        // If the location returns nil than that means that the invitations has already been created and saved to the server
        if self.location != nil  {
            if locationTextField.text?.isEmpty == true {
                self.address = nil
            } else {
                self.address = locationTextField.text
            }
            
            saveAndSendInvitation(currentLocation: self.location)
        }
        else
        {
            let alertController = UIAlertController(title: "Location", message: "Please enter a location, or press the current location switch.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Place all of the UI elements on screen
    func setupUI() {
        let sendButton = HijinnksButton(customButtonType: HijinnksViewTypes.Send)
        sendButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        sendButton.addTarget(self, action: #selector(sendInvite), for: .touchUpInside)
        let donebutton = UIBarButtonItem(customView: sendButton)
        self.sendButton = sendButton
        self.navigationItem.rightBarButtonItem = donebutton
        self.view.backgroundColor = .white
        
        wrapperView = createWrapperView(myScrollView: scrollView)
        nameTextField = createTextField(superview: wrapperView, relativeViewAbove: nil, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing .rawValue, placeholderText: "Event Name", showViewController: nil, colorViewColor: Colors.green.value)
        self.nameTextField.autocapitalizationType = .words
        inviteMessageTextField = createTextField(superview: wrapperView, relativeViewAbove: self.nameTextField, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing .rawValue, placeholderText: "Message", showViewController: nil, colorViewColor: Colors.green.value)
        
        startingTimeTextField = createTextField(superview: wrapperView, relativeViewAbove: inviteMessageTextField, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing .rawValue, placeholderText: "Time", showViewController: nil, colorViewColor: Colors.blue.value)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        let date = NSDate.init() // gets me the current date and time
        datePicker.minimumDate = date as Date // make sure the minimum time they can choose is the current time
        datePicker.minuteInterval = 10
        startingTimeTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(startTimePickerDateChanged(sender:)), for: .valueChanged)
        
        durationTextField = createTextField(superview: wrapperView, relativeViewAbove: startingTimeTextField, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing .rawValue, placeholderText: "Duration", showViewController: nil, colorViewColor: Colors.grey.value)
        
        let selectFriendsViewController = SelectFriendsViewController()
        selectFriendsViewController.delegate = self
        
        inviteesTextField = createTextField(superview: wrapperView, relativeViewAbove: durationTextField, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing .rawValue, placeholderText: "Who's Invited?", showViewController: nil, colorViewColor: Colors.green.value)
        
        inviteInterestsTextField = createTextField(superview: wrapperView, relativeViewAbove: inviteesTextField, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing .rawValue, placeholderText: "Type of Invite", showViewController: nil, colorViewColor: Colors.blue.value)
        
        self.maxNumberOfAttendeesTextField = createTextField(superview: self.wrapperView, relativeViewAbove: inviteInterestsTextField, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing.rawValue, placeholderText: "Max Attendees", showViewController: nil, colorViewColor: Colors.blue.value)
        self.maxNumberOfAttendeesTextField.keyboardType = .numberPad
        
        locationTextField = createTextField(superview: wrapperView, relativeViewAbove: self.maxNumberOfAttendeesTextField, leftConstraintOffset: 0, rightConstraintOffset: 0, verticalSpacingToRelativeViewAbove: UIConstants.CreateInvitationVerticalSpacing .rawValue, placeholderText: "Location", showViewController: nil, colorViewColor: Colors.blue.value)
        
        setLocationSwitch()
        setupDurationTextFieldInputView()
        setRecurringView()
    }
    
    func setLocationSwitch () {
        let locationSwitch = UISwitch()
        locationSwitch.addTarget(self, action: #selector(locationSwitchPressed(sender:)), for: .valueChanged)
//        locationSwitch.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        locationSwitch.layer.zPosition = 1
        let locationTextFieldSuperView = self.locationTextField.superview
        locationTextFieldSuperView?.addSubview(locationSwitch)
        
        locationSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(locationTextFieldSuperView!).offset(-35)
            make.centerY.equalTo(locationTextFieldSuperView!.snp.centerY).offset(5)
        }
        
        let currentLocationLabel = UILabel(text: "Current Location")
        currentLocationLabel.font = UIFont.systemFont(ofSize: 14)
        currentLocationLabel.textColor = Colors.DarkGray.value
        currentLocationLabel.layer.zPosition = 1
        locationTextFieldSuperView?.addSubview(currentLocationLabel)
        currentLocationLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(locationSwitch)
            make.bottom.equalTo(locationSwitch.snp.top)
        }
        self.locationSwitch = locationSwitch
    }
    
    func createHeaderLabel () -> UILabel {
        let label = UILabel()
        label.text = "Create Invitation"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(20)
        }
        
        return label
    }
    
    // Whenever the user changes the date and the time the startingTimeTextField is updated with the selected information
    func startTimePickerDateChanged (sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let startDateAndTime = dateFormatter.string(from: sender.date)
        self.startingTime = sender.date
        
        if sender == self.quickInviteView.timeTextField.inputView {
            self.quickInviteView.timeTextField.text = startDateAndTime
        }
        else {
            startingTimeTextField.text = startDateAndTime
        }
    }
    
    // This is the view that contains all the other subviews.  It acts as a wrapper so that the scroll view works correctly
    func createWrapperView (myScrollView: UIScrollView) -> UIView {
        let myWrapperView = UIView()
        myWrapperView.backgroundColor = Colors.VeryLightGray.value
        myScrollView.addSubview(myWrapperView)
        myWrapperView.snp.makeConstraints { (make) in
            make.edges.equalTo(myScrollView)
            make.centerX.equalTo(myScrollView)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        return myWrapperView
    }
    
    // Scroll view which will basically act as our main view
    func createScrollView () -> UIScrollView {
        let myScrollView = UIScrollView()
        myScrollView.backgroundColor = Colors.VeryLightGray.value
        self.view.addSubview(myScrollView)
        myScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide as! ConstraintRelatableTarget)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomLayoutGuide as! ConstraintRelatableTarget)
        }
        
        return myScrollView
    }
    
    func createTextField (superview: UIView, relativeViewAbove: UIView!, leftConstraintOffset: Int, rightConstraintOffset: Int, verticalSpacingToRelativeViewAbove: Int, placeholderText: String, showViewController: UIViewController!, colorViewColor: UIColor) -> UITextField {
        let textField = UITextField()
        // The superview is the wrapper which contains all our elements within the scroll view
        textField.textAlignment = .left
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [ NSForegroundColorAttributeName : Colors.DarkGray.value ])
        textField.layer.borderWidth = 0
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = .white
        textField.delegate = self
        textField.textColor = Colors.DarkGray.value
    
        let textFieldContainerView = UIView()
        self.wrapperView.addSubview(textFieldContainerView)
        textFieldContainerView.backgroundColor = .white
        textFieldContainerView.snp.makeConstraints { (make) in
            if placeholderText != "Location" {
                make.height.equalTo(40)
            }
            else {
                make.height.equalTo(60)
            }
            make.left.equalTo(self.wrapperView)
            make.right.equalTo(self.wrapperView)
            if relativeViewAbove == nil {
                make.top.equalTo(self.wrapperView).offset(30)
            }
            else {
                make.top.equalTo(relativeViewAbove.snp.bottom).offset(5)
            }
        }
        
        textFieldContainerView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldContainerView).offset(20)
            if placeholderText == "Location" {
                make.right.equalTo(textFieldContainerView).offset(-100)
            }
            else {
                make.right.equalTo(textFieldContainerView).offset(-20)
            }
            make.top.equalTo(textFieldContainerView)
            make.bottom.equalTo(textFieldContainerView)
        }
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGray
        self.wrapperView.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { (make) in
            make.left.equalTo(self.wrapperView)
            make.right.equalTo(self.wrapperView)
            make.height.equalTo(0.25)
            make.top.equalTo(textFieldContainerView.snp.bottom)
        }
        
        return textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.selectedTextField != nil && textField == self.selectedTextField {
            self.selectedTextField = nil
            return false
        }
        
        return true
    }
    
    // When the text field is selected than change the color of the border
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextField = textField
        if textField == locationTextField {
            let autocompleteViewController = GMSAutocompleteViewController()
            autocompleteViewController.delegate = self            
            self.navigationController?.present(autocompleteViewController, animated: true, completion: nil)
        }
        else if textField == inviteInterestsTextField {
            let viewInterestsViewController = ViewInterestsViewController(setting: Settings.ViewInterestsCreateInvite, willPresentViewController: true)
            viewInterestsViewController.delegate = self
            viewInterestsViewController.wasPresented = true            
            let navController = UINavigationController(rootViewController: viewInterestsViewController)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
        else if textField == inviteesTextField {
            let viewUsersViewController = ViewUsersViewController(setting: Settings.ViewUsersInvite, willPresentViewController: true)            
            viewUsersViewController.showSpecificUsers(userObjectIds: PFUser.current()?.value(forKey: ParseObjectColumns.Friends.rawValue) as? [String])
            viewUsersViewController.delegate = self
            let navController = UINavigationController(rootViewController: viewUsersViewController)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
        else if textField == self.quickInviteView.locationTextField {
            let autocompleteViewController = GMSAutocompleteViewController()
            autocompleteViewController.delegate = self
            self.navigationController?.present(autocompleteViewController, animated: true, completion: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view
    }
}
// Handle the creation, source, and delegation for the duration text field
extension CreateInvitationViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func setupDurationTextFieldInputView () {
        var durationOptions:Array<String> = Array<String>()
        for counter in 1...20 {
            durationOptions.append(String((counter * 10)) + " mins")
        }
        
        let durationPicker = UIPickerView()
        durationPicker.dataSource = self
        durationPicker.delegate = self
        durationTextField.inputView = durationPicker
        self.durations = durationOptions
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.durations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.durations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationTextField.text = self.durations[row]
    }
}


// Quick Invite
extension CreateInvitationViewController {
    
    func cancelButtonPressed () {
        self.hideQuickView()
    }
    
    func hideQuickView () {
        // TODO: Move over to the QuickInviteController
        self.quickInviteView.superview?.isHidden = true
        self.quickMode = false
        self.sendButton.isHidden = false
    }
    
}

class ColorView : UIControl {
    var textField:UITextField!
    var showViewController:UIViewController!
}
