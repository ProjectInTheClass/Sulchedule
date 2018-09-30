import UIKit

protocol EmbedGoalsDelegate {
    func tableManipulateValue(_ sender: EmbedGoalsTableCell, enable: Bool, value: Int)
    func isEditing() -> Bool
    func reloadTable()
    func manipulateSignal(value: Int)
}

var goals: [cellContent] = []
var pickerList: [[Int]] = [[],[],[],[]]

struct cellContent {
    var goalValue: Float
    var goalLimit: Int
    var goalStat: Int
    var isEnabled: Bool
}

class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EmbedGoalsDelegate {
    func isEditing() -> Bool {
        return editEnabled
    }
    func moveTableBottom(value: CGFloat) {
        var final_value = value
        if(value != 0){
            final_value -= tabBarController?.tabBar.frame.height ?? 0
            if((rootViewDelegate?.isAdOpen())!){
                if(notched_display_height.contains(Int(UIScreen.main.nativeBounds.height))){
                    final_value -= 110
                }
                else{
                    final_value -= 60
                }
            }
        }
        tableBottom.constant = final_value
    }
    func manipulateSignal(value: Int) {
        cycleSignalColor(cursor: value)
    }
    func reloadTable() {
        tableOutlet.reloadData()
    }
    
    @IBOutlet weak var tableOutlet: UITableView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var howYouDoingLabel: UILabel!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        if(editEnabled){
            editEnabled = false
            sender.title = "목표 수정"
        }
        else{
            if(userSetting.isThemeBright){
                snackBar(string: "우측의 파란 숫자를 누르세요.", buttonPlaced: true)
            }
            else{
                snackBar(string: "우측의 노란 숫자를 누르세요.", buttonPlaced: true)
            }
            editEnabled = true
            sender.title = "목표 저장"
        }
        tableOutlet.reloadData()
    }
    
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 18,y: 18), radius: CGFloat(18), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    
    let redCircle = CAShapeLayer()
    let yellowCircle = CAShapeLayer()
    let greenCircle = CAShapeLayer()
    
    let date = Date()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initCircle()
        formatter.dateFormat = "M월의 목표"
        self.navigationItem.title = formatter.string(from: date)
        
        //0:며칠
        //1:며칠 연속
        //2:지출액
        //3:칼로리
        goals = []
        goals.append(cellContent(goalValue: divisionByZeroWTF(getDaysOfMonthStatus(month: monthmonth), getDaysOfMonthLimit(month: monthmonth)), goalLimit: getDaysOfMonthLimit(month: monthmonth) , goalStat: getDaysOfMonthStatus(month: monthmonth), isEnabled: isDaysOfMonthEnabled(month: monthmonth)))
        goals.append(cellContent(goalValue: divisionByZeroWTF(getStreakOfMonthStatus(month: monthmonth), getStreakOfMonthLimit(month: monthmonth)), goalLimit: getStreakOfMonthLimit(month: monthmonth), goalStat: getStreakOfMonthStatus(month: monthmonth), isEnabled: isStreakOfMonthEnabled(month: monthmonth)))
        goals.append(cellContent(goalValue: divisionByZeroWTF(getCurrentExpenseStatus(month: monthmonth), getCurrentExpenseLimit(month: monthmonth)), goalLimit: getCurrentExpenseLimit(month: monthmonth), goalStat: getCurrentExpenseStatus(month: monthmonth), isEnabled: isCurrentExpenseEnabled(month: monthmonth)))
        goals.append(cellContent(goalValue: divisionByZeroWTF(getCaloriesOfMonthStatus(month: monthmonth), getCaloriesOfMonthLimit(month: monthmonth)), goalLimit: getCaloriesOfMonthLimit(month: monthmonth), goalStat: getCaloriesOfMonthStatus(month: monthmonth), isEnabled: isCaloriesOfMonthEnabled(month: monthmonth)))
        for i in 0...3{
            if(!isStatZero(i) && goals[i].isEnabled && goals[i].goalLimit == 0){
                goals[i].goalValue = 1.1
            }
        }
        
        if(userSetting.firstLaunch){
            snackBar(string: "목표를 설정해 건강을 지키세요!\n우측 상단에 목표 설정 버튼이 있습니다.", buttonPlaced: false)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(snackBarWaitTime))){
                snackBar(string: "목표를 달성하면 다음 달에 광고를 제거할 수 있습니다!", buttonPlaced: true)
            }
        }
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFixed), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        topBackgroundView.backgroundColor = colorLightBackground
        navigationItem.rightBarButtonItem?.tintColor = colorPoint
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:colorText]
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
        tableOutlet.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
        var dangerLevel = 0
        var flag_dangerLevel = false
        for item in goals {
            if(item.isEnabled){
                flag_dangerLevel = true
                if(item.goalValue >= 0.7){
                    dangerLevel = 1
                }
                if(item.goalValue > 1.0){
                    dangerLevel = 2
                }
            }
        }
        if(!flag_dangerLevel){
            dangerLevel = 3
        }
        
        reloadTableData()
        tableOutlet.reloadData()
        manipulateSignal(value: dangerLevel)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        editEnabled = false
        navigationItem.rightBarButtonItem!.title = "목표 수정"
    }
    
    func initCircle(){
        redView.layer.addSublayer(redCircle)
        yellowView.layer.addSublayer(yellowCircle)
        greenView.layer.addSublayer(greenCircle)
        
        redCircle.path = circlePath.cgPath
        redCircle.fillColor = colorRed.cgColor
        yellowCircle.path = circlePath.cgPath
        yellowCircle.fillColor = colorYellow.cgColor
        greenCircle.path = circlePath.cgPath
        greenCircle.fillColor = colorGreen.cgColor
    }
    
    func cycleSignalColor(cursor: Int){
        let alpha: CGFloat = 0.2
        switch (cursor){
        case 3:
            redView.alpha = alpha
            yellowView.alpha = alpha
            greenView.alpha = alpha
            howYouDoingLabel.text = "목표를 설정하세요!"
        case 2:
            redView.alpha = 1.0
            yellowView.alpha = alpha
            greenView.alpha = alpha
            howYouDoingLabel.text = "어떡하려고 그래요...?"
        case 1:
            redView.alpha = alpha
            yellowView.alpha = 1.0
            greenView.alpha = alpha
            howYouDoingLabel.text = "아슬아슬해요!!!"
        case 0:
            redView.alpha = alpha
            yellowView.alpha = alpha
            greenView.alpha = 1.0
            howYouDoingLabel.text = "목표한 대로 잘하고 있어요!"
        default:
            defaultSwitch()
        }
    }

    
    var keyboardHeight: CGFloat = 0
    var tempRow = 0
    var tempSection = 0
    var editEnabled = false
    
    func keyboard(pullUp: Bool, row: Int, section: Int){
        if(pullUp){
            moveTableBottom(value: keyboardHeight)
        }
        else {
            moveTableBottom(value: 0)
        }
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.height
        keyboard(pullUp: true, row: tempRow, section: tempSection)
    }
    
    @objc func keyboardFixed(notification: NSNotification) {
        tableOutlet.scrollToRow(at: IndexPath(row:tempRow, section:tempSection), at: .bottom, animated: true)
    }
    
    @objc func keyboardHidden(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.height
        keyboard(pullUp: false, row: tempRow, section: tempSection)
    }
    
    func divisionByZeroWTF(_ stat: Int, _ limit: Int) -> Float{
        if(limit == 0){
            return 0
        }
        else{
            return Float(stat)/Float(limit)
        }
    }
    func isStatZero(_ index: Int) -> Bool{
        if(goals[index].goalStat != 0){
            return false
        }
        else{
            return true
        }
    }
    
    func tableManipulateValue(_ sender: EmbedGoalsTableCell, enable: Bool, value: Int) {
        guard let indexPath = tableOutlet.indexPath(for: sender) else { return }
        if(enable){
            switch indexPath.row {
            case 0:
                setDaysOfMonthEnabled(enabled: true)
                setDaysOfMonthLimit(month: dateToMonthConverter(date: Date()), value: value)
            case 1:
                setStreakOfMonthEnabled(enabled: true)
                setStreakOfMonthLimit(month: dateToMonthConverter(date: Date()), value: value)
            case 2:
                setCurrentExpenseEnabled(enabled: true)
                setCurrentExpenseLimit(month: dateToMonthConverter(date: Date()), value: value)
            case 3:
                setCaloriesOfMonthEnabled(enabled: true)
                setCaloriesOfMonthLimit(month: dateToMonthConverter(date: Date()), value: value)
            default:
                defaultSwitch()
            }
        }
        else{
            switch indexPath.row {
            case 0:
                setDaysOfMonthEnabled(enabled: false)
            case 1:
                setStreakOfMonthEnabled(enabled: false)
            case 2:
                setCurrentExpenseEnabled(enabled: false)
            case 3:
                setCaloriesOfMonthEnabled(enabled: false)
            default:
                defaultSwitch()
            }
        }
        
        reloadTableData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func reloadTableData(){
        goals[0] = cellContent(goalValue: divisionByZeroWTF(getDaysOfMonthStatus(month: monthmonth), getDaysOfMonthLimit(month: monthmonth)), goalLimit: getDaysOfMonthLimit(month: monthmonth) , goalStat: getDaysOfMonthStatus(month: monthmonth), isEnabled: isDaysOfMonthEnabled(month: monthmonth))
        goals[1] = cellContent(goalValue: divisionByZeroWTF(getStreakOfMonthStatus(month: monthmonth), getStreakOfMonthLimit(month: monthmonth)), goalLimit: getStreakOfMonthLimit(month: monthmonth), goalStat: getStreakOfMonthStatus(month: monthmonth), isEnabled: isStreakOfMonthEnabled(month: monthmonth))
        goals[2] = cellContent(goalValue: divisionByZeroWTF(getCurrentExpenseStatus(month: monthmonth), getCurrentExpenseLimit(month: monthmonth)), goalLimit: getCurrentExpenseLimit(month: monthmonth), goalStat: getCurrentExpenseStatus(month: monthmonth), isEnabled: isCurrentExpenseEnabled(month: monthmonth))
        goals[3] = cellContent(goalValue: divisionByZeroWTF(getCaloriesOfMonthStatus(month: monthmonth), getCaloriesOfMonthLimit(month: monthmonth)), goalLimit: getCaloriesOfMonthLimit(month: monthmonth), goalStat: getCaloriesOfMonthStatus(month: monthmonth), isEnabled: isCaloriesOfMonthEnabled(month: monthmonth))
        for i in 0...3{
            if(!isStatZero(i) && goals[i].isEnabled && goals[i].goalLimit == 0){
                goals[i].goalValue = 1.1
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "embedGoalsIdentifier", for: indexPath)
        
        guard let customCell = cell as? EmbedGoalsTableCell else{
            return cell
        }
        
        
        switch (indexPath.row){
        case 0:
            customCell.leftTitleLabel.text = "음주 일수"
            customCell.leftValueLabel.text = "\(String(goals[indexPath.row].goalStat))일"
            if(!goals[indexPath.row].isEnabled){
                customCell.editField.text = "설정하지 않음"
            }
            else{
                customCell.editField.text = String(goals[indexPath.row].goalLimit)
            }
            customCell.setGraphValue(value: goals[indexPath.row].goalValue)
        case 1:
            customCell.leftTitleLabel.text = "연이어 음주한 일수"
            customCell.leftValueLabel.text = "\(String(goals[indexPath.row].goalStat))일"
            if(!goals[indexPath.row].isEnabled){
                customCell.editField.text = "설정하지 않음"
            }
            else{
                customCell.editField.text = String(goals[indexPath.row].goalLimit)
            }
            customCell.setGraphValue(value: goals[indexPath.row].goalValue)
        case 2:
            customCell.leftTitleLabel.text = "총 지출액"
            customCell.leftValueLabel.text = "\(String(goals[indexPath.row].goalStat))원"
            if(!goals[indexPath.row].isEnabled){
                customCell.editField.text = "설정하지 않음"
            }
            else{
                customCell.editField.text = String(goals[indexPath.row].goalLimit)
            }
            customCell.setGraphValue(value: goals[indexPath.row].goalValue)
        case 3:
            customCell.leftTitleLabel.text = "총 열량"
            customCell.leftValueLabel.text = "\(String(goals[indexPath.row].goalStat))kcal"
            if(!goals[indexPath.row].isEnabled){
                customCell.editField.text = "설정하지 않음"
            }
            else{
                customCell.editField.text = String(goals[indexPath.row].goalLimit)
            }
            customCell.setGraphValue(value: goals[indexPath.row].goalValue)
        default:
            defaultSwitch()
            
        }
        
        customCell.leftValueLabel.textColor = colorText
        if(!editEnabled){
            customCell.editField.textColor = colorText
            customCell.editField.isUserInteractionEnabled = false
        }
        else{
            customCell.editField.textColor = colorPoint
            customCell.editField.isUserInteractionEnabled = true
        }
        customCell.leftTitleLabel.textColor = colorGray
        customCell.rightTitleLabel.textColor = colorGray
        customCell.currentRow = indexPath.row
        
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bgGraph.layer.backgroundColor = colorLightBackground.cgColor
        
        customCell.delegate = self
        
        return customCell
    }
}
class EmbedGoalsTableCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var bgGraph: UIView!
    @IBOutlet weak var leftValueLabel: UILabel!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var editField: NoEditerUITextFieldForSection!
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    @IBOutlet weak var graphWidth: NSLayoutConstraint!
    @IBOutlet weak var actualGraph: UIView!
    
    let numDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
    let month = Calendar.current.component(.month, from: Date())
    
    var delegate: EmbedGoalsDelegate?
    var currentRow: Int = 0
    
    var picker = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList[currentRow].count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if(row == 0){
            return NSAttributedString(string: "목표 설정 안 함", attributes: [NSAttributedStringKey.foregroundColor : colorText])
        }
        else{
            switch currentRow{
            case 0:
                return NSAttributedString(string: "\((pickerList[0])[row])일", attributes: [NSAttributedStringKey.foregroundColor : colorText])
            //                return "\((pickerList[0])[row])일"
            case 1:
                return NSAttributedString(string: "연속 \((pickerList[1])[row])일", attributes: [NSAttributedStringKey.foregroundColor : colorText])
            //                return "연속 \((pickerList[1])[row])일"
            case 2:
                return NSAttributedString(string: "\((pickerList[2])[row])원", attributes: [NSAttributedStringKey.foregroundColor : colorText])
            //                return "\((pickerList[2])[row])원"
            case 3:
                return NSAttributedString(string: "\((pickerList[3])[row])kcal", attributes: [NSAttributedStringKey.foregroundColor : colorText])
            //                return "\((pickerList[3])[row])kcal"
            default:
                return NSAttributedString(string: "Not Accepted Switch Value", attributes: [NSAttributedStringKey.foregroundColor : colorText])
                //                return "Not Accepted Switch Value"
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(picker.selectedRow(inComponent: 0) == 0){
            delegate?.tableManipulateValue(self, enable: false, value: 0)
            editField.text = "설정하지 않음"
        }
        else{
            delegate?.tableManipulateValue(self, enable: true, value: pickerList[currentRow][picker.selectedRow(inComponent: 0)])
            switch currentRow{
            case 0:
                editField.text = "\(pickerList[0][row])"
            case 1:
                editField.text = "\((pickerList[1])[row])"
            case 2:
                editField.text = "\((pickerList[2])[row])"
            case 3:
                editField.text = "\((pickerList[3])[row])"
            default:
                editField.text = "Not Accepted Switch Value"
            }
        }
    }
    func setGraphValue(value: Float){
        if(0 <= value && value < 0.7){
            drawRect(color: colorGreen, value: value)
        }
        else if(value <= 1.0){
            drawRect(color: colorYellow, value: value)
        }
        else{
            drawRect(color: colorRed, value: 1)
        }
    }
    
    func drawRect(color: UIColor, value: Float)
    {
        bgGraph.layer.cornerRadius = bgGraph.bounds.height/2
        actualGraph.layer.cornerRadius = bgGraph.bounds.height/2
        bgGraph.layer.backgroundColor = colorLightBackground.cgColor
        actualGraph.layer.backgroundColor = color.cgColor
        graphWidth.constant = CGFloat(value * Float(bgGraph.bounds.width))
    }
    @IBAction func labelEditBegan(_ sender: UITextField) {
        picker.backgroundColor = colorLightBackground
        editField.tintColor = colorText
        
        let tempValue: Int = goals[currentRow].goalLimit
        if(goals[currentRow].isEnabled){
            var flag = false
            for i in 0...pickerList[currentRow].count - 1{
                if pickerList[currentRow][i] == tempValue{
                    picker.selectRow(i, inComponent: 0, animated: true)
                    flag = true
                }
            }
            if(!flag){
                picker.selectRow(1, inComponent: 0, animated: true)
            }
        }
        else{
            picker.selectRow(0, inComponent: 0, animated: true)
        }
        sender.allowsEditingTextAttributes = false
    }
    @IBAction func labelEditEnded(_ sender: UITextField) {
        delegate?.reloadTable()
        var dangerLevel = 0
        var flag_dangerLevel = false
        for item in goals {
            if(item.isEnabled){
                flag_dangerLevel = true
                if(item.goalValue >= 0.7){
                    dangerLevel = 1
                }
                if(item.goalValue > 1.0){
                    dangerLevel = 2
                }
            }
        }
        if(!flag_dangerLevel){
            dangerLevel = 3
        }
        
        delegate?.manipulateSignal(value: dangerLevel)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
        editField.inputView = picker
        
        pickerList = [[],[],[],[]]
        for i in -1...numDays{
            pickerList[0].append(i)
        }
        
        for i in -1...numDays{
            pickerList[1].append(i)
        }
        
        for i in -1...19{
            pickerList[2].append(i*5000)
        }
        for i in 2...10{
            pickerList[2].append(i*50000)
        }
        //5000씩, 100000까지, 50000씩, 500000까지
        
        for i in -1...19{
            pickerList[3].append(i*50)
        }
        for i in 10...49{
            pickerList[3].append(i*100)
        }
        for i in 10...19{
            pickerList[3].append(i*500)
        }
        for i in 2...20{
            pickerList[3].append(i*5000)
        }
        //50씩, 1000까지, 100씩, 5000까지, 500씩, 10000까지, 5000씩 100000까지
        
        
    }
}

class NoEditerUITextFieldForSection: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)){
            return false
        }
        if action == #selector(UIResponderStandardEditActions.cut(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

