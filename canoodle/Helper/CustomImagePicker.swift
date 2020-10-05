//
//  CustomImagePicker.swift
//  WhiteLabelApp
//
//  Created by hb on 17/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import Photos

/// Media Type
///
/// - MediaTypeImage: Image
/// - MediaTypeVideo: Video
enum mediaType {
    /// - MediaTypeImage: Image
    case MediaTypeImage
    /// - MediaTypeImage: Image
    case MediaTypeVideo
}

// Add following permission in info.plist
/*
 <key>NSPhotoLibraryUsageDescription</key>
 <string>$(PRODUCT_NAME) want to access Photo Library</string>
 */

/// Common image picker to be used in the app
class CustomImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Shared instance
    static let shared = CustomImagePicker()
    /// Allow editing with picker
    var allowsEditing: Bool!
    /// Image picker object
    var imagePicker : UIImagePickerController!
    var currentMediaType: [mediaType] = [.MediaTypeImage]
    /// Comletion is called after image is picked or captured
    var completion: ((_ index: Int,_ success: Bool, _ dicMedia: [String: Any]?) -> ())?
    
    
    
    
    
    /// Show Picker in the View Controller
    ///
    /// - Parameters:
    ///   - mediaType: Type of the media
    ///   - allowsEditing: Allow editing on the picked media
    ///   - actionSheetTitle: Title of the Action sheet
    ///   - message: Message on the actionsheet
    ///   - cancelButtonTitle: Cancel button title
    ///   - cameraButtonTitle: Camera button title
    ///   - galleryButtonTitle: Gallery button title
    ///   - completion: Closure gets called once the image is picked successfully
    func openImagePickerWith(mediaType: mediaType = .MediaTypeImage,allowsEditing: Bool = true, actionSheetTitle: String? = nil, message: String? = nil, cancelButtonTitle: String = "Cancel", cameraButtonTitle: String = "Camera", galleryButtonTitle: String = "Gallery", completion: ((_ index: Int,_ success: Bool, _ dicMedia: [String: Any]?) -> ())?) {
        
        self.allowsEditing = allowsEditing
        self.completion = completion
        currentMediaType = [mediaType]
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: actionSheetTitle, message: message, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: cancelButtonTitle, style: .cancel) { action -> Void in
            print(cancelButtonTitle)
        }
        actionSheetController.addAction(cancelActionButton)
        let cameraActionButton = UIAlertAction(title: cameraButtonTitle, style: .default) { action -> Void in
            print(cameraButtonTitle)
            self.checkAccess()
        }
        actionSheetController.addAction(cameraActionButton)
        let galleryActionButton = UIAlertAction(title: galleryButtonTitle, style: .default) { action -> Void in
            print(galleryButtonTitle)
            self.checkAccessForPhotoLibrary()
        }
        actionSheetController.addAction(galleryActionButton)
        DispatchQueue.main.async {
            GlobalUtility.shared.currentTopViewController().present(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    /// Open Image Picker with more options
    ///
    /// - Parameters:
    ///   - mediaType: Type of the media
    ///   - allowsEditing: Allow editing on the picked media
    ///   - actionSheetTitle: Title of the Action sheet
    ///   - message:  Message on the actionsheet
    ///   - cancelButtonTitle: Cancel button title
    ///   - cameraButtonTitle: Camera button title
    ///   - galleryButtonTitle: Gallery button title
    ///   - completion: Closure gets called once the image is picked successfully
    func openImagePickerWithMoreOptions(mediaType: mediaType = .MediaTypeImage,allowsEditing: Bool = true, actionSheetTitle: String? = nil, message: String? = nil, cancelButtonTitle: String = "Cancel", cameraButtonTitle: String = "Camera", galleryButtonTitle: String = "Gallery", completion: ((_ index: Int,_ success: Bool, _ dicMedia: [String: Any]?) -> ())?) {
        
        self.allowsEditing = allowsEditing
        self.completion = completion
        currentMediaType = [mediaType]
        // Create the AlertController and add its actions like button in ActionSheet
        let actionSheetController = UIAlertController(title: actionSheetTitle, message: message, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: cancelButtonTitle, style: .cancel) { action -> Void in
            print(cancelButtonTitle)
            
        }
        actionSheetController.addAction(cancelActionButton)
        
        
        let viewImageActionButton = UIAlertAction(title: "View", style: .default) { action -> Void in
            self.completion!(1,true, nil)
            
        }
        actionSheetController.addAction(viewImageActionButton)
        
        let cameraActionButton = UIAlertAction(title: cameraButtonTitle, style: .default) { action -> Void in
            print(cameraButtonTitle)
            self.checkAccess()
        }
        actionSheetController.addAction(cameraActionButton)
        
        let galleryActionButton = UIAlertAction(title: galleryButtonTitle, style: .default) { action -> Void in
            print(galleryButtonTitle)
            self.checkAccessForPhotoLibrary()
        }
        actionSheetController.addAction(galleryActionButton)
        
        let removeImageActionButton = UIAlertAction(title: "Remove", style: .destructive) { action -> Void in
            self.completion!(2,true, nil)
            
        }
        actionSheetController.addAction(removeImageActionButton)
        DispatchQueue.main.async {
            GlobalUtility.shared.currentTopViewController().present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    /// To open camera
    ///
    /// - Parameters:
    ///   - mediaType: Media type for the picker
    ///   - completion: Closure gets called once the media is picked successfully
    func openCameraWith(mediaType: mediaType = .MediaTypeImage, completion: ((_ index: Int,_ success: Bool, _ dicMedia: [String: Any]?) -> ())?) {
        self.completion = completion
        currentMediaType = [mediaType]
        self.checkAccess()
        
    }
    
    /// To open gallery
    ///
    /// - Parameters:
    ///   - mediaType: Media type for the picker
    ///   - completion:  Closure gets called once the media is picked successfully
    func openGalleryWith(mediaType: [mediaType] = [.MediaTypeImage], completion: ((_ index: Int,_ success: Bool, _ dicMedia: [String: Any]?) -> ())?) {
        self.completion = completion
        currentMediaType = mediaType
        self.checkAccessForPhotoLibrary()
    }
    
    /// Check access for camera
    func checkAccess()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if let _ = imagePicker
            {
                imagePicker = nil
            }
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                self.openCamera()
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        self.openCamera()
                        
                    } else {
                        DispatchQueue.main.async {
                            GlobalUtility.shared.currentTopViewController().displayAlert(msg: AlertMessage.cameraAccess, ok: "Settings", cancel: "Cancel", okAction: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                
                            }, cancelAction: nil)
                        }
                    }
                })
            }
            
            
        } else {
            if self.completion != nil {
                self.completion!(3,false, nil)
            }
            let alert  = UIAlertController(title: "Warning", message: "Device has no camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            DispatchQueue.main.async {
                GlobalUtility.shared.currentTopViewController().present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    
    /// Check access for photo library
    func checkAccessForPhotoLibrary()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.openGallery()
            case .denied:
                DispatchQueue.main.async {
                    GlobalUtility.shared.currentTopViewController().displayAlert(msg: AlertMessage.photoLibraryAccess, ok: "Settings", cancel: "Cancel", okAction: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        
                    }, cancelAction: nil)
                }
            default:
                print("default")
            }
        }
    }
    
    /// Open ImagePicker with camera option
    func openCamera() {
        DispatchQueue.main.async {
            self.imagePicker = UIImagePickerController()
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = self.allowsEditing
            
            var arr  = [String]()
            for aMediatype in self.currentMediaType
            {
                if aMediatype == .MediaTypeImage
                {
                    arr.append(kUTTypeImage as String)
                }
                else
                {
                    arr.append(kUTTypeMovie as String)
                }
            }
            
            self.imagePicker.mediaTypes = arr
            
            GlobalUtility.shared.currentTopViewController().present(self.imagePicker, animated: true, completion: nil)
        }
        
    }
    
    /// Open ImagePicker with gallery option
    func openGallery() {
        DispatchQueue.main.async {
            if let _ = self.imagePicker
            {
                self.imagePicker = nil
            }
            
            self.imagePicker = UIImagePickerController()
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = self.allowsEditing
            self.imagePicker.videoMaximumDuration = TimeInterval(60.0)
            
            
            var arr  = [String]()
            for aMediatype in self.currentMediaType
            {
                if aMediatype == .MediaTypeImage
                {
                    arr.append(kUTTypeImage as String)
                }
                else
                {
                    arr.append(kUTTypeMovie as String)
                }
            }
            
            self.imagePicker.mediaTypes = arr
            
            GlobalUtility.shared.currentTopViewController().present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    /// Delegate method that gets called once the image is picked successfully
    ///
    /// - Parameters:
    ///   - picker: picker that is opened
    ///   - info: Info contains all the data related to media picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var dic = [String: Any]()
        if let _ = info[UIImagePickerController.InfoKey.originalImage] {
            dic["image"] = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if let infor = info[UIImagePickerController.InfoKey.editedImage] {
                dic["edited_image"] = infor as! UIImage
            }
            dic["url"] = info[UIImagePickerController.InfoKey.imageURL]
            if let infor = info[UIImagePickerController.InfoKey.imageURL] {
                if let url = infor as? URL {
                    dic["stringUrl"] = url
                }
            }
            
        } else {
            dic["video"] = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        }
        imagePicker.dismiss(animated: false) {
            if self.completion != nil {
                self.completion!(3,true, dic)
            }
        }
    }
    
    /// Delegate method called when user cancels media picking option
    ///
    /// - Parameter picker: picker that is opened
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: false) {
            if self.completion != nil {
                self.completion!(3,false, nil)
            }
        }
    }
    
}


