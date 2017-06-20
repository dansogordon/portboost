//
//  OptionsViewController.swift
//  Hijinnks
//
//  Created by adeiji on 3/11/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MessageUI
import FBSDKLoginKit
import FBSDKShareKit

class OptionsViewController : UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, PassDataBetweenViewControllersProtocol {
    
    /**
     * - Description The options that the user can select
     */
    let options = [ProfileOptions.ReportProblem.rawValue, ProfileOptions.Logout.rawValue, ProfileOptions.ChangeInterests.rawValue, ProfileOptions.InviteFacebookFriends.rawValue]
    
    override func viewDidLoad() {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "option")
        cell.textLabel?.text = options[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = options[indexPath.row]
        if selectedOption == ProfileOptions.Logout.rawValue {
            confirmLogout()
        } else if selectedOption == ProfileOptions.ReportProblem.rawValue {
            showEmailScreen()
        } else if selectedOption == ProfileOptions.ChangePassword.rawValue {
            let changePasswordViewController = ChangePasswordViewController()
            self.navigationController?.pushViewController(changePasswordViewController, animated: true)
        } else if selectedOption == ProfileOptions.ChangeInterests.rawValue {
            let viewInterestsViewController = ViewInterestsViewController(setting: Settings.ViewInterestsChangeInterests, willPresentViewController: false)
            viewInterestsViewController.delegate = self
            self.navigationController?.pushViewController(viewInterestsViewController, animated: true)
        } else if selectedOption == ProfileOptions.InviteFacebookFriends.rawValue {
            // Send an invitation to facebook users
            self.postToFacebook()
        }
    }
    
    /**
     * - Description Post to Facebook
     */
    func postToFacebook () {
        let content = FBSDKShareLinkContent()
        content.contentTitle = "Invite Friends"
        content.contentURL = NSURL(string: "http://hijinnks.com") as URL!
        content.contentDescription = "Become a beta tester for Hijinnks!"
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }
    
    func showEmailScreen () {
        if MFMailComposeViewController.canSendMail() {            
            let mailViewController = MFMailComposeViewController()
            mailViewController.setSubject("Report")
            mailViewController.setToRecipients(["adebayoiji@gmail.com", "info@hijinnks.com"])
            mailViewController.setMessageBody("Uh oh!  Looks like there was an issue with the application.", isHTML: false)
            mailViewController.mailComposeDelegate = self
            self.present(mailViewController, animated: true, completion: nil)
        }
        else {
            print("User cannot send emails with this device")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func confirmLogout () {
        let alertController = UIAlertController(title: "Logout", message: "Are You Sure You Want To Log Out?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            PFUser.logOutInBackground()
            // Show the login by removing all the current views and making the login view controller the root
            (UIApplication.shared.delegate as! AppDelegate).showLoginView()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setSelectedInterests(mySelectedInterest: Array<String>) {
        PFUser.current()?.setObject(mySelectedInterest, forKey: ParseObjectColumns.Interests.rawValue)
        PFUser.current()?.saveInBackground()
    }
}

class LogoutCellView : UITableViewCell {
    
    weak var yesButton:UIButton!
    weak var noButton:UIButton!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        // No button must come first because the yes button constraints are based on the no button
        setNoButton()
        setYesButton()
    }
    
    func setYesButton () {
        let yesButton = UIButton()
        yesButton.setTitle("Yes", for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.backgroundColor = Colors.invitationTextGrayColor.value
        self.contentView.addSubview(yesButton)
        yesButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.noButton.snp.left).offset(20)
            make.centerY.equalTo(self.noButton)
            
        }
        self.yesButton = yesButton
    }
    
    func setNoButton () {
        let noButton = UIButton()
        noButton.setTitle("No", for: .normal)
        noButton.setTitleColor(.white, for: .normal)
        noButton.layer.borderWidth = 2
        noButton.layer.borderColor = Colors.invitationTextGrayColor.value.cgColor
        self.contentView.addSubview(noButton)
        noButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(20)
            make.width.equalTo(100)
            make.centerY.equalTo(self.contentView)
        }
        
        self.noButton = noButton
    }
    
}
