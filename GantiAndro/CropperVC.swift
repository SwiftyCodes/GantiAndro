
import UIKit
import TOCropViewController
import AVFoundation

class CropperVC: UIViewController,FloatyDelegate,TOCropViewControllerDelegate{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var flipButton: UIButton!
    
    @IBOutlet weak var sliderOutlet: UISlider!
    
    var image : UIImage?
    
    var lastPoint : CGPoint = CGPoint.zero
    var isSwipe : Bool = false
    
    var editBool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.frame = AVMakeRect(aspectRatio: (image?.size)!, insideRect: photoView.bounds)
        photoView.image = image
        
        sliderOutlet.isHidden = true

    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    
    var flipHor = true
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
        
        let toVC: StartVC? = self.storyboard?.instantiateViewController(withIdentifier: "StartVC") as? StartVC

        
        self.present(toVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func cropAction(_ sender: UIButton) {
        
        photoView.image = returnFinalImage()
        
        self.presentViewController()
        
    }
    
    
    //MARK: Cropper Tool
    func presentViewController() {
        
        let imageView = UIImageView(image: photoView.image)
        _ = self.view.convert(imageView.frame, to: self.view)
        let cropViewController = TOCropViewController(image: photoView.image!)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: { _ in })
    }
    
    
    @objc(cropViewController:didCropToImage:withRect:angle:) func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
 
        photoView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func flipHorizontal(_ sender: UIButton) {
        editBool = false
        sliderOutlet.isHidden = true
        self.flipperPressed()
        
    }
    
    var flipTogleHorizontal = false
    var flipTogleVertical = false
    
    func flipperPressed() {
        
        self.photoView.image = returnFinalImage()
        
        if flipTogleHorizontal {
            
            
            UIView.transition(with: photoView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.photoView.transform = CGAffineTransform(scaleX: -1, y: 1)
                
              //  self.flipButton.setImage(UIImage(named:"flip"), for: .normal)
                
            }, completion: { _ in })
            
            flipTogleHorizontal = false
            
        }else {
            
            UIView.transition(with: photoView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                self.photoView.transform = CGAffineTransform(scaleX: 1, y: 1)
               // self.flipButton.setImage(UIImage(named:"v-flip"), for: .normal)
            }, completion: { _ in })
            
            flipTogleHorizontal = true
        }
    }
    

    @IBAction func rotateAction(_ sender: UIButton) {
        editBool = false
        sliderOutlet.isHidden = true
        self.rotate()
        
    }
    
    var countRotation = 1
    
    func rotate() {
        
        if countRotation == 1 {
            
            
            UIView.transition(with: photoView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                
                
                let image = UIImage(cgImage: (self.photoView.image?.cgImage!)!, scale: CGFloat(1.0), orientation: .right)
                self.photoView.image = image
                
            }, completion: { _ in })
            
            countRotation += 1
            return
        }
        
        if countRotation == 2 {
            
            
            UIView.transition(with: photoView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                
                
                let image = UIImage(cgImage: (self.photoView.image?.cgImage!)!, scale: CGFloat(1.0), orientation: .down)
                self.photoView.image = image
                
            }, completion: { _ in })
            
            countRotation += 1
            return
        }
        
        if countRotation == 3 {
            
            
            UIView.transition(with: photoView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                
                
                let image = UIImage(cgImage: (self.photoView.image?.cgImage!)!, scale: CGFloat(1.0), orientation: .left)
                self.photoView.image = image
                
            }, completion: { _ in })
            
            
            countRotation += 1
            return
            
        }
        
        if countRotation == 4{
            
            UIView.transition(with: photoView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                
                
                let image = UIImage(cgImage: (self.photoView.image?.cgImage!)!, scale: CGFloat(1.0), orientation: .up)
                self.photoView.image = image
                
            }, completion: { _ in })
            
            countRotation = 1
            return
            
        }
        
    }

    
    @IBAction func doneButtonAction(_ sender: UIButton) {
   
        let vc: EditorVC? = self.storyboard?.instantiateViewController(withIdentifier: "EditorVC") as? EditorVC
        
        vc?.image = photoView.image
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    func returnFinalImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(photoView.frame.size, photoView.isOpaque, 0.0)
        contentView.drawHierarchy(in: CGRect(x: CGFloat(photoView.frame.origin.x), y: CGFloat(0), width: CGFloat(photoView.frame.size.width), height: CGFloat(photoView.frame.size.height)), afterScreenUpdates: true)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    //Touches Function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSwipe = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.photoView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.photoView)
            draw(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
            
        }
        
    }
    
    func draw(fromPoint:CGPoint,toPoint:CGPoint) {
        
        if editBool {
            
            UIGraphicsBeginImageContext(self.photoView.bounds.size)// ??
            let context = UIGraphicsGetCurrentContext()
            photoView.image?.draw(in: self.photoView.bounds)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(CGFloat(sliderOutlet.value))
            context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            context?.setBlendMode(CGBlendMode.clear)
            context?.strokePath()
            photoView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
 
        }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isSwipe {
            draw(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }

    @IBAction func editButtonAction(_ sender: UIButton) {
        
        editBool = true
        photoView.image = returnFinalImage()
        sliderOutlet.isHidden = false

      
    }
    
}
