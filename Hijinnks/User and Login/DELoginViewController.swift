//  Converted with Swiftify v1.0.6274 - https://objectivec2swift.com/
//
//  DELoginViewController.swift
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//
import UIKit
import Parse
import ParseFacebookUtilsV4

class DELoginViewController: UIViewController, PassDataBetweenViewControllersProtocol {
// MARK: - IBOutlets
    var buttons: [UIButton]!
    var textFields: [UITextField]!
    weak var lblLoginMessage: UILabel!
    weak var btnSkip: UIButton!
    weak var createAccountButtonToBottomConstraint: NSLayoutConstraint!
    weak var skipButtonToBottomConstraint: NSLayoutConstraint!
    var txtUsernameOrEmail: UITextField!
    var txtPassword: UITextField!
    weak var lblErrorLabel: UILabel!
    var backgroundView: UIView!
    var isAccount: Bool = false
    var isPosting: Bool = false
    var loginView:DELoginView!
// MARK: - Button Press Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        // Check to see why this page is being displayed.
        if self.isAccount { // User is trying to access the settings and account page
            self.btnSkip.isHidden = true
        }
        if self.isPosting { // User is trying to post something
            
        }
        else {  // Prompting for them to login right at start up
            self.loginView = DELoginView()
            self.view.addSubview(self.loginView)
            self.loginView.signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
            self.loginView.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
            self.loginView.facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonPressed), for: .touchUpInside)
            loginView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.view)
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // Login using facebook and get their public profile and email address
    func facebookLoginButtonPressed () {
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile","email"]) { (user, error) in
            if(error != nil)
            {
                //Display an alert message
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert);
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                myAlert.addAction(okAction);
                self.present(myAlert, animated:true, completion:nil);
                
                return
            }
            // Is Facebook active
            if(FBSDKAccessToken.current() != nil)
            {
                if user != nil {
                    // If the user has no interests selected yet, than prompt him to add some
                    if user?.object(forKey: ParseObjectColumns.Interests.rawValue) == nil {
                        let viewInterestsViewController = ViewInterestsViewController(setting: Settings.ViewInterestsCreateAccount, willPresentViewController: false)
                        viewInterestsViewController.delegate = self
                        viewInterestsViewController.showExplanationView()
                        self.navigationController?.pushViewController(viewInterestsViewController, animated: true)
                    }
                    else {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.setupNavigationController()
                    }
                    
                    DEUserManager.sharedManager.setupSendBird(userId: (user?.objectId)!)
                }
            }
            self.getProfileInformationFromFacebook()
            // Connect this user with Send Bird
        }
    }
    
    /**
     * - Description Delegat Method - activated when the user has selected an interests on the ViewInterestsViewController object
     * - Parameter Array<String> mySelectedInterests - The interests that the user has selected
     * - Code 
     ```
        let selectedRowsIndexPaths = self.tableView.indexPathsForSelectedRows
        var selectedInterests:Array<String> = Array<String>()
     
        for indexPath in selectedRowsIndexPaths! {
            let interest = tableData[indexPath.row]
            selectedInterests.append(interest as! String)
        }
     
        delegate.setSelectedInterests!(mySelectedInterest: selectedInterests)
        // Handle the exit of the view controller
     ```
     */
    func setSelectedInterests(mySelectedInterest: Array<String>) {
        PFUser.current()?.setObject(mySelectedInterest, forKey: ParseObjectColumns.Interests.rawValue)
        PFUser.current()?.saveInBackground()
        // Once the user has selected the interests that he wants than we show the main tab controller
        let tabBarController = MainTabBarController()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window!?.rootViewController = tabBarController
    }
    
    func getProfileInformationFromFacebook () {
        let requestParameters = ["fields": "id, email, first_name, last_name, name"]
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        _ = userDetails?.start(completionHandler: { (connection, result, error) in
            if(error != nil)
            {
                print("\(error?.localizedDescription)")
                return
            }
            
            if(result != nil)
            {
                let myResult = result as! [String:AnyObject]
                let userId:String = myResult["id"] as! String
                let name:String = myResult["name"] as! String
                let userFirstName:String? = myResult["first_name"] as? String
                let userLastName:String? = myResult["last_name"] as? String
                let userEmail:String? = myResult["email"] as? String
                print("\(userEmail)")
                
                // Save first name
                if(userFirstName != nil)
                {
                    PFUser.current()!.setObject(userFirstName!, forKey: ParseObjectColumns.FirstName.rawValue)
                }
                
                //Save last name
                if(userLastName != nil)
                {
                    PFUser.current()!.setObject(userLastName!, forKey: ParseObjectColumns.LastName.rawValue)
                }
                
                // Save email address
//                if(userEmail != nil)
//                {
//                    PFUser.current()!.email = userEmail
//                }
                
                PFUser.current()!.username = name
                
                DispatchQueue.global().async {
                    // Get Facebook profile picture
                    let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    let profilePictureUrl = NSURL(string: userProfile)
                    let profilePictureData = NSData(contentsOf: profilePictureUrl! as URL)
                    if(profilePictureData != nil) {
                        let profileFileObject = PFFile(data:profilePictureData! as Data)
                        PFUser.current()!.setObject(profileFileObject!, forKey: "profile_picture")
                    }
                    
                    PFUser.current()!.saveInBackground(block: { (success, error) -> Void in
                        if(success) {
                            print("User details are now updated")
                        }
                    })
                }
            }
        })
    }
    
    func signUpButtonPressed () {
        let createAccountViewController = CreateAccountViewController()
        self.navigationController?.pushViewController(createAccountViewController, animated: true)
    }
    
    func signInButtonPressed () {
        
        // If the password text field is hidden then we know that the user has already pressed sign in once
        if (self.loginView.txtPassword.isHidden == false) {
            _ = DEUserManager.sharedManager.login(username: self.loginView.txtUsernameOrEmail.text!, password: self.loginView.txtPassword.text!, viewController: self, errorLabel: self.loginView.errorLabel)
        }
        else {
            self.loginView.txtPassword.isHidden = false
            self.loginView.txtUsernameOrEmail.isHidden = false
        }
    }
    
    func createAnAccount(_ sender: Any) {
        
    }

    func goBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func sign(in sender: Any) {
        let view: DELoginView? = (self.view as? DELoginView)
        let userManager = DEUserManager.sharedManager
        
        let nextViewController = UIViewController()
        _ = userManager.login(username: (view?.txtUsernameOrEmail?.text)!, password: (view?.txtPassword?.text)!, viewController: nextViewController, errorLabel: self.lblErrorLabel)
    }

    func skipLogin(_ sender: Any) {
    }

    let CREATE_ACCOUNT_VIEW_CONTROLLER = "createAccountViewController"
    let VIEW_RESTAURANTS_VIEW_CONTROLLER: String = "ViewRestaurantsViewController"
    let VIEW_RESTAURANTS_STORYBOARD: String = "ViewRestaurants"

    func setUpCreateAccountView() {
        if (self.view is DECreateAccountView) {
            let view: DECreateAccountView? = (self.view as? DECreateAccountView)
            view?.txtPassword?.layer.borderColor = UIColor(red: CGFloat(203.0 / 255.0), green: CGFloat(80.0 / 255.0), blue: CGFloat(134.0 / 255.0), alpha: CGFloat(1.0)).cgColor
            view?.txtConfirmPassword?.layer.borderColor = UIColor(red: CGFloat(203.0 / 255.0), green: CGFloat(80.0 / 255.0), blue: CGFloat(134.0 / 255.0), alpha: CGFloat(1.0)).cgColor
            view?.txtUsername?.layer.borderColor = UIColor(red: CGFloat(76.0 / 255.0), green: CGFloat(161.0 / 255.0), blue: CGFloat(182.0 / 255.0), alpha: CGFloat(1.0)).cgColor
            view?.txtEmail?.layer.borderColor = UIColor(red: CGFloat(76.0 / 255.0), green: CGFloat(161.0 / 255.0), blue: CGFloat(182.0 / 255.0), alpha: CGFloat(1.0)).cgColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
