import UIKit

class EmbedSettingsTableViewController: UITableViewController {
    
    @IBOutlet var backgroundView: UITableView!
    
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var adSwitch: UISwitch!
    @IBOutlet weak var hapticSwitch: UISwitch!
    @IBOutlet weak var yesterdaySwitch: UISwitch!
    
    @IBOutlet weak var iconCell: UITableViewCell!
    @IBOutlet weak var resetCell: UITableViewCell!
    
    @IBAction func themeSwitch(_ sender: UISwitch) {
        userSetting.isThemeBright = sender.isOn
        darkThemeSwitch()
    }
    @IBAction func adSwitch(_ sender: UISwitch) {
        if(userSetting.succeededLastMonth){
            let tempBool = userSetting.adIsOff ?? true
            userSetting.adIsOff? = !tempBool
            
            if(getAdIsOff()){
                rootViewDelegate?.removeAd()
            }
            else{
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
            self.present(alertController, animated: true, completion: {
                self.adSwitch.setOn(false, animated: true)})
        }
    }
    @IBAction func hapticSwitch(_ sender: UISwitch) {
        userSetting.isVibrationEnabled = !userSetting.isVibrationEnabled
        if(deviceCategory != 0){
            if(userSetting.isVibrationEnabled){
                AudioServicesPlaySystemSound(vibTryAgain)
            }
            else{
            }
        }
        else{
            //미지원 기기
        }
    }
    @IBAction func yesterdaySwitch(_ sender: UISwitch) {
        setShowYesterdayFirst(yesterday: !getShowYesterdayFirst())
        if(getShowYesterdayFirst()){
        }
        else{
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
}
