//table view input
import UIKit
import AudioToolbox.AudioServices

protocol GoalsEditTableDelegate {
    func tableManipulateValue(_ sender: GoalsEditTableCell, enable: Bool, value: Int)
}

struct UserGoal{
    var name: String
    var checked: Bool
    var value: Int
}
var goals: [UserGoal] = []
var pickerList: [[Int]] = [[],[],[],[]]

class GoalsEditTableViewController: UITableViewController, GoalsEditTableDelegate {
    
    let numDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
    let month = Calendar.current.component(.month, from: Date())
    
    @IBOutlet var backgroundView: UITableView!
    
    func reload(){
        goals = [
            UserGoal(name: "음주 일수", checked: isDaysOfMonthEnabled(month: monthmonth), value: getDaysOfMonthLimit(month: monthmonth)),
            UserGoal(name: "연이어 음주한 일수", checked: isStreakOfMonthEnabled(month: monthmonth), value: getStreakOfMonthLimit(month: monthmonth)),
            UserGoal(name: "총 지출액", checked: isCurrentExpenseEnabled(month: monthmonth), value: getCurrentExpenseLimit(month: monthmonth)),
            UserGoal(name: "총 열량", checked: isCaloriesOfMonthEnabled(month: monthmonth), value: getCaloriesOfMonthLimit(month: monthmonth))
        ]
        
        backgroundView.reloadData()
    }
    
    func tableManipulateValue(_ sender: GoalsEditTableCell, enable: Bool, value: Int) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
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
        

        goals = [
            UserGoal(name: "음주 일수", checked: isDaysOfMonthEnabled(month: monthmonth), value: getDaysOfMonthLimit(month: monthmonth)),
            UserGoal(name: "연이어 음주한 일수", checked: isStreakOfMonthEnabled(month: monthmonth), value: getStreakOfMonthLimit(month: monthmonth)),
            UserGoal(name: "총 지출액", checked: isCurrentExpenseEnabled(month: monthmonth), value: getCurrentExpenseLimit(month: monthmonth)),
            UserGoal(name: "총 열량", checked: isCaloriesOfMonthEnabled(month: monthmonth), value: getCaloriesOfMonthLimit(month: monthmonth))
        ]
    }
    
    let formatter = DateFormatter()
    
    //save button
//    @objc func buttonAction(){
//        self.navigationController?.popViewController(animated: true)
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        formatter.dateFormat = "M월 목표 설정"
        self.navigationItem.title = formatter.string(from: Date())
        self.tableView.isEditing = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GoalsEditTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //save button
//        let rightBtn = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(buttonAction))
//        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        backgroundView.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText

        reload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        var isEnabled:[Int] = []
        if(isDaysOfMonthEnabled(month: monthmonth)){
            isEnabled.append(0)
        }
        if(isStreakOfMonthEnabled(month: monthmonth)){
            isEnabled.append(1)
        }
        if(isCurrentExpenseEnabled(month: monthmonth)){
            isEnabled.append(2)
        }
        if(isCaloriesOfMonthEnabled(month: monthmonth)){
            isEnabled.append(3)
        }
        if(isEnabled.count != 0){
            snackBar(string: "목표가 설정되었습니다.\n파이팅!", buttonPlaced: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        reload()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goals.count
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsEditIdentifier", for: indexPath)
        let row = indexPath.row
        
        guard let customCell = cell as? GoalsEditTableCell else {
            return cell
        }

        customCell.titleLabel.text = "\(goals[row].name)"
        customCell.delegate = self
        switch row{
            case 0:
                customCell.editField.text = "\(goals[row].value)일"
            case 1:
                customCell.editField.text = "연속 \(goals[row].value)일"
            case 2:
                customCell.editField.text = "\(goals[row].value)원"
            case 3:
                customCell.editField.text = "\(goals[row].value)kcal"
            default:
                customCell.editField.text = "Not Accepted Switch Value"
        }
        
        
        if(!(goals[row].checked)){
            customCell.editField.text = ""
        }

        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.tintColor = colorDeepBackground
        customCell.backgroundColor = colorDeepBackground
        customCell.currentRow = row
        
//        for view in customCell.subviews {
//            if(view.description.lowercased().contains("reorder")){
//                print(view)
//                view.superview?.backgroundColor = colorDeepBackground
//            }
//        }
        
        if(userSetting.isThemeBright){
            customCell.editField.keyboardAppearance = .light
        }
        else{
            customCell.editField.keyboardAppearance = .dark
        }
        
        customCell.editField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])

        return customCell
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }

}
class GoalsEditTableCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
//            return "목표 설정 안 함"
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
            editField.text = "목표 설정 안 함"
        }
        else{
            delegate?.tableManipulateValue(self, enable: true, value: pickerList[currentRow][picker.selectedRow(inComponent: 0)])
            switch currentRow{
            case 0:
                editField.text = "\((pickerList[0])[row])일"
            case 1:
                editField.text = "연속 \((pickerList[1])[row])일"
            case 2:
                editField.text = "\((pickerList[2])[row])원"
            case 3:
                editField.text = "\((pickerList[3])[row])kcal"
            default:
                editField.text = "Not Accepted Switch Value"
            }
        }
    }
    let numDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
    let month = Calendar.current.component(.month, from: Date())
    
    var delegate: GoalsEditTableDelegate?
    var currentRow: Int = 0
    
    @IBOutlet weak var editField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func labelEditBegan(_ sender: UITextField) {
        let tempValue: Int = goals[currentRow].value
        if(goals[currentRow].checked){
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
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = colorLightBackground
        
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
        
        editField.inputView = picker
        
        editField.textColor = colorPoint
        editField.tintColor = colorText
    }
}
