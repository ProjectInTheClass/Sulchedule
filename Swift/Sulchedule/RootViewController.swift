import UIKit
import GoogleMobileAds

protocol RootViewDelegate{
    func removeAd(_ animated: Bool)
    func showAd(_ animated: Bool)
    func setAdBackgroundColor()
    func setBackgroundColor(light: Bool)
    func showSnackBar(string: String, buttonPlaced: Bool, animated: Bool)
    func refreshXLowerColor()
    func hideSnackBar(animated: Bool)
    
    func isSnackBarOpen() -> Bool
}

var rootViewDelegate: RootViewDelegate?

class RootViewController: UIViewController, GADBannerViewDelegate, RootViewDelegate, UIGestureRecognizerDelegate {
    var adReceived = false
    var positionConstraintValue = -80
    
    var workItem: DispatchWorkItem? = nil
    
    func setBackgroundColor(light: Bool) {
        if(light){
            backgroundView.backgroundColor = colorLightBackground
        }
        else{
            backgroundView.backgroundColor = colorDeepBackground
        }
    }
    
    func showAd(_ animated: Bool = true) {
        let time = 0.35
        if(!getAdIsOff() && adReceived && !userSetting.firstLaunch && animated){
            addBannerViewToView(bannerView)
            self.adAreaLoc.constant = 0
            UIView.animate(withDuration: time, delay: 0, options: [.curveEaseInOut], animations: {
                self.adArea.alpha = 1
            }, completion:nil)
            UIView.animate(withDuration: time, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else if(!getAdIsOff() && adReceived && !userSetting.firstLaunch){
            addBannerViewToView(bannerView)
            self.adAreaLoc.constant = 0
            self.adArea.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func isSnackBarOpen() -> Bool{
        if(snackBarPositionConstraint.constant == 0){
            return false
        }
        else{
            return true
        }
    }
    
    func refreshSnackBarColor(){
        snackBarView.backgroundColor = colorLightBackground
        snackBarCloseButton.titleLabel?.textColor = colorPoint
        snackBarText.textColor = colorText
    }
    
    func setAdBackgroundColor() {
        backgroundView.backgroundColor = colorLightBackground
        adArea.backgroundColor = colorLightBackground
        
        //and snackbar background also (squeezing it in)
        refreshSnackBarColor()
    }
    
    func refreshXLowerColor(){
        iPhoneXLowerBackground.backgroundColor = colorLightBackground
    }
    
    func removeAd(_ animated: Bool = true) {
        let time = 0.35
        if(adReceived && animated){
            self.adAreaLoc.constant = -60
            UIView.animate(withDuration: time, delay: 0, options: [.curveEaseInOut], animations: {
                self.adArea.alpha = 0
            }, completion:nil)
            UIView.animate(withDuration: time, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion:{ (finished: Bool) in for view in self.adArea.subviews {
                view.removeFromSuperview()
                }})
        }
        else if(adReceived){
            self.adAreaLoc.constant = -60
            self.adArea.alpha = 0
            self.view.layoutIfNeeded()
            view.removeFromSuperview()
        }
    }
    
    func showSnackBar(string: String, buttonPlaced: Bool, animated: Bool = true) {
        let radius: CGFloat = snackBarView.frame.width / 2.0
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2 * radius, height: snackBarView.frame.height))
        snackBarView.layer.shadowColor = UIColor.black.cgColor
        snackBarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        snackBarView.layer.shadowOpacity = 0.4
        snackBarView.layer.shadowRadius = 7.0
        snackBarView.layer.masksToBounds =  false
        snackBarView.layer.shadowPath = shadowPath.cgPath
        refreshSnackBarColor()
        snackBarText.text = string
        snackBarPositionConstraint.constant = CGFloat(positionConstraintValue)
        if(buttonPlaced){
            snackBarCloseButton.isHidden = false
            snackBarCloseButton.isUserInteractionEnabled = true
        }
        else{
            snackBarCloseButton.isHidden = true
            snackBarCloseButton.isUserInteractionEnabled = false
        }
        
        if(animated){
            UIView.animate(withDuration: 0.25, delay: 0.05, options: [.curveEaseInOut], animations: {
                self.snackBarView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion:nil)
        }
        else{
            self.snackBarView.alpha = 1
            self.view.layoutIfNeeded()
        }
        workItem = DispatchWorkItem { self.hideSnackBar() }
        DispatchQueue.main.asyncAfter(deadline: .now() + snackBarWaitTime, execute: workItem!)
    }
    
    func hideSnackBar(animated: Bool = true){
        snackBarPositionConstraint.constant = 0
        if(isSnackBarOpen()){
            workItem!.cancel()
        }
        if(animated){
            UIView.animate(withDuration: 0.25, delay: 0.05, options: [.curveEaseInOut], animations: {
                self.snackBarView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion:nil)
        }
        else{
            self.snackBarView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func snackBarCloseAction(_ sender: UIButton) {
        hideSnackBar()
    }
    @IBOutlet weak var iPhoneXLowerBackground: UIView!
    @IBOutlet weak var snackBarLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var snackBarRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var snackBarCloseButton: UIButton!
    @IBOutlet weak var snackBarText: UILabel!
    @IBOutlet weak var snackBarView: UIView!
    @IBOutlet weak var snackBarPositionConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var adAreaLoc: NSLayoutConstraint!
    @IBOutlet weak var adArea: UIView!
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootViewDelegate = self
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        //test unit id
//            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //actual unit id
        bannerView.adUnitID = "ca-app-pub-4587910042719801/7836975613"
        
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(request)
        
        setSucceededLastMonth()
        adArea.alpha = 0
        
        snackBarText.numberOfLines = 2
        
        positionConstraintValue = -80
        if(UIScreen.main.nativeBounds.height == 2436){
            snackBarLeftConstraint.constant = 10
            snackBarRightConstraint.constant = 10
            positionConstraintValue = -110
        }
        iPhoneXLowerBackground.backgroundColor = colorLightBackground
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown))
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeDownRecognizer.delegate = self
        snackBarView.addGestureRecognizer(swipeDownRecognizer)
    }
    override func viewDidAppear(_ animated: Bool) {
        setAdBackgroundColor()
        UIScreen.main.addObserver(self, forKeyPath: "captured", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "captured") {
            if #available(iOS 11.0, *) {
                let isCaptured = UIScreen.main.isCaptured
                if(isCaptured){
                    removeAd(false)
                    print("///removeAd from root")
                }
                else{
                    if(!getAdIsOff()){
                        showAd(false)
                        print("///showAd from root")
                    }
                }
            } else {
            }
        }
    }
    
    @objc func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
        if(!snackBarCloseButton.isHidden){
            hideSnackBar()
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        adReceived = true
        showAd()
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        adArea.addSubview(bannerView)
        adArea.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: adArea,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: adArea,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
}
