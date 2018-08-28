import UIKit
import AudioToolbox.AudioServices

class StatsViewController: UIViewController, UIGestureRecognizerDelegate {
    var lastSegmentChoice: Int = 0
    
    var firstAppearance = true
    let friendCircle = CAShapeLayer()
    let sulCircle = CAShapeLayer()
    let locationCircle = CAShapeLayer()
    var radOfCircle: CGFloat = 0
    var circlePath: UIBezierPath? = nil
    var currentCursor: Int = 0
    
    var constraintLarge = false
    
    var vc:EmbedStatsTableViewController? = nil
    
    @IBOutlet weak var viewGestureRecognizer: UIView!
    @IBOutlet var backgroundView: UIView!
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
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var desc1: UILabel!
    @IBOutlet weak var desc2: UILabel!
    @IBOutlet weak var desc3: UILabel!
    
    @IBOutlet weak var embedStatsView: UIView!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var topSegmentOutlet: UISegmentedControl!
    
    @IBOutlet weak var leaderboardTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var picktargetTopConstraint: NSLayoutConstraint!
    
    @IBAction func topSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            lastSegmentChoice = 0
            loadSegment(whichSegment: 0)
            cycleCircleBorder(cursor: currentCursor)
            if(shouldComeDown() && constraintLarge){
                viewGestureRecognizer.isUserInteractionEnabled = true
            }
        case 1:
            lastSegmentChoice = 1
            loadSegment(whichSegment: 1)
            viewGestureRecognizer.isUserInteractionEnabled = false
        default:
            print("Not Accepted Switch Value")
        }
    }
    
    @objc func handleSwipeUp(gesture: UISwipeGestureRecognizer) {
        viewGestureRecognizer.isUserInteractionEnabled = false
        
        self.leaderboardTopConstraint.constant = -20
        self.picktargetTopConstraint.constant = 52
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.leaderboardView.alpha = 0
            self.view.layoutIfNeeded()
            rootViewDelegate?.setBackgroundColor(light: false)
        }, completion: nil)
        vc?.backgroundView.scrollToTop()
        
        constraintLarge = false
    }
    
    @objc func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
        if(shouldComeDown()){
            self.leaderboardTopConstraint.constant = -20
            self.picktargetTopConstraint.constant = 248
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.leaderboardView.alpha = 1
                self.view.layoutIfNeeded()
                rootViewDelegate?.setBackgroundColor(light: true)
            }, completion: nil)
            
            viewGestureRecognizer.isUserInteractionEnabled = true
            constraintLarge = true
            vc?.backgroundView.scrollToTop()
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        viewGestureRecognizer.isUserInteractionEnabled = false
        
        self.leaderboardTopConstraint.constant = -20
        self.picktargetTopConstraint.constant = 52
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.leaderboardView.alpha = 0
            self.view.layoutIfNeeded()
            rootViewDelegate?.setBackgroundColor(light: false)
        }, completion: nil)
        
        constraintLarge = false
        vc?.backgroundView.scrollToTop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desc1.numberOfLines = 3
        desc2.numberOfLines = 3
        desc3.numberOfLines = 3
        sulLabel.numberOfLines = 2
        friendLabel.numberOfLines = 2
        locationLabel.numberOfLines = 2
        
        initLeaderboard()
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeUp))
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.up
        swipeUpRecognizer.delegate = self
        viewGestureRecognizer.addGestureRecognizer(swipeUpRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewGestureRecognizer.addGestureRecognizer(tapRecognizer)
        let swipeDownRecognizerForPickTarget = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown))
        swipeDownRecognizerForPickTarget.direction = UISwipeGestureRecognizerDirection.down
        swipeDownRecognizerForPickTarget.delegate = self
        picktargetView.addGestureRecognizer(swipeDownRecognizerForPickTarget)
        let swipeUpRecognizerForPickTarget = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeUp))
        swipeUpRecognizerForPickTarget.direction = UISwipeGestureRecognizerDirection.up
        swipeUpRecognizerForPickTarget.delegate = self
        picktargetView.addGestureRecognizer(swipeUpRecognizerForPickTarget)
        
        
        if(userSetting.firstLaunch){
            snackBar(string: "음주 기록이 다양해지면 단상에 순위가 표시됩니다.", buttonPlaced: false)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(snackBarWaitTime))) {
                snackBar(string: "이 달의 목표 탭으로 이동해주세요!", buttonPlaced: true)
            }
        }
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
        
        backgroundView.backgroundColor = colorDeepBackground
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        if(screenWidth == 320){ //야메 코드!
            radOfCircle = 40
            heightConstraint.constant = 120
        }
        else{
            radOfCircle = 48.5
            heightConstraint.constant = 134
        }
        circlePath = UIBezierPath(arcCenter: CGPoint(x: radOfCircle,y: radOfCircle), radius: radOfCircle, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        initCircle()
        initLeaderboard()
        
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
        
        if(topSegmentOutlet.selectedSegmentIndex == 0){
            rootViewDelegate?.setBackgroundColor(light: true)
        }
        else{
            rootViewDelegate?.setBackgroundColor(light: false)
            
            leaderboardTopConstraint.constant = -120
            picktargetTopConstraint.constant = -66
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(topSegmentOutlet.selectedSegmentIndex == 0){
            cycleCircleBorder(cursor: currentCursor)
            showPlatform(cursor: currentCursor)
        }
        if(topSegmentOutlet.selectedSegmentIndex == 0 && constraintLarge){
            rootViewDelegate?.setBackgroundColor(light: true)
        }
        else{
            rootViewDelegate?.setBackgroundColor(light: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        rootViewDelegate?.setBackgroundColor(light: true)
    }
    
    @objc func sulClicked(){
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        currentCursor = 0
        vc?.reloadCurrentCursor(cursor: 0)
        cycleCircleBorder(cursor: currentCursor)
        showPlatform(cursor: currentCursor)
    }
    @objc func friendClicked(){
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        currentCursor = 1
        vc?.reloadCurrentCursor(cursor: 1)
        cycleCircleBorder(cursor: currentCursor)
        showPlatform(cursor: currentCursor)
    }
    @objc func locationClicked(){
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        currentCursor = 2
        vc?.reloadCurrentCursor(cursor: 2)
        cycleCircleBorder(cursor: currentCursor)
        showPlatform(cursor: currentCursor)
    }
    
    func showPlatform(cursor: Int){
        switch cursor {
        case 0:
            let suls = getRecordMonthBestSul(month: monthmonth)
            let k = suls!
            sulLabel.text = "음주 기록이\n없습니다"
            if(1 <= k.count){
                let temp = k[0]
                sulLabel.text = sul[Array(temp.keys)[0]].displayName
            }
            if(3 <= k.count){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.leaderboardTopConstraint.constant = -20
                    self.picktargetTopConstraint.constant = 248
                    self.leaderboardView.alpha = 1
                    rootViewDelegate?.setBackgroundColor(light: true)
                }, completion: nil)
                constraintLarge = true
                viewGestureRecognizer.isUserInteractionEnabled = constraintLarge
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                var temp = k[0]
                title1.text = sul[Array(temp.keys)[0]].displayName
                var temp2 = temp[Array(temp.keys)[0]]!
                desc1.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
                temp = k[1]
                title2.text = sul[Array(temp.keys)[0]].displayName
                temp2 = temp[Array(temp.keys)[0]]!
                desc2.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
                temp = k[2]
                title3.text = sul[Array(temp.keys)[0]].displayName
                temp2 = temp[Array(temp.keys)[0]]!
                desc3.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
            }
            else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.leaderboardTopConstraint.constant = -20
                    self.leaderboardView.alpha = 0
                    self.picktargetTopConstraint.constant = 52
                    rootViewDelegate?.setBackgroundColor(light: false)
                }, completion: nil)
                constraintLarge = false
                viewGestureRecognizer.isUserInteractionEnabled = constraintLarge
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }

        case 1:
            let friends = getRecordMonthBestFriends(month: monthmonth)
            let k = friends!
            friendLabel.text = "술친구가\n없습니다"
            if(1 <= k.count){
                let temp = k[0]!
                friendLabel.text = Array(temp.keys)[0]
            }
            if(3 <= k.count){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.leaderboardTopConstraint.constant = -20
                    self.picktargetTopConstraint.constant = 248
                    self.leaderboardView.alpha = 1
                    rootViewDelegate?.setBackgroundColor(light: true)
                }, completion: nil)
                constraintLarge = true
                viewGestureRecognizer.isUserInteractionEnabled = constraintLarge
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                var temp = k[0]!
                title1.text = Array(temp.keys)[0]
                var temp2 = temp[Array(temp.keys)[0]]!
                desc1.text = "\(temp2)회"
                temp = k[1]!
                title2.text = Array(temp.keys)[0]
                temp2 = temp[Array(temp.keys)[0]]!
                desc2.text = "\(temp2)회"
                temp = k[2]!
                title3.text = Array(temp.keys)[0]
                temp2 = temp[Array(temp.keys)[0]]!
                desc3.text = "\(temp2)회"
            }
            else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.leaderboardTopConstraint.constant = -20
                    self.leaderboardView.alpha = 0
                    self.picktargetTopConstraint.constant = 52
                    rootViewDelegate?.setBackgroundColor(light: false)
                }, completion: nil)
                constraintLarge = false
                viewGestureRecognizer.isUserInteractionEnabled = constraintLarge
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }

        case 2:
            let locations = getRecordMonthBestLocation(month: monthmonth)
            let k = locations!
            locationLabel.text = "자주 가는 곳이\n없습니다"
            if(1 <= k.count){
                let temp = k[0]
                locationLabel.text = Array(temp.keys)[0]
            }
            if(3 <= k.count){
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.leaderboardTopConstraint.constant = -20
                    self.picktargetTopConstraint.constant = 248
                    self.leaderboardView.alpha = 1
                    rootViewDelegate?.setBackgroundColor(light: true)
                }, completion: nil)
                constraintLarge = true
                viewGestureRecognizer.isUserInteractionEnabled = constraintLarge
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
                
                var temp = k[0]
                title1.text = Array(temp.keys)[0]
                var temp2 = temp[Array(temp.keys)[0]]!
                desc1.text = "\(temp2)회"
                temp = k[1]
                title2.text = Array(temp.keys)[0]
                temp2 = temp[Array(temp.keys)[0]]!
                desc2.text = "\(temp2)회"
                temp = k[2]
                title3.text = Array(temp.keys)[0]
                temp2 = temp[Array(temp.keys)[0]]!
                desc3.text = "\(temp2)회"
            }
            else{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.leaderboardTopConstraint.constant = -20
                    self.leaderboardView.alpha = 0
                    self.picktargetTopConstraint.constant = 52
                    rootViewDelegate?.setBackgroundColor(light: false)
                }, completion: nil)
                constraintLarge = false
                viewGestureRecognizer.isUserInteractionEnabled = constraintLarge
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            
        default:
            print("Not Accepted Switch Value")
        }
    }
    
    func loadSegment(whichSegment: Int){
        if(whichSegment == 0 && constraintLarge){
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
                if(userSetting.isVibrationEnabled && constraintLarge){
                    AudioServicesPlaySystemSound(vibCancelled)
                }
                animator(isLeft: true)
                firstAppearance = false
            }
            vc?.showWeekly = false
            vc?.showWeeklyFunc(showWeekly: false)
        }
        else{
            if(userSetting.isVibrationEnabled && constraintLarge){
                AudioServicesPlaySystemSound(vibCancelled)
            }
            animator(isLeft: false)
            firstAppearance = false
            vc?.showWeekly = true
            vc?.showWeeklyFunc(showWeekly: true)
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: {(finished: Bool) in self.vc?.backgroundScrollToTop()})
    }
    
    func animator(isLeft: Bool){
        
        let duration = 0.35
        let delay = -0.15
        if(isLeft){
            if(constraintLarge){
                leaderboardTopConstraint.constant = -20
                picktargetTopConstraint.constant = 248
            }
            else{
                leaderboardTopConstraint.constant = -20
                picktargetTopConstraint.constant = 52
            }
            
            
            UIView.animate(withDuration: duration + delay, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.friendView.alpha = 1
                self.locationView.alpha = 1
                self.sulView.alpha = 1
                if(self.constraintLarge){
                    self.leaderboardView.alpha = 1
                }
                else{
                    self.leaderboardView.alpha = 0
                }
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
            print("Not Accepted Switch Value")
        }
    }

    func initLeaderboard(){
        let suls = getRecordMonthBestSul(month: monthmonth)
        let k = suls!
        sulLabel.text = "음주 기록이\n없습니다"
        if(1 <= k.count){
            let temp = k[0]
            sulLabel.text = sul[Array(temp.keys)[0]].displayName
        }
        if(3 <= k.count){
            if(currentCursor == 0){
                self.leaderboardTopConstraint.constant = -20
                self.picktargetTopConstraint.constant = 248
                self.leaderboardView.alpha = 1
            }
            rootViewDelegate?.setBackgroundColor(light: true)
            
            var temp = k[0]
            title1.text = sul[Array(temp.keys)[0]].displayName
            var temp2 = temp[Array(temp.keys)[0]]!
            desc1.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
            temp = k[1]
            title2.text = sul[Array(temp.keys)[0]].displayName
            temp2 = temp[Array(temp.keys)[0]]!
            desc2.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
            temp = k[2]
            title3.text = sul[Array(temp.keys)[0]].displayName
            temp2 = temp[Array(temp.keys)[0]]!
            desc3.text = "\(temp2[0]!)kcal\n\(temp2[1]!)원\n\(temp2[2]!)\(getSulUnit(index: Array(temp.keys)[0]))"
        }
        else{
            if(currentCursor == 0){
                self.leaderboardTopConstraint.constant = -20
                self.leaderboardView.alpha = 0
                self.picktargetTopConstraint.constant = 52
            }
            rootViewDelegate?.setBackgroundColor(light: false)
        }
        
        let friends = getRecordMonthBestFriends(month: monthmonth)
        let j = friends!
        friendLabel.text = "술친구가\n없습니다"
        if(1 <= j.count){
            let temp = j[0]!
            friendLabel.text = Array(temp.keys)[0]
        }
        if(3 <= j.count){
            if(currentCursor == 1){
                self.leaderboardTopConstraint.constant = -20
                self.picktargetTopConstraint.constant = 248
            }
            var temp = j[0]!
            title1.text = Array(temp.keys)[0]
            var temp2 = temp[Array(temp.keys)[0]]!
            desc1.text = "\(temp2)회"
            temp = j[1]!
            title2.text = Array(temp.keys)[0]
            temp2 = temp[Array(temp.keys)[0]]!
            desc2.text = "\(temp2)회"
            temp = j[2]!
            title3.text = Array(temp.keys)[0]
            temp2 = temp[Array(temp.keys)[0]]!
            desc3.text = "\(temp2)회"
        }
        else{
            if(currentCursor == 1){
                self.leaderboardTopConstraint.constant = -20
                self.leaderboardView.alpha = 0
                self.picktargetTopConstraint.constant = 52
            }
            rootViewDelegate?.setBackgroundColor(light: false)
        }
        
        let locations = getRecordMonthBestLocation(month: monthmonth)
        let v = locations!
        locationLabel.text = "자주 가는 곳이\n없습니다"
        if(1 <= v.count){
            let temp = v[0]
            locationLabel.text = Array(temp.keys)[0]
        }
        if(3 <= v.count){
            if(currentCursor == 2){
                self.leaderboardTopConstraint.constant = -20
                self.picktargetTopConstraint.constant = 248
            }
            var temp = v[0]
            title1.text = Array(temp.keys)[0]
            var temp2 = temp[Array(temp.keys)[0]]!
            desc1.text = "\(temp2)회"
            temp = v[1]
            title2.text = Array(temp.keys)[0]
            temp2 = temp[Array(temp.keys)[0]]!
            desc2.text = "\(temp2)회"
            temp = v[2]
            title3.text = Array(temp.keys)[0]
            temp2 = temp[Array(temp.keys)[0]]!
            desc3.text = "\(temp2)회"
        }
        else{
            if(currentCursor == 2){
                self.leaderboardTopConstraint.constant = -20
                self.leaderboardView.alpha = 0
                self.picktargetTopConstraint.constant = 52
            }
            rootViewDelegate?.setBackgroundColor(light: false)
        }
    }
    
    func shouldComeDown() -> Bool{
        switch currentCursor{
        case 2:
            if(getRecordMonthBestLocation(month: monthmonth)!.count < 3){
                return false
            }
        case 1:
            if(getRecordMonthBestFriends(month: monthmonth)!.count < 3){
                return false
            }
        case 0:
            if(getRecordMonthBestSul(month: monthmonth)!.count < 3){
                return false
            }
        default:
            print("Not Accepted Switch Value")
        }
        return true
    }
}
