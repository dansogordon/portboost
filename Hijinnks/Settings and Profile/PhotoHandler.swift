//
//  PhotoHandler.swift
//  Hijinnks
//
//  Created by adeiji on 3/21/17.
//  Copyright © 2017 adeiji. All rights reserved.
//

import Foundation
import UIKit

class PhotoHandler : NSObject {
    
    var viewController:UIViewController
    var imageView:UIImageView!
    var imagePicker:UIImagePickerController!
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    
    func showCamera () {
        // Has Camera
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self.viewController as! ProfileViewController
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        viewController.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func promptForPicture () -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let alert = UIAlertController(title: "Profile Picture", message: "Where would you like to get your profile picture?", preferredStyle: .actionSheet)
            let camerAction = UIAlertAction(title: "Use Your Camera", style: .default, handler: { (action) in
                self.showCamera()
            })
            let photoLibraryAction = UIAlertAction(title: "From Your Photo Library", style: .default, handler: { (action) in
                self.showPhotoLibrary()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(camerAction)
            alert.addAction(photoLibraryAction)
            alert.addAction(cancelAction)
            self.viewController.present(alert, animated: true, completion: nil)
            
            return true
        }
        
        print("The user does not have the ability to take pictures on this device")
        return false
    }
    
    func showPhotoLibrary () {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self.viewController as! ProfileViewController
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.imagePicker.allowsEditing = true
        // Hide the Navigation Bar
        self.viewController.present(self.imagePicker, animated: true, completion: nil)
    }
}
