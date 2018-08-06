import UIKit
import AudioToolbox.AudioServices

protocol GoalsEditTableDelegate {
    func tableManipulate(_ sender: GoalsEditTableCell)
}

struct UserGoalOrder{
    var name: String
    var checked: Bool
    var value: Int
}
var goals: [UserGoalOrder] = [UserGoalOrder(name: "First Dummy", checked: false, value: 1000), UserGoalOrder(name: "Second Dummy", checked: true, value: 1500), UserGoalOrder(name: "Third Dummy", checked: false, value: 2000)]

class GoalsEditTableViewController: UITableViewController, GoalsEditTableDelegate {
    
    func tableManipulate(_ sender: GoalsEditTableCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        goals[indexPath.row].checked.toggle()
        sender.uiSwitch.setOn(goals[indexPath.row].checked, animated: true)
    }
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "FFDC67")
        formatter.dateFormat = "M월 목표 수정"
        self.navigationItem.title = formatter.string(from: Date())
        self.tableView.isEditing = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GoalsEditTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        AudioServicesPlaySystemSound(peek)
        let v = goals[fromIndexPath.row]
        goals.remove(at: fromIndexPath.row)
        goals.insert(v, at: to.row)
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class GoalsEditTableCell: UITableViewCell {
    
    var delegate: GoalsEditTableDelegate?
    
    @IBOutlet weak var editField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    @IBAction func switchChanged(_ sender: UISwitch) {
        delegate?.tableManipulate(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: hexStringToUIColor(hex: "#FFDC67")])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
