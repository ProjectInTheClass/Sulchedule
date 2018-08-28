import UIKit
import AudioToolbox.AudioServices




class EmbedAddSulTableViewController: UITableViewController {
    
    var sulArray: [Sul] = []
    var actualIndexArray: [Int] = []
    var hook: [Sul] = []
    
    func reload(){
        backgroundView.reloadData()
        backgroundView.scrollToBottom()
    }
    func loadArray(){
        hook = userSetting.newSul
        
        sulArray = []
        actualIndexArray = []
        let currentDictionary: [Int: Sul] = getUserSulDictionary()
        var cnt = 0
        var i = -1
        while(cnt < getUserSulDictionary().count){
            i += 1
            if(currentDictionary[i] != nil){
                sulArray.append(currentDictionary[i]!)
                actualIndexArray.append(i)
                cnt += 1
            }
        }
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
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        loadArray()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getUserSulDictionary().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSulIdentifier", for: indexPath)
        
        guard let customCell = cell as? EmbedAddSulTableViewCell else{
            return cell
        }
        
        customCell.titleLabel.text = sulArray[indexPath.row].displayName
        customCell.valueLabel.text = "\(sulArray[indexPath.row].unit)당 \(sulArray[indexPath.row].basePrice)원, \(sulArray[indexPath.row].baseCalorie)kcal"
        
        
        customCell.backgroundColor = colorLightBackground
        customCell.valueLabel.textColor = colorGray
        customCell.titleLabel.textColor = colorText
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
            let alertController = UIAlertController(title: "삭제할까요?", message: "\(userSetting.newSul[self.actualIndexArray[indexPath.row]].displayName)로 추가된 칼로리와 지출액은 사라지지 않습니다.", preferredStyle: UIAlertControllerStyle.alert)
            let deleteAction = UIAlertAction(title: "삭제", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
                setSulDisabled(index: self.actualIndexArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.loadArray()
            }
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.default)
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
 
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        if(userSetting.isVibrationEnabled){
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
}

