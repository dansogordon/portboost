//  Converted with Swiftify v1.0.6274 - https://objectivec2swift.com/
//
//  DELoginView.swift
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//
import UIKit
import FBSDKLoginKit

class DELoginView: UIView {
// MARK: - View Outlets
    // This view displays at the top of the login screen and simply displays the logo for the application
    weak var logoView:UIImageView!
    weak var txtUsernameOrEmail: UITextField!
    weak var txtPassword: UITextField!
    weak var signInButton: UIButton!
    weak var signUpButton: UIButton!
    weak var facebookLoginButton: UIButton!
    var nextScreen: UIViewController!
    weak var errorLabel: UILabel!
    
    func connect(withFacebook sender: Any) {
        
    }
    
    required init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI () {
//        addImageToBackground()
        logoView = setLogoView()
        signInButton = setupSignInButton(title: "SIGN IN", viewObjectAbove: nil)
        signUpButton = setupSignInButton(title: "CREATE ACCOUNT", viewObjectAbove: self.signInButton)
        facebookLoginButton = setFacebookLoginButton(signUpButton: self.signUpButton)
        
        txtPassword = setupTextField(placeholder: "Enter Password", viewBelow: self.signInButton)
        txtUsernameOrEmail = setupTextField(placeholder: "Enter Username or Email", viewBelow : self.txtPassword)
        txtPassword.isSecureTextEntry = true
        errorLabel = setupErrorLabel()
    }
    
    
    
    func addImageToBackground () {
        let imageView = UIImageView(image: UIImage(named: Images.Background.rawValue))
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        imageView.layer.zPosition = -1
        
        let blackAlphaView = UIView()
        self.addSubview(blackAlphaView)
        blackAlphaView.backgroundColor = .black
        blackAlphaView.alpha = 0.35
        blackAlphaView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        blackAlphaView.layer.zPosition = -1
    }
    
    func setFacebookLoginButton (signUpButton: UIButton) -> UIButton {
        
        let myFacebookLoginButton = UIButton()
        myFacebookLoginButton.backgroundColor = Colors.FacebookButton.value
        myFacebookLoginButton.setTitleColor(.white, for: .normal)
        myFacebookLoginButton.setTitle("Login With Facebook", for: .normal)
        myFacebookLoginButton.layer.cornerRadius = 5
        self.addSubview(myFacebookLoginButton)
        myFacebookLoginButton.snp.makeConstraints { (make) in
            make.width.equalTo(signUpButton)
            make.height.equalTo(signUpButton)
            make.centerX.equalTo(signUpButton)
            make.top.equalTo(signUpButton.snp.bottom).offset(10)
        }
        
        return myFacebookLoginButton
        
    }
    
    // Display a sign in button below the password text field
    func setupSignInButton (title: String, viewObjectAbove: UIView!) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.borderColor = Colors.DarkGray.value.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitleColor(Colors.DarkGray.value, for: .normal)
        
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            if viewObjectAbove != nil {
                make.top.equalTo(viewObjectAbove.snp.bottom).offset(10)
            }
            else {
                make.top.equalTo(self.snp.bottom).offset(-170)
            }
            make.left.equalTo(self).offset(UIConstants.HorizontalSpacingToSuperview.rawValue)
            make.right.equalTo(self).offset(-UIConstants.HorizontalSpacingToSuperview.rawValue)
            make.centerX.equalTo(self)
            make.height.equalTo(45)
        }
        
        return button
    }
    
    func setLogoView () -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Images.LaunchScreen_Logo.rawValue)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(75)
            make.height.equalTo(125)
            make.width.equalTo(125)
            make.centerX.equalTo(self)
        }
        
        return imageView
    }
    
    func setupTextField (placeholder: String, viewBelow : UIView!) -> UITextField {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [NSForegroundColorAttributeName: Colors.DarkGray.value])
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.borderColor = Colors.DarkGray.value.cgColor
        textField.layer.borderWidth = 0.5
        textField.textColor = Colors.DarkGray.value
        textField.isHidden = true
        textField.autocorrectionType = .no
        self.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            if viewBelow != self.signInButton {
                make.bottom.equalTo(viewBelow.snp.top).offset(-10)
            }
            else {
                make.bottom.equalTo(viewBelow.snp.top).offset(-65)
            }
            
            make.left.equalTo(self).offset(UIConstants.HorizontalSpacingToSuperview.rawValue)
            make.right.equalTo(self).offset(-UIConstants.HorizontalSpacingToSuperview.rawValue)
            make.height.equalTo(45)
        }
        
        return textField
    }
    
    func setupErrorLabel () -> UILabel {
        let label = UILabel()
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Colors.DarkGray.value
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(txtPassword)
            make.top.equalTo(txtPassword.snp.bottom).offset(5)
            make.width.equalTo(txtPassword)
        }
        
        return label
    }

    func removeFirstResponder() {
        // When the user taps the image, resign the first responder
        self.txtPassword.resignFirstResponder()
        self.txtUsernameOrEmail.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFirstResponder()   
    }
}
