
import UIKit
import AVFoundation

var globalImageView = UIImageView()

class EditorVC: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var floatyButton: Floaty!
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var rotatableimageView: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var backGroundScrollView: UIScrollView!
    
    var image : UIImage?
    
    var floaty = Floaty()


    var aCIImage = CIImage()
    var brightnessFilter: CIFilter!
    var contrastFilter: CIFilter!
    var context = CIContext()
    var outputImage = CIImage()
    var newUIImage = UIImage()

        var blenderImageArray = ["bg1","bg2","bg3","bg4","bg5","bg6","bg7","bg8","bg9","bg10","bg11","bg12","bg13","bg14","bg15","bg16","bg17","bg18","bg19","bg20","bg21","bg22","bg23","bg24","bg25","bg26","bg27","bg28","bg29","bg30","bg31","bg32","bg33","bg34","bg35","bg36","bg37","bg38","bg39","bg40","bg41","bg42","bg43","bg44","bg45","bg46","bg47","bg48","bg49","bg50"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.frontImageView1.image = self.returnFinalImage()
    
        let randomValue = arc4random_uniform(19)
        self.frontImageView.image = UIImage(named: self.blenderImageArray[Int(randomValue)])
        
        masking()
        
        rotatableimageView.frame = AVMakeRect(aspectRatio: (image?.size)!, insideRect: rotatableimageView.bounds)
        
        rotatableimageView.image = image
        blenderScrollerCreation()
        floatyButtonCreation()
        
        self.viewSlider.isHidden = true
     
        let aUIImage = rotatableimageView.image;
        let aCGImage = aUIImage?.cgImage
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil)
        
        brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
        
        contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        
        opacitySlider.addTarget(self, action: #selector(EditorVC.opacityFrontImage), for: .touchUpInside)
        
        brightnessSlider.addTarget(self, action: #selector(EditorVC.brightnessFrontImage), for: .touchUpInside)
        
        contrastSlider.addTarget(self, action: #selector(EditorVC.contrastFrontImage), for: .touchUpInside)

    }

    
    func masking() {
        
        let maskLayer = CALayer()
        maskLayer.frame = rotatableimageView.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: rotatableimageView.bounds.insetBy(dx: CGFloat(5), dy: CGFloat(5)), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 15
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowColor = UIColor.black.cgColor
        rotatableimageView.layer.mask = maskLayer
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.backGroundScrollView.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
 
    var itemCount = 0
    func blenderScrollerCreation() {
        
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 50.0
        let buttonHeight: CGFloat = 50.0
        let gapBetweenButtons: CGFloat = 5
        
        
        for i in 0..<blenderImageArray.count{
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.showsTouchWhenHighlighted = true
            filterButton.contentMode = .scaleAspectFill
            
            let myimage = UIImage(named: blenderImageArray[itemCount])
            filterButton.setImage(myimage, for: .normal)
            
            filterButton.addTarget(self, action:#selector(blenderButtonTapped), for: .touchUpInside)
            filterButton.layer.cornerRadius = 4
            filterButton.clipsToBounds = true
            
            xCoord +=  buttonWidth + gapBetweenButtons
            backGroundScrollView.addSubview(filterButton)
        }
        
        backGroundScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+6), height: yCoord)

    }
  
    var filterItem : Int?
    
    func blenderButtonTapped(sender: UIButton) {
        let button = sender as UIButton
        filterItem = button.tag
        
        UIView.transition(with: frontImageView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.frontImageView.image = UIImage(named: self.blenderImageArray[button.tag])
        }, completion: { _ in })
  
    }

    
    func opacityFrontImage(sender: UISlider) {
        
        DispatchQueue.main.async
            {
                
                UIView.transition(with: self.rotatableimageView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.rotatableimageView.alpha = CGFloat(sender.value)
                }, completion: { _ in })
    
        }
        
    }
    
    func brightnessFrontImage(sender: UISlider) {
        
        brightnessFilter.setValue(NSNumber(value: sender.value), forKey: "inputBrightness");
        outputImage = brightnessFilter.outputImage!;
        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: imageRef!)
        rotatableimageView.image = newUIImage
    }
    
    func contrastFrontImage(sender: UISlider) {
        
        contrastFilter.setValue(NSNumber(value: sender.value), forKey: "inputContrast")
        outputImage = contrastFilter.outputImage!;
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        newUIImage = UIImage(cgImage: cgimg!)
        rotatableimageView.image = newUIImage
        
    }

   func floatyButtonCreation() {
    
    
    //Mark: Effects Button
        let item = FloatyItem()
        item.buttonColor = UIColor.black
        item.circleShadowColor = UIColor.white
        item.title = "Effects"
        item.icon = UIImage(named : "effects")
    
        item.handler = { item in
        
           
            self.toShowViewSlider()
            self.toHideScrollView()
            self.floatyButton.isHidden = false
        
        }
    

    //Mark: Background Button
        let itemBackground = FloatyItem()
        itemBackground.buttonColor = UIColor.black
        itemBackground.circleShadowColor = UIColor.white
        itemBackground.title = "Background"
        itemBackground.icon = UIImage(named : "background-image")
    
        itemBackground.handler = { item in
        
         
            self.toHideViewSlider()
            self.toShowScrollView()
            //self.floatyButton.isHidden = true
        
        }
    
    //Mark: Edit Button
        let itemEdit = FloatyItem()
        itemEdit.buttonColor = UIColor.black
        itemEdit.circleShadowColor = UIColor.white
        itemEdit.title = "Edit"
        itemEdit.icon = UIImage(named : "edit")
    
        itemEdit.handler = { item in
        
         
            self.toHideViewSlider()
            self.toHideScrollView()
            self.floatyButton.isHidden = false
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
    
    //Mark: Home Button
    let itemHome = FloatyItem()
    itemHome.buttonColor = UIColor.black
    itemHome.circleShadowColor = UIColor.white
    itemHome.title = "Home"
    itemHome.icon = UIImage(named : "home")
    
    itemHome.handler = { item in

        self.toHideViewSlider()
        self.toHideScrollView()
        self.floatyButton.isHidden = false
        
        let refreshAlert = UIAlertController(title: "Alert", message: "All creations will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in

            let toVC: StartVC? = self.storyboard?.instantiateViewController(withIdentifier: "StartVC") as? StartVC
            
            
            self.present(toVC!, animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
           
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)

        
    }
    
    //Mark: Share Button
    let itemSahre = FloatyItem()
    itemSahre.buttonColor = UIColor.black
    itemSahre.circleShadowColor = UIColor.white
    itemSahre.title = "Share"
    itemSahre.icon = UIImage(named : "share")
    
    itemSahre.handler = { item in
        
        globalImageView.image = self.returnFinalImage()
        print(self.frontImageView.image as Any)
        
        self.toHideViewSlider()
        self.toHideScrollView()
        self.floatyButton.isHidden = false
        
        
        
        let toVC: SahringVC? = self.storyboard?.instantiateViewController(withIdentifier: "SahringVC") as? SahringVC
        
        
        
        self.present(toVC!, animated: true, completion: nil)
    
    }
    
        floatyButton.addItem(item: item)
        floatyButton.addItem(item: itemBackground)
        floatyButton.addItem(item: itemEdit)
        floatyButton.addItem(item: itemHome)
        floatyButton.addItem(item: itemSahre)

    }
    
   
      func floatyOpened(_ floaty: Floaty) {
       
    }
    
    func floatyClosed(_ floaty: Floaty) {
       
    }
    
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        
        frontImageView.bringSubview(toFront: rotatableimageView)
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
        
    }
    
    
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc func gestureRecognizer(_: UIGestureRecognizer,
                                 shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func toShowViewSlider() {
        
        UIView.transition(with: viewSlider, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewSlider.isHidden = false
        }, completion: { _ in })
    }
    
    func toHideViewSlider() {
        
        UIView.transition(with: viewSlider, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewSlider.isHidden = true
        }, completion: { _ in })
    }
    
    func toHideScrollView() {
        
        UIView.transition(with: backGroundScrollView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.backGroundScrollView.isHidden = true
        }, completion: { _ in })
    }
    
    func toShowScrollView() {
        
        UIView.transition(with: backGroundScrollView, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.backGroundScrollView.isHidden = false
        }, completion: { _ in })
    }
    
    
    func returnFinalImage() -> UIImage {
        
    UIGraphicsBeginImageContextWithOptions(contentView.frame.size, contentView.isOpaque, 0.0)
    contentView.drawHierarchy(in: CGRect(x: CGFloat(contentView.frame.origin.x), y: CGFloat(0), width: CGFloat(contentView.frame.size.width), height: CGFloat(contentView.frame.size.height)), afterScreenUpdates: true)
    let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
        
    }
    
    @IBAction func crossButton(_ sender: UIButton) {
        
        UIView.transition(with: viewSlider, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.viewSlider.isHidden = true
        }, completion: { _ in })
        
    }
    
}
