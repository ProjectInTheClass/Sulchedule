//table view input
import UIKit
import AudioToolbox.AudioServices

var selectedDay: Day = dateToDayConverter(date: Date())
var gotDay: RecordDay?

protocol TableDelegate {
    func tableManipulate(_ sender: TodayTableViewCell)
}

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, TableDelegate {
    func tableManipulate(_ sender: TodayTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let index = indexPath.row
        let favorite = getFavoriteSul()
        setRecordDayForSul(day: selectedDay, index: favorite![index], bottles: Int(sender.bottleStepper.value))

    }
    
    
    @IBOutlet weak var loadAdditionalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var favorite: [Int]? = nil
    
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
    
    
    var scope: FSCalendarScope = .week
    var upFlag = false
    var firstRunForHaptic: Bool = true
    var firstRunForMonthlySummary: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        self.calendar.accessibilityIdentifier = "calendar" // For UITest
        
        userData.favorites = [0, 2]
        favorite = getFavoriteSul()
        //        setFavoriteSul(1, true)
              
        newDaySelected(date: calendar.today!)
        gotDay = getRecordDay(day: selectedDay)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shouldViewMonthlyStats()
        
        topInfoLabel.textColor = colorPoint

        if(isBrightTheme){
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
        if(isBrightTheme){
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if(isBrightTheme){
            return .black
        }
        else{
            return .white
        }
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if(isBrightTheme){
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
        self.navigationController?.show(vc, sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    

    
    func shouldViewMonthlyStats(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let formatterFirstDayOfMonth = DateFormatter()
            formatterFirstDayOfMonth.dateFormat = "dd"
            if(self.firstRunForMonthlySummary && formatterFirstDayOfMonth.string(from: Date()) == "01"){
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "monthlyView") as UIViewController
                self.present(viewController, animated: true, completion: {self.firstRunForMonthlySummary = false})
            }
        })
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
        let temp = getFavoriteSul()?.count ?? 0
        return temp
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayIdentifier")!
        guard let customCell = cell as? TodayTableViewCell else{
            return cell
        }
    
        //Value
        customCell.bottleStepper.value = Double(getRecordDayBottles(day: selectedDay, index: favorite![indexPath.row]) ?? 0)
        customCell.bottleLabel.text = "\(getRecordDayBottles(day: selectedDay, index: favorite![indexPath.row]) ?? 0)병"
        customCell.titleLabel.text = sul[favorite![indexPath.row]].displayName ?? "undefined"
        
        //UI
        customCell.backgroundColor = .clear
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bottleStepper.tintColor = colorPoint
        customCell.colorTag.backgroundColor = .clear
        if(isBrightTheme){
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
        }
        else{
            if(isVibrationOn){
                AudioServicesPlaySystemSound(vibPeek)
            }
        }
        navigationTitle.title = "\(self.dateFormatter.string(from: date))"
        selectedDay = dateToDayConverter(date: date)
        
        scope = .week
        self.calendar.setScope(scope, animated: true)
        
        gotDay = getRecordDay(day: selectedDay)!
        
        
//        for item in favorite!{
//            setRecordDayForSul(day: selectedDay, index: item, bottles: 0)
//        }
        
        //load data into tableView
        //set new array
        //reload table
        setTopInfoLabelString()
        setBottomInfoLabelString()
        tableView.reloadData()
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
        if (gotDay?.customExpense == nil){
            bottomInfoLabel.text = "약 \(gotDay?.expense)원, 약 \(gotDay?.calories)kcal"
        }
        else{
            bottomInfoLabel.text = "\(gotDay?.customExpense)원, 약 \(gotDay?.calories)kcal"
        }
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
    
    var delegate: TableDelegate?
    
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var bottleStepper: UIStepper!
    @IBAction func bottleStepper(_ sender: UIStepper) {
        if(isVibrationOn){
            AudioServicesPlaySystemSound(vibPeek)
        }
        let favorite = getFavoriteSul()
        
        bottleLabel.text = "\(String(Int(sender.value)))병"
        delegate?.tableManipulate(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(isBrightTheme){
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

