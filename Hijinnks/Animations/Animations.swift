//
//  Animations.swift
//  Hijinnks
//
//  Created by adeiji on 3/28/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

class Animations {
    
    /**
     * - Description Show a view showing a confirmation message
     * - Parameter type AnimationConfirmation - The way the layout should look, ex: .Circle, .Square
     * - Parameter message String - The confirmation message
     * - Parameter backgroundColor UIColor - The color of the view
     * - Parameter superView UIView - The view in which to display the confirmation view
     * - Parameter superView UIColor - The color of the message text
     * - Code 
     ```
    Animations.showConfirmationView (type: AnimationConfirmation.Circle, message: "You RSVP'd", backgroundColor: .blue, superView: self.view, textColor: .white)
     ```
     */
    class func showConfirmationView (type: AnimationConfirmation, message: String, backgroundColor: UIColor, superView: UIView, textColor: UIColor) {
        let ConfirmationViewDimension = 200
        let confirmationView = UIView()
        confirmationView.backgroundColor = backgroundColor
        superView.addSubview(confirmationView)
        confirmationView.snp.makeConstraints({ (make) in
            make.height.equalTo(ConfirmationViewDimension)
            make.width.equalTo(ConfirmationViewDimension)
            make.center.equalTo(superView)
        })
        
        let confirmationLabel = UILabel(text: message)
        confirmationLabel.textColor = textColor
        confirmationLabel.font = UIFont.systemFont(ofSize: 25)
        confirmationLabel.numberOfLines = 0
        confirmationLabel.textAlignment = .center
        confirmationView.addSubview(confirmationLabel)
        confirmationLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(confirmationView).offset(20)
            make.right.equalTo(confirmationView).offset(-20)
            make.center.equalTo(confirmationView)
        })
        
        if type == AnimationConfirmation.Circle {
            confirmationView.layer.cornerRadius = CGFloat(ConfirmationViewDimension / 2)
        }
        
        UIView.animate(withDuration: 2.0, animations: {
            confirmationView.alpha = 0
        }) { (completed) in
            confirmationView.removeFromSuperview()
        }
    }
    
}
