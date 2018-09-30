//table view input
import UIKit
import AudioToolbox.AudioServices

var selectedDay: Day = dateToDayConverter(date: Date())
var gotDay: RecordDay?


protocol TodayTableDelegate {
    func tableManipulate(_ sender: TodayTableViewCell)
}

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, TodayTableDelegate {
    @objc func showToday(_ notification: Notification) {
        newDaySelected(date: Date())
        self.calendar.select(Date())
    }
    
    func tableManipulate(_ sender: TodayTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let index = indexPath.row
        setRecordDayForSul(day: selectedDay, index: tempFavourite[index], bottles: Int(sender.bottleStepper.value))
        setTopInfoLabelString()
        setBottomInfoLabelString()
    }
    
    var actualIndexArray: [Int] = []
    var sulArray: [Sul] = []
    var currentDictionary: [Int: Sul] = [:]
    var tempFavourite = getFavouriteSulIndex()
    
    func loadArray(){
        //adds sul and userSul into currentDictionary
        //than puts each into sulArray and actualIndexArray
        sulArray = []
        actualIndexArray = []
        currentDictionary = [:]
        currentDictionary = getSulDictionary()
        
        var cnt = 0
        var i = -1
        while(cnt < currentDictionary.count){
            i += 1
            if(currentDictionary[i] != nil){
                sulArray.append(currentDictionary[i]!)
                actualIndexArray.append(i)
                cnt += 1
            }
        }
        
        initTempFavourite()
    }
    
    func initTempFavourite(){
        tempFavourite = []
        for i in 0...currentDictionary.count - 1{
            let t = getRecordDayBottles(day: selectedDay, index: actualIndexArray[i])
            if(t != 0 && t != nil && sul[actualIndexArray[i]].enabled){
                tempFavourite.append(actualIndexArray[i])
            }
        }
        tempFavourite = Array(Set(tempFavourite).subtracting(getFavouriteSulIndex()))
        tempFavourite.insert(contentsOf: getFavouriteSulIndex(), at: 0)
    }
    
    @IBOutlet weak var loadAdditionalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBAction func calendarView(_ sender: Any) {
        scope = (scope == .week) ? .month : .week
        self.calendar.setScope(scope, animated: true)
    }
    @IBAction func calendarToday(_ sender: Any) {
        calendar.select(Date(), scrollToDate: true)
        newDaySelected(date: Date())
    }
    @IBOutlet weak var bottomInfoLabel: UILabel!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var tableFooter: UIView!
    @IBOutlet weak var textColor1: UILabel!
    @IBOutlet weak var textColor2: UILabel!
    @IBOutlet weak var disclosureIcon: UIImageView!
    @IBOutlet weak var moreInfoInput: UIView!
    @IBOutlet weak var topInfoLabel: UILabel!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var scope: FSCalendarScope = .week
    var shouldDisableHapticForCalendarWhenAppLaunch: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shouldViewMonthlyStats()
        
        if(userSetting.firstLaunch){
            firstLaunchAction()
        }
        if(isFirstLaunchMonth()){
            firstMonthLaunchAction()
        }
        
        self.calendar.select(Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(showToday(_:)), name: Notification.Name(rawValue: "showToday"), object: nil)
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        self.calendar.accessibilityIdentifier = "calendar" // For UITest
        
        if(Calendar.current.component(.hour, from: Date()) < 12 && getShowYesterdayFirst() && selectedDay.day != 1) {
            newDaySelected(date: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!)
            gotDay = getRecordDay(day: selectedDay)
            calendar.select(Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!)
            navigationTitle.title = "\(self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!)) (어제)"
        }
        else {
            newDaySelected(date: calendar.today!)
            gotDay = getRecordDay(day: selectedDay)
        }
        
        if(userSetting.firstLaunch){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(snackBarWaitTime))) {
                snackBar(string: "우측의 -/+를 눌러 음주량을 기록해주세요.\n다른 주류는 '기타'에서 찾거나 추가할 수 있습니다.", buttonPlaced: false)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(snackBarWaitTime)*2)) {
                snackBar(string: "함께한 사람, 지출액, 장소를 입력하면\n더 자세한 통계를 볼 수 있습니다.", buttonPlaced: false)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(snackBarWaitTime)*3)) {
                snackBar(string: "통계 탭으로 이동해주세요!", buttonPlaced: true)
            }
        }
        setIsShowDrunkDays(enabled: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadArray()
    
        self.calendar.today = Date()
        
        topInfoLabel.textColor = colorPoint
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:colorText]
        textColor2.textColor = colorGray
        self.calendar.appearance.weekdayTextColor = colorText
        if(userSetting.isThemeBright){
            disclosureIcon.image = UIImage(named:"Chevron_blue")
            self.calendar.appearance.titleDefaultColor = .white
        }
        else{
            disclosureIcon.image = UIImage(named:"Chevron")
            self.calendar.appearance.titleDefaultColor = .black
        }
        navigationTitle.leftBarButtonItem?.tintColor = colorPoint
        navigationTitle.rightBarButtonItem?.tintColor = colorPoint

        moreInfoInput.backgroundColor = colorLightBackground
        
        bottomContainer.backgroundColor = colorDeepBackground
        tableFooter.backgroundColor = colorDeepBackground
        tableView.backgroundColor = colorDeepBackground
        
        self.calendar.appearance.todayColor = colorDeepBackground
        self.calendar.calendarHeaderView.backgroundColor = colorLightBackground
        self.calendar.calendarWeekdayView.backgroundColor = colorLightBackground
        self.calendar.backgroundColor = colorLightBackground
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        loadAdditionalView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapMoreInfo(_:)))
        moreInfoInput.addGestureRecognizer(tap2)
        
        tableView.reloadData()
        setTopInfoLabelString()
        setBottomInfoLabelString()
        
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
        let gradient = CAGradientLayer(layer: bottomContainer.layer)
        gradient.frame = bottomContainer.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.2)
        bottomContainer.backgroundColor = colorDeepBackground
        bottomContainer.layer.mask = gradient
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }()
    
    lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if(isShowDrunkDaysEnabled()){
            let temp = dateToDayConverter(date: date)
            for item in getAllDrunkDays() {
                if(item.year == temp.year && item.month == temp.month && item.day == temp.day){
                    return 1
                }
            }
            return 0
        }
        return 0
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [colorRed]
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [colorRed.withAlphaComponent(0.4)]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return colorText
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if(userSetting.isThemeBright){
            return .white
        }
        else{
            return .black
        }
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return colorPoint
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "additionView")
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func handleTapMoreInfo(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "moreInfoView")
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setTopInfoLabelString()
        calendar.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    

    
    func shouldViewMonthlyStats(){
        if(isFirstLaunchMonth() && !userSetting.firstLaunch){
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                let formatterFirstDayOfMonth = DateFormatter()
                formatterFirstDayOfMonth.dateFormat = "dd"
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "monthlyView") as UIViewController
                self.present(viewController, animated: true, completion: nil)
            })
        }
        setFirstLaunchMonthFalse()
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                scope = (self.calendar.scope == .week) ? .month : .week
                return velocity.y < 0
            case .week:
                scope = (self.calendar.scope == .week) ? .month : .week
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        newDaySelected(date: date)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempFavourite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayIdentifier")!
        guard let customCell = cell as? TodayTableViewCell else{
            return cell
        }
    
        //Value
        customCell.bottleStepper.value = Double(getRecordDayBottles(day: selectedDay, index: tempFavourite[indexPath.row]) ?? 0)
        customCell.bottleLabel.text = "\(getRecordDayBottles(day: selectedDay, index: tempFavourite[indexPath.row]) ?? 0)\(getSulUnit(index: tempFavourite[indexPath.row]))"
        customCell.titleLabel.text = sul[tempFavourite[indexPath.row]].displayName
        
        //UI
        customCell.bottleStepper.tintColor = colorPoint
        customCell.colorTag.backgroundColor = .clear
        if(indexPath.row < getFavouriteSulIndex().count){
            customCell.colorTag.backgroundColor = colorPoint
        }
        customCell.bottleLabel.textColor = colorText
        customCell.titleLabel.textColor = colorGray
        
        customCell.delegate = self
        
        return customCell
    }
    
    // MARK:- Target actions
    
    func newDaySelected(date: Date){
        if(shouldDisableHapticForCalendarWhenAppLaunch){
            shouldDisableHapticForCalendarWhenAppLaunch = false
            self.calendar.setScope(.week, animated: true)
        }
        else{
            if(userSetting.isVibrationEnabled){
                AudioServicesPlaySystemSound(vibPeek)
            }
        }
        navigationTitle.title = "\(self.dateFormatter.string(from: date))"
        selectedDay = dateToDayConverter(date: date)
        
        scope = .week
        self.calendar.setScope(.week, animated: true)
        
        gotDay = getRecordDay(day: selectedDay)
        
        setTopInfoLabelString()
        setBottomInfoLabelString()
        loadArray()
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setTopInfoLabelString(){
        var tempStr: String = ""
        let a = gotDay?.friends
        let b = gotDay?.location
        let c = gotDay?.customExpense
        if((a == nil || a?.count == 0) && (b == nil || b?.count == 0) && (c == nil)){
            topInfoLabel.font = UIFont(name: "Helvetica Neue", size: 17)!
            tempStr = "함께한 사람, 지출액, 장소를 입력하려면 누르세요"
        }
        else{
            topInfoLabel.font = UIFont(name: "Helvetica Neue", size: 15)!
            let tempLocation = gotDay?.location ?? []
            let tempFriends = gotDay?.friends ?? []
            let tempExpense = gotDay?.customExpense ?? -1
            
            if (tempLocation.count != 0){
                for i in (tempLocation) {
                    tempStr.append(i + ", ")
                }
                tempStr.removeLast(2)
                tempStr.append("에서 ")
            }
            if (tempFriends.count != 0){
                for i in (tempFriends) {
                    tempStr.append(i + ", ")
                }
                tempStr.removeLast(2)
                tempStr.append("와(과) ")
            }
            if (tempExpense == -1){
                if(tempLocation.count != 0 || tempFriends.count != 0){
                    tempStr.append("마셨어요")
                }
            }
            else{
                tempStr.append("\(tempExpense)원 지출했어요")
            }
        }
        topInfoLabel.text = tempStr
    }
    
    
    func setBottomInfoLabelString(){
        var temp: String = ""
        if((gotDay?.customExpense == nil || gotDay?.customExpense == 0) && gotDay?.calories == 0){
            temp = "0원, 0kcal"
        }
        else if (gotDay?.customExpense == nil){
            temp = "약 \((gotDay?.expense)!)원, 약 \((gotDay?.calories)!)kcal"
        }
        else{
            temp = "약 \((gotDay?.calories)!)kcal"
        }
        
        if(getDeletedSulTotalCalorieForDay(day: selectedDay) != 0){
            temp.append("(지워진 주류 포함)")
        }
        bottomInfoLabel.text = temp
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

class TodayTableViewCell: UITableViewCell {
    
    var delegate: TodayTableDelegate?
    
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var bottleStepper: UIStepper!
    @IBAction func bottleStepper(_ sender: UIStepper) {

        bottleLabel.text = "\(String(Int(sender.value)))\(getSulUnit(index: getSulIndexByName(sulName: titleLabel.text!)!))"
        delegate?.tableManipulate(self)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(userSetting.isThemeBright){
            titleLabel.textColor = colorGray
        }
        else{
            titleLabel.textColor = colorGray
        }
    }
}

