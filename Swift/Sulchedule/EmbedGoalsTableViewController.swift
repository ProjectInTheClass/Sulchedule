import UIKit

var goalViewDelegate: CycleBorderDelegate?

class EmbedGoalsTableViewController: UITableViewController {
    
    var goalValue: [Float] = []
    var goalLimit: [Int] = []
    var goalStat: [Int] = []
    var isEnabled: [Int] = []
    
    
    
//    var isLastMonth: Int = -1

    @IBOutlet var backgroundView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        goalValue = []
        goalLimit = []
        goalStat = []
        isEnabled = []
        
        for i in 0...3{
            switch i {
            case 0 :
                if(isDaysOfMonthEnabled(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))){
                    isEnabled.append(i)
                    goalStat.append(getDaysOfMonthStatus(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)))
                    goalLimit.append(getDaysOfMonthLimit(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))!)
                    goalValue.append(Float(goalStat[i]) / Float(goalLimit[i]))
                }
            case 1 :
                if(isStreakOfMonthEnabled(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))){
                    isEnabled.append(i)
                    goalStat.append(getStreakOfMonthStatus(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)))
                    goalLimit.append(getStreakOfMonthLimit(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))!)
                    goalValue.append(Float(goalStat[i]) / Float(goalLimit[i]))
                }
            case 2 :
                if(isCurrentExpenseEnabled(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))){
                    isEnabled.append(i)
                    goalStat.append(getCurrentExpenseStatus(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)))
                    goalLimit.append(getCurrentExpenseLimit(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))!)
                    goalValue.append(Float(goalStat[i]) / Float(goalLimit[i]))
                }
            case 3 :
                if(isCaloriesOfMonthEnabled(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))){
                    isEnabled.append(i)
                    goalStat.append(getCaloriesOfMonthStatus(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)))
                    goalLimit.append(getCaloriesOfMonthLimit(month: dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!))!)
                    goalValue.append(Float(goalStat[i]) / Float(goalLimit[i]))
                }
            default :
                print("wtf")
            }
        }
        var dangerLevel = 0
        for item in goalValue {
            if(item > 0.8){
                dangerLevel = 1
            }
            if(item > 1){
                dangerLevel = 2
            }
        }
        goalViewDelegate?.manipulateCircle(value: dangerLevel)
        
        backgroundView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isEnabled.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "embedGoalsIdentifier", for: indexPath)

        guard let customCell = cell as? EmbedGoalsTableCell else{
            return cell
        }
        
        switch (isEnabled[indexPath.row]){
        case 0:
            customCell.leftTitleLabel.text = "음주 일수"
            customCell.leftValueLabel.text = "\(String(goalStat[indexPath.row]))일"
            customCell.rightValueLabel.text = String(goalLimit[indexPath.row])
            customCell.setGraphValue(value: goalValue[indexPath.row])
        case 1:
            customCell.leftTitleLabel.text = "연이어 음주한 일수"
            customCell.leftValueLabel.text = "\(String(goalStat[indexPath.row]))일"
            customCell.rightValueLabel.text = String(goalLimit[indexPath.row])
            customCell.setGraphValue(value: goalValue[indexPath.row])
        case 2:
            customCell.leftTitleLabel.text = "총 지출액"
            customCell.leftValueLabel.text = "\(String(goalStat[indexPath.row]))원"
            customCell.rightValueLabel.text = String(goalLimit[indexPath.row])
            customCell.setGraphValue(value: goalValue[indexPath.row])
        case 3:
            customCell.leftTitleLabel.text = "총 열량"
            customCell.leftValueLabel.text = "\(String(goalStat[indexPath.row]))kcal"
            customCell.rightValueLabel.text = String(goalLimit[indexPath.row])
            customCell.setGraphValue(value: goalValue[indexPath.row])
        default:
            print("wtf")
            
        }
        
        if(isBrightTheme){
            customCell.leftValueLabel.textColor = .black
            customCell.rightValueLabel.textColor = .black
            customCell.leftTitleLabel.textColor = .gray
            customCell.rightTitleLabel.textColor = .gray
        }
        else{
            customCell.leftValueLabel.textColor = .white
            customCell.rightValueLabel.textColor = .white
            customCell.leftTitleLabel.textColor = colorGray
            customCell.rightTitleLabel.textColor = colorGray
        }
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bgGraph.layer.backgroundColor = colorLightBackground.cgColor
        
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
    func setGraphValue(value: Float){
        if(0 <= value && value < 0.7){
            drawRect(color: colorGreen, value: value)
        }
        else if(value < 1){
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

