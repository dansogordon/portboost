//
//  ViewUsersViewController.swift
//  Hijinnks
//
//  Created by adeiji on 3/13/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ViewUsersViewController : UITableViewController {
    
    var setting:Settings
    var friends:[PFUser] = [PFUser]()
    var groupOptions:[String] = ["All Your Friends", "Make Public to Anyone"]
    var kFriendIndexPath = 1
    var kGroupIndexPath = 0
    var kContactsIndexPath = 2
    var phoneContacts = ContactsController.getContacts()
    var delegate:PassDataBetweenViewControllersProtocol! // CreateInvitationViewController
    /// If this value is set to true than that means that this view controller was presented not pushed onto the view controller stack.
    var wasPresented:Bool = false
    var activitySpinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    func startActivitySpinner () {
        // Add the activity spinner
        self.activitySpinner.startAnimating()
        self.activitySpinner.hidesWhenStopped = true
        
        self.view.addSubview(self.activitySpinner)
        self.activitySpinner.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
    }
    
    init(setting: Settings, willPresentViewController: Bool) {
        self.setting = setting
        super.init(style: .plain)
        
        if setting == Settings.ViewUsersInvite {
            self.tableView.allowsMultipleSelection = true
        }
        else if setting == Settings.ViewUsersAll || setting == Settings.ViewPeopleComing {
            self.tableView.allowsMultipleSelection = false
        }
        
        self.wasPresented = willPresentViewController
    }
    
    func showAllUsers () {
        let query = PFUser.query()
        query?.whereKey(ParseObjectColumns.ObjectId.rawValue, notEqualTo: PFUser.current()?.objectId! as Any)
        query?.findObjectsInBackground(block: { (users, error) in
            if (error != nil) {
                print((error?.localizedDescription)! as String)
            }
            else if (users != nil) {
                self.friends = users as! [PFUser]
                self.tableView.reloadData()
            }
        })
    }
    
    func showSpecificUsers (userObjectIds : [String]!) {
        self.startActivitySpinner()
        if userObjectIds != nil {
            let query = PFUser.query()
            query?.whereKey(ParseObjectColumns.ObjectId.rawValue, containedIn: userObjectIds)
            query?.findObjectsInBackground(block: { (friends, error) in
                self.friends = friends as! [PFUser]
                self.tableView.reloadData()
                self.activitySpinner.stopAnimating()
            })
        } else {
            self.activitySpinner.stopAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if setting == Settings.ViewUsersInvite {
            let doneButton = UIBarButtonItem()
            doneButton.title = "Done"
            doneButton.target = self
            doneButton.action = #selector(doneButtonPressed)
            self.navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "header.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // Inform the delegate that the users have been selected
    func doneButtonPressed () {
        let selectedFriends = NSMutableArray()
        let selectedContacts = NSMutableArray()
        let indexPaths = self.tableView.indexPathsForSelectedRows
        if indexPaths != nil {  // If the user has actually selectred a person
            for indexPath in indexPaths! {
                if indexPath.section == kFriendIndexPath {
                    // Get each indexPath
                    let user = self.friends[indexPath.row]
                    selectedFriends.add(user)
                }
                else if indexPath.section == kContactsIndexPath {
                    let contact = self.phoneContacts[indexPath.row]
                    selectedContacts.add(contact)
                }
            }
            delegate.setSelectedFriends!(mySelectedFriends: selectedFriends)
            delegate.setSelectedContacts!(mySelectedContacts: selectedContacts)
        }
        if self.wasPresented
        {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if setting == Settings.ViewUsersInvite {
            return 3
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if setting == Settings.ViewPeopleComing {
            return "People Coming"
        }
        else if setting == Settings.ViewUsersInvite {
            if section == kContactsIndexPath {
                return "Phone Contacts"
            }
            else if section == kFriendIndexPath {
                return "Select From Friends"
            }
            else {
                return "Preset"
            }
        }
        else {
            return "Select A User"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == kContactsIndexPath {
            return phoneContacts.count
        }
        
        if setting == Settings.ViewUsersInvite {
            if section == kFriendIndexPath {
                return self.friends.count
            }
            else {
                return self.groupOptions.count
            }
        }
        else {
            return self.friends.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if setting == Settings.ViewUsersAll || setting == Settings.ViewPeopleComing {   // If we need to view all the users
            let userCell = UserCell(user: self.friends[indexPath.row])
            userCell.setupUI()
            userCell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0)
            return userCell
        } else if setting == Settings.ViewUsersInvite {   // If the user is currently creating an invitation
            if indexPath.section == kFriendIndexPath {
                let userCell = UserCell(user: self.friends[indexPath.row])
                userCell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0)
                userCell.setupUI()
                return userCell
            }
            else if indexPath.section == kContactsIndexPath {
                let contactCell = ContactTableViewCell(contact: phoneContacts[indexPath.row])
                contactCell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0)
                contactCell.setupUI()
                return contactCell
            }
            else {
                let cell = UITableViewCell()
                cell.textLabel?.text = groupOptions[indexPath.row]                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var shouldDismiss = true
        if setting == Settings.ViewUsersAll || setting == Settings.ViewPeopleComing {
            let profileViewController = ProfileViewController(user: self.friends[indexPath.row])
            self.navigationController?.pushViewController(profileViewController, animated: true)
        } else if setting == Settings.ViewUsersInvite {
            if indexPath.section == kGroupIndexPath {
                if indexPath.row == 0 {  // all your friends
                    if delegate != nil {
                        if self.friends.count > 0 {
                            delegate!.setSelectedFriendsToEveryone!()
                        }
                        else {
                            let alert = UIAlertController(title: "No Friends Yet", message: "Ooops, it seems you don't have any friends in the app yet.", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                            alert.addAction(okayAction)
                            self.present(alert, animated: true, completion: nil)
                            shouldDismiss = false
                            tableView.deselectRow(at: indexPath, animated: false)
                        }
                    }
                }
                else {
                    if delegate != nil {
                        delegate.setSelectedFriendsToAnyone!()
                    }
                }
                
                if self.wasPresented && shouldDismiss == true
                {
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}

class UserCell : UITableViewCell {
    
    weak var usernameLabel:UILabel!
    weak var profileImageView:UIImageView!
    weak var user:PFUser!
    
    init(user: PFUser) {
        super.init(style: .default, reuseIdentifier: "user_cell")
        self.user = user
    }
    
    func setupUI() {
        setProfileImage()
        setUsernameLabel()
    }
    
    func setUsernameLabel () {
        let label = UILabel(text: user.username!)
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.profileImageView.snp.right).offset(10)
        }
        self.usernameLabel = label
    }
    
    func setProfileImage () {
        let imageView = UIImageView()
        self.contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        self.profileImageView = imageView
        self.loadProfileImage()
    }
    
    func loadProfileImage () {
        
        let imageFile = self.user.value(forKey: ParseObjectColumns.Profile_Picture.rawValue) as? PFFile
        if imageFile != nil {
            imageFile?.getDataInBackground(block: { (imageData, error) in
                if error == nil && imageData != nil {
                    let image = UIImage(data: imageData!)
                    self.profileImageView.image = image
                }
                else {
                    print("Error retrieving image from server - \(error?.localizedDescription)")
                }
            })
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
