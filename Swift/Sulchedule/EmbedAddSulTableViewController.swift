import UIKit
import AudioToolbox.AudioServices

struct SulSulSUl{
    var name: String
    var calorie: Int
    var price: Int
}

class EmbedAddSulTableViewController: UITableViewController {
    
    var arr: [SulSulSUl] = [SulSulSUl(name: "First Dummy", calorie: 1, price: 1000), SulSulSUl(name: "Second Dummy", calorie: 2, price: 1500), SulSulSUl(name: "Third Dummy", calorie: 3, price: 2000)]

    @IBOutlet var backgroundView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmbedAddSulTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.backgroundColor = colorDeepBackground
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
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addSulIdentifier", for: indexPath)
        
        guard let customCell = cell as? EmbedAddSulTableViewCell else{
            return cell
        }
        
        customCell.valueLabel.text = "Dummy Value"
        customCell.titleLabel.text = "Dummy Title"
        customCell.backgroundColor = colorDeepBackground
        
        if(isBrightTheme){
            customCell.valueLabel.textColor = .gray
            customCell.titleLabel.textColor = .black
        }
        else{
            customCell.valueLabel.textColor = colorGray
            customCell.titleLabel.textColor = .white
        }
        
        for view in customCell.subviews {
            if(view.description.lowercased().contains("reorder")){
                print(view)
                view.superview?.backgroundColor = colorDeepBackground
            }
        }
        
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
            // Delete the row from the data source
            print("delete method")
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        if(isVibrationOn){
            AudioServicesPlaySystemSound(peek)
        }
        let v = arr[fromIndexPath.row]
//        let order = goalOrder[fromIndexPath.row]
        arr.remove(at: fromIndexPath.row)
//        goalOrder.remove(at: fromIndexPath.row)
        arr.insert(v, at: to.row)
//        goalOrder.insert(order, at: to.row)
//        print(goalOrder)
    }
    
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

