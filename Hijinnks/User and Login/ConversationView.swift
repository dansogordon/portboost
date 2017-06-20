//
//  ConversationView.swift
//  Hijinnks
//
//  Created by adeiji on 3/23/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ConversationView : UIView {
    
    var listOfUsersView:UIView!
    var messagesTableView:UITableView!
    var messageTextField:UITextField!
    var user:PFUser!
    var keyboardHeight:CGFloat!
    var sendButton:UIButton!
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        setListOfUsersView()
        setMessageTextField()
        setMessagesTableView()
        setSendButton()
        self.backgroundColor = .white
    }
    
    func keyboardWillShow (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.messageTextField.snp.remakeConstraints { (make) in
                make.left.equalTo(self).offset(5)
                make.right.equalTo(self).offset(-75)
                make.bottom.equalTo(self).offset(-keyboardHeight)
                make.height.equalTo(50)
            }
        }
    }
    
    func setSendButton () {
        self.sendButton = UIButton()
        self.sendButton.setTitle("Send", for: .normal)
        self.sendButton.setTitleColor(.white, for: .normal)
        self.sendButton.backgroundColor = Colors.blue.value
        self.addSubview(self.sendButton)
        self.sendButton.snp.makeConstraints { (make) in
            make.right.equalTo(self)
            make.width.equalTo(75)
            make.height.equalTo(50)
            make.centerY.equalTo(self.messageTextField)
        }
    }
    
    func setMessageTextField () {
        self.messageTextField = UITextField()
        self.messageTextField.becomeFirstResponder()
        self.messageTextField.backgroundColor = .white
        self.addSubview(self.messageTextField)
        self.messageTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-75)
            make.height.equalTo(50)
        }
    }
    
    func setMessagesTableView () {
        self.messagesTableView = UITableView()
        self.messagesTableView.separatorStyle = .none
        self.messagesTableView.layer.borderWidth = 0.5
        self.messagesTableView.layer.borderColor = UIColor.gray.cgColor
        self.addSubview(self.messagesTableView)
        self.messagesTableView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(-1)
            make.right.equalTo(self).offset(1)
            make.top.equalTo(self.listOfUsersView.snp.bottom)
            make.bottom.equalTo(self.messageTextField.snp.top)
        }
    }
    
    func setListOfUsersView () {
        self.listOfUsersView = UIView()
        self.listOfUsersView.backgroundColor = .white
        self.listOfUsersView.layer.borderColor = UIColor.gray.cgColor
        self.listOfUsersView.layer.borderWidth = 0.5
        self.addSubview(self.listOfUsersView)
        self.showUsers()
        self.listOfUsersView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(-1)
            make.top.equalTo(self)
            make.right.equalTo(self).offset(1)
            make.height.equalTo(50)
        }
    }
    
    // Show a list of users that are part of this conversation
    func showUsers () {
        
        let profileImageView = UIImageView()
        loadProfileImage(profileImageView: profileImageView)
        let profileNameLabel = UILabel()
        profileNameLabel.text = self.user.username
        self.listOfUsersView.addSubview(profileImageView)
        self.listOfUsersView.addSubview(profileNameLabel)
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.listOfUsersView).offset(10)
            make.centerY.equalTo(self.listOfUsersView)
            make.height.equalTo(45)
            make.width.equalTo(45)
        }
        profileImageView.layer.cornerRadius = 45/2.0
        profileImageView.clipsToBounds = true
        
        profileNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView.snp.right).offset(5)
            make.centerY.equalTo(self.listOfUsersView)
        }
    }
    
    // Get the image from the server and display it
    func loadProfileImage (profileImageView: UIImageView!) {
        if self.user.value(forKey: ParseObjectColumns.Profile_Picture.rawValue) != nil {
            let imageData = self.user.value(forKey: ParseObjectColumns.Profile_Picture.rawValue) as! PFFile
            imageData.getDataInBackground { (data: Data?, error: Error?) in
                let image = UIImage(data: data!)
                if image != nil {
                    profileImageView.image = image
                }
            }
        }
    }
}

class MessageCell : UITableViewCell {
    // WARN - See about changing this to weak var in the future
    var messageLabel:UILabel!
    var messageOwnerLabel:UILabel!
 
    var messageOwner:PFUser
    var message:String
    
    /**
     * - Description Initialize the MessageCell object
     * - Parameter messageOwner - The PFUser who sent this message
     * - Parameter message - The message that needs to be displayed
     * - Returns MessageCell Object
     * - Code let messageCell = MessageCell(messageOwner: <PFUser>, message:<String>)
     */
    init(messageOwner: PFUser, message: String) {
        self.messageOwner = messageOwner
        self.message = message
        super.init(style: .default, reuseIdentifier: "message")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
        self.contentView.autoresizingMask = .flexibleHeight
        self.autoresizingMask = .flexibleHeight
        // Set the very large sized content view so that the contentView will shrink.  There seems to be an iOS bug with it growing in size
        self.contentView.bounds = CGRect(x: 0, y: 0, width: 9999, height: 9999)
        
        self.setMessageOwnerLabel()
        self.setMessageLabel()
    }
    
    func setMessageOwnerLabel () {
        self.messageOwnerLabel = UILabel()
        self.messageOwnerLabel.font = UIFont.systemFont(ofSize: 12)
        self.messageOwnerLabel.text = messageOwner.username
        self.contentView.addSubview(self.messageOwnerLabel)
        self.messageOwnerLabel.snp.makeConstraints { (make) in
            if messageOwner == PFUser.current() {
                make.right.equalTo(self.contentView).offset(-20)
            }
            else {
                make.left.equalTo(self.contentView).offset(20)
            }
            
            make.top.equalTo(self.contentView).offset(10)
        }
    }
    
    func setMessageLabel () {
        self.messageLabel = UILabel()
        self.messageLabel.text = message
        self.messageLabel.textColor = .white
        self.messageLabel.numberOfLines = 0
        self.messageLabel.preferredMaxLayoutWidth = self.frame.size.width - 50
        let messageLabelView = self.messageLabel.withPadding(padding: UIEdgeInsetsMake(10, 10, 10, 10))
        messageLabelView.layer.cornerRadius = 5
        messageLabelView.backgroundColor = Colors.blue.value
        self.contentView.addSubview(messageLabelView)
        messageLabelView.snp.makeConstraints { (make) in
            if messageOwner == PFUser.current() {
                make.right.equalTo(self.messageOwnerLabel)
                make.left.greaterThanOrEqualTo(self.contentView).offset(50)
                self.messageLabel.textAlignment = .right
                messageLabel.textColor = .black
                messageLabelView.backgroundColor = Colors.grey.value
            } else {
                make.left.equalTo(self.messageOwnerLabel)
                make.right.lessThanOrEqualTo(self.contentView).offset(-50)
                self.messageLabel.textAlignment = .left
            }
            make.top.equalTo(self.messageOwnerLabel.snp.bottom).offset(5)
            make.bottom.equalTo(self.contentView).offset(-20)
        }
    }
}

extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}

extension UIView {
    func withPadding(padding: UIEdgeInsets) -> UIView {
        let container = UIView()
        container.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalTo(container).inset(padding)
        }
        return container
    }
}
