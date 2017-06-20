//
//  ProfileViewController+ProfileExtraDetails.swift
//  Hijinnks
//
//  Created by adeiji on 5/9/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.profileView.profileDetailsView.cityYouLiveInTextField {
            // Store the user's city information
            self.user.setObject(textField.text!, forKey: ParseObjectColumns.CityYouLiveIn.rawValue)
        }
        else if textField == self.profileView.profileDetailsView.collegeAttendedTextField {
            // Store user's college information
            self.user.setObject(textField.text!, forKey: ParseObjectColumns.CollegeAttended.rawValue)
        }
        else if textField == self.profileView.profileDetailsView.dateOfBirthTextField {
            // Store user's date of birth information
            self.user.setObject(textField.text!, forKey: ParseObjectColumns.DateOfBirth.rawValue)
        }
        else if textField == self.profileView.profileDetailsView.firstNameTextField {
            // Store the user's full name information
            self.user.setObject(textField.text!, forKey: ParseObjectColumns.FirstName.rawValue)
        }
        else if textField == self.profileView.profileDetailsView.lastNameTextField {
            // Store the user's full name information
            self.user.setObject(textField.text!, forKey: ParseObjectColumns.LastName.rawValue)
        }
        
        self.user.saveInBackground { (success, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func keyboardWillShow(notification:NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue  // Get the rectangle for the keyboard
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)                                     // the from view is nil therefore the keyboardFrame is converted to the coordinates of the window
        
        var contentInset:UIEdgeInsets = self.profileView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        contentInset.top = (self.navigationController?.navigationBar.frame.size.height)!
        self.profileView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.profileView.contentInset = contentInset
    }

    
    
}
