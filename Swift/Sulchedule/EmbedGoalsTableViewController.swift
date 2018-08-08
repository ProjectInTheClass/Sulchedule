import UIKit

class EmbedGoalsTableViewController: UITableViewController {

    @IBOutlet var backgroundView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = colorDeepBackground
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "embedGoalsIdentifier", for: indexPath)

        guard let customCell = cell as? EmbedGoalsTableCell else{
            return cell
        }
        
        customCell.leftTitleLabel.text = "Dummy Data"
        customCell.leftValueLabel.text = "100000원"
        customCell.rightValueLabel.text = String(110000)
        customCell.contentView.backgroundColor = colorDeepBackground

        return customCell
    }

    
    
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
// 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

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
class EmbedGoalsTableCell: UITableViewCell {
    
    @IBOutlet var bgGraph: UIView!
    @IBOutlet weak var leftValueLabel: UILabel!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightValueLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    @IBOutlet weak var graphWidth: NSLayoutConstraint!
    @IBOutlet weak var actualGraph: UIView!
    
    func drawRect(color: String, value: Float)
    {
        bgGraph.layer.cornerRadius = bgGraph.bounds.height/2
        actualGraph.layer.cornerRadius = bgGraph.bounds.height/2
        bgGraph.layer.backgroundColor = colorLightBackground.cgColor
        graphWidth.constant = CGFloat(value * Float(bgGraph.bounds.width))
        if(color == "green"){
            actualGraph.layer.backgroundColor = colorGreen.cgColor
        }
        else if(color == "yellow"){
            actualGraph.layer.backgroundColor = colorYellow.cgColor
        }
        else{
            actualGraph.layer.backgroundColor = colorRed.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        drawRect(color: "red", value: 0.55)
        leftTitleLabel.textColor = .gray
        rightTitleLabel.textColor = .gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

