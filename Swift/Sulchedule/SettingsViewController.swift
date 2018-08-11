import UIKit
import AudioToolbox.AudioServices

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationBar_changeColor: UINavigationBar!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet var mainBackgroundView: UIView!
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var vibrationImageView: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var vibLabel: UILabel!
    @IBOutlet weak var themeContainer: UIView!
    @IBOutlet weak var vibContainer: UIView!
    @IBOutlet weak var addSulContainer: UIView!
    @IBOutlet weak var addSulButton: UIButton!
    @IBOutlet weak var resetContainer: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var yesterdayButton: UIButton!
    @IBOutlet weak var yesterdayContainer: UIView!
    
    var vibOn: UIImage?
    var vibOff: UIImage?
    
    var showyester = false //
    
    @IBAction func yesterdayButton(_ sender: UIButton) {
        showyester.toggle()
        if(showyester){
            yesterdayButton.titleLabel!.text = "정오까지 전날 날짜가 표시됩니다"
        }
        else{
            yesterdayButton.titleLabel!.text = "자정부터 당시 날짜가 표시됩니다"
        }
    }
    @IBAction func resetButton(_ sender: UIButton) {
        //reset method
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.darkThemeSwitch(_:)))
        themeContainer.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.vibrationSwitch(_:)))
        vibContainer.addGestureRecognizer(tap2)
    }
    override func viewWillAppear(_ animated: Bool) {
        themeLabel.textColor = colorPoint
        vibLabel.textColor = colorPoint
        resetButton.tintColor = colorRed
        addSulButton.tintColor = colorPoint
        
        navigationItem.rightBarButtonItem?.tintColor = colorPoint
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(isBrightTheme){
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
            
            self.topBackgroundView.backgroundColor = colorLightBackground
            self.mainBackgroundView.backgroundColor = colorLightBackground
            self.themeContainer.backgroundColor = colorDeepBackground
            self.vibContainer.backgroundColor = colorDeepBackground
            self.addSulContainer.backgroundColor = colorDeepBackground
            self.resetContainer.backgroundColor = colorDeepBackground
        }
        else{
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
            
            self.topBackgroundView.backgroundColor = colorLightBackground
            self.mainBackgroundView.backgroundColor = colorDeepBackground
            self.themeContainer.backgroundColor = colorLightBackground
            self.vibContainer.backgroundColor = colorLightBackground
            self.addSulContainer.backgroundColor = colorLightBackground
            self.resetContainer.backgroundColor = colorLightBackground
        }
        self.applyShadow(view: self.resetContainer, enable: isBrightTheme)
        self.applyShadow(view: self.addSulContainer, enable: isBrightTheme)
        self.applyShadow(view: self.themeContainer, enable: isBrightTheme)
        if(isVibrationOn){
            self.applyShadow(view: self.vibContainer, enable: isBrightTheme)
        }
        if(isBrightTheme){
            vibOn = UIImage(named: "vib_bright_on")
            vibOff = UIImage(named: "vib_bright_off")
        }
        else{
            vibOn = UIImage(named: "vib_on")
            vibOff = UIImage(named: "vib_off")
        }
        if(isVibrationOn){
            vibLabel.text = "진동 켜짐"
            self.vibrationImageView.image = self.vibOn
        }
        else{
            vibLabel.text = "진동 꺼짐"
            self.vibrationImageView.image = self.vibOff
        }
    }
    
    @objc func darkThemeSwitch(_ sender: UITapGestureRecognizer) {
        if(isVibrationOn){
            AudioServicesPlaySystemSound(vibPeek)
        }
        isBrightTheme.toggle()
        
        self.applyShadow(view: self.resetContainer, enable: isBrightTheme)
        self.applyShadow(view: self.addSulContainer, enable: isBrightTheme)
        self.applyShadow(view: self.themeContainer, enable: isBrightTheme)
        if(isVibrationOn){
            self.applyShadow(view: self.vibContainer, enable: isBrightTheme)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            if(isBrightTheme){
                colorPoint = hexStringToUIColor(hex: "#0067B2")
                colorLightBackground = hexStringToUIColor(hex: "#EAEAEA")
                colorDeepBackground = hexStringToUIColor(hex: "#FFFFFF")
                
                self.mainBackgroundView.backgroundColor = colorLightBackground
                self.themeContainer.backgroundColor = colorDeepBackground
                self.vibContainer.backgroundColor = colorDeepBackground
                self.addSulContainer.backgroundColor = colorDeepBackground
                self.resetContainer.backgroundColor = colorDeepBackground
            }
            else{
                colorPoint = hexStringToUIColor(hex:"FFDC67")
                colorLightBackground = hexStringToUIColor(hex:"252B53")
                colorDeepBackground = hexStringToUIColor(hex:"0B102F")
                
                self.mainBackgroundView.backgroundColor = colorDeepBackground
                self.themeContainer.backgroundColor = colorLightBackground
                self.vibContainer.backgroundColor = colorLightBackground
                self.addSulContainer.backgroundColor = colorLightBackground
                self.resetContainer.backgroundColor = colorLightBackground
            }
            
            self.themeLabel.textColor = colorPoint
            self.vibLabel.textColor = colorPoint
            self.resetButton.tintColor = colorRed
            self.addSulButton.tintColor = colorPoint
            
            self.navigationBar_changeColor.barTintColor = colorLightBackground
            self.navigationBar_changeColor.backgroundColor = colorLightBackground
        }, completion: nil)
        if(isBrightTheme){
            vibOn = UIImage(named: "vib_bright_on")
            vibOff = UIImage(named: "vib_bright_off")
            
            self.topBackgroundView.backgroundColor = colorLightBackground
            UINavigationBar.appearance().tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
            UITabBar.appearance().unselectedItemTintColor = .black
            UILabel.appearance().textColor = UIColor.black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
            
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
            self.navigationBar_changeColor.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        }
        else{
            vibOn = UIImage(named: "vib_on")
            vibOff = UIImage(named: "vib_off")
            
            self.topBackgroundView.backgroundColor = colorLightBackground
            UINavigationBar.appearance().tintColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            UITabBar.appearance().unselectedItemTintColor = .white
            UILabel.appearance().textColor = UIColor.white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
            self.navigationBar_changeColor.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        if(isVibrationOn){
            vibLabel.text = "진동 켜짐"
            self.vibrationImageView.image = self.vibOn
        }
        else{
            vibLabel.text = "진동 꺼짐"
            self.vibrationImageView.image = self.vibOff
        }
        UINavigationBar.appearance().barTintColor = colorLightBackground
        UINavigationBar.appearance().backgroundColor = colorLightBackground
        
        UITabBar.appearance().tintColor = colorPoint
        UITabBar.appearance().barTintColor = colorLightBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
    }
    @objc func vibrationSwitch(_ sender: UITapGestureRecognizer) {
        isVibrationOn.toggle()
        if(isVibrationOn){
            AudioServicesPlaySystemSound(vibTryAgain)
            vibLabel.text = "진동 켜짐"
            self.vibContainer.layer.shadowColor = UIColor.black.cgColor
            self.vibrationImageView.image = self.vibOn
        }
        else{
            vibLabel.text = "진동 꺼짐"
            self.vibContainer.layer.shadowColor = UIColor.clear.cgColor
            self.vibrationImageView.image = self.vibOff
        }
    }
    
    func applyShadow(view: UIView, enable: Bool){
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: view.frame.width + 8, height: view.frame.height + 8))
        view.layer.shadowOffset = CGSize(width: -4, height: -4)
        view.layer.shadowOpacity = 0.06
        view.layer.shadowRadius = 3.0
        view.layer.masksToBounds =  false
        view.layer.shadowPath = shadowPath.cgPath
        if(enable){
            view.layer.shadowColor = UIColor.black.cgColor
        }
        else{
            view.layer.shadowColor = UIColor.clear.cgColor
        }
    }

}
