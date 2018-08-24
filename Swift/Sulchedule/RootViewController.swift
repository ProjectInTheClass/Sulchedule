import UIKit
import GoogleMobileAds

protocol RootViewDelegate{
    func removeAd()
    func showAd()
    func setAdBackgroundColor()
    func setBackgroundColor(light: Bool)
}

var rootViewDelegate: RootViewDelegate?

class RootViewController: UIViewController, GADBannerViewDelegate, RootViewDelegate {
    
    var adReceived = false
    
    func setBackgroundColor(light: Bool) {
        if(light){
            backgroundView.backgroundColor = colorLightBackground
        }
        else{
            backgroundView.backgroundColor = colorDeepBackground
        }
    }
    
    func showAd() {
        print("///Show Ad")
        if(!getAdIsOff() && adReceived && !userSetting.firstLaunch){
            addBannerViewToView(bannerView)
            self.adAreaLoc.constant = 0
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                self.adArea.alpha = 1
            }, completion:nil)
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setAdBackgroundColor() {
        backgroundView.backgroundColor = colorLightBackground
        adArea.backgroundColor = colorLightBackground
    }
    
    func removeAd() {
        if(adReceived){
            self.adAreaLoc.constant = -60
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                self.adArea.alpha = 0
            }, completion:nil)
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion:{ (finished: Bool) in for view in self.adArea.subviews {
                view.removeFromSuperview()
                }})
        }
    }
    
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
        self.adArea.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        setAdBackgroundColor()
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
