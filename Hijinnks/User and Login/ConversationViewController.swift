//
//  ConversationViewController.swift
//  Hijinnks
//
//  Created by adeiji on 3/23/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import SendBirdSDK
import Parse

/**
 * - The view controller which  handles having conversations with other users
 */
class ConversationViewController : UIViewController, UITableViewDataSource, UITableViewDelegate ,SBDChannelDelegate {
    
    var toUser:PFUser
    var messages:[SBDUserMessage] = [SBDUserMessage]()
    var channel:SBDBaseChannel!
    var conversationView:ConversationView!
    var activitySpinner:UIActivityIndicatorView!
    
    init(toUser: PFUser) {
        self.toUser = toUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConversationView () {
        self.conversationView = ConversationView()
        self.conversationView.user = toUser
        self.view.addSubview(self.conversationView)
        self.conversationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.conversationView.setupUI()
        self.conversationView.messagesTableView.dataSource = self
        self.conversationView.messagesTableView.delegate = self
        self.conversationView.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        
    }
    
    func startActivitySpinner () {
        // Add the activity spinner
        self.activitySpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activitySpinner.startAnimating()
        self.activitySpinner.hidesWhenStopped = true
        self.view.addSubview(self.activitySpinner)
        self.activitySpinner.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
    }
    
    func load () {
        // Make self the delegate for the SBDChannel with the specified identifier
        SBDMain.add(self as SBDChannelDelegate, identifier: ConversationChannelKeys.One_To_One.rawValue)
        self.setupConversationView()
        
        // Get all the previous messages that have been sent in this channel
        (self.channel as SBDBaseChannel).getPreviousMessages(byTimestamp: Int64(Date().timeIntervalSince1970 * 1000), limit: 100, reverse: false, messageType: SBDMessageTypeFilter.all, customType: nil) { (messages: [SBDBaseMessage]?, error: SBDError?) in
            self.activitySpinner.stopAnimating()
            if (error != nil) {
                print(error!)
            }
            else {
                self.messages = messages! as! [SBDUserMessage]
                self.reloadTableView()
            }
        }

    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.startActivitySpinner()
    }
    
    /**
     * - Description Reloads the table view and scrolls to the bottom of the table view
     */
    func reloadTableView () {
        self.conversationView.messagesTableView.reloadData()
        if self.messages.count > 1 {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.conversationView.messagesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    func sendButtonPressed () {
        channel.sendUserMessage(self.conversationView.messageTextField.text) { (userMessage, error) in
            if error == nil {
                self.messages.append(userMessage!)
                self.conversationView.messageTextField.text = ""
                self.reloadTableView()
            }
            else {
                print("Error sending message with id - \((userMessage?.messageId)!)")
            }
        }
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if message is SBDUserMessage
        {
            let message = message as! SBDUserMessage
            messages.append(message)
            self.reloadTableView()
        }
    }
    
    /**
     * - Description Get the user that is the sender of a SBDUserMessage
     * - Parameter message SBDUserMessage - The message to check for the sender of
     * - Returns PFUser - The PFUser who sent the message
     * - Code let user = getUser(message)
     */
    func getUser (message: SBDUserMessage) -> PFUser {
        let messageOwner = message.sender
        
        if messageOwner?.userId == PFUser.current()?.objectId {
            return PFUser.current()!
        } else {
            return toUser
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let user = getUser(message: message)
        let messageCell = MessageCell(messageOwner: user, message: message.message!)
        messageCell.setupUI()
        messageCell.isUserInteractionEnabled = false    // We don't want the user being able to click on a message
        return messageCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = calculateHeightForCell(message: messages[indexPath.row])
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func calculateHeightForCell (message: SBDUserMessage) -> CGFloat {
        let messageCell = MessageCell(messageOwner: getUser(message: message), message: message.message!)
        messageCell.contentView.layoutIfNeeded()
        messageCell.setupUI()
        let size = messageCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return size.height
    }
}

