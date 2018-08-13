import UIKit

class MoreInfoInputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var expenseField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var friendsField: UITextField!
    @IBOutlet var background: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    
    @IBAction func expenseField(_ sender: UITextField) {
        var input: String
        var returnValue: Int? = nil
        if(sender.text != "" || sender.text != nil){
            input = sender.text!
            
            if let myNumber = NumberFormatter().number(from: input) {
                returnValue = myNumber.intValue
                sender.text = String(myNumber.intValue)
                // do what you need to do with myInt
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
        
        expenseField.delegate = self
        friendsField.delegate = self
        locationField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
        
        
        if(userSetting.isThemeBright){
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
        
        var reusableTemp = ""
        
        for string in gotDay?.friends ?? [""]{
            reusableTemp.append(", \(string)")
        }
        if(reusableTemp.count >= 2){
            reusableTemp.removeFirst(2)
        }
        friendsField.text = reusableTemp
        
        reusableTemp = ""
        
        for string in gotDay?.location ?? [""]{
            reusableTemp.append(", \(string)")
        }
        if(reusableTemp.count >= 2){
            reusableTemp.removeFirst(2)
        }
        locationField.text = reusableTemp
        
        let k = (gotDay!.customExpense) ?? 0
        if(k == 0){
            expenseField.text = ""
        }
        else{
            expenseField.text = String(k)
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        var input: String
        var returnValue: Int? = nil
        if(expenseField.text != "" || expenseField.text != nil){
            input = expenseField.text!
            
            if let myNumber = NumberFormatter().number(from: input) {
                returnValue = myNumber.intValue
                expenseField.text = String(myNumber.intValue)
                // do what you need to do with myInt
            } else {
                expenseField.text = ""
            }
        }
        setRecordDayCustomExpense(day: selectedDay, customExpense: returnValue)

        input = locationField.text ?? ""
        var split: [Substring] = (input.split(separator: ","))
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
            locationField.text = tmpText
        }
        setRecordDayLocation(day: selectedDay, location: returnArray)

        input = friendsField.text ?? ""
        split = (input.split(separator: ","))
        returnArray = []
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
            friendsField.text = tmpText
        }
        setRecordDayFriends(day: selectedDay, friends: returnArray)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        expenseField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        locationField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        friendsField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
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
