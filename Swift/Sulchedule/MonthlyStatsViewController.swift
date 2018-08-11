import UIKit
import AudioToolbox.AudioServices

class MonthlyStatsViewController: UIViewController {
    var lastSegmentChoice: Int = 0
    
    var firstAppearance = true
    let friendCircle = CAShapeLayer()
    let sulCircle = CAShapeLayer()
    let locationCircle = CAShapeLayer()
    var lastMonth: Int = 0
    var lastYear: Int = 2000
    var radOfCircle: CGFloat = 0
    var circlePath: UIBezierPath? = nil
    
    var vc:EmbedStatsTableViewController? = nil
    
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
    
    var selectedMonth: Day?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        vc = segue.destination as! EmbedStatsTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desc1.numberOfLines = 3
        desc2.numberOfLines = 3
        desc3.numberOfLines = 3
        sulLabel.numberOfLines = 2
        friendLabel.numberOfLines = 2
        locationLabel.numberOfLines = 2
        
        let initFormatter = DateFormatter()
        initFormatter.dateFormat = "M"
        var month = NumberFormatter().number(from: initFormatter.string(from: Date()))!.intValue
        initFormatter.dateFormat = "yyyy"
        var year = NumberFormatter().number(from: initFormatter.string(from: Date()))!.intValue
        month -= 1
        if(month == 0){
            month += 12
            year -= 1
        }
        selectedMonth = Day(year: year, month: month, day:nil)
        vc?.month = selectedMonth!
    }
    override func viewWillAppear(_ animated: Bool) {
        leaderboardView.backgroundColor = colorLightBackground
        picktargetView.backgroundColor = colorDeepBackground
        firstPlaceLabel.backgroundColor = colorPoint
        if(isBrightTheme){
            firstPlaceText.textColor = .white
            secondPlaceLabel.textColor = .black
            thirdPlaceLabel.textColor = .black
            
            sulLabel.textColor = .black
            friendLabel.textColor = .black
            locationLabel.textColor = .black
            
            title1.textColor = .black
            desc1.textColor = .black
            title2.textColor = .black
            desc2.textColor = .black
            title3.textColor = .black
            desc3.textColor = .black
        }
        else{
            firstPlaceText.textColor = .black
            secondPlaceLabel.textColor = .black
            thirdPlaceLabel.textColor = .black
            
            sulLabel.textColor = .white
            friendLabel.textColor = .white
            locationLabel.textColor = .white
            
            title1.textColor = .black
            desc1.textColor = .black
            title2.textColor = .black
            desc2.textColor = .black
            title3.textColor = .black
            desc3.textColor = .black
        }
        
        radOfCircle = sulView.bounds.height/2
        circlePath = UIBezierPath(arcCenter: CGPoint(x: radOfCircle,y: radOfCircle), radius: radOfCircle, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
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
        firstPlaceView.layer.shadowOffset = CGSize(width: 0, height: 0)  //Here you control x and y
        firstPlaceView.layer.shadowOpacity = 0.2
        firstPlaceView.layer.shadowRadius = 5.0 //Here your control your blur
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
        if(isBrightTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
        showPlatform(cursor: 2)
        showPlatform(cursor: 1)
        showPlatform(cursor: 0)
        cycleCircleBorder(cursor: 0)
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
            let suls = getRecordMonthBestSul(month: selectedMonth!)
            let k = suls!
            sulLabel.text = "음주 기록이\n없습니다"
            if(1 <= k.count){
                let temp = k[0]
                title1.text = sul[Array(temp.keys)[0]].displayName
                sulLabel.text = sul[Array(temp.keys)[0]].displayName
                let temp2 = temp[Array(temp.keys)[0]]!
                desc1.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원"
                title2.text = "정보 부족"
                desc2.text = ""
                title3.text = "정보 부족"
                desc3.text = ""
                //\n\(temp2[2]!)\(sul[Array(temp.keys)[0]].unit)
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
            let friends = getRecordMonthBestFriends(month: selectedMonth!)
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
            let locations = getRecordMonthBestLocation(month: selectedMonth!)
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
        //Dev on Main first, than transfer here
        cycleCircleBorder(cursor: 0)
        showPlatform(cursor: 0)
    }
    @objc func friendClicked(){
        //Dev on Main first, than transfer here
        cycleCircleBorder(cursor: 1)
        showPlatform(cursor: 1)
    }
    @objc func locationClicked(){
        //Dev on Main first, than transfer here
        cycleCircleBorder(cursor: 2)
        showPlatform(cursor: 2)
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
        //Dev on Main first, than transfer here
        if(isVibrationOn){
            AudioServicesPlaySystemSound(vibPeek)
        }
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
