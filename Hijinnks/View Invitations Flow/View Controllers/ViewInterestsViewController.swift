//
//  ViewInterestsViewController.swift
//  Hijinnks
//
//  Created by adeiji on 2/23/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse
import SnapKit

@objc protocol PassDataBetweenViewControllersProtocol {
    @objc optional func setSelectedInterests(mySelectedInterest: Array<String>)
    @objc optional func setSelectedFriends(mySelectedFriends: NSArray)
    @objc optional func setSelectedContacts(mySelectedContacts: NSArray)
    @objc optional func setSelectedFriendsToEveryone ()
    @objc optional func setSelectedFriendsToAnyone ()
    @objc optional func addInvitation (invitation: InvitationParseObject)
    @objc optional func showInvitationCommentScreen (invitation: InvitationParseObject)
    @objc optional func loggedIn ()
    @objc optional func loadInvitations (invitations: [InvitationParseObject])
    @objc optional func rsvpButtonPressed (invitation: InvitationParseObject, invitationCell: ViewInvitationsCell, userDetails: UserDetailsParseObject)
    @objc optional func profileImagePressed (user: PFUser)
    @objc optional func viewRsvpListButtonPressed (invitation: InvitationParseObject)
    
}

class ViewInterestsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource   {
    
    var tableData:NSArray!
    var delegate:PassDataBetweenViewControllersProtocol!
    var tableView = UITableView()
    var setting:Settings
    var explanationLabel:UILabel!
    var wasPresented:Bool = false
    
    func getInterests () -> NSArray {
        
        let path = Bundle.main.path(forResource: kInterestsPlistFile, ofType: fileType.plist.rawValue)
        let myInterests = NSArray(contentsOfFile: path!)
        
        return myInterests!
    }
    /**
     * - Description Initialize the ViewInterestsViewController
     * - Parameter setting (Settings) - What is the main purpose for this view controller, ex.  To select interest for an invite, for a new friend, or to change interests for your profile
     * - Parameter willPresentViewController Bool - Will you be presenting this view controller or pushing onto the stack?
     ```
        let viewController = ViewInterestsViewController(setting: Settings.ViewInterestsCreateInvite, willPresentViewController: true)
        let viewController = ViewInterestsViewController(setting: Settings.ViewInterestsAddFriend, willPresentViewController: true)
        let viewController = ViewInterestsViewController(setting: Settings.ViewInterestsCreateAccountOrChangeInterests, willPresentViewController: true)
     ```
     */
    init(setting: Settings, willPresentViewController: Bool) {
        self.setting = setting
        super.init(nibName: nil, bundle: nil)
        wasPresented = willPresentViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = getInterests()
        setupUI()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(getAllSelectedInterests))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupUI () {
        self.view.backgroundColor = .white
        if setting == Settings.ViewInterestsCreateInvite {
            setExplanationLabel(text: "Please select interests that you feel fit this invitation.")
            setTableView(explanationLabel: self.explanationLabel)
        }
        else if setting == Settings.ViewInterestsAddFriend {
            setExplanationLabel(text: "Please select interests that this friend will be affiliated with.")
            setTableView(explanationLabel: self.explanationLabel)
        }
        else if setting == Settings.ViewInterestsCreateAccount || setting == Settings.ViewInterestsChangeInterests {
            setExplanationLabel(text: "Please select interests that you would like to receive invitations for.")
            setTableView(explanationLabel: self.explanationLabel)
        }
    }
    // The label that provides an explanation of what they are to do with this view
    func setExplanationLabel (text: String) {
        self.explanationLabel = UILabel()
        self.explanationLabel.text = text
        self.explanationLabel.numberOfLines = 0
        self.explanationLabel.textAlignment = .center
        self.explanationLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightBold)
        self.view.addSubview(self.explanationLabel)
        self.explanationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
            make.height.equalTo(75)
        }
    }
    
    func setTableView (explanationLabel: UILabel!) {
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsMultipleSelection = true
        self.tableView.separatorColor = Colors.TableViewSeparatorColor.value
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            if explanationLabel == nil {
                make.edges.equalTo(self.view)
            }
            else {
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-75)
                make.top.equalTo(explanationLabel.snp.bottom)
            }
        }
    }
    
    func showExplanationView () {
        let explanationView = ExplanationView()
        self.view.addSubview(explanationView)
        explanationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    // Gets all the interests that are selected in the TableView and stores them in an array
    func getAllSelectedInterests () {
        
        let selectedRowsIndexPaths = self.tableView.indexPathsForSelectedRows
        var selectedInterests:Array<String> = Array<String>()
        if selectedRowsIndexPaths != nil {
            for indexPath in selectedRowsIndexPaths! {
                let interest = tableData[indexPath.row]
                selectedInterests.append(interest as! String)
            }
            
            delegate.setSelectedInterests!(mySelectedInterest: selectedInterests)
        } // If the user has created an account and they are trying to go through without selecting an interests, than we prompt them to select 2
        else if selectedRowsIndexPaths == nil && (setting == Settings.ViewInterestsCreateAccount || setting == Settings.ViewInterestsAddFriend) {
            let alertController = UIAlertController(title: "Interests", message: "Please select some interest", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        if setting != Settings.ViewInterestsCreateAccount {
            if wasPresented
            {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension ViewInterestsViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Interests"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = (tableData[indexPath.row] as! String)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        return cell
    }
}
