//  Converted with Swiftify v1.0.6274 - https://objectivec2swift.com/
//
//  DESettingsAccount.swift
//  whatsgoinon
//
//  Created by adeiji on 8/19/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//
import UIKit
import Parse

class DESettingsAccount: UIView, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var isPublic: Bool = false
    var user: PFUser!
    var promptView: UIView!
    var activeField: UITextField!
    let PARSE_CLASS_USER_CANONICAL_USERNAME = "canonical_username"
    let PARSE_CLASS_USER_USERNAME = "username"
// MARK: - View Outlets
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    /*
     
     Displays since when the user has had a happsnap login
     
     */
    @IBOutlet weak var lblMemberSince: UILabel!
    /*
     
     Displays the number of events that the user has posted since he has been a HappSnap member
     
    */
    @IBOutlet weak var lblNumberOfPosts: UILabel!
    /*
     
     These switches are used to be able to know if they have enabled facebook and twitter to be used within the application - (These switches will most likely be removed before release)
     
     */
    @IBOutlet weak var switchFacebook: UISwitch!
    @IBOutlet weak var switchTwitter: UISwitch!
    /*
     
     The button that the user clicks when they want to take their profile picture.  This button also displays the profile picture after it has been taken.
     
     */
    @IBOutlet weak var btnSendFeedback: UIButton!
    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var bottomViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnChangePassword: UIButton!
    /*
     
     Displays the rank of the user. For ex: Ambassador, standard, Admin etc
     
     */
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblConnected: UILabel!
    var viewToHide: UIView!
    @IBOutlet weak var lblTwitter: UILabel!
    @IBOutlet weak var lblProgressToNextLevel: UILabel!
    /*
     
     This progress bar shows how far the user is until the next level
     
     */
    @IBOutlet weak var progressBarForLevel: UIProgressView!
    @IBOutlet weak var lblTitle: UILabel!
    /*
     
     When the user clicks on change password then this is the view that goes down.  It contains everything from Change Password Button and Below.
     
     */
    @IBOutlet weak var bottomHalfView: UIView!
    @IBOutlet weak var lblPasswordError: UILabel!
// MARK: - Button Actions

    required init(user myUser: PFUser, isPublic myIsPublic: Bool) {
        super.init(frame: .zero)
        
        user = myUser
        isPublic = myIsPublic
        DEUserManager.sharedManager.getUserRank(myUser.username!)
        self.lblRank.text = ""
        self.setUpTextFields()

        //        [self displayProfilePicture];
        self.btnChangePassword.addTarget(self, action: #selector(self.changePasswordPressed), for: .touchUpInside)
        self.txtUsername.text = PFUser.current()?.username
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func takePicture(_ sender: Any) {
        // Use Alert View Controller
//        var actionSheet = UIActionSheet(title: {0
//        actionSheet.show(in: self)
//        actionSheet.tag = PICTURE_ACTION_SHEET
    }

    @IBAction func sendFeedback(_ sender: Any) {
        // Use Alert View Controller
//        var actionSheet = UIActionSheet(title: {0
//        actionSheet.tag = FEEDBACK_ACTION_SHEET
//        DEScreenManager.shared.nextScreen = DEScreenManager.getMainNavigationController().topViewController
//        actionSheet.show(in: self)
    }
    /*
     
     Display a prompt asking if the user wants to quit for sure
     
     */

    @IBAction func signOut(_ sender: Any) {
        if DEUserManager.sharedManager.isLoggedIn() {
//            promptView = Bundle.main.loadNibNamed("ViewSettingsAccount", owner: self, options: nil).last
//            promptView.frame = self.frame
            // Set up the view of the prompt screen
//            self.setUpPromptViewButtons()
        }
        else {
//            var loginViewController: DELoginViewController? = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: PROMPT_LOGIN_VIEW_CONTROLLER)
//            loginViewController?.btnSkip?.isHidden = true
//            DEScreenManager.getMainNavigationController().pushViewController(loginViewController, animated: true)
        }
    }
     
    // Signs the user out of the app
    @IBAction func signOutUser(_ sender: Any) {
        PFUser.logOut()
        self.btnSignOut.setTitle("Sign Up", for: .normal)
        NotificationCenter.default.removeObserver(self)
        promptView.removeFromSuperview()
        // Take the user back to the main view controller
    }

    @IBAction func changePasswordPressed(_ sender: Any) {
        // Move the view that contains the buttons and the social media prompts down
        self.changePasswordButtonFunction()
    }

    let FEEDBACK_ACTION_SHEET: Int = 1
    let PICTURE_ACTION_SHEET: Int = 2


    // MARK: - Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(self.txtPassword) {
            let password = self.txtPassword.text as NSString?
            // Check to make sure that the new and old passwords actually match
            if (password?.replacingCharacters(in: range, with: string) == self.txtConfirmPassword.text) {
                self.btnChangePassword.setTitle("Save New Password", for: .normal)
                self.btnChangePassword.removeTarget(self, action: #selector(self.cancel), for: .touchUpInside)
                self.btnChangePassword.addTarget(self, action: #selector(self.savePassword), for: .touchUpInside)
            }
            else {
                self.btnChangePassword.setTitle("Cancel", for: .normal)
                self.btnChangePassword.removeTarget(self, action: #selector(self.savePassword), for: .touchUpInside)
                self.btnChangePassword.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
            }
        }
        else if textField.isEqual(self.txtConfirmPassword) {
            let confirmPassword = self.txtConfirmPassword.text as NSString?
            if (confirmPassword?.replacingCharacters(in: range, with: string) == self.txtPassword.text) {
                self.btnChangePassword.setTitle("Save New Password", for: .normal)
                self.btnChangePassword.removeTarget(self, action: #selector(self.cancel), for: .touchUpInside)
                self.btnChangePassword.addTarget(self, action: #selector(self.savePassword), for: .touchUpInside)
            }
            else {
                self.btnChangePassword.setTitle("Cancel", for: .normal)
                self.btnChangePassword.removeTarget(self, action: #selector(self.savePassword), for: .touchUpInside)
                self.btnChangePassword.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
            }
        }
        
        return true
        
    }


    func setUpTextFields() {        
        if (user.object(forKey: PARSE_CLASS_USER_CANONICAL_USERNAME) != nil) {
            self.txtUsername.text = user.object(forKey: PARSE_CLASS_USER_CANONICAL_USERNAME) as! String?
        }
        else {
            self.txtUsername.text = user.object(forKey: PARSE_CLASS_USER_USERNAME) as! String?
        }
        self.txtPassword.delegate = self
        self.txtConfirmPassword.delegate = self
    }

    // MARK: - Button Presses
    /*
        Signs the user out of the app
        If the user has clicked on change password then we display the password text fields
     */

    func changePasswordButtonFunction() {
        self.btnChangePassword.setTitle("Cancel", for: .normal)
        // Remove the target first then add the new target otherwise this will not work
        self.btnChangePassword.removeTarget(self, action: #selector(self.changePasswordPressed), for: .touchUpInside)
        self.btnChangePassword.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        self.txtPassword.isHidden = false
        self.txtConfirmPassword.isHidden = false
    }
    // MARK: - Change Password Button Functionality
    // User presses the cancel button and we just want to hide the password text fields
     
    func cancel() {
        self.txtPassword.isHidden = true
        self.txtConfirmPassword.isHidden = true
        self.btnChangePassword.setTitle("Change Password", for: .normal)
        self.btnChangePassword.removeTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        self.btnChangePassword.addTarget(self, action: #selector(self.changePasswordPressed), for: .touchUpInside)
        let height: CGFloat = UIScreen.main.bounds.size.height
        if height < 500 {
            var frame: CGRect = self.frame
            frame.size.height -= 80
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                self.frame = frame
            })
            let scrollView: UIScrollView? = (self.superview as? UIScrollView)
            let topOffset = CGPoint(x: CGFloat(0), y: CGFloat(0))
            scrollView?.setContentOffset(topOffset, animated: true)
        }
    }

    func savePassword() {
        // Save the new password to the parse database
        DEUserManager.sharedManager.changePassword(self.txtPassword.text!)
        self.txtConfirmPassword.isHidden = true
        self.txtPassword.isHidden = true
        self.lblPasswordError.text = "Password Saved"
        self.txtConfirmPassword.text = ""
        self.lblPasswordError.textAlignment = .center
        self.txtConfirmPassword.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
}
