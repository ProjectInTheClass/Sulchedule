import UIKit

class MonthlyStatsViewController: UIViewController {
    var lastSegmentChoice: Int = 0
    
    var firstAppearance = true
    let friendCircle = CAShapeLayer()
    let sulCircle = CAShapeLayer()
    let locationCircle = CAShapeLayer()
    var lastMonth: Int = 0
    var lastYear: Int = 2000
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 48.5,y: 48.5), radius: CGFloat(48.5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    
    @IBOutlet weak var sulLabel: UILabel!
    @IBOutlet weak var friendLabel: UIView!
    @IBOutlet weak var locationLabel: UIView!
    @IBOutlet weak var firstPlaceLabel: UIView!
    @IBOutlet weak var firstPlaceText: UILabel!
    @IBOutlet weak var firstPlaceView: UIView!
    
    @IBOutlet weak var picktargetView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var sulView: UIView!
    
    @IBOutlet weak var embedStatsView: UIView!
    @IBOutlet weak var leaderboardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(!isDarkTheme){
            leaderboardView.backgroundColor = colorLightBackground
            picktargetView.backgroundColor = colorDeepBackground
            firstPlaceLabel.backgroundColor = colorPoint
            firstPlaceText.textColor = .white
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
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
        friendCircle.path = circlePath.cgPath
        friendCircle.fillColor = colorLightBackground.cgColor
        friendCircle.strokeColor = colorPoint.cgColor
        friendCircle.lineWidth = 3.0
        sulCircle.path = circlePath.cgPath
        sulCircle.fillColor = colorLightBackground.cgColor
        sulCircle.strokeColor = colorPoint.cgColor
        sulCircle.lineWidth = 0
        locationCircle.path = circlePath.cgPath
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
