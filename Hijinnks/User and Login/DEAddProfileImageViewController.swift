//  Converted with Swiftify v1.0.6274 - https://objectivec2swift.com/
//
//  DEAddProfileImageViewController.swift
//  whatsgoinon
//
//  Created by adeiji on 10/8/14.
//  Copyright (c) 2014 adeiji. All rights reserved.
//
import UIKit
class DEAddProfileImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    var profileImageData: Data!

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet var btnProfilePicture: UIButton!

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Custom initialization
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takeProfileImagePicture(_ sender: Any) {
        // Make sure that they have a camera on this device
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Display Alert Controller asking if they want to use the camera or pull from already existing images
            
        }
    }
}
