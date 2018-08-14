import UIKit
import GoogleMobileAds

protocol RemoveAdDelegate{
    func removeAd()
    func showAd()
    func setAdBackgroundColor()
}

var removeAdDelegate: RemoveAdDelegate?

class RootViewController: UIViewController, GADBannerViewDelegate, RemoveAdDelegate {
    func showAd() {
        if(!getPurchased()){
            self.adAreaLoc.constant = 0
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setAdBackgroundColor() {
        adArea.backgroundColor = colorLightBackground
    }
    
    func removeAd() {
        self.adAreaLoc.constant = -60
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBOutlet weak var adAreaLoc: NSLayoutConstraint!
    @IBOutlet weak var adArea: UIView!
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeAdDelegate = self
        
        if(!getPurchased()){
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            //test unit id
//            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            //actual unit id
            bannerView.adUnitID = "ca-app-pub-4587910042719801/7836975613"
            
            bannerView.rootViewController = self
            bannerView.delegate = self
            
            bannerView.load(request)
            addBannerViewToView(bannerView)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setAdBackgroundColor()
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    
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
