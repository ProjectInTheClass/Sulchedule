import UIKit
import AudioToolbox.AudioServices

class StatsViewController: UIViewController {
    var lastSegmentChoice: Int = 0
    
    var firstAppearance = true
    let friendCircle = CAShapeLayer()
    let sulCircle = CAShapeLayer()
    let locationCircle = CAShapeLayer()
    var radOfCircle: CGFloat = 0
    var circlePath: UIBezierPath? = nil
    var currentCursor: Int = 0
    
    var vc:EmbedStatsTableViewController? = nil
    
    @IBOutlet weak var sulLabel: UILabel!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var picktargetView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var sulView: UIView!
    @IBOutlet weak var firstPlaceLabel: UIView!
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    @IBOutlet weak var firstPlaceView: UIView!
    @IBOutlet weak var firstPlaceText: UILabel!
    @IBOutlet weak var secondPlaceView: UIView!
    @IBOutlet weak var thirdPlaceView: UIView!
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var desc1: UITextView!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var desc2: UITextView!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var desc3: UITextView!
    
    @IBOutlet weak var embedStatsView: UIView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var topSegmentOutlet: UISegmentedControl!
    @IBAction func topSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            lastSegmentChoice = 0
            loadSegment(whichSegment: 0)
            
        case 1:
            lastSegmentChoice = 1
            loadSegment(whichSegment: 1)
            
        default:
            print("wtf")
        }
    }
    
    @IBOutlet weak var leaderboardTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var picktargetTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        vc = segue.destination as? EmbedStatsTableViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leaderboardView.backgroundColor = colorLightBackground
        picktargetView.backgroundColor = colorDeepBackground
        firstPlaceLabel.backgroundColor = colorPoint
        topSegmentOutlet.tintColor = colorPoint
        topSegmentOutlet.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: colorPoint], for: UIControlState.normal)
        
        secondPlaceLabel.textColor = .black
        thirdPlaceLabel.textColor = .black
        title1.textColor = .black
        desc1.textColor = .black
        title2.textColor = .black
        desc2.textColor = .black
        title3.textColor = .black
        desc3.textColor = .black
        sulLabel.textColor = colorText
        friendLabel.textColor = colorText
        locationLabel.textColor = colorText
        if(userSetting.isThemeBright){
            firstPlaceText.textColor = .white
        }
        else{
            firstPlaceText.textColor = .black
        }
        
        radOfCircle = sulView.bounds.height/2
        circlePath = UIBezierPath(arcCenter: CGPoint(x: radOfCircle,y: radOfCircle), radius: radOfCircle, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        print(sulView.bounds.height)
        
        initCircle()
        
        let sulTap = UITapGestureRecognizer(target: self, action: #selector(sulClicked))
        let friendTap = UITapGestureRecognizer(target: self, action: #selector(friendClicked))
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(locationClicked))
        sulView.addGestureRecognizer(sulTap)
        friendView.addGestureRecognizer(friendTap)
        locationView.addGestureRecognizer(locationTap)
        
        let radius: CGFloat = firstPlaceView.frame.width / 2.0
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2 * radius, height: firstPlaceView.frame.height))
        firstPlaceView.layer.shadowColor = UIColor.black.cgColor
        firstPlaceView.layer.shadowOffset = CGSize(width: 0, height: 0)
        firstPlaceView.layer.shadowOpacity = 0.2
        firstPlaceView.layer.shadowRadius = 5.0
        firstPlaceView.layer.masksToBounds =  false
        firstPlaceView.layer.shadowPath = shadowPath.cgPath

        friendView.layer.addSublayer(friendCircle)
        friendView.bringSubview(toFront: friendLabel)
        locationView.layer.addSublayer(locationCircle)
        locationView.bringSubview(toFront: locationLabel)
        sulView.layer.addSublayer(sulCircle)
        sulView.bringSubview(toFront: sulLabel)
        
        
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText

        showPlatform(cursor: 0)
        showPlatform(cursor: 1)
        showPlatform(cursor: 2)
        
        if(topSegmentOutlet.selectedSegmentIndex == 0){
            rootViewDelegate?.setBackgroundColor(light: true)
        }
        else{
            rootViewDelegate?.setBackgroundColor(light: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cycleCircleBorder(cursor: currentCursor)
        showPlatform(cursor: currentCursor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        rootViewDelegate?.setBackgroundColor(light: true)
    }
    
    
    @objc func sulClicked(){
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        currentCursor = 0
        cycleCircleBorder(cursor: currentCursor)
        showPlatform(cursor: currentCursor)
    }
    @objc func friendClicked(){
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        currentCursor = 1
        cycleCircleBorder(cursor: currentCursor)
        showPlatform(cursor: currentCursor)
    }
    @objc func locationClicked(){
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        currentCursor = 2
        cycleCircleBorder(cursor: currentCursor)
        showPlatform(cursor: currentCursor)
    }
    
    func showPlatform(cursor: Int){
        title1.text = "정보 부족"
        desc1.text = ""
        title2.text = "정보 부족"
        desc2.text = ""
        title3.text = "정보 부족"
        desc3.text = ""
        switch cursor {
        case 0:
            let suls = getRecordMonthBestSul(month: monthmonth)
            let k = suls!
            sulLabel.numberOfLines = 2
            sulLabel.text = "음주 기록이\n없습니다"
            if(1 <= k.count){
                let temp = k[0]
                title1.text = sul[Array(temp.keys)[0]].displayName
                sulLabel.text = sul[Array(temp.keys)[0]].displayName
                let temp2 = temp[Array(temp.keys)[0]]!
                desc1.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
                title2.text = "정보 부족"
                desc2.text = ""
                title3.text = "정보 부족"
                desc3.text = ""
            }
            if(2 <= k.count){
                let temp = k[1]
                title2.text = sul[Array(temp.keys)[0]].displayName
                let temp2 = temp[Array(temp.keys)[0]]!
                desc2.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
                title3.text = "정보 부족"
                desc3.text = ""
            }
            if(3 <= k.count){
                let temp = k[2]
                title3.text = sul[Array(temp.keys)[0]].displayName
                let temp2 = temp[Array(temp.keys)[0]]!
                desc3.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
            }

        case 1:
            let friends = getRecordMonthBestFriends(month: monthmonth)
            let k = friends!
            friendLabel.numberOfLines = 2
            friendLabel.text = "술친구가\n없습니다"
            if(1 <= k.count){
                let temp = k[0]!
                title1.text = Array(temp.keys)[0]
                friendLabel.text = Array(temp.keys)[0]
                let temp2 = temp[Array(temp.keys)[0]]!
                desc1.text = "\(temp2)회"
                title2.text = "정보 부족"
                desc2.text = ""
                title3.text = "정보 부족"
                desc3.text = ""
            }
            if(2 <= k.count){
                let temp = k[1]!
                title2.text = Array(temp.keys)[0]
                let temp2 = temp[Array(temp.keys)[0]]!
                desc2.text = "\(temp2)회"
                title3.text = "정보 부족"
                desc3.text = ""
            }
            if(3 <= k.count){
                let temp = k[2]!
                title3.text = Array(temp.keys)[0]
                let temp2 = temp[Array(temp.keys)[0]]!
                desc3.text = "\(temp2)회"
            }

        case 2:
            let locations = getRecordMonthBestLocation(month: monthmonth)
            let k = locations!
            locationLabel.numberOfLines = 2
            locationLabel.text = "자주 가는 곳이\n없습니다"
            if(1 <= k.count){
                let temp = k[0]
                title1.text = Array(temp.keys)[0]
                locationLabel.text = Array(temp.keys)[0]
                let temp2 = temp[Array(temp.keys)[0]]!
                desc1.text = "\(temp2)회"
                title2.text = "정보 부족"
                desc2.text = ""
                title3.text = "정보 부족"
                desc3.text = ""
            }
            if(2 <= k.count){
                let temp = k[1]
                title2.text = Array(temp.keys)[0]
                let temp2 = temp[Array(temp.keys)[0]]!
                desc2.text = "\(temp2)회"
                title3.text = "정보 부족"
                desc3.text = ""
            }
            if(3 <= k.count){
                let temp = k[2]
                title3.text = Array(temp.keys)[0]
                let temp2 = temp[Array(temp.keys)[0]]!
                desc3.text = "\(temp2)회"
            }
        default:
            print("wtf")
        }
    }
    
    func loadSegment(whichSegment: Int){
        if(whichSegment == 0){
            UIView.animate(withDuration: 0.1, delay: 0.05, options: [.curveEaseInOut], animations: {
                rootViewDelegate?.setBackgroundColor(light: true)
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.11, delay: 0.19, options: [.curveEaseInOut], animations: {
                rootViewDelegate?.setBackgroundColor(light: false)
            }, completion: nil)
        }
        
        
        if(whichSegment == 0){
            if(firstAppearance){
                firstAppearance = false
            }
            else{
                if(userSetting.isVibrationEnabled){
                    AudioServicesPlaySystemSound(vibCancelled)
                }
                animator(isLeft: true)
                firstAppearance = false
            }
            vc?.showWeekly = false
            vc?.showWeeklyFunc(showWeekly: false)
        }
        else{
            if(userSetting.isVibrationEnabled){
                AudioServicesPlaySystemSound(vibCancelled)
            }
            animator(isLeft: false)
            firstAppearance = false
            vc?.showWeekly = true
            vc?.showWeeklyFunc(showWeekly: true)
        }
    }
    
    func animator(isLeft: Bool){
        
        let duration = 0.35
        let delay = -0.15
        if(isLeft){
            leaderboardTopConstraint.constant = -20
            picktargetTopConstraint.constant = 248
            
            UIView.animate(withDuration: duration + delay, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.friendView.alpha = 1
                self.locationView.alpha = 1
                self.sulView.alpha = 1
            }, completion: nil)
            
            self.friendView.isUserInteractionEnabled = true
            self.locationView.isUserInteractionEnabled = true
            self.sulView.isUserInteractionEnabled = true
        }
        else{
            leaderboardTopConstraint.constant = -120
            picktargetTopConstraint.constant = -66
            
            UIView.animate(withDuration: duration + delay, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.friendView.alpha = 0
                self.locationView.alpha = 0
                self.sulView.alpha = 0
            }, completion: nil)
            self.friendView.isUserInteractionEnabled = false
            self.locationView.isUserInteractionEnabled = false
            self.sulView.isUserInteractionEnabled = false
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func initCircle(){
        topSegmentOutlet.selectedSegmentIndex = lastSegmentChoice
        topSegmentOutlet.bringSubview(toFront: picktargetView)
        
        friendCircle.path = circlePath?.cgPath
        friendCircle.fillColor = colorLightBackground.cgColor
        friendCircle.strokeColor = colorPoint.cgColor
        friendCircle.lineWidth = 3.0
        sulCircle.path = circlePath?.cgPath
        sulCircle.fillColor = colorLightBackground.cgColor
        sulCircle.strokeColor = colorPoint.cgColor
        sulCircle.lineWidth = 0
        locationCircle.path = circlePath?.cgPath
        locationCircle.fillColor = colorLightBackground.cgColor
        locationCircle.strokeColor = colorPoint.cgColor
        locationCircle.lineWidth = 0
    }
    
    func cycleCircleBorder(cursor: Int){
        switch (cursor){
        case 0:
            friendCircle.lineWidth = 0.0
            sulCircle.lineWidth = 3.0
            locationCircle.lineWidth = 0.0
        case 1:
            friendCircle.lineWidth = 3.0
            sulCircle.lineWidth = 0.0
            locationCircle.lineWidth = 0.0
        case 2:
            friendCircle.lineWidth = 0.0
            sulCircle.lineWidth = 0.0
            locationCircle.lineWidth = 3.0
        default:
            print("wtf")
        }
    }

}
