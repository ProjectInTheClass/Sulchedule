import UIKit

class StatsViewController: UIViewController {
    var lastSegmentChoice = 0
    
    var firstRun = true
    let friendCircle = CAShapeLayer()
    let sulCircle = CAShapeLayer()
    let locationCircle = CAShapeLayer()
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
    @IBOutlet weak var topSegmentOutlet: UISegmentedControl!
    @IBAction func topSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadSegment(whichSegment: 0)
            lastSegmentChoice = 0
        case 1:
            loadSegment(whichSegment: 1)
            lastSegmentChoice = 1
        default:
            print("wtf")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCirlce()
        
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
        
        firstRun = false
        cycleCircleBorder(cursor: 0)
    }
    
    @objc func sulClicked(){
        cycleCircleBorder(cursor: 0)
    }
    @objc func friendClicked(){
        cycleCircleBorder(cursor: 1)
    }
    @objc func locationClicked(){
        cycleCircleBorder(cursor: 2)
    }
    
    func loadSegment(whichSegment: Int){
        if(whichSegment == 0){
            if(firstRun){
                self.leaderboardView.frame = CGRect(x: self.leaderboardView.frame.origin.x, y: self.leaderboardView.frame.origin.y + 100, width: self.leaderboardView.frame.size.width, height: self.leaderboardView.frame.size.height)
                
                self.picktargetView.frame = CGRect(x: self.picktargetView.frame.origin.x, y: self.picktargetView.frame.origin.y + 320, width: self.picktargetView.frame.size.width, height: self.picktargetView.frame.size.height)
                
                self.embedStatsView.frame = CGRect(x: self.embedStatsView.frame.origin.x, y: self.embedStatsView.frame.origin.y + 320, width: self.embedStatsView.frame.size.width, height: self.embedStatsView.frame.size.height - 320)
                
                self.friendView.alpha = 1
                self.locationView.alpha = 1
                self.sulView.alpha = 1
            }
            else{
                animator(isLeft: true)
            }
        }
        else{
                animator(isLeft: false)
        }
    }

    func animator(isLeft: Bool){
        let duration = 0.4

        if(isLeft){
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                self.leaderboardView.frame = CGRect(x: self.leaderboardView.frame.origin.x, y: self.leaderboardView.frame.origin.y + 100, width: self.leaderboardView.frame.size.width, height: self.leaderboardView.frame.size.height)
                
                self.picktargetView.frame = CGRect(x: self.picktargetView.frame.origin.x, y: self.picktargetView.frame.origin.y + 320, width: self.picktargetView.frame.size.width, height: self.picktargetView.frame.size.height)
                
                self.embedStatsView.frame = CGRect(x: self.embedStatsView.frame.origin.x, y: self.embedStatsView.frame.origin.y + 320, width: self.embedStatsView.frame.size.width, height: self.embedStatsView.frame.size.height - 320)
                
                self.friendView.alpha = 1
                self.locationView.alpha = 1
                self.sulView.alpha = 1
            
            }, completion: nil)
            
            self.friendView.isUserInteractionEnabled = true
            self.locationView.isUserInteractionEnabled = true
            self.sulView.isUserInteractionEnabled = true
        }
        else{
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                self.leaderboardView.frame = CGRect(x: self.leaderboardView.frame.origin.x, y: self.leaderboardView.frame.origin.y - 100, width: self.leaderboardView.frame.size.width, height: self.leaderboardView.frame.size.height)
                
                self.picktargetView.frame = CGRect(x: self.picktargetView.frame.origin.x, y: self.picktargetView.frame.origin.y - 320, width: self.picktargetView.frame.size.width, height: self.picktargetView.frame.size.height)
                
                self.embedStatsView.frame = CGRect(x: self.embedStatsView.frame.origin.x, y: self.embedStatsView.frame.origin.y - 320
                    , width: self.embedStatsView.frame.size.width, height: self.embedStatsView.frame.size.height + 320)
                
                self.friendView.alpha = 0
                self.locationView.alpha = 0
                self.sulView.alpha = 0
                
            }, completion: nil)
            
            self.friendView.isUserInteractionEnabled = false
            self.locationView.isUserInteractionEnabled = false
            self.sulView.isUserInteractionEnabled = false
        }
    }
    
    func initCirlce(){
        topSegmentOutlet.selectedSegmentIndex = lastSegmentChoice
        topSegmentOutlet.bringSubview(toFront: picktargetView)
        loadSegment(whichSegment: topSegmentOutlet.selectedSegmentIndex)
        
        friendCircle.path = circlePath.cgPath
        friendCircle.fillColor = hexStringToUIColor(hex: "#252B53").cgColor
        friendCircle.strokeColor = hexStringToUIColor(hex: "#FFDC67").cgColor
        friendCircle.lineWidth = 3.0
        sulCircle.path = circlePath.cgPath
        sulCircle.fillColor = hexStringToUIColor(hex: "#252B53").cgColor
        sulCircle.strokeColor = hexStringToUIColor(hex: "#FFDC67").cgColor
        sulCircle.lineWidth = 0
        locationCircle.path = circlePath.cgPath
        locationCircle.fillColor = hexStringToUIColor(hex: "#252B53").cgColor
        locationCircle.strokeColor = hexStringToUIColor(hex: "#FFDC67").cgColor
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
