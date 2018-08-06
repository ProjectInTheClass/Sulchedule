import UIKit
import AudioToolbox.AudioServices

class MonthlyStatsViewController: UIViewController {
    var lastSegmentChoice: Int = 0
    
    var firstAppearance = true
    let friendCircle = CAShapeLayer()
    let sulCircle = CAShapeLayer()
    let locationCircle = CAShapeLayer()
    var lastMonth: Int = 0
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 48.5,y: 48.5), radius: CGFloat(48.5), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    
    @IBOutlet weak var sulLabel: UILabel!
    @IBOutlet weak var friendLabel: UIView!
    @IBOutlet weak var locationLabel: UIView!
    
    @IBOutlet weak var picktargetView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var sulView: UIView!
    
    @IBOutlet weak var embedStatsView: UIView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var thisMonthLabel: UILabel!
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        lastMonth = Int(formatter.string(from: Date())) ?? 1
        lastMonth -= 1
        if(lastMonth == 0){
            lastMonth = 12
        }
        thisMonthLabel.text = "지난 달(\(lastMonth)월)의 통계"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        initCircle()
        
        let sulTap = UITapGestureRecognizer(target: self, action: #selector(sulClicked))
        let friendTap = UITapGestureRecognizer(target: self, action: #selector(friendClicked))
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(locationClicked))
        sulView.addGestureRecognizer(sulTap)
        friendView.addGestureRecognizer(friendTap)
        locationView.addGestureRecognizer(locationTap)
        
        friendView.layer.addSublayer(friendCircle)
        friendView.bringSubview(toFront: friendLabel)
        locationView.layer.addSublayer(locationCircle)
        locationView.bringSubview(toFront: locationLabel)
        sulView.layer.addSublayer(sulCircle)
        sulView.bringSubview(toFront: sulLabel)
        
        cycleCircleBorder(cursor: 0)
    }
    
    @objc func sulClicked(){
//        AudioServicesPlaySystemSound(peek)
        cycleCircleBorder(cursor: 0)
    }
    @objc func friendClicked(){
//        AudioServicesPlaySystemSound(peek)
        cycleCircleBorder(cursor: 1)
    }
    @objc func locationClicked(){
//        AudioServicesPlaySystemSound(peek)
        cycleCircleBorder(cursor: 2)
    }

    func initCircle(){
        friendCircle.path = circlePath.cgPath
        friendCircle.fillColor = colorLightBlue.cgColor
        friendCircle.strokeColor = colorPoint.cgColor
        friendCircle.lineWidth = 3.0
        sulCircle.path = circlePath.cgPath
        sulCircle.fillColor = colorLightBlue.cgColor
        sulCircle.strokeColor = colorPoint.cgColor
        sulCircle.lineWidth = 0
        locationCircle.path = circlePath.cgPath
        locationCircle.fillColor = colorLightBlue.cgColor
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
    
    func reloadLeaderboard(cursor: Int){
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
