//
//  ChangePasswordViewController.swift
//  Hijinnks
//
//  Created by adeiji on 3/11/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ChangePasswordViewController : UIViewController {
    
    let changeProfileView = ChangePasswordView()
    
    override func viewDidLoad() {
        self.changeProfileView.savePasswordButton.addTarget(self, action: #selector(savePasswordButtonPressed), for: .touchUpInside)
    }

    // Cannot Save Password Right Now
    func savePasswordButtonPressed () {

    }
    
}

class ChangePasswordView : UIView {
    var currentPasswordTextField:UITextField!
    var newPasswordTextField:UITextField!
    var newPasswordConfirmTextField:UITextField!
    var savePasswordButton:UIButton!
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.currentPasswordTextField = setupTextField(placeholder: "Enter current password", viewAbove: nil)
        self.newPasswordTextField = setupTextField(placeholder: "Enter new password", viewAbove: self.currentPasswordTextField)
        self.newPasswordConfirmTextField = setupTextField(placeholder: "Confirm your new password", viewAbove: self.newPasswordTextField)
    }
    
    func setupTextField (placeholder: String, viewAbove: UIView!) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = .white
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.invitationTextGrayColor.value.cgColor
        self.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(UIConstants.HorizontalSpacingToSuperview.rawValue)
            if viewAbove == nil {
                make.top.equalTo(self).offset(UIConstants.VerticalDistanceToLogo.rawValue)
            } else {
                make.top.equalTo(viewAbove.snp.bottom).offset(UIConstants.ProfileViewVerticalSpacing.rawValue)
            }
            make.right.equalTo(self).offset(UIConstants.ProfileViewHorizontalSpacing.rawValue)
        }
        
        return textField
    }
    
    func setSavePasswordButton (viewAbove: UIView) {
        let passwordButton = UIButton()
        passwordButton.setTitle("Save", for: .normal)
        passwordButton.backgroundColor = Colors.invitationTextGrayColor.value
        self.addSubview(passwordButton)
        passwordButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(viewAbove.snp.bottom).offset(UIConstants.ProfileViewVerticalSpacing.rawValue)
            make.width.equalTo(100)
        }
        
        self.savePasswordButton = passwordButton
    }
}
