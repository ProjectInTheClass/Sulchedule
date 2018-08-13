import UIKit

class EmbedStatsTableViewController: UITableViewController {
    var showWeekly = false
    var tableValues: [String] = []
    var tableTitles: [String] = []
    var month = dateToMonthConverter(date: Date())
    func showWeeklyFunc(showWeekly: Bool){
        tableValues = []
        tableTitles = []
        if(showWeekly){
            tableTitles.append("총 지출액")
            tableTitles.append("총 열량")
            tableValues.append("\(getWeeklyExpense())원")
            tableValues.append("\(getWeeklyCalorie())kcal")
            
            if(getWeeklySul().count > 1){
                var cnt = 0
                var i = -1
                let currentDictionary = getWeeklySul()
                var valueArr:[Int] = []
                var indexArr:[Int] = []
                while(cnt < currentDictionary.count){
                    i += 1
                    if(currentDictionary[i] != nil){
                        valueArr.append(currentDictionary[i]!)
                        indexArr.append(i)
                        cnt += 1
                    }
                }
                let count = valueArr.count - 1
                for i in 0...count{
                    for j in 0...count{
                        if(valueArr[i]>valueArr[j]){
                            let temp = valueArr[i]
                            valueArr[i] = valueArr[j]
                            valueArr[j] = temp
                            let temp2 = indexArr[i]
                            indexArr[i] = indexArr[j]
                            indexArr[j] = temp2
                        }
                    }
                }
                
                for i in 0...count {
                    tableTitles.append(sul[indexArr[i]].displayName)
                    tableValues.append("\(valueArr[i])\(getSulUnit(index: indexArr[i]))")
                }
            }
            else{
                for item in getWeeklySul() {
                    tableTitles.append(sul[item.key].displayName)
                    tableValues.append("\(item.value)\(getSulUnit(index: item.key))")
                }
            }
            
            if(getWeeklyFriend().count > 1){
                var cnt = 0
                var i = -1
                let currentDictionary = getWeeklyFriend()
                var valueArr:[Int] = []
                var nameArr:[String] = []
                for item in currentDictionary{
                    nameArr.append(item.key)
                    valueArr.append(item.value)
                }
                let count = valueArr.count - 1
                for i in 0...count{
                    for j in 0...count{
                        if(valueArr[i]>valueArr[j]){
                            let temp = valueArr[i]
                            valueArr[i] = valueArr[j]
                            valueArr[j] = temp
                            let temp2 = nameArr[i]
                            nameArr[i] = nameArr[j]
                            nameArr[j] = temp2
                        }
                    }
                }
                
                for i in 0...count {
                    tableTitles.append(nameArr[i])
                    tableValues.append("\(valueArr[i])회 합석")
                }
            }
            else{
                for item in getWeeklyFriend() {
                    tableTitles.append(item.key)
                    tableValues.append("\(item.value)회 합석")
                }
            }

            if(getWeeklyLocation().count > 1){
                var cnt = 0
                var i = -1
                let currentDictionary = getWeeklyLocation()
                var valueArr:[Int] = []
                var locArr:[String] = []
                for item in currentDictionary{
                    locArr.append(item.key)
                    valueArr.append(item.value)
                }
                let count = valueArr.count - 1
                for i in 0...count{
                    for j in 0...count{
                        if(valueArr[i]>valueArr[j]){
                            let temp = valueArr[i]
                            valueArr[i] = valueArr[j]
                            valueArr[j] = temp
                            let temp2 = locArr[i]
                            locArr[i] = locArr[j]
                            locArr[j] = temp2
                        }
                    }
                }
                
                for i in 0...count {
                    tableTitles.append(locArr[i])
                    tableValues.append("\(valueArr[i])회 방문")
                }
            }
            else{
                for item in getWeeklyLocation() {
                    tableTitles.append(item.key)
                    tableValues.append("\(item.value)회 방문")
                }
            }
            

        }
        else{
            tableTitles.append("총 지출액")
            tableTitles.append("총 열량")
            tableValues.append("\(getRecordMonthExpense(month: month)!)원")
            tableValues.append("\(getRecordMonthCalorie(month: month)!)kcal")

            for item in getRecordMonthAllSul(month: month)! {
                tableTitles.append(sul[Array(item.keys)[0]].displayName)
                tableValues.append("\((item[Array(item.keys)[0]]!)[2]!)\(getSulUnit(index: Array(item.keys)[0]))")
            }
            
            for item in getRecordMonthAllFriends(month: month)! {
                tableTitles.append(Array(item!.keys)[0])
                tableValues.append("\(item![Array(item!.keys)[0]]!)회 합석")
            }
            
            for item in getRecordMonthAllLocation(month: month)! {
                tableTitles.append(Array(item.keys)[0])
                tableValues.append("\(item[Array(item.keys)[0]]!)회 방문")
            }
        }
        backgroundView.reloadData()
    }

    @IBOutlet var backgroundView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        showWeeklyFunc(showWeekly: showWeekly)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.backgroundColor = colorDeepBackground
        showWeeklyFunc(showWeekly: showWeekly)
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(userData.isThemeBright){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "embedStatsIdentifier", for: indexPath)

        guard let customCell = cell as? EmbedStatsTableViewCell else{
            return cell
        }
        
        customCell.valueLabel.text = tableValues[indexPath.row]
        customCell.titleLabel.text = tableTitles[indexPath.row]
        
        customCell.backgroundColor = colorDeepBackground
        if(userData.isThemeBright){
            customCell.valueLabel.textColor = .black
            customCell.titleLabel.textColor = .gray
        }
        else{
            customCell.valueLabel.textColor = .white
            customCell.titleLabel.textColor = colorGray
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

class EmbedStatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(userData.isThemeBright){
            titleLabel.textColor = .gray
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

