import UIKit
import GoogleMobileAds

class IconSelectViewController: UIViewController {
    
    var bannerView: GADBannerView!

    @IBOutlet var backgroundView: UIView!
    @IBAction func button1(_ sender: UIButton) {
        changeIcon(to: "redTeaser")
    }
    @IBOutlet weak var label1: UILabel!
    @IBAction func button2(_ sender: Any) {
        changeIcon(to: "yellowTeaser")
    }
    @IBOutlet weak var label2: UILabel!
    @IBAction func button3(_ sender: Any) {
        changeIcon(to: "greenTeaser")
    }
    @IBOutlet weak var label3: UILabel!
    @IBAction func button4(_ sender: Any) {
        if(userSetting.succeededLastMonth){
            changeIcon(to: "greenTeaser")
        }
    }
    @IBOutlet weak var label4: UILabel!
    @IBAction func button5(_ sender: Any) {
        if(userSetting.succeededLastMonth){
            changeIcon(to: "greenTeaser")
        }
    }
    @IBOutlet weak var label5: UILabel!
    @IBAction func button6(_ sender: Any) {
        if(userSetting.succeededLastMonth){
            changeIcon(to: "greenTeaser")
        }
    }
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!getPurchased()){
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView.adUnitID = "ca-app-pub-4587910042719801/9709526145"
            bannerView.rootViewController = self
            bannerView.load(request)
            addBannerViewToView(bannerView)
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(userSetting.isThemeBright){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
        if(!userSetting.succeededLastMonth){
            label4.textColor = .gray
            label5.textColor = .gray
            label6.textColor = .gray
            button4.alpha = 0.5
            button5.alpha = 0.5
            button6.alpha = 0.5
        }
    }
}
