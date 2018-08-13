//table view input
import UIKit
import AudioToolbox.AudioServices

var selectedDay: Day = dateToDayConverter(date: Date())
var gotDay: RecordDay?
//var tempSul = getSulDictionary()


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
//        getSulDictionary().forEach { (k,v) in currentDictionary[k] = v }
//        getUserSulDictionary().forEach { (k,v) in currentDictionary[k + getSulDictionary().count] = v }
        
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
        let date: Date = Date.init()
        calendar.select(date, scrollToDate: true)
        newDaySelected(date: calendar.today!)
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
    var upFlag = false
    var firstRunForHaptic: Bool = true
    var firstRunForMonthlySummary: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(userSetting.firstLaunch){
            firstLaunchExecution()
            setFirstLaunchFalse()
        }
        self.calendar.select(Date())
        
        NotificationCenter.default.addObserver(self, selector: #selector(showToday(_:)), name: Notification.Name(rawValue: "showToday"), object: nil)
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        self.calendar.accessibilityIdentifier = "calendar" // For UITest
        
        if(Calendar.current.component(.hour, from: Date()) < 12 && getShowYesterdayFirst()) {
            newDaySelected(date: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!)
            gotDay = getRecordDay(day: selectedDay)
            calendar.select(Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!)
            navigationTitle.title = "\(self.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!)) (어제)"
        }
        else {
            newDaySelected(date: calendar.today!)
            gotDay = getRecordDay(day: selectedDay)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shouldViewMonthlyStats()
        
        loadArray()
        
        topInfoLabel.textColor = colorPoint
        if(userSetting.isThemeBright){
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            textColor2.textColor = .gray
            disclosureIcon.image = UIImage(named:"Chevron_blue")
            self.calendar.appearance.weekdayTextColor = .black
            self.calendar.appearance.titleDefaultColor = .white
        }
        else{
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            textColor2.textColor = colorGray
            disclosureIcon.image = UIImage(named:"Chevron")
            self.calendar.appearance.weekdayTextColor = .white
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
        
        calendar.reloadData()
        tableView.reloadData()
        setTopInfoLabelString()
        setBottomInfoLabelString()
        
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(userSetting.isThemeBright){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
        
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
        return [colorLightBackground]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if(userSetting.isThemeBright){
            return .black
        }
        else{
            return .white
        }
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
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        if(isShowDrunkDaysEnabled()){
//            let temp = dateToDayConverter(date: date)
//            for item in getAllDrunkDays() {
//                if(item.year == temp.year && item.month == temp.month && item.day == temp.day){
//                    return colorRed
//                }
//            }
//            return nil
//        }
//        else{
//            return nil
//        }
//    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "additionView")
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func handleTapMoreInfo(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "moreInfoView")
        self.navigationController?.show(vc, sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    

    
    func shouldViewMonthlyStats(){
        if(isFirstLaunchToday() && !userSetting.firstLaunch){
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                let formatterFirstDayOfMonth = DateFormatter()
                formatterFirstDayOfMonth.dateFormat = "dd"
                if(self.firstRunForMonthlySummary && formatterFirstDayOfMonth.string(from: Date()) == "01"){
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "monthlyView") as UIViewController
                    self.present(viewController, animated: true, completion: {self.firstRunForMonthlySummary = false})
                }
            })
            setFirstLaunchTodayFalse()
        }
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
        customCell.titleLabel.text = sul[tempFavourite[indexPath.row]].displayName ?? "undefined"
        
        //UI
        customCell.backgroundColor = .clear
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bottleStepper.tintColor = colorPoint
        customCell.colorTag.backgroundColor = .clear
        if(indexPath.row < getFavouriteSulIndex().count){
            customCell.colorTag.backgroundColor = colorPoint
        }
        if(userSetting.isThemeBright){
            customCell.bottleLabel.textColor = .black
            customCell.titleLabel.textColor = .gray
        }
        else{
            customCell.bottleLabel.textColor = .white
            customCell.titleLabel.textColor = colorGray
        }
        
        customCell.delegate = self
        
        return customCell
    }
    
    // MARK:- Target actions
    
    func newDaySelected(date: Date){
        if(firstRunForHaptic){
            firstRunForHaptic = false
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
        
        gotDay = getRecordDay(day: selectedDay)!
        
        setTopInfoLabelString()
        setBottomInfoLabelString()
        loadArray()
        tableView.reloadData()
//        calendar.cell(for: <#T##Date#>, at: <#T##FSCalendarMonthPosition#>).configureAppearance()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setTopInfoLabelString(){
        var tempStr: String = ""
        if((gotDay?.friends == nil && gotDay?.location == nil) || (gotDay?.friends?.count == 0 && gotDay?.location?.count == 0)){
            topInfoLabel.font = UIFont(name: "Helvetica Neue", size: 17)!
            tempStr = "함께한 사람, 지출액, 장소를 입력하려면 누르세요"
        }
        else{
            topInfoLabel.font = UIFont(name: "Helvetica Neue", size: 15)!
            let tempLocation = gotDay?.location ?? []
            let tempFriends = gotDay?.friends ?? []
            
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
            tempStr.append("마셨어요")
        }
        topInfoLabel.text = tempStr
    }
    
    
    func setBottomInfoLabelString(){
        var temp: String = ""
        if((gotDay?.customExpense == nil || gotDay?.customExpense == 0) && gotDay?.calories == 0){
            temp = "0원, 0kcal"
        }
        else if (gotDay?.customExpense == nil || gotDay?.customExpense == 0){
            temp = "약 \((gotDay?.expense)!)원, 약 \((gotDay?.calories)!)kcal"
        }
        else{
            temp = "\((gotDay?.customExpense)!)원, 약 \((gotDay?.calories)!)kcal"
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
            titleLabel.textColor = .gray
        }
        else{
            titleLabel.textColor = colorGray
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

