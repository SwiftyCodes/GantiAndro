//
//  SahringVC.swift
//  GantiAndro
//
//  Created by Polak on 6/6/17.
//  Copyright © 2017 Polak. All rights reserved.
//

import UIKit
import Social
import MessageUI
import AVFoundation

class SahringVC: UIViewController ,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate{
    
    @IBOutlet var gradientview: GradientView!
    @IBOutlet weak var leadingInstaConstant: NSLayoutConstraint!
        @IBOutlet weak var mailTrailingConstant: NSLayoutConstraint!
    var currentColorArrayIndex = -1
    var colorArray : [(color1:UIColor , color2:UIColor)] = []
 
     let modelName = UIDevice.current.modelName

       override func viewDidLoad() {
        super.viewDidLoad()
    
        if modelName == "iPhone 6 Plus" || modelName == "iPhone 7 Plus" {
            leadingInstaConstant.constant = -60
            mailTrailingConstant.constant = 60

            
        }else if (modelName == "iPhone 7" || modelName == "iPhone 6") {
            leadingInstaConstant.constant = -45
            mailTrailingConstant.constant = 45

            
        }else if (modelName == "iPhone SE" || modelName == "iPhone 5" || modelName == "iPhone 5c" || modelName == "iPhone 5s" || modelName == "iPhone 4" || modelName == "iPhone 4s" || modelName == "Simulator" || modelName == "iPad Mini") {
            leadingInstaConstant.constant = -25
            mailTrailingConstant.constant = 25
        
        }

        
    }
    

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        
        let screen = UIScreen.main
        
        switch sender
            .tag{
            
        case 1:
            
            if let window = UIApplication.shared.keyWindow {
                UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
                let image = globalImageView.image!
                UIGraphicsEndImageContext();
                
                let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                composeSheet?.setInitialText("Hello, Facebook!")
                composeSheet?.add(image)
                present(composeSheet!, animated: true, completion: nil)
            }
            
        case 2:
            
            let screen = UIScreen.main
            
            if let window = UIApplication.shared.keyWindow {
                UIGraphicsBeginImageContextWithOptions(screen.bounds.size, false, 0);
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
                let image = globalImageView.image!
                UIGraphicsEndImageContext();
                
                let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                composeSheet?.setInitialText("Hello, Twitter!")
                composeSheet?.add(image)
                present(composeSheet!, animated: true, completion: nil)
            }
            
        case 3:
            
            InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: globalImageView.image!, instagramCaption: "\(self.description)", view: self.view)
            
        case 4:
            
            sendMail(imageView: globalImageView)
            
        case 5:
            
            UIImageWriteToSavedPhotosAlbum(globalImageView.image!, nil, nil, nil)

            
           _ = SCLAlertView().showSuccess("Success", subTitle: "Your Image has been saved.")

        case 6:
            
            sharePhoto()
            
        default:
            break
        }
        
    }
    
    //MARK: Sending Mail
    func sendMail(imageView: UIImageView) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Your messagge")
            mail.setMessageBody("Message body", isHTML: false)
            let imageData: NSData = UIImagePNGRepresentation(imageView.image!)! as NSData
            mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName")
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Share
    var activityPopoverController: UIPopoverController?
    func sharePhoto() {
        if globalImageView.image == nil {
            return
        }
        let activityController = UIActivityViewController(activityItems: [globalImageView.image! as Any], applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            present(activityController, animated: true, completion: { _ in })
        }
        else {
            
            activityPopoverController?.dismiss(animated: false)
            activityPopoverController = UIPopoverController(contentViewController: activityController)
            activityPopoverController?.present(from: navigationItem.rightBarButtonItem!, permittedArrowDirections: .any, animated: true)
            
        }
    }
    

    
}


// For Dynamic UIImanagement Purpose

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}


