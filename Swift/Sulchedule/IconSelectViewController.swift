import UIKit

class IconSelectViewController: UIViewController {
    
    var dismissFlag = false

    @IBOutlet var backgroundView: UIView!
    @IBAction func button1(_ sender: UIButton) {
        changeIcon(to: "original")
    }
    @IBOutlet weak var label1: UILabel!
    @IBAction func button2(_ sender: Any) {
        changeIcon(to: "depressed")
    }
    @IBOutlet weak var label2: UILabel!
    @IBAction func button3(_ sender: Any) {
        changeIcon(to: "straight")
    }
    @IBOutlet weak var label3: UILabel!
    @IBAction func button4(_ sender: Any) {
        if(userSetting.succeededLastMonth){
            changeIcon(to: "koala")
        }
    }
    @IBOutlet weak var label4: UILabel!
    @IBAction func button5(_ sender: Any) {
        if(userSetting.succeededLastMonth){
            changeIcon(to: "thrilled")
        }
    }
    @IBOutlet weak var label5: UILabel!
    @IBAction func button6(_ sender: Any) {
        if(userSetting.succeededLastMonth){
            changeIcon(to: "happy")
        }
    }
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var background2View: UIView!
    @IBOutlet weak var bottomExplanation: UILabel!
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var close: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        if(!userSetting.succeededLastMonth){
            label4.textColor = colorGray
            label5.textColor = colorGray
            label6.textColor = colorGray
            button4.alpha = 0.5
            button5.alpha = 0.5
            button6.alpha = 0.5
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:colorText]
        topTitle.textColor = colorText
        bottomExplanation.textColor = colorText

        navigationController?.navigationItem.rightBarButtonItem?.title = "닫기"
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = colorPoint
        
        backgroundView.backgroundColor = colorLightBackground
        background2View.backgroundColor = colorDeepBackground
        close.tintColor = colorPoint
    }
    
    func changeIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }
        UIApplication.shared.setAlternateIconName(iconName, completionHandler: {(error) in
            if error != nil {
                let alertController = UIAlertController(title: "미지원 기기", message: "iPhone에서만 작동합니다.", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.default)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}
