//  Converted with Swiftify v1.0.6274 - https://objectivec2swift.com/
//
//  DECreateAccountView.swift
//  whatsgoinon
//
//  Created by adeiji on 8/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//
import UIKit
class DECreateAccountView: UIView, UITextFieldDelegate {
    weak var logoView:CustomHijinnksView!
    weak var txtUsername: UITextField!
    weak var txtEmail: UITextField!
    weak var txtPassword: UITextField!
    weak var txtConfirmPassword: UITextField!
    weak var txtPhoneNumber: UITextField!
    weak var lblUsernameError: UILabel!
    weak var headerLabel:UILabel!
    weak var signupButton:UIButton!
    weak var checkbox:HijinnksButton!
    weak var termsAndConditionsTextView:UITextView!
    weak var termsAndConditionsButton:UIButton!
    weak var licenseAgreementButton:UIButton!

    func setUp() {
        for view: UIView in self.subviews {
            if (view is UITextField) {
                let textField: UITextField? = (view as? UITextField)
                textField?.delegate = self
            }
        }
    }

    func setUpValidators() {

    }

    let ERROR_CODE_EMAIL_TAKEN = 203

    required init () {
        super.init(frame: .zero)
    }
    
    func setupUI () {
        self.backgroundColor = .white
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(self.superview!)
        }
//        addImageToBackground()
        self.lblUsernameError = setUsernameErrorLabel()
        self.txtUsername = setTextField(viewAbove: lblUsernameError, placeholderText: "Enter username", isSecureTextEntry: false)
        self.txtEmail = setTextField(viewAbove: txtUsername, placeholderText: "Enter your email", isSecureTextEntry: false)
        self.txtPassword = setTextField(viewAbove: txtEmail, placeholderText: "Enter your password", isSecureTextEntry: true)
        self.txtConfirmPassword = setTextField(viewAbove: txtPassword, placeholderText: "Confirm your password", isSecureTextEntry: true)
        self.txtPhoneNumber = setTextField(viewAbove: self.txtConfirmPassword, placeholderText: "Enter Your Phone Number", isSecureTextEntry: false)
        signupButton = setSignupButton()
        self.checkbox = setCheckbox()
        self.termsAndConditionsTextView = self.setAcceptTermsAndConditionsTextView()
        
        let font = UIFont.systemFont(ofSize: 12.0)
        
        self.licenseAgreementButton = self.setLicenseAgreementButton(font: font)
        self.termsAndConditionsButton = self.setTermsAndConditionsButton(font: font)
    }
    
    func setTermsAndConditionsButton (font: UIFont) -> UIButton {
        let button = UIButton()
        button.setTitle("Terms and Conditions", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.titleLabel?.font = font
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(self.txtUsername)
            make.right.equalTo(self.snp.centerX).offset(-5)
            make.height.equalTo(self.signupButton)
            make.top.equalTo(self.termsAndConditionsTextView.snp.bottom).offset(10)
        }
        
        return button
    }
    
    func setLicenseAgreementButton (font: UIFont) -> UIButton {
        let button = UIButton()
        button.setTitle("License Agreement", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = font
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(5)
            make.right.equalTo(self.txtUsername)
            make.height.equalTo(self.signupButton)
            make.top.equalTo(self.termsAndConditionsTextView.snp.bottom).offset(10)
        }
        return button
    }
    
    func checkboxPressed () {
        if checkbox.isSelected == false {
            checkbox.isSelected = true
            checkbox.customButtonType = .CheckedBox
            checkbox.setNeedsDisplay()
        }
        else {
            checkbox.isSelected = false
            checkbox.customButtonType = .UncheckedBox
            checkbox.setNeedsDisplay()
        }
    }
    
    func setCheckbox () -> HijinnksButton {
        let checkbox = HijinnksButton(customButtonType: .UncheckedBox)
        checkbox.isSelected = false
        checkbox.addTarget(self, action: #selector(checkboxPressed), for: .touchUpInside)
        self.addSubview(checkbox)
        checkbox.snp.makeConstraints { (make) in
            make.left.equalTo(self.txtUsername)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.top.equalTo(self.signupButton.snp.bottom).offset(20)
        }
        
        return checkbox
    }
    
    func setAcceptTermsAndConditionsTextView () -> UITextView {
        let textView = UITextView()
        self.addSubview(textView)
        textView.text = "In order to create an acount, please accept our Terms and Conditions and License Agreement"
        textView.isUserInteractionEnabled = false
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(self.checkbox.snp.right).offset(15)
            make.top.equalTo(self.checkbox)
            make.right.equalTo(self.txtUsername)
            make.height.equalTo(25)
        }
        
        textView.layoutIfNeeded()
        textView.sizeToFit()
        
        return textView
    }
    
    func addImageToBackground () {
        let imageView = UIImageView(image: UIImage(named: Images.Background.rawValue))
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        imageView.layer.zPosition = -2
        
        let blackAlphaView = UIView()
        self.addSubview(blackAlphaView)
        blackAlphaView.backgroundColor = .black
        blackAlphaView.alpha = 0.35
        blackAlphaView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        blackAlphaView.layer.zPosition = -1
    }
    
    
    func setLogoView () -> CustomHijinnksView {
        let view = CustomHijinnksView(customViewType: .LogoView)
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(90)
            make.height.equalTo(40)
            make.width.equalTo(160)
            make.centerX.equalTo(self)
        }
        
        return view
    }
    
    func setUsernameErrorLabel () -> UILabel {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(30)
        }
        
        return label
    }
    
    func setTextField (viewAbove: UIView!, placeholderText: String, isSecureTextEntry: Bool) -> UITextField {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                             attributes: [NSForegroundColorAttributeName: Colors.DarkGray.value])
        textField.textAlignment = .center
        textField.isSecureTextEntry = isSecureTextEntry
        textField.backgroundColor = .white
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = Colors.DarkGray.value.cgColor
        textField.layer.cornerRadius = 5
        textField.textColor = Colors.DarkGray.value
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        self.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            if viewAbove != nil {
                make.top.equalTo(viewAbove.snp.bottom).offset(10)
            }
            else {
                make.top.equalTo(logoView.snp.bottom).offset(UIConstants.VerticalDistanceToLogo.rawValue)
            }
            
            make.height.equalTo(40)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        return textField
    }
    
    func setSignupButton () -> UIButton {
        
        let button = UIButton()
        button.setTitle("CREATE ACCOUNT", for: .normal)
        button.layer.borderColor = Colors.DarkGray.value.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitleColor(Colors.DarkGray.value, for: .normal)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.txtPhoneNumber.snp.bottom).offset(10)
            make.width.equalTo(UIConstants.SignUpAndSignInButtonWidth.rawValue)
            make.height.equalTo(self.txtUsername)
        }
        
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view: UIView in self.subviews {
            if (view is UITextField) {
                view.resignFirstResponder()
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
