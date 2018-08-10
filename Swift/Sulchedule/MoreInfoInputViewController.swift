import UIKit

//var moreInfoInputFriends: String?
//var moreInfoInputExpense: String?
//var moreInfoInputLocation: String?
//
//func getTodayMoreInfoPromptLabel() -> String?{
//    if(){
//        return nil
//    }
//
//}

class MoreInfoInputViewController: UIViewController {

    @IBOutlet weak var expenseField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var friendsField: UITextField!
    @IBOutlet var background: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBAction func expenseField(_ sender: UITextField) {
        var input: String
        var returnValue: Int
        if(sender.text != "" || sender.text != nil){
            input = sender.text!
            
            if let myNumber = NumberFormatter().number(from: input) {
                returnValue = myNumber.intValue
                // do what you need to do with myInt
            } else {
                sender.text = ""
            }
        }
        //pass data
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
        //pass data
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
        //pass data
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "추가 정보 입력"
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        background.backgroundColor = colorDeepBackground
        
        expenseField.textColor = colorPoint
        locationField.textColor = colorPoint
        friendsField.textColor = colorPoint
        promptLabel.backgroundColor = colorLightBackground
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            _ = expenseField
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        
        if(isBrightTheme){
            expenseField.tintColor = .black
            locationField.tintColor = .black
            friendsField.tintColor = .black
            expenseField.keyboardAppearance = .light
            locationField.keyboardAppearance = .light
            friendsField.keyboardAppearance = .light
        }
        else{
            expenseField.tintColor = .white
            locationField.tintColor = .white
            friendsField.tintColor = .white
            expenseField.keyboardAppearance = .dark
            locationField.keyboardAppearance = .dark
            friendsField.keyboardAppearance = .dark
        }
        
        expenseField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        locationField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        friendsField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        expenseField.text = ""
        locationField.text = ""
        friendsField.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        expenseField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        locationField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        friendsField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
