import UIKit
import AudioToolbox.AudioServices


class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationBar_changeColor: UINavigationBar!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet var mainBackgroundView: UIView!
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeLabel: UILabel!
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
    @IBOutlet weak var changeIconContainer: UIView!
    @IBOutlet weak var removeAdContainer: UIView!
    @IBOutlet weak var vibButton: UIButton!
    @IBOutlet weak var changeIconButton: UIButton!
    @IBOutlet weak var removeAdButton: UIButton!
    
    
    @IBAction func removeAdButton(_ sender: Any) {
        if(userSetting.succeededLastMonth){
            let tempBool = userSetting.adIsOff ?? true
            userSetting.adIsOff? = !tempBool
            
            if(getAdIsOff()){
                self.applyShadow(view: self.vibContainer, enable: true)
                removeAdButton.setTitleColor(colorPoint, for: .normal)
                removeAdButton.setTitle("광고 꺼짐", for: .normal)
                self.applyShadow(view: self.removeAdContainer, enable: false)
                rootViewDelegate?.removeAd()
            }
            else{
                self.applyShadow(view: self.vibContainer, enable: true)
                removeAdButton.setTitleColor(colorPoint, for: .normal)
                removeAdButton.setTitle("광고 켜짐", for: .normal)
                self.applyShadow(view: self.removeAdContainer, enable: true)
                rootViewDelegate?.showAd()
            }
            rootViewDelegate?.setAdBackgroundColor()
        }
        else{
            let formatter = DateFormatter()
            formatter.dateFormat = "M"
            var lastMonth = Int(formatter.string(from: Date())) ?? 1
            lastMonth -= 1
            if(lastMonth == 0){
                lastMonth = 12
            }
            let alertController = UIAlertController(title: "\(lastMonth)월 목표 달성 실패", message: "\(lastMonth)월에 목표를 설정하지 않았거나 달성하지 못했습니다. 목표를 달성하면 광고를 제거할 수 있습니다.", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func vibButton(_ sender: Any) {
        userSetting.isVibrationEnabled = !userSetting.isVibrationEnabled
        if(deviceCategory != 0){
            if(userSetting.isVibrationEnabled){
                AudioServicesPlaySystemSound(vibTryAgain)
                vibButton.setTitle("햅틱 켜짐", for: .normal)
                self.applyShadow(view: self.vibContainer, enable: userSetting.isThemeBright)
            }
            else{
                vibButton.setTitle("햅틱 꺼짐", for: .normal)
                self.applyShadow(view: self.vibContainer, enable: false)
            }
        }
        else{
            vibButton.setTitle("햅틱 미지원 기기", for: .normal)
            vibButton.setTitleColor(colorGray, for: .normal)
            vibButton.isUserInteractionEnabled = false
            self.applyShadow(view: self.vibContainer, enable: false)
        }
    }
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
            yesterdayButton.setTitle("정오까지 전날이 먼저 표시됩니다", for: .normal)
        }
        else{
            yesterdayButton.setTitle("자정부터 당시 날짜가 표시됩니다", for: .normal)
        }
    }
    @IBAction func resetButton(_ sender: UIButton) {
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
    
        if(deviceCategory != 0){
            if(userSetting.isVibrationEnabled){
                vibButton.setTitle("햅틱 켜짐", for: .normal)
            }
            else{
                vibButton.setTitle("햅틱 꺼짐", for: .normal)
            }
        }
        else{
            vibButton.setTitle("햅틱 미지원 기기", for: .normal)
            vibButton.isUserInteractionEnabled = false
            self.applyShadow(view: self.vibContainer, enable: false)
        }
        if(getShowYesterdayFirst()){
            yesterdayButton.setTitle("정오까지 전날이 먼저 표시됩니다", for: .normal)
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
        vibButton.setTitleColor(colorPoint, for: .normal)
        resetButton.tintColor = colorRed
        addSulButton.tintColor = colorPoint
        yesterdayButton.tintColor = colorPoint
        showDrunkButton.tintColor = colorPoint
        resetButton.setTitleColor(colorRed, for: .normal)
        addSulButton.setTitleColor(colorPoint, for: .normal)
        yesterdayButton.setTitleColor(colorPoint, for: .normal)
        showDrunkButton.setTitleColor(colorPoint, for: .normal)
        changeIconButton.setTitleColor(colorPoint, for: .normal)
        setSucceededLastMonth()
        if(!userSetting.succeededLastMonth){
            removeAdButton.setTitle("광고 켜짐", for: .normal)
            rootViewDelegate?.showAd()
            setAdIsOff(adIsOff: false)
            removeAdButton.setTitleColor(colorGray, for: .normal)
            self.applyShadow(view: self.removeAdContainer, enable: false)
        }
        else if(getAdIsOff()){
//            for future in-app purchase
//            removeAdButton.isUserInteractionEnabled = false
//            removeAdButton.setTitleColor(colorGray, for: .normal)
            removeAdButton.setTitle("광고 꺼짐", for: .normal)
            removeAdButton.isUserInteractionEnabled = true
            self.applyShadow(view: self.removeAdContainer, enable: false)
            removeAdButton.setTitleColor(colorPoint, for: .normal)
            rootViewDelegate?.removeAd()
        }
        else{
            removeAdButton.setTitle("광고 켜짐", for: .normal)
            removeAdButton.isUserInteractionEnabled = true
            self.applyShadow(view: self.removeAdContainer, enable: true)
            removeAdButton.setTitleColor(colorPoint, for: .normal)
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
            self.themeContainer.backgroundColor = colorDeepBackground
            self.vibContainer.backgroundColor = colorDeepBackground
            self.addSulContainer.backgroundColor = colorDeepBackground
            self.resetContainer.backgroundColor = colorDeepBackground
            self.yesterdayContainer.backgroundColor = colorDeepBackground
            self.showDrunkContainer.backgroundColor = colorDeepBackground
            self.changeIconContainer.backgroundColor = colorDeepBackground
            self.removeAdContainer.backgroundColor = colorDeepBackground
        }
        else{
            self.topBackgroundView.backgroundColor = colorLightBackground
            self.mainBackgroundView.backgroundColor = colorDeepBackground
            self.themeContainer.backgroundColor = colorLightBackground
            self.vibContainer.backgroundColor = colorLightBackground
            self.addSulContainer.backgroundColor = colorLightBackground
            self.resetContainer.backgroundColor = colorLightBackground
            self.yesterdayContainer.backgroundColor = colorLightBackground
            self.showDrunkContainer.backgroundColor = colorLightBackground
            self.changeIconContainer.backgroundColor = colorLightBackground
            self.removeAdContainer.backgroundColor = colorLightBackground
        }
        self.applyShadow(view: self.resetContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.addSulContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.themeContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.showDrunkContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.yesterdayContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.changeIconContainer, enable: userSetting.isThemeBright)
        
        if(userSetting.isVibrationEnabled){
            self.applyShadow(view: self.vibContainer, enable: userSetting.isThemeBright)
        }
        
        self.applyShadow(view: self.removeAdContainer, enable: userSetting.isThemeBright && !getAdIsOff())
        
        if(deviceCategory == 0){
            self.applyShadow(view: self.vibContainer, enable: false)
            self.vibButton.setTitleColor(colorGray, for: .normal)
        }
    }
    
    @objc func darkThemeSwitch(_ sender: UITapGestureRecognizer) {
        userSetting.isThemeBright = !userSetting.isThemeBright
        
        self.applyShadow(view: self.resetContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.addSulContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.themeContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.showDrunkContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.changeIconContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.yesterdayContainer, enable: userSetting.isThemeBright)
        self.applyShadow(view: self.removeAdContainer, enable: userSetting.isThemeBright && !getAdIsOff())
        self.applyShadow(view: self.vibContainer, enable: userSetting.isThemeBright && userSetting.isVibrationEnabled)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            if(userSetting.isThemeBright){
                colorPoint = hexStringToUIColor(hex: "#0067B2")
                colorLightBackground = hexStringToUIColor(hex: "#EAEAEA")
                colorDeepBackground = hexStringToUIColor(hex: "#FFFFFF")
                colorGray = .gray
                colorText = .black
                
                self.mainBackgroundView.backgroundColor = colorLightBackground
                self.themeContainer.backgroundColor = colorDeepBackground
                self.vibContainer.backgroundColor = colorDeepBackground
                self.addSulContainer.backgroundColor = colorDeepBackground
                self.resetContainer.backgroundColor = colorDeepBackground
                self.yesterdayContainer.backgroundColor = colorDeepBackground
                self.showDrunkContainer.backgroundColor = colorDeepBackground
                self.changeIconContainer.backgroundColor = colorDeepBackground
                self.removeAdContainer.backgroundColor = colorDeepBackground
            }
            else{
                colorPoint = hexStringToUIColor(hex:"FFDC67")
                colorLightBackground = hexStringToUIColor(hex:"252B53")
                colorDeepBackground = hexStringToUIColor(hex:"0B102F")
                colorGray = hexStringToUIColor(hex:"A4A4A4")
                colorText = .white
                
                self.mainBackgroundView.backgroundColor = colorDeepBackground
                self.themeContainer.backgroundColor = colorLightBackground
                self.vibContainer.backgroundColor = colorLightBackground
                self.addSulContainer.backgroundColor = colorLightBackground
                self.resetContainer.backgroundColor = colorLightBackground
                self.yesterdayContainer.backgroundColor = colorLightBackground
                self.showDrunkContainer.backgroundColor = colorLightBackground
                self.changeIconContainer.backgroundColor = colorLightBackground
                self.removeAdContainer.backgroundColor = colorLightBackground
            }
            
            self.themeLabel.textColor = colorPoint
            self.vibButton.setTitleColor(colorPoint, for: .normal)
            self.resetButton.setTitleColor(colorRed, for: .normal)
            self.addSulButton.setTitleColor(colorPoint, for: .normal)
            self.yesterdayButton.setTitleColor(colorPoint, for: .normal)
            self.showDrunkButton.setTitleColor(colorPoint, for: .normal)
            self.changeIconButton.setTitleColor(colorPoint, for: .normal)
            
            if(deviceCategory == 0){
                self.vibButton.setTitleColor(colorGray, for: .normal)
            }
            
            if(!userSetting.succeededLastMonth){
                self.removeAdButton.setTitleColor(colorGray, for: .normal)
            }
            else if(getAdIsOff()){
//                For future in-app purchase
//                self.removeAdButton.setTitleColor(colorGray, for: .normal)
                self.removeAdButton.setTitleColor(colorPoint, for: .normal)
            }
            else{
                self.removeAdButton.setTitleColor(colorPoint, for: .normal)
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
                vibButton.setTitle("햅틱 켜짐", for: .normal)
            }
            else{
                vibButton.setTitle("햅틱 꺼짐", for: .normal)
            }
        }
        else{
            vibButton.isUserInteractionEnabled = false
            self.applyShadow(view: self.vibContainer, enable: false)
            vibButton.setTitle("햅틱 미지원 기기", for: .normal)
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

}
