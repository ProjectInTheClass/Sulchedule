//table view input
import UIKit
import AudioToolbox.AudioServices

protocol GoalsEditTableDelegate {
    func tableManipulateSwitch(_ sender: GoalsEditTableCell)
    func tableManipulateValue(_ sender: GoalsEditTableCell)
}

struct UserGoalOrder{
    var name: String
    var checked: Bool
    var value: Int
}
var goals: [UserGoalOrder] = [UserGoalOrder(name: "First Dummy", checked: false, value: 1000), UserGoalOrder(name: "Second Dummy", checked: true, value: 1500), UserGoalOrder(name: "Third Dummy", checked: false, value: 2000)]

var goalOrder = [0,1,2,3]

class GoalsEditTableViewController: UITableViewController, GoalsEditTableDelegate {
    
    @IBOutlet var backgroundView: UITableView!
    
    func tableManipulateSwitch(_ sender: GoalsEditTableCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        goals[indexPath.row].checked.toggle()
        sender.uiSwitch.setOn(goals[indexPath.row].checked, animated: true)
    }
    
    func tableManipulateValue(_ sender: GoalsEditTableCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
//        apply to array here
        let k: NSString = sender.editField.text! as NSString
        goals[indexPath.row].value = Int(k.integerValue)
        tableView.reloadData()
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
        if(isBrightTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
        backgroundView.reloadData()
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
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.tintColor = colorDeepBackground
        customCell.backgroundColor = colorDeepBackground
        
        for view in customCell.subviews {
            if(view.description.lowercased().contains("reorder")){
                print(view)
                view.superview?.backgroundColor = colorDeepBackground
            }
        }
        
        if(isBrightTheme){
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
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if(isVibrationOn){
            AudioServicesPlaySystemSound(vibPeek)
        }
        let v = goals[fromIndexPath.row]
        let order = goalOrder[fromIndexPath.row]
        goals.remove(at: fromIndexPath.row)
        goalOrder.remove(at: fromIndexPath.row)
        goals.insert(v, at: to.row)
        goalOrder.insert(order, at: to.row)
        print(goalOrder)
    }
    
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
        if(isVibrationOn){
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
        
        if(isBrightTheme){
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
