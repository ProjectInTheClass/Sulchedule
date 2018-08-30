import UIKit
import AudioToolbox.AudioServices
import MessageUI

class EmbedSettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var delegate : SettingsViewController?
    
    @IBOutlet var backgroundView: UITableView!
    
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var adSwitch: UISwitch!
    @IBOutlet weak var hapticSwitch: UISwitch!
    @IBOutlet weak var yesterdaySwitch: UISwitch!
    var switches: [UISwitch] = []
    
    @IBOutlet weak var iconCell: UITableViewCell!
    @IBOutlet weak var resetCell: UITableViewCell!
    @IBOutlet weak var hapticCell: UITableViewCell!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var bugCell: UITableViewCell!
    
    @IBAction func themeSwitch(_ sender: UISwitch) {
        userSetting.isThemeBright = !sender.isOn
        delegate?.darkThemeSwitch()
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.tableView.backgroundColor = colorDeepBackground
            self.backgroundView.separatorColor = colorLightBackground
        })
        for item in self.switches{
            item.tintColor = colorPoint
            item.thumbTintColor = colorLightBackground
            item.onTintColor = colorPoint
        }
        backgroundView.reloadData()
        resetLabel.textColor = colorRed
    }
    @IBAction func adSwitch(_ sender: UISwitch) {
        if(userSetting.succeededLastMonth){
            let tempBool = userSetting.adIsOff ?? true
            userSetting.adIsOff? = !tempBool
            
            if(getAdIsOff()){
                rootViewDelegate?.removeAd(true)
            }
            else{
                rootViewDelegate?.showAd(true)
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
                self.adSwitch.setOn(true, animated: true)})
        }
    }
    @IBAction func hapticSwitch(_ sender: UISwitch) {
        userSetting.isVibrationEnabled = !userSetting.isVibrationEnabled
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibTryAgain)
        }
    }
    @IBAction func yesterdaySwitch(_ sender: UISwitch) {
        setShowYesterdayFirst(yesterday: !getShowYesterdayFirst())
    }
    
    @objc func resetApp(){
        delegate?.resetButtonClicked()
    }
    
    @objc func changeIcon(){
        delegate?.loadChangeIcon()
    }
    
    @objc func bugReport(){
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: "DDDDDD")
            UINavigationBar.appearance().backgroundColor = hexStringToUIColor(hex: "DDDDDD")
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["herojeff02@daum.net"])
            let chars = dateToDayConverter(date: Date())
            mail.setSubject("술케줄 버그 신고/기능 요청 [\(chars.year)\(chars.month)\(chars.day!)]")
            mail.setMessageBody("<br><br><br>뭐든지 자세하게 서술해주시면 큰 도움이 됩니다!", isHTML: true)
            present(mail, animated: true)
        } else {
            snackBar(string: "지금 메일을 보낼 수 없습니다.", buttonPlaced: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        UINavigationBar.appearance().barTintColor = colorLightBackground
        UINavigationBar.appearance().backgroundColor = colorLightBackground
        controller.dismiss(animated: true)
        if(result.rawValue == 2){
            snackBar(string: "메일이 발송됐습니다.", buttonPlaced: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(resetApp))
        resetCell.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(changeIcon))
        iconCell.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(bugReport))
        bugCell.addGestureRecognizer(tap3)
        
        switches = [self.themeSwitch, self.adSwitch, self.hapticSwitch, self.yesterdaySwitch]
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(deviceCategory == 0 && indexPath.row == 2){
            hapticCell.isHidden = true
            return 0
        }
        else{
            return 60
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.backgroundColor = colorDeepBackground
        for item in switches{
            item.tintColor = colorPoint
            item.thumbTintColor = colorLightBackground
            item.onTintColor = colorPoint
            resetLabel.textColor = colorRed
        }
        
        themeSwitch.setOn(userSetting.isThemeBright, animated: false)
        adSwitch.setOn(!(userSetting.adIsOff ?? false), animated: false)
        hapticSwitch.setOn(userSetting.isVibrationEnabled, animated: false)
        yesterdaySwitch.setOn(userSetting.showYesterdayFirst, animated: false)
        
        backgroundView.separatorColor = colorLightBackground
    }
}
