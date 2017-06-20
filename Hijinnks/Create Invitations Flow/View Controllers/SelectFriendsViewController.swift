//
//  SelectFriendsViewController.swift
//  Hijinnks
//
//  Created by adeiji on 2/24/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

class SelectFriendsViewController : UITableViewController {
    
    var friends:Array<String>!
    var presetOptions:Array<String> = [InviteesPresets.Anyone.rawValue, InviteesPresets.Everyone.rawValue]
    var kSectionPresets = 0
    var kSectionFriends = 1
    var kSectionPhoneContacts = 2
    var delegate:PassDataBetweenViewControllersProtocol!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
    }
    
    // Gets your friends from the server
    func getFriends () {
        
    }
}

extension SelectFriendsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == kSectionPresets {
            return presetOptions.count
        }
        
        else {
            return friends.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = presetOptions[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == kSectionPresets {
            if presetOptions[indexPath.row] as String == InviteesPresets.Everyone.rawValue {
                delegate.setSelectedFriendsToEveryone!()
                _  = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
