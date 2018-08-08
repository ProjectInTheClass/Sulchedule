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
    @IBOutlet weak var inputFriends: UITextField!
    @IBOutlet weak var inputLocation: UITextField!
    @IBOutlet weak var inputExpense: UITextField!
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    @IBOutlet weak var rightExpenseLabel: UILabel!
    @IBOutlet weak var rightTypeLabel: UILabel!
    @IBOutlet weak var leftCalorieLevel: UILabel!
    @IBOutlet weak var leftTypeLabel: UILabel!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var tableFooter: UIView!
    @IBOutlet weak var textColor1: UILabel!
    @IBOutlet weak var textColor2: UILabel!
    @IBOutlet weak var disclosureIcon: UIImageView!
    
    
    var scope: FSCalendarScope = .week
    var upFlag = false
    var firstRunForHaptic: Bool = true
    var firstRunForMonthlySummary: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.inputFriends.delegate = self
        self.inputExpense.delegate = self
        self.inputLocation.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        self.calendar.accessibilityIdentifier = "calendar" // For UITest
        
        inputFriends.attributedPlaceholder = NSAttributedString(string: "함께한 사람",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        inputLocation.attributedPlaceholder = NSAttributedString(string: "장소",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        inputExpense.attributedPlaceholder = NSAttributedString(string: "지출액",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        
        newDaySelected(date: calendar.today!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shouldViewMonthlyStats()
        
        

        if(!isDarkTheme){
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
            
            textColor2.textColor = .gray
            disclosureIcon.image = UIImage(named:"Chevron_blue")
            inputFriends.textColor = .black
            inputLocation.textColor = .black
            inputExpense.textColor = .black
            
            self.calendar.appearance.weekdayTextColor = .black
            self.calendar.appearance.titleDefaultColor = .white
        }
        else{
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            
            textColor2.textColor = colorGray
            disclosureIcon.image = UIImage(named:"Chevron")
            inputFriends.textColor = .white
            inputLocation.textColor = .white
            inputExpense.textColor = .white
            
            self.calendar.appearance.weekdayTextColor = .white
            self.calendar.appearance.titleDefaultColor = .black
        }
        navigationTitle.leftBarButtonItem?.tintColor = colorPoint
        navigationTitle.rightBarButtonItem?.tintColor = colorPoint
        
        container1.layer.borderWidth = 1
        container1.layer.borderColor = colorPoint.cgColor
        container3.layer.borderWidth = 1
        container3.layer.borderColor = colorPoint.cgColor
        
        bottomContainer.backgroundColor = colorLightBackground
        tableFooter.backgroundColor = colorDeepBackground
        tableView.backgroundColor = colorDeepBackground
        
        self.calendar.appearance.todayColor = colorDeepBackground
        self.calendar.calendarHeaderView.backgroundColor = colorLightBackground
        self.calendar.calendarWeekdayView.backgroundColor = colorLightBackground
        self.calendar.backgroundColor = colorLightBackground
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        loadAdditionalView.addGestureRecognizer(tap)
        
        let tapFriends = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFriends(_:)))
        let tapExpense = UITapGestureRecognizer(target: self, action: #selector(self.handleTapExpense(_:)))
        let tapLocation = UITapGestureRecognizer(target: self, action: #selector(self.handleTapLocation(_:)))
        container1.addGestureRecognizer(tapFriends)
        container2.addGestureRecognizer(tapLocation)
        container3.addGestureRecognizer(tapExpense)
        
        calendar.reloadData()
        tableView.reloadData()
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(!isDarkTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
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
        if(!isDarkTheme){
            return .black
        }
        else{
            return .white
        }
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        if(!isDarkTheme){
            return .white
        }
        else{
            return .black
        }
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return colorPoint
    }
    
    @objc func handleTapFriends(_ sender: UITapGestureRecognizer) {
        inputFriends.isUserInteractionEnabled = true
        inputFriends.becomeFirstResponder()
    }
    @objc func handleTapExpense(_ sender: UITapGestureRecognizer) {
        inputExpense.isUserInteractionEnabled = true
        inputExpense.becomeFirstResponder()
    }
    @objc func handleTapLocation(_ sender: UITapGestureRecognizer) {
        inputLocation.isUserInteractionEnabled = true
        inputLocation.becomeFirstResponder()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "additionView")
        // Alternative way to present the new view controller
        self.navigationController?.show(vc, sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        loadAdditionalView.isUserInteractionEnabled = false
        animateViewMoving(up: true, moveValue: 150)
        upFlag = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputFriends.isUserInteractionEnabled = false
        inputExpense.isUserInteractionEnabled = false
        inputLocation.isUserInteractionEnabled = false
        loadAdditionalView.isUserInteractionEnabled = true
        animateViewMoving(up: false, moveValue: 150)
        upFlag = false
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
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
        
        customCell.bottleLabel.text = "3병"
        customCell.titleLabel.text = "Dummy Data"
        customCell.backgroundColor = .clear
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bottleStepper.tintColor = colorPoint
        
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
                AudioServicesPlaySystemSound(peek)
            }
        }
        navigationTitle.title = "\(self.dateFormatter.string(from: date))"
        
        scope = .week
        self.calendar.setScope(scope, animated: true)
        //load data into tableView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var bottleStepper: UIStepper!
    @IBAction func bottleStepper(_ sender: UIStepper) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(!isDarkTheme){
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
