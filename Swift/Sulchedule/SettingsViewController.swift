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
    @IBOutlet weak var showDrunkButton: UIButton!
    @IBOutlet weak var showDrunkContainer: UIView!
    
    var vibOn: UIImage?
    var vibOff: UIImage?
    
    
//    var showYesterdayFirst = true
//    var isVibrationEnabled = true
//    var isThemeBright = false
    
    @IBAction func showDrunkButton(_ sender: UIButton) {
        setIsShowDrunkDays(enabled: !isShowDrunkDaysEnabled())
        if(isShowDrunkDaysEnabled()){
            showDrunkButton.setTitle("달력에 음주한 날짜를 표시합니다", for: .normal)
        }
        else{
            showDrunkButton.setTitle("달력에서 음주한 날짜를 숨깁니다", for: .normal)
        }
    }
    @IBAction func yesterdayButton(_ sender: UIButton) {
        setShowYesterdayFirst(yesterday: !getShowYesterdayFirst())
        if(getShowYesterdayFirst()){
            yesterdayButton.setTitle("정오까지 전날 날짜가 표시됩니다", for: .normal)
        }
        else{
            yesterdayButton.setTitle("자정부터 당시 날짜가 표시됩니다", for: .normal)
        }
    }
    @IBAction func resetButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "모든 정보 삭제", message: "음주 기록, 설정을 포함한 모든 정보가 초기화됩니다. 계속하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        let deleteAction = UIAlertAction(title: "삭제", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            resetApp()
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.darkThemeSwitch(_:)))
        themeContainer.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.vibrationSwitch(_:)))
        vibContainer.addGestureRecognizer(tap2)
        
        if(userData.isThemeBright){
            vibOn = UIImage(named: "vib_bright_on")
            vibOff = UIImage(named: "vib_bright_off")
        }
        else{
            vibOn = UIImage(named: "vib_on")
            vibOff = UIImage(named: "vib_off")
        }
        if(deviceCategory != 0){
            if(userData.isVibrationEnabled){
                vibLabel.text = "햅틱 켜짐"
                self.vibrationImageView.image = self.vibOn
            }
            else{
                vibLabel.text = "햅틱 꺼짐"
                self.vibrationImageView.image = self.vibOff
            }
        }
        else{
            vibLabel.text = "햅틱 미지원 기기"
            self.vibrationImageView.image = self.vibOff
        }
        if(getShowYesterdayFirst()){
            yesterdayButton.setTitle("정오까지 전날 날짜가 표시됩니다", for: .normal)
        }
        else{
            yesterdayButton.setTitle("자정부터 당시 날짜가 표시됩니다", for: .normal)
        }
        if(isShowDrunkDaysEnabled()){
            showDrunkButton.setTitle("달력에 음주한 날짜를 표시합니다", for: .normal)
        }
        else{
            showDrunkButton.setTitle("달력에서 음주한 날짜를 숨깁니다", for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        themeLabel.textColor = colorPoint
        vibLabel.textColor = colorPoint
        resetButton.tintColor = colorRed
        addSulButton.tintColor = colorPoint
        yesterdayButton.tintColor = colorPoint
        showDrunkButton.tintColor = colorPoint
        resetButton.setTitleColor(colorRed, for: .normal)
        addSulButton.setTitleColor(colorPoint, for: .normal)
        yesterdayButton.setTitleColor(colorPoint, for: .normal)
        showDrunkButton.setTitleColor(colorPoint, for: .normal)
        
        navigationItem.rightBarButtonItem?.tintColor = colorPoint
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(userData.isThemeBright){
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
            
            self.topBackgroundView.backgroundColor = colorLightBackground
            self.mainBackgroundView.backgroundColor = colorLightBackground
            self.themeContainer.backgroundColor = colorDeepBackground
            self.vibContainer.backgroundColor = colorDeepBackground
            self.addSulContainer.backgroundColor = colorDeepBackground
            self.resetContainer.backgroundColor = colorDeepBackground
            self.yesterdayContainer.backgroundColor = colorDeepBackground
            self.showDrunkContainer.backgroundColor = colorDeepBackground
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
            self.yesterdayContainer.backgroundColor = colorLightBackground
            self.showDrunkContainer.backgroundColor = colorLightBackground
        }
        self.applyShadow(view: self.resetContainer, enable: userData.isThemeBright)
        self.applyShadow(view: self.addSulContainer, enable: userData.isThemeBright)
        self.applyShadow(view: self.themeContainer, enable: userData.isThemeBright)
        self.applyShadow(view: self.yesterdayContainer, enable: userData.isThemeBright)
        
        if(userData.isVibrationEnabled){
            self.applyShadow(view: self.vibContainer, enable: userData.isThemeBright)
        }
        
        if(deviceCategory == 0){
            self.applyShadow(view: self.vibContainer, enable: false)
            self.vibLabel.textColor = .gray
        }
    }
    
    @objc func darkThemeSwitch(_ sender: UITapGestureRecognizer) {
        userData.isThemeBright.toggle()
        
        self.applyShadow(view: self.resetContainer, enable: userData.isThemeBright)
        self.applyShadow(view: self.addSulContainer, enable: userData.isThemeBright)
        self.applyShadow(view: self.themeContainer, enable: userData.isThemeBright)
        self.applyShadow(view: self.showDrunkContainer, enable: userData.isThemeBright)
        if(userData.isVibrationEnabled){
            self.applyShadow(view: self.vibContainer, enable: userData.isThemeBright)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            if(userData.isThemeBright){
                colorPoint = hexStringToUIColor(hex: "#0067B2")
                colorLightBackground = hexStringToUIColor(hex: "#EAEAEA")
                colorDeepBackground = hexStringToUIColor(hex: "#FFFFFF")
                
                self.mainBackgroundView.backgroundColor = colorLightBackground
                self.themeContainer.backgroundColor = colorDeepBackground
                self.vibContainer.backgroundColor = colorDeepBackground
                self.addSulContainer.backgroundColor = colorDeepBackground
                self.resetContainer.backgroundColor = colorDeepBackground
                self.yesterdayContainer.backgroundColor = colorDeepBackground
                self.showDrunkContainer.backgroundColor = colorDeepBackground
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
                self.yesterdayContainer.backgroundColor = colorLightBackground
                self.showDrunkContainer.backgroundColor = colorLightBackground
            }
            
            self.themeLabel.textColor = colorPoint
            self.vibLabel.textColor = colorPoint
            self.resetButton.setTitleColor(colorRed, for: .normal)
            self.addSulButton.setTitleColor(colorPoint, for: .normal)
            self.yesterdayButton.setTitleColor(colorPoint, for: .normal)
            self.showDrunkButton.setTitleColor(colorPoint, for: .normal)
            if(deviceCategory == 0){
                self.vibLabel.textColor = .gray
            }
            
            self.navigationBar_changeColor.barTintColor = colorLightBackground
            self.navigationBar_changeColor.backgroundColor = colorLightBackground
        }, completion: nil)
        if(userData.isThemeBright){
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
        if(deviceCategory != 0){
            if(userData.isVibrationEnabled){
                vibLabel.text = "햅틱 켜짐"
                self.vibrationImageView.image = self.vibOn
            }
            else{
                vibLabel.text = "햅틱 꺼짐"
                self.vibrationImageView.image = self.vibOff
            }
        }
        else{
            vibLabel.text = "햅틱 미지원 기기"
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
        userData.isVibrationEnabled.toggle()
        if(deviceCategory != 0){
            if(userData.isVibrationEnabled){
                AudioServicesPlaySystemSound(vibTryAgain)
                vibLabel.text = "햅틱 켜짐"
                self.vibrationImageView.image = self.vibOn
            }
            else{
                vibLabel.text = "햅틱 꺼짐"
                self.vibrationImageView.image = self.vibOff
            }
        }
        else{
            vibLabel.text = "햅틱 미지원 기기"
            vibLabel.textColor = .gray
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
