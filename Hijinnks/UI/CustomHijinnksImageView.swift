//
//  CustomHijinnksImageView.swift
//  Hijinnks
//
//  Created by adeiji on 2/19/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

public class CustomHijinnksImageView : UIImageView {
    
    override public func draw(_ rect: CGRect) {
        HijinnksStyleKit.drawTextLogo()
    }
    
}
