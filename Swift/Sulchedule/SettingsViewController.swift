import UIKit
import AudioToolbox.AudioServices

protocol RootSettingDelegate {
    func darkThemeSwitch()
    func resetButtonClicked()
    func loadChangeIcon()
}

class SettingsViewController: UIViewController, RootSettingDelegate {

    @IBOutlet weak var navigationBar_changeColor: UINavigationBar!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var addSulContainer: UIView!
    @IBOutlet weak var addSulButton: UIButton!
    @IBOutlet weak var monthlyReportContainer: UIView!
    @IBOutlet weak var monthlyReportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if(deviceCategory != 0){
            if(userSetting.isVibrationEnabled){
            }
            else{
            }
        }
        else{
            //미지원 기기
        }
        if(getShowYesterdayFirst()){
        }
        else{
        }
        if(isShowDrunkDaysEnabled()){
        }
        else{
        }
        
        if(userSetting.firstLaunch){
            snackBar(string: "이곳은 설정과 정보가 공존하는 곳입니다.\n월간 보고서를 눌러보세요!", buttonPlaced: false)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        addSulButton.tintColor = colorPoint
        addSulButton.setTitleColor(colorPoint, for: .normal)
        monthlyReportButton.setTitleColor(colorPoint, for: .normal)
        setSucceededLastMonth()
        if(!userSetting.succeededLastMonth){
            rootViewDelegate?.showAd()
            setAdIsOff(adIsOff: false)
        }
        else if(getAdIsOff()){
//            for future in-app purchase
//            removeAdButton.isUserInteractionEnabled = false
//            removeAdButton.setTitleColor(colorGray, for: .normal)
            rootViewDelegate?.removeAd()
        }
        else{
            rootViewDelegate?.showAd()
        }
        
        rootViewDelegate?.setAdBackgroundColor()
        navigationItem.rightBarButtonItem?.tintColor = colorPoint
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:colorText]
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
        if(userSetting.isThemeBright){
            self.topBackgroundView.backgroundColor = colorLightBackground
            self.mainBackgroundView.backgroundColor = colorLightBackground
            self.addSulContainer.backgroundColor = colorDeepBackground
            self.monthlyReportContainer.backgroundColor = colorDeepBackground
        }
        else{
            self.topBackgroundView.backgroundColor = colorLightBackground
            self.mainBackgroundView.backgroundColor = colorDeepBackground
            self.addSulContainer.backgroundColor = colorLightBackground
            self.monthlyReportContainer.backgroundColor = colorLightBackground
        }
        self.applyShadow(view: self.addSulContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.monthlyReportContainer, enable: userSetting.isThemeBright)
        
        if(deviceCategory == 0){
            //미지원 기기
        }
    }
    
    func darkThemeSwitch() {
        userSetting.isThemeBright = !userSetting.isThemeBright
        
        self.applyShadow(view: self.addSulContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.monthlyReportContainer, enable: userSetting.isThemeBright)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            if(userSetting.isThemeBright){
                colorPoint = hexStringToUIColor(hex: "#0067B2")
                colorLightBackground = hexStringToUIColor(hex: "#EAEAEA")
                colorDeepBackground = hexStringToUIColor(hex: "#FFFFFF")
                colorGray = .gray
                colorText = .black
                
                self.mainBackgroundView.backgroundColor = colorLightBackground
                self.addSulContainer.backgroundColor = colorDeepBackground
                self.monthlyReportContainer.backgroundColor = colorDeepBackground
            }
            else{
                colorPoint = hexStringToUIColor(hex:"FFDC67")
                colorLightBackground = hexStringToUIColor(hex:"252B53")
                colorDeepBackground = hexStringToUIColor(hex:"0B102F")
                colorGray = hexStringToUIColor(hex:"A4A4A4")
                colorText = .white
                
                self.mainBackgroundView.backgroundColor = colorDeepBackground
                self.addSulContainer.backgroundColor = colorLightBackground
                self.monthlyReportContainer.backgroundColor = colorLightBackground
            }
            
            rootViewDelegate?.refreshXLowerColor()
            self.addSulButton.setTitleColor(colorPoint, for: .normal)
            self.monthlyReportButton.setTitleColor(colorPoint, for: .normal)
            
            if(deviceCategory == 0){
                //미지원 기기
            }
            
            if(!userSetting.succeededLastMonth){
                //전 달 실패
            }
            else if(getAdIsOff()){
//                For future in-app purchase
//                self.removeAdButton.setTitleColor(colorGray, for: .normal)
            }
            else{
            }
            
            self.navigationBar_changeColor.barTintColor = colorLightBackground
            self.navigationBar_changeColor.backgroundColor = colorLightBackground
        }, completion: nil)
        self.topBackgroundView.backgroundColor = colorLightBackground
        UINavigationBar.appearance().tintColor = colorText
        UITabBar.appearance().unselectedItemTintColor = colorText
        UILabel.appearance().textColor = colorText
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : colorText]
        
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        self.navigationBar_changeColor.titleTextAttributes = [NSAttributedStringKey.foregroundColor : colorText]
        if(userSetting.isThemeBright){
            UIApplication.shared.statusBarStyle = .default
        }
        else{
            UIApplication.shared.statusBarStyle = .lightContent
        }
        if(deviceCategory != 0){
            if(userSetting.isVibrationEnabled){
            }
            else{
            }
        }
        else{
            //미지원 기기
        }
        UINavigationBar.appearance().barTintColor = colorLightBackground
        UINavigationBar.appearance().backgroundColor = colorLightBackground
        
        UITabBar.appearance().tintColor = colorPoint
        UITabBar.appearance().barTintColor = colorLightBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        rootViewDelegate?.setAdBackgroundColor()
    }
    
    func applyShadow(view: UIView, enable: Bool){
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: view.frame.width + 4, height: view.frame.height + 4))
        view.layer.shadowOffset = CGSize(width: -2, height: -2)
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
    
    func resetButtonClicked() {
        let alertController = UIAlertController(title: "모든 정보 삭제", message: "음주 기록, 설정을 포함한 모든 정보가 초기화됩니다. 계속하시겠습니까?", preferredStyle: UIAlertControllerStyle.alert)
        let deleteAction = UIAlertAction(title: "삭제", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            resetApp()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showToday"), object: nil)
            
            colorPoint = hexStringToUIColor(hex:"FFDC67")
            colorLightBackground = hexStringToUIColor(hex:"252B53")
            colorDeepBackground = hexStringToUIColor(hex:"0B102F")
            colorGray = hexStringToUIColor(hex:"A4A4A4")
            colorText = .white
            UINavigationBar.appearance().barTintColor = colorLightBackground
            UINavigationBar.appearance().backgroundColor = colorLightBackground
            UILabel.appearance().textColor = UIColor.white
            UITabBar.appearance().tintColor = colorPoint
            UITabBar.appearance().barTintColor = colorLightBackground
            self.tabBarController?.tabBar.barTintColor = colorLightBackground
            self.tabBarController?.tabBar.tintColor = colorPoint
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
            UIApplication.shared.statusBarStyle = .lightContent
            rootViewDelegate?.setBackgroundColor(light: true)
            rootViewDelegate?.setAdBackgroundColor()
            self.navigationBar_changeColor.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            self.navigationBar_changeColor.barTintColor = colorLightBackground
            self.tabBarController?.selectedIndex = 0
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : colorText]
            
            snackBar(string: "앱이 성공적으로 초기화되었습니다.", buttonPlaced: true)
            
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadChangeIcon(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "iconNavigation")
        self.present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? EmbedSettingsTableViewController
        vc?.delegate = self
    }

}
