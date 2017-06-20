//
//  CreateAccountViewController.swift
//  Hijinnks
//
//  Created by adeiji on 3/9/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse

class CreateAccountViewController : UIViewController, PassDataBetweenViewControllersProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var createAccountView:DECreateAccountView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        self.createAccountView = DECreateAccountView()
        self.view.addSubview(createAccountView)
        self.createAccountView.setupUI()
        self.createAccountView.signupButton.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
        self.createAccountView.termsAndConditionsButton.addTarget(self, action: #selector(termsAndConditionsButtonPressed), for: .touchUpInside)
        self.createAccountView.licenseAgreementButton.addTarget(self, action: #selector(licenseAgreementButtonPressed), for: .touchUpInside)
    }

    func termsAndConditionsButtonPressed () {
        let termsAndConditionsURL = NSURL(string: "https://hijinnksdocs.wordpress.com/2017/05/09/terms-and-conditions/")
        UIApplication.shared.open(termsAndConditionsURL as! URL, options: [:], completionHandler: nil)
    }
    
    func licenseAgreementButtonPressed () {
        let licenseAgreementURL = NSURL(string: "https://hijinnksdocs.wordpress.com/2017/05/09/license-agreement/")
        UIApplication.shared.open(licenseAgreementURL as! URL, options: [:], completionHandler: nil)
    }
    
    /*!
     * - Description When the user presses the Sign Up button we sign him in and prompt for a picture
     */
    func signupButtonPressed () {
        
        if self.createAccountView.checkbox.isSelected == true {
            let username = createAccountView.txtUsername.text
            let password = createAccountView.txtPassword.text
            let email = createAccountView.txtEmail.text
            let phoneNumber = createAccountView.txtPhoneNumber.text
            
            let viewInterestsViewController = ViewInterestsViewController(setting: Settings.ViewInterestsCreateAccount, willPresentViewController: false)
            viewInterestsViewController.delegate = self
            viewInterestsViewController.showExplanationView()
            // Create user and then display the view interests view controller upon success
            DEUserManager.sharedManager.createUser(withUserName: username!, password: password!, email: email!, phoneNumber: phoneNumber!, errorLabel: createAccountView.lblUsernameError, showViewControllerOnComplete: viewInterestsViewController)
        } else {
            let alertController = UIAlertController(title: "Terms and Conditions", message: "Please accept the terms and conditions for the application", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setSelectedInterests(mySelectedInterest: Array<String>) {
        PFUser.current()?.setObject(mySelectedInterest, forKey: ParseObjectColumns.Interests.rawValue)
        PFUser.current()?.saveInBackground()
        // Once the user has selected the interests that he wants than we show the main tab controller
        let tabBarController = MainTabBarController()
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window!?.rootViewController = tabBarController
    }
}
