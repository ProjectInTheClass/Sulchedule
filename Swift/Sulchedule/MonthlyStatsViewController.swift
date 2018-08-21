import UIKit
import AudioToolbox.AudioServices

class MonthlyStatsViewController: UIViewController {
    var lastSegmentChoice: Int = 0
    
    var firstAppearance = true
    let friendCircle = CAShapeLayer()
    let sulCircle = CAShapeLayer()
    let locationCircle = CAShapeLayer()
    var radOfCircle: CGFloat = 0
    var circlePath: UIBezierPath? = nil
    var currentCursor: Int = 0
    
    
    @IBOutlet weak var sulLabel: UILabel!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var firstPlaceLabel: UIView!
    @IBOutlet weak var secondPlaceLabel: UILabel!
    @IBOutlet weak var thirdPlaceLabel: UILabel!
    @IBOutlet weak var firstPlaceText: UILabel!
    @IBOutlet weak var firstPlaceView: UIView!
    
    @IBOutlet weak var picktargetView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var sulView: UIView!
    
    @IBOutlet weak var embedStatsView: UIView!
    @IBOutlet weak var leaderboardView: UIView!
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var desc3: UILabel!
    @IBOutlet weak var desc2: UILabel!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        desc1.numberOfLines = 3
        desc2.numberOfLines = 3
        desc3.numberOfLines = 3
        sulLabel.numberOfLines = 2
        friendLabel.numberOfLines = 2
        locationLabel.numberOfLines = 2

    }
    override func viewWillAppear(_ animated: Bool) {
        leaderboardView.backgroundColor = colorLightBackground
        picktargetView.backgroundColor = colorDeepBackground
        firstPlaceLabel.backgroundColor = colorPoint
        
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
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        if(screenWidth == 320){ //야메 코드!
            radOfCircle = 40
        }
        else{
            radOfCircle = 48.5
        }
//        radOfCircle = sulView.bounds.height/2
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
        
        showPlatform(cursor: 0)
        showPlatform(cursor: 1)
        showPlatform(cursor: 2)
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

    func initCircle(){
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
