
//
//  HijinnksButton.swift
//  Hijinnks
//
//  Created by adeiji on 3/4/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

class HijinnksButton : UIButton {
    
    var customButtonType:HijinnksViewTypes
    
    init(customButtonType: HijinnksViewTypes) {
        self.customButtonType = customButtonType
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {        
        if customButtonType == .Map {
            HijinnksStyleKit.drawLocationButton(frame: rect)
        }
        else if customButtonType == .LikeEmpty {
            HijinnksStyleKit.drawLikeButton(frame: rect)
        }
        else if customButtonType == .LikeFilled {
            HijinnksStyleKit.drawLikeButtonFilled(frame: rect)            
        }
        else if customButtonType == .Home {
            HijinnksStyleKit.drawHomeButton(frame: rect, resizing: .stretch)
        }
        else if customButtonType == .Comment {
            HijinnksStyleKit.drawCommentButton(frame: rect)
        }
        else if customButtonType == .Message {
            HijinnksStyleKit.drawMessageButton(frame: rect)
        }
        else if customButtonType == .Settings {
            HijinnksStyleKit.drawSettings(frame: rect)
        }
        else if customButtonType == .Send {
            HijinnksStyleKit.drawSendButton(frame: rect)
        }
        else if customButtonType == .Conversation {
            HijinnksStyleKit.drawChatButton(frame: rect)
        }
        else if customButtonType == .Cancel {
            HijinnksStyleKit.drawCancel(frame: rect)
        }
        else if customButtonType == .Invitations {
            HijinnksStyleKit.drawInvitationsButton(frame: rect)
        }
        else if customButtonType == .More {
            HijinnksStyleKit.drawMoreButton(frame: rect)
        }
        else if customButtonType == .Interests {
            HijinnksStyleKit.drawInterestsButton(frame: rect)
        }
        else if customButtonType == .CheckedBox {
            HijinnksStyleKit.drawCheckedBox(frame: rect)
        }
        else if customButtonType == .UncheckedBox {
            HijinnksStyleKit.drawUncheckedBox(frame: rect)
        }
    }
}

class HijinnksBarButtonItem : UIView {
    var customButtonType:HijinnksViewTypes
    
    init(customButtonType: HijinnksViewTypes) {
        self.customButtonType = customButtonType
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
}
