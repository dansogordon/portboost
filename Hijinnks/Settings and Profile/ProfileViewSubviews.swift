//
//  InterestsView.swift
//  Hijinnks
//
//  Created by adeiji on 5/7/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse

class InterestsListView : UIView {
    
    func setupUI (user: PFUser) {
        var yPos = 5
        let interests = DEUserManager.sharedManager.getInterests(user: user)
        if interests != nil {
            for interest in interests!	 {
                let interestView = UtilityFunctions.getInterestIcon(interest: interest)
                let interestIconLabel = interestView?.subviews.first
                let interestTextLabel = interestView?.subviews.last
                let font = UIFont.systemFont(ofSize: 18.0)
                (interestIconLabel as! UILabel).font = font
                (interestTextLabel as! UILabel).font = font
                interestTextLabel?.snp.remakeConstraints({ (remake) in
                    remake.left.equalTo((interestIconLabel?.snp.right)!).offset(5)
                    remake.centerY.equalTo(interestView!)
                })
                
                interestIconLabel?.snp.makeConstraints({ (remake) in
                    remake.centerY.equalTo(interestView!)
                })
                
                // Add the interest view to the interest list view
                self.addSubview(interestView!)
                interestView?.snp.makeConstraints({ (make) in
                    make.left.equalTo(self).offset(50)
                    make.top.equalTo(self).offset(yPos)
                    // If we're at the last view make sure that we set the constraint to the bottom of the profile view in order for the profile view to properly expand
                    if interest == interests?.last {
                        make.bottom.equalTo(self).offset(-25)
                    }
                })

                yPos += 40
            }
        }
    }
}

class ProfileDetailsView : UIView {
    
    weak var firstNameTextField:UITextField!
    weak var lastNameTextField:UITextField!
    weak var dateOfBirthTextField:UITextField!
    weak var collegeAttendedTextField:UITextField!
    weak var cityYouLiveInTextField:UITextField!
    let SIDE_MARGINS = 0
    var user:PFUser
    
    required init(user: PFUser) {
        self.user = user
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI (user: PFUser) {
        let font = UIFont.systemFont(ofSize: 12)
        self.firstNameTextField = self.setFirstNameTextField(font: font)
        self.lastNameTextField = self.setLastNameTextField(font: font)
        self.dateOfBirthTextField = self.setDateOfBirthTextField(font: font)
        self.collegeAttendedTextField = self.setCollegeAttendedTextField(font: font)
        self.cityYouLiveInTextField = self.setCityYouLiveInTextField(font: font)
        if !UtilityFunctions.isCurrent(user: user) {
            self.firstNameTextField.isEnabled = false
            self.lastNameTextField.isEnabled = false
            self.dateOfBirthTextField.isEnabled = false
            self.collegeAttendedTextField.isEnabled = false
            self.cityYouLiveInTextField.isEnabled = false
        }                
    }
    
    func setFirstNameTextField (font: UIFont) -> UITextField {
        let textField = ProfileTextField()
        textField.text = self.user.object(forKey: ParseObjectColumns.FirstName.rawValue) as? String
        self.addSubview(textField)
        textField.font = font
        self.addBottomBorder(textField: textField)
        textField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [ NSForegroundColorAttributeName : Colors.DarkGray.value ])
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(SIDE_MARGINS)
            make.right.equalTo(self.snp.centerX).offset(-SIDE_MARGINS)
            make.top.equalTo(self).offset(5)
            make.height.equalTo(40)
        }
        
        return textField
    }
    
    func setLastNameTextField (font: UIFont) -> UITextField {
        let textField = ProfileTextField()
        textField.text = self.user.object(forKey: ParseObjectColumns.LastName.rawValue) as? String
        self.addSubview(textField)
        textField.font = font
        self.addBottomBorder(textField: textField)
        textField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [ NSForegroundColorAttributeName : Colors.DarkGray.value ])
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(SIDE_MARGINS)
            make.right.equalTo(self).offset(SIDE_MARGINS)
            make.top.equalTo(self.firstNameTextField)
            make.height.equalTo(40)
        }
        
        return textField
    }
    
    func setDateOfBirthTextField (font: UIFont) -> UITextField {
        let textField = ProfileTextField()
        textField.text = self.user.object(forKey: ParseObjectColumns.DateOfBirth.rawValue) as? String
        self.addSubview(textField)
        textField.font = font
        self.addBottomBorder(textField: textField)
        textField.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: [ NSForegroundColorAttributeName : Colors.DarkGray.value ])
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(SIDE_MARGINS)
            make.right.equalTo(self).offset(SIDE_MARGINS)
            make.top.equalTo(self.lastNameTextField.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        
        return textField
    }
    
    func setCollegeAttendedTextField (font: UIFont) -> UITextField {
        let textField = ProfileTextField()
        textField.text = self.user.object(forKey: ParseObjectColumns.CollegeAttended.rawValue) as? String
        self.addSubview(textField)
        textField.font = font
        self.addBottomBorder(textField: textField)
        textField.attributedPlaceholder = NSAttributedString(string: "College Attended", attributes: [ NSForegroundColorAttributeName : Colors.DarkGray.value ])
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(SIDE_MARGINS)
            make.right.equalTo(self).offset(SIDE_MARGINS)
            make.top.equalTo(self.dateOfBirthTextField.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        
        return textField
    }
    
    func setCityYouLiveInTextField (font: UIFont) -> UITextField {
        let textField = ProfileTextField()
        textField.text = self.user.object(forKey: ParseObjectColumns.CityYouLiveIn.rawValue) as? String
        self.addSubview(textField)
        textField.font = font
        textField.attributedPlaceholder = NSAttributedString(string: "City You Live In", attributes: [ NSForegroundColorAttributeName : Colors.DarkGray.value ])
        self.addBottomBorder(textField: textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(SIDE_MARGINS)
            make.right.equalTo(self).offset(SIDE_MARGINS)
            make.top.equalTo(self.collegeAttendedTextField.snp.bottom).offset(5)
            make.height.equalTo(40)
            make.bottom.equalTo(self).offset(-25)
        }
        
        return textField
    }
    
    func addBottomBorder (textField: ProfileTextField) {
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGray
        textField.backgroundColor = .white
        self.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0.25)
            make.top.equalTo(textField.snp.bottom)
        }
    }
}

class ProfileTextField : UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 25, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 25, dy: 10)
    }
}
