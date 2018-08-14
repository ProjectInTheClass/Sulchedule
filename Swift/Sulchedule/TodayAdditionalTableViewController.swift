//table view input
import UIKit
import AudioToolbox.AudioServices

var star: UIImage?
var star_empty: UIImage?

protocol TodayAdditionalTableDelegate{
    func tableManipulate(_ sender: TodayAdditionalTableViewCell)
    func starManipulate(_ sender: TodayAdditionalTableViewCell, bool: Bool)
}

class TodayAdditionalTableViewController: UITableViewController, TodayAdditionalTableDelegate {
    func starManipulate(_ sender: TodayAdditionalTableViewCell, bool: Bool) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let index = indexPath.row
        setFavouriteSul(index: actualIndexArray[index], set: bool)
    }
    
    
    func tableManipulate(_ sender: TodayAdditionalTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let index = indexPath.row
        setRecordDayForSul(day: selectedDay, index: actualIndexArray[index], bottles: Int(sender.bottleStepper.value))
    }
    
    var actualIndexArray: [Int] = []
    var sulArray: [Sul] = []
    var currentDictionary: [Int: Sul] = [:]
    func loadArray(){
        //adds sul and userSul into currentDictionary
        //than puts each into sulArray and actualIndexArray
        sulArray = []
        actualIndexArray = []
        currentDictionary = [:]
        currentDictionary = getSulDictionary()
//        getSulDictionary().forEach { (k,v) in currentDictionary[k] = v }
//        getUserSulDictionary().forEach { (k,v) in currentDictionary[k + getSulDictionary().count] = v }
        
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

    let star_yellow = UIImage(named: "star")
    let star_yellow_empty = UIImage(named: "star_empty")
    let star_blue = UIImage(named: "star_blue")
    let star_blue_empty = UIImage(named: "star_blue_empty")

    @IBOutlet var backgroundView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "직접 추가", style: .done, target: self, action: #selector(loadAddSul))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        backgroundView.backgroundColor = colorDeepBackground
        self.tabBarController?.tabBar.backgroundColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(userSetting.isThemeBright){
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
            star = star_blue!
            star_empty = star_blue_empty!
        }
        else{
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            star = star_yellow!
            star_empty = star_yellow_empty!

        }
        loadArray()
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
        return currentDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayAdditionalIdentifier", for: indexPath)

        guard let customCell = cell as? TodayAdditionalTableViewCell else{
            return cell
        }
        
        customCell.bottleStepper.value = Double(getRecordDayBottles(day: selectedDay, index: actualIndexArray[indexPath.row]) ?? 0)
        customCell.bottleLabel.text = "\(Int(customCell.bottleStepper.value))\(getSulUnit(index: actualIndexArray[indexPath.row]))"
        customCell.titleLabel.text = sulArray[indexPath.row].displayName
        if(userSetting.isThemeBright){
            customCell.bottleLabel.textColor = .black
            customCell.titleLabel.textColor = .gray
        }
        else{
            customCell.bottleLabel.textColor = .white
            customCell.titleLabel.textColor = colorGray
        }
        customCell.contentView.backgroundColor = colorDeepBackground
        customCell.bottleStepper.tintColor = colorPoint
        customCell.colorTag.backgroundColor = .clear
        for item in getFavouriteSulIndex() {
            if(item == actualIndexArray[indexPath.row]){
                customCell.flag = true
                break
            }
            customCell.flag = false
        }
        if(customCell.flag){
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
    var flag = false
    
    @IBOutlet weak var starButtonOutlet: UIButton!
    
    @IBAction func starOnTap(_ sender: UIButton) {
        flag.toggle()
        if(userSetting.isVibrationEnabled){
            AudioServicesPlaySystemSound(vibPeek)
        }
        if(flag){
            starButtonOutlet.setImage(star!, for: UIControlState())
        }
        else{
            starButtonOutlet.setImage(star_empty!, for: UIControlState())
        }
        delegate?.starManipulate(self, bool: flag)
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
            bottleLabel.textColor = .black
            titleLabel.textColor = .gray
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
