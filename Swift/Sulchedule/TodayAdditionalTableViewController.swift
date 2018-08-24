//table view input
import UIKit
import AudioToolbox.AudioServices

var star: UIImage?
var star_empty: UIImage?

protocol TodayAdditionalTableDelegate{
    func tableManipulate(_ sender: TodayAdditionalTableViewCell)
    func starManipulate(_ sender: TodayAdditionalTableViewCell)
}

class TodayAdditionalTableViewController: UITableViewController, TodayAdditionalTableDelegate, UISearchBarDelegate {
    func starManipulate(_ sender: TodayAdditionalTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let index = indexPath.row
        if userSetting.favorites.contains(filteredIndexArray[index]){
            setFavouriteSul(index: filteredIndexArray[index], set: false)
            sender.starButtonOutlet.setImage(star_empty!, for: UIControlState())
            snackBar(string: "즐겨찾기가 해제되었습니다.", buttonPlaced: true)
        }
        else{
            setFavouriteSul(index: filteredIndexArray[index], set: true)
            sender.starButtonOutlet.setImage(star!, for: UIControlState())
            snackBar(string: "즐겨찾기로 설정되었습니다.", buttonPlaced: true)
        }
        
    }
    
    
    func tableManipulate(_ sender: TodayAdditionalTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let index = indexPath.row

        setRecordDayForSul(day: selectedDay, index: filteredIndexArray[index], bottles: Int(sender.bottleStepper.value))
    }
    
    var actualIndexArray: [Int] = []
    var sulArray: [Sul] = []
    var currentDictionary: [Int: Sul] = [:]
    func loadArray(){
        //adds sul and userSul into currentDictionary
        //than puts each into sulArray and actualIndexArray
        sulArray = []
        actualIndexArray = []
        currentDictionary = getSulDictionary()
        filteredSulArray = []
        filteredIndexArray = []
        
        var cnt = 0
        var i = -1
        while(cnt < currentDictionary.count){
            i += 1
            if(currentDictionary[i] != nil){
                sulArray.append(currentDictionary[i]!)
                actualIndexArray.append(i)
                cnt += 1
            }
        }
    }
    
    var filteredSulArray: [Sul] = []
    var filteredIndexArray: [Int] = []

    let star_yellow = UIImage(named: "star")
    let star_yellow_empty = UIImage(named: "star_empty")
    let star_blue = UIImage(named: "star_blue")
    let star_blue_empty = UIImage(named: "star_blue_empty")
    
    @IBOutlet weak var searchBackground: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var backgroundView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty){
            filteredIndexArray = actualIndexArray
        }
        else{
            filteredIndexArray = actualIndexArray.filter({(index : Int) -> Bool in
                return sul[index].displayName.lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "직접 추가", style: .done, target: self, action: #selector(loadAddSul))
        
        searchBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        loadArray()
        filteredIndexArray = actualIndexArray
        
        searchBar.text = ""
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = colorLightBackground
        textFieldInsideSearchBar?.textColor = colorText
        textFieldInsideSearchBar?.tintColor = colorPoint
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = colorPoint
        
        searchBar.barTintColor = colorDeepBackground
        searchBackground.backgroundColor = colorDeepBackground
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = colorDeepBackground.cgColor
        
        self.navigationController?.navigationBar.tintColor = colorPoint
        backgroundView.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.backgroundColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colorText]
        textFieldInsideSearchBar?.textColor = colorText
        
        if(userSetting.isThemeBright){
            star = star_blue!
            star_empty = star_blue_empty!
            searchBar.keyboardAppearance = .light
        }
        else{
            star = star_yellow!
            star_empty = star_yellow_empty!
            searchBar.keyboardAppearance = .dark
        }
        backgroundView.reloadData()
        
    }
    
    @objc func loadAddSul(){
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addSul") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredIndexArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayAdditionalIdentifier", for: indexPath)

        guard let customCell = cell as? TodayAdditionalTableViewCell else{
            return cell
        }
        
        customCell.bottleLabel.textColor = colorText
        customCell.titleLabel.textColor = colorGray
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bottleStepper.tintColor = colorPoint
        customCell.colorTag.backgroundColor = .clear
        

        customCell.bottleStepper.value = Double(getRecordDayBottles(day: selectedDay, index: filteredIndexArray[indexPath.row]) ?? 0)
        customCell.bottleLabel.text = "\(Int(customCell.bottleStepper.value))\(getSulUnit(index: filteredIndexArray[indexPath.row]))"
        customCell.titleLabel.text = sul[filteredIndexArray[indexPath.row]].displayName
        
        if userSetting.favorites.contains(filteredIndexArray[indexPath.row]){
            customCell.starButtonOutlet.setImage(star!, for: UIControlState())
        }
        else{
            customCell.starButtonOutlet.setImage(star_empty!, for: UIControlState())
        }
        
        customCell.delegate = self
        
        return customCell
    }

}

class TodayAdditionalTableViewCell: UITableViewCell {
    
    var delegate: TodayAdditionalTableDelegate?
    
    @IBOutlet weak var starButtonOutlet: UIButton!
    
    @IBAction func starOnTap(_ sender: UIButton) {
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        delegate?.starManipulate(self)
    }
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var bottleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottleStepper: UIStepper!
    @IBAction func bottleStepper(_ sender: UIStepper) {
        bottleLabel.text = "\(Int(bottleStepper.value))\(getSulUnit(index: getSulIndexByName(sulName: titleLabel.text!)!))"
        delegate?.tableManipulate(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(userSetting.isThemeBright){
            bottleStepper.tintColor = colorPoint
            bottleLabel.textColor = colorText
            titleLabel.textColor = colorGray
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
