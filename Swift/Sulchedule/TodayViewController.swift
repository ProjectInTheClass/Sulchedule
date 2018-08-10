//table view input
import UIKit
import AudioToolbox.AudioServices

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
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
              
        newDaySelected(date: calendar.today!)
        
        //test value
        bottomInfoLabel.text = "약 65000원, 약 1205kcal"
        setTopInfoLabelString()
        setBottomInfoLabelString()
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
        // Alternative way to present the new view controller
        self.navigationController?.show(vc, sender: nil)
    }
    @objc func handleTapMoreInfo(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "moreInfoView")
        // Alternative way to present the new view controller
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayIdentifier")!
        guard let customCell = cell as? TodayTableViewCell else{
            return cell
        }
 
        customCell.bottleStepper.value = 5//술 값 읽어오기
        customCell.bottleLabel.text = "\(Int(customCell.bottleStepper.value))병"
        customCell.titleLabel.text = "술 이름"
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
        
        
        
        return customCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
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
        
        scope = .week
        self.calendar.setScope(scope, animated: true)
        
        //load data into tableView
        //set new array
        //reload table
        setTopInfoLabelString()
        setBottomInfoLabelString()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setTopInfoLabelString(){
        var tempStr: String = ""
        tempStr = "Temp와(과) Temp에서 Temp원 소비했어요."
//        if(name.count == 0 && locations.count == 0){
//            topInfoLabel.font = UIFont(name: "Helvetica Neue", size: 17)!
//            tempStr = "함께한 사람, 지출액, 장소를 입력하려면 누르세요"
//        }
//        else{
//        if locations.count != 0{
//            for i in locations{
//                tempStr.append(i + ", ")
//            }
//            tempStr.removeLast()
//            tempStr.removeLast()
//            tempStr.append("에서 ")
//            if name.count != 0{
//                for i in names{
//                    tempStr.append(i + ", ")
//                }
//            tempStr.removeLast()
//            tempStr.removeLast()
//            tempStr.append("와(과) 함께했어요")
//            }
//        }
//
//        topInfoLabel.font = UIFont(name: "Helvetica Neue", size: 15)!
//
//        }
        topInfoLabel.text = tempStr
    }
    
    
    func setBottomInfoLabelString(){
//        if (customExpense == 0){
//            bottomInfoLabel.text = "약 \(expense)원, 약 \(calorie)kcal"
//        }
//        else{
//            bottomInfoLabel.text = "\(customExpense)원, 약 \(calorie)kcal"
//        }
    }
    //customexpense가 0인지 nil인지 확인!
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
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var bottleStepper: UIStepper!
    @IBAction func bottleStepper(_ sender: UIStepper) {
        if(isVibrationOn){
            AudioServicesPlaySystemSound(vibPeek)
        }
        bottleLabel.text = "\(String(Int(sender.value)))병"
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
