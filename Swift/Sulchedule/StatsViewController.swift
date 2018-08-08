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
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var desc3: UILabel!
    
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
    override func viewWillAppear(_ animated: Bool) {
        leaderboardView.backgroundColor = colorLightBackground
        picktargetView.backgroundColor = colorDeepBackground
        firstPlaceLabel.backgroundColor = colorPoint
        topSegmentOutlet.tintColor = colorPoint
        topSegmentOutlet.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: colorPoint], for: UIControlState.normal)
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
        if(isVibrationOn){
            AudioServicesPlaySystemSound(peek)
        }
        cycleCircleBorder(cursor: 0)
    }
    @objc func friendClicked(){
        if(isVibrationOn){
            AudioServicesPlaySystemSound(peek)
        }
        cycleCircleBorder(cursor: 1)
    }
    @objc func locationClicked(){
        if(isVibrationOn){
            AudioServicesPlaySystemSound(peek)
        }
        cycleCircleBorder(cursor: 2)
    }
    
    func loadSegment(whichSegment: Int){
        if(whichSegment == 0){
            if(firstAppearance){
                firstAppearance = false
            }
            else{
                animator(isLeft: true)
                firstAppearance = false
            }
        }
        else{
            animator(isLeft: false)
            firstAppearance = false
        }
    }
    
    func animator(isLeft: Bool){
        if(isVibrationOn){
            AudioServicesPlaySystemSound(cancelled)
        }
        
        let duration = 0.35
        let delay = -0.15
        if(isLeft){
            leaderboardTopConstraint.constant = 0
            picktargetTopConstraint.constant = 268
            
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
            leaderboardTopConstraint.constant = -100
            picktargetTopConstraint.constant = -46
            
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
