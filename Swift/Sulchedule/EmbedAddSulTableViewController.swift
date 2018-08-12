import UIKit
import AudioToolbox.AudioServices


extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: NSIndexPath(row: row - 1, section: section - 1) as IndexPath, at: .bottom, animated: animated)
            }
        }
    }
}

class EmbedAddSulTableViewController: UITableViewController {
    
    var i = 0
    var matchingPairs: [Int: Int] = [:]
    func reload(){
        i = 0
        matchingPairs = [:]
        backgroundView.reloadData()
        backgroundView.scrollToBottom()
    }

    @IBOutlet var backgroundView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.backgroundColor = colorLightBackground
        backgroundView.reloadData()
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(isBrightTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getUserSul().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSulIdentifier", for: indexPath)
        
        guard let customCell = cell as? EmbedAddSulTableViewCell else{
            return cell
        }
        
        while(true){
            if userData.newSul[i].enabled {
                customCell.titleLabel.text = userData.newSul[i].displayName
                customCell.valueLabel.text = "\(userData.newSul[i].basePrice)\(userData.newSul[i].unit), \(userData.newSul[i].baseCalorie)kcal"
                matchingPairsㅋ([i:indexPath.row])
                i += 1
                break
            }
            i += 1
        }
//        customCell.titleLabel.text = (getUserSul())[indexPath.row].displayName
//        customCell.valueLabel.text = "\((getUserSul())[indexPath.row].basePrice)\((getUserSul())[indexPath.row].unit), \((getUserSul())[indexPath.row].baseCalorie)kcal"
        customCell.backgroundColor = colorLightBackground
        
        if(isBrightTheme){
            customCell.valueLabel.textColor = .gray
            customCell.titleLabel.textColor = .black
        }
        else{
            customCell.valueLabel.textColor = colorGray
            customCell.titleLabel.textColor = .white
        }
        
//        for view in customCell.subviews {
//            if(view.description.lowercased().contains("reorder")){
//                print(view)
//                view.superview?.backgroundColor = colorLightBackground
//            }
//        }
        
        return customCell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            userData.newSul.remove(at: indexPath.row)
//            let originalSulCount = sul.count - userData.newSul.count
//            setRecordDayForSul(day: selectedDay, index: indexPath.row + originalSulCount - 1, bottles: 0)
//            해당 인덱스에 대한 모든 날의 기록을 삭제하는 메소드가 필요!
//            removeSulFromEveryRecordDay(index: indexPath.row + originalSulCount - 1)
            
            setSulDisabled(index: i)
            
            print(getUserSul().count)
            tableView.deleteRows(at: [indexPath], with: .fade)
            backgroundView.reloadData()
        }
    }
 
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        if(isVibrationOn){
//            AudioServicesPlaySystemSound(vibPeek)
//        }
//        let v = arr[fromIndexPath.row]
//        let order = goalOrder[fromIndexPath.row]
//        arr.remove(at: fromIndexPath.row)
//        goalOrder.remove(at: fromIndexPath.row)
//        arr.insert(v, at: to.row)
//        goalOrder.insert(order, at: to.row)
//        print(goalOrder)
//    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class EmbedAddSulTableViewCell: UITableViewCell {
    
    //valueLabel:"??원, ??칼로리"
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

