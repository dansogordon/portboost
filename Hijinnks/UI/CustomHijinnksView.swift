//
//  CustomHijinnksView.swift
//  Hijinnks
//
//  Created by adeiji on 2/19/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

class CustomHijinnksView : UIView {
    
    var customViewType:HijinnksViewTypes
    
    init(customViewType: HijinnksViewTypes) {
        self.customViewType = customViewType
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        if customViewType == .LogoView {
            HijinnksStyleKit.drawLogoWithText(frame: rect)
        }
        else if customViewType == .Map {
            HijinnksStyleKit.drawMapButton(frame: rect)
        }
        else if customViewType == .Clock {
            HijinnksStyleKit.drawClock(frame: rect)
        }
        else if customViewType == .Comment {
            HijinnksStyleKit.drawCommentButton(frame: rect, fillColor19: .black)
        }        
    }
}

