import UIKit

class MoreInfoInputViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            print("///\(gotDay?.friends?.count ?? 1)")
            return gotDay?.friends?.count ?? 1
        case 1:
            print("///\(gotDay?.location?.count ?? 1)")
            return gotDay?.location?.count ?? 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "additionO", for: indexPath) as! AdditionalInputTableViewCell
        
        if((indexPath.section == 0 && indexPath.row == (gotDay?.friends?.count ?? 1) - 1) || (indexPath.section == 1 && indexPath.row == (gotDay?.location?.count ?? 1) - 1)){
            customCell.addButtonWidth.constant = 60
            customCell.textFieldRightSpace.constant = 45
        }
        else{
            customCell.addButtonWidth.constant = 0
            customCell.textFieldRightSpace.constant = 0
        }
        
        switch indexPath.section {
        case 0:
            customCell.inputField.text = gotDay?.friends?[indexPath.row]
        case 1:
            customCell.inputField.text = gotDay?.location?[indexPath.row]
        case 2:
            if let a = gotDay?.customExpense {
                if(a == 0){
                    customCell.inputField.text = ""
                }
                else{
                    customCell.inputField.text = String(a)
                }
            }
            else{
                customCell.inputField.text = ""
            }
        default:
            defaultSwitch()
        }
        
        customCell.row = indexPath.row
        customCell.section = indexPath.section
        
        return customCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "함께한 사람들"
        case 1:
            return "장소"
        case 2:
            return "총 지출액"
        default:
            return nil
        }
    }

    @IBOutlet var background: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func expenseField(_ sender: UITextField) {
        var input: String
        var returnValue: Int? = nil
        if(sender.text != "" || sender.text != nil){
            input = sender.text!
            
            if let myNumber = NumberFormatter().number(from: input) {
                returnValue = myNumber.intValue
                sender.text = String(myNumber.intValue)
            } else {
                sender.text = ""
            }
        }
        setRecordDayCustomExpense(day: selectedDay, customExpense: returnValue)
    }
    @IBAction func locationField(_ sender: UITextField) {
        let input = sender.text
        var split: [Substring] = (input?.split(separator: ","))!
        var returnArray: [String] = []
        if(split.count != 0){
            for i in 0...split.count - 1{
                while(split[i].hasSuffix(" ")){
                    split[i].removeLast()
                }
                while(split[i].hasPrefix(" ")){
                    split[i].removeFirst()
                }
                returnArray.append(String(split[i]))
            }
            var tmpText: String = ""
            for string in returnArray{
                tmpText.append(", \(string)")
            }
            tmpText.removeFirst()
            tmpText.removeFirst()
            sender.text = tmpText
        }
        setRecordDayLocation(day: selectedDay, location: returnArray)
    }
    @IBAction func friendsField(_ sender: UITextField) {
        let input = sender.text
        var split: [Substring] = (input?.split(separator: ","))!
        var returnArray: [String] = []
        if(split.count != 0){
            for i in 0...split.count - 1{
                while(split[i].hasSuffix(" ")){
                    split[i].removeLast()
                }
                while(split[i].hasPrefix(" ")){
                    split[i].removeFirst()
                }
                returnArray.append(String(split[i]))
            }
            var tmpText: String = ""
            for string in returnArray{
                tmpText.append(", \(string)")
            }
            tmpText.removeFirst()
            tmpText.removeFirst()
            sender.text = tmpText
        }
        setRecordDayFriends(day: selectedDay, friends: returnArray)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "추가 정보 입력"
        self.hideKeyboardWhenTappedAround()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        background.backgroundColor = colorDeepBackground
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            _ = expenseField
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        if(userSetting.isThemeBright){
            //keyboard appearance
        }
        else{
//            expenseField.keyboardAppearance = .dark
//            locationField.keyboardAppearance = .dark
//            friendsField.keyboardAppearance = .dark
        }
        
//        friendsField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
//                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        var input: String
        var returnValue: Int? = nil

        setRecordDayCustomExpense(day: selectedDay, customExpense: returnValue)

        
//        setRecordDayLocation(day: selectedDay, location: returnArray)
//
//
//        setRecordDayFriends(day: selectedDay, friends: returnArray)
//
        let a = gotDay?.friends
        let b = gotDay?.location
        let c = gotDay?.customExpense
        if(!((a == nil || a?.count == 0) && (b == nil || b?.count == 0) && (c == nil || c == 0))){
            snackBar(string: "추가 정보가 저장되었습니다.", buttonPlaced: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}

class AdditionalInputTableViewCell: UITableViewCell{
    
    var section = 0
    var row = 0
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var addButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var textFieldRightSpace: NSLayoutConstraint!
    
    @IBAction func inputEnded(_ sender: UITextField) {
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.tintColor = colorPoint
        inputField.attributedPlaceholder = NSAttributedString(string: "터치하세요", attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        if(userSetting.isThemeBright){
        }
    }
}
