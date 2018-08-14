//table view input
import UIKit
import AudioToolbox.AudioServices

protocol GoalsEditTableDelegate {
    func tableManipulateSwitch(_ sender: GoalsEditTableCell)
    func tableManipulateValue(_ sender: GoalsEditTableCell)
}

struct UserGoal{
    var name: String
    var checked: Bool
    var value: Int
}
var goals: [UserGoal] = []

class GoalsEditTableViewController: UITableViewController, GoalsEditTableDelegate {
    
    
    @IBOutlet var backgroundView: UITableView!
    
    func reload(){
        goals = [
            UserGoal(name: "음주 일수", checked: isDaysOfMonthEnabled(month: monthmonth), value: getDaysOfMonthLimit(month: monthmonth)!),
            UserGoal(name: "연이어 음주한 일수", checked: isStreakOfMonthEnabled(month: monthmonth), value: getStreakOfMonthLimit(month: monthmonth)!),
            UserGoal(name: "총 지출액", checked: isCurrentExpenseEnabled(month: monthmonth), value: getCurrentExpenseLimit(month: monthmonth)!),
            UserGoal(name: "총 열량", checked: isCaloriesOfMonthEnabled(month: monthmonth), value: getCaloriesOfMonthLimit(month: monthmonth)!)
        ]
        
        backgroundView.reloadData()
    }
    
    func tableManipulateSwitch(_ sender: GoalsEditTableCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        switch indexPath.row {
        case 0:
            setDaysOfMonthEnabled(enabled: sender.uiSwitch.isOn)
        case 1:
            setStreakOfMonthEnabled(enabled: sender.uiSwitch.isOn)
        case 2:
            setCurrentExpenseEnabled(enabled: sender.uiSwitch.isOn)
        case 3:
            setCaloriesOfMonthEnabled(enabled: sender.uiSwitch.isOn)
        default:
            print("wtf")
        }
    }
    
    func tableManipulateValue(_ sender: GoalsEditTableCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
//        apply to array here
        let temp = Int((sender.editField.text! as NSString).integerValue)
        switch indexPath.row {
        case 0:
            setDaysOfMonthLimit(month: dateToMonthConverter(date: Date()), value: temp)
            if(temp != 0){
                setDaysOfMonthEnabled(enabled: true)
                sender.uiSwitch.setOn(true, animated: true)
            }
        case 1:
            setStreakOfMonthLimit(month: dateToMonthConverter(date: Date()), value: temp)
            if(temp != 0){
                setStreakOfMonthEnabled(enabled: true)
                sender.uiSwitch.setOn(true, animated: true)
            }
        case 2:
            setCurrentExpenseLimit(month: dateToMonthConverter(date: Date()), value: temp)
            if(temp != 0){
                setCurrentExpenseEnabled(enabled: true)
                sender.uiSwitch.setOn(true, animated: true)
            }
        case 3:
            setCaloriesOfMonthLimit(month: dateToMonthConverter(date: Date()), value: temp)
            if(temp != 0){
                setCaloriesOfMonthEnabled(enabled: true)
                sender.uiSwitch.setOn(true, animated: true)
            }
        default:
            print("wtf")
        }
        
        let numDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
        let month = Calendar.current.component(.month, from: Date())
        
        goals = [
            UserGoal(name: "음주 일수", checked: isDaysOfMonthEnabled(month: monthmonth), value: getDaysOfMonthLimit(month: monthmonth)!),
            UserGoal(name: "연이어 음주한 일수", checked: isStreakOfMonthEnabled(month: monthmonth), value: getStreakOfMonthLimit(month: monthmonth)!),
            UserGoal(name: "총 지출액", checked: isCurrentExpenseEnabled(month: monthmonth), value: getCurrentExpenseLimit(month: monthmonth)!),
            UserGoal(name: "총 열량", checked: isCaloriesOfMonthEnabled(month: monthmonth), value: getCaloriesOfMonthLimit(month: monthmonth)!)
        ]
        
        if(indexPath.row == 0 && goals[indexPath.row].value > numDays){
            let alertController = UIAlertController(title: "며칠이라고요?", message: "\(month)월의 말일은 \(numDays)일입니다.\n입력하신 수가 이번 달의 날수보다 큽니다.", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                sender.editField.text = String(numDays)
                setDaysOfMonthLimit(month: monthmonth, value: numDays)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else if(indexPath.row == 1 && goals[indexPath.row].value > numDays){
            let alertController = UIAlertController(title: "며칠이라고요?", message: "\(month)월의 말일은 \(numDays)일입니다.\n입력하신 수가 이번 달의 날수보다 큽니다.", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                sender.editField.text = String(numDays)
                setStreakOfMonthLimit(month: monthmonth, value: numDays)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        formatter.dateFormat = "M월 목표 수정"
        self.navigationItem.title = formatter.string(from: Date())
        self.tableView.isEditing = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GoalsEditTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        backgroundView.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(userSetting.isThemeBright){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }

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
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsEditIdentifier", for: indexPath)
        
        guard let customCell = cell as? GoalsEditTableCell else {
            return cell
        }

        customCell.titleLabel.text = "\(goals[indexPath.row].name)"
        customCell.delegate = self
        customCell.uiSwitch.setOn(goals[indexPath.row].checked, animated: false)
        customCell.editField.text = String(goals[indexPath.row].value)

        
        let numDays = Calendar.current.range(of: .day, in: .month, for: Date())!.count
        let month = Calendar.current.component(.month, from: Date())
        
        if(goals[indexPath.row].value == 0){
            customCell.editField.text = ""
        }
//        else if(indexPath.row == 0 && goals[indexPath.row].value > numDays){
//            let alertController = UIAlertController(title: "며칠이라고요?", message: "\(month)월의 말일은 \(numDays)일입니다.\n입력하신 수가 이번 달의 날수보다 큽니다.", preferredStyle: UIAlertControllerStyle.alert)
//            let cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//                customCell.editField.text = String(numDays)
//                setDaysOfMonthLimit(month: monthmonth, value: numDays)
//            }
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        else if(indexPath.row == 1 && goals[indexPath.row].value > numDays){
//            let alertController = UIAlertController(title: "며칠이라고요?", message: "\(month)월의 말일은 \(numDays)일입니다.\n입력하신 수가 이번 달의 날수보다 큽니다.", preferredStyle: UIAlertControllerStyle.alert)
//            let cancelAction = UIAlertAction(title: "닫기", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//                customCell.editField.text = String(numDays)
//                setStreakOfMonthLimit(month: monthmonth, value: numDays)
//            }
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//        else{
//            customCell.editField.text = String(goals[indexPath.row].value)
//            customCell.uiSwitch.setOn(true, animated: true)
//            switch indexPath.row {
//            case 0:
//                setDaysOfMonthLimit(month: dateToMonthConverter(date: Date()), value: Int(customCell.editField!.text!)!)
//                setDaysOfMonthEnabled(enabled: true)
//            case 1:
//                setStreakOfMonthLimit(month: dateToMonthConverter(date: Date()), value: Int(customCell.editField!.text!)!)
//                setStreakOfMonthEnabled(enabled: true)
//            case 2:
//                setCurrentExpenseLimit(month: dateToMonthConverter(date: Date()), value: Int(customCell.editField!.text!)!)
//                setCurrentExpenseEnabled(enabled: true)
//            case 3:
//                setCaloriesOfMonthLimit(month: dateToMonthConverter(date: Date()), value: Int(customCell.editField!.text!)!)
//                setCaloriesOfMonthEnabled(enabled: true)
//            default:
//                print("wtf")
//            }
//        }
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.tintColor = colorDeepBackground
        customCell.backgroundColor = colorDeepBackground
        
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        if(userSetting.isVibrationEnabled){
//            AudioServicesPlaySystemSound(vibPeek)
//        }
//        let v = goals[fromIndexPath.row]
//        let order = goalOrder[fromIndexPath.row]
//        goals.remove(at: fromIndexPath.row)
//        goalOrder.remove(at: fromIndexPath.row)
//        goals.insert(v, at: to.row)
//        goalOrder.insert(order, at: to.row)
//        print(goalOrder)
//    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }

}
class GoalsEditTableCell: UITableViewCell {
    
    var delegate: GoalsEditTableDelegate?
    
    @IBOutlet weak var editField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func labelEditEnded(_ sender: UITextField) {
        delegate?.tableManipulateValue(self)
    }
    @IBOutlet weak var uiSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        delegate?.tableManipulateSwitch(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        uiSwitch.tintColor = colorPoint
        uiSwitch.thumbTintColor = colorLightBackground
        uiSwitch.onTintColor = colorPoint
        editField.textColor = colorPoint
        
        if(userSetting.isThemeBright){
            editField.tintColor = .black
        }
        else{
            editField.tintColor = .white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
