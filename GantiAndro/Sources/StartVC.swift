import UIKit
import WobbleBubbleButton
import TGCameraViewController


class StartVC: UIViewController,TGCameraDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    
    @IBOutlet weak var cameraButton: WobbleBubbleButton!
    @IBOutlet weak var galleryButton: WobbleBubbleButton!
    
    var picker:UIImagePickerController?=UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    @IBAction func galleryButtonAction(_ sender: UIButton) {
        
        print("Gallery Button Clicked")
        
        self.openGallery()
        
    }
    
    func openGallery()
        
    {
        
        picker?.delegate=self
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
 
        let cameraImageis = info[UIImagePickerControllerOriginalImage] as? UIImage
     
        let vc: CropperVC? = self.storyboard?.instantiateViewController(withIdentifier: "CropperVC") as? CropperVC
        
        vc?.image = cameraImageis
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = vc

        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    


    @IBAction func cameraButtonAction(_ sender: UIButton) {
        
        print("Camera Button Clicked")
        
        let navigationController = TGCameraNavigationController.new(with: self)
        present(navigationController!, animated: true, completion: nil)
    }
    
    func cameraDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func cameraDidTakePhoto(_ image: UIImage!) {
        
        let toVC: CropperVC? = self.storyboard?.instantiateViewController(withIdentifier: "CropperVC") as? CropperVC
        
        toVC?.image = image
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = toVC
        
        
    }
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        
        let toVC: CropperVC? = self.storyboard?.instantiateViewController(withIdentifier: "CropperVC") as? CropperVC
        
        toVC?.image = image
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = toVC
        
    }

    // MARK: TGCameraDelegate - Optional methods
    
    func cameraWillTakePhoto() {
        print("cameraWillTakePhoto")
    }
    
    func cameraDidSavePhoto(atPath assetURL: URL!) {
        print("cameraDidSavePhotoAtPath: \(assetURL)")
    }
    
    func cameraDidSavePhotoWithError(_ error: Error!) {
        print("cameraDidSavePhotoWithError \(error)")
    }

}
