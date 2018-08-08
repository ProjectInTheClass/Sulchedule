import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        cycleCircleBorder(cursor: 0)
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(isBrightTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
    }
    
    @objc func sulClicked(){
        //Dev on Main first, than transfer here
        cycleCircleBorder(cursor: 0)
    }
    @objc func friendClicked(){
        //Dev on Main first, than transfer here
        cycleCircleBorder(cursor: 1)
    }
    @objc func locationClicked(){
        //Dev on Main first, than transfer here
        cycleCircleBorder(cursor: 2)
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
    
    func reloadLeaderboard(cursor: Int){
        //Dev on Main first, than transfer here
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
