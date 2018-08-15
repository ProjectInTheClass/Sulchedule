import UIKit

class AddSulViewController: UIViewController, UITextFieldDelegate {
    
    var vc: EmbedAddSulTableViewController?
    

    @IBOutlet weak var tableDescriptionLabel: UILabel!
    @IBOutlet var background: UIView!
    @IBOutlet weak var embedTableView: UIView!
    @IBOutlet weak var foreground: UIView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        if(nameField.text != "" && calorieField.text != "" && priceField.text != "" && unitField.text != "" && nameField.text != nil && calorieField.text != nil && priceField.text != nil && unitField.text != nil){
            if(!addUserSul(newSul: Sul(displayName: nameField.text!, baseCalorie: Int(calorieField.text!)!, basePrice: Int(priceField.text!)!, colorTag: "#FFFFFF", unit: unitField.text!))){
                let alertController = UIAlertController(title: "같은 이름의 주류가 있습니다", message: "이름을 바꾼 뒤 다시 시도해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                vc?.loadArray()
                vc?.reload()
                
                nameField.text = ""
                calorieField.text = ""
                unitField.text = ""
                priceField.text = ""
                dismissKeyboard()
            }
            
            
            
            
            nameField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
            priceField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                  attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
            calorieField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                    attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
            unitField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        }
        else{
            if(nameField.text == "" || nameField.text == nil){
                nameField.attributedPlaceholder = NSAttributedString(string: "모두 입력해주세요",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: colorRed])
            }
            if(priceField.text == "" || priceField.text == nil){
                priceField.attributedPlaceholder = NSAttributedString(string: "모두 입력해주세요",
                                                                      attributes: [NSAttributedStringKey.foregroundColor: colorRed])
            }
            if(calorieField.text == "" || calorieField.text == nil){
                calorieField.attributedPlaceholder = NSAttributedString(string: "모두 입력해주세요",
                                                                        attributes: [NSAttributedStringKey.foregroundColor: colorRed])
            }
            if(unitField.text == "" || unitField.text == nil){
                unitField.attributedPlaceholder = NSAttributedString(string: "모두 입력해주세요",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: colorRed])
            }
        }
    }
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var calorieField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var unitField: UITextField!
    @IBAction func unitField(_ sender: UITextField) {
        //pass to temporary Sul
    }
    @IBAction func nameField(_ sender: UITextField) {
        //pass to temporary Sul
    }
    @IBAction func calorieField(_ sender: UITextField) {
        var input: String
        if(sender.text != "" || sender.text != nil){
            input = sender.text!
            
            if let myNumber = NumberFormatter().number(from: input) {
                sender.text = String(myNumber.intValue)
            } else {
                sender.text = ""
            }
        }
    }
    @IBAction func priceField(_ sender: UITextField) {
        var input: String
        if(sender.text != "" || sender.text != nil){
            input = sender.text!
            
            if let myNumber = NumberFormatter().number(from: input) {
                sender.text = String(myNumber.intValue)
            } else {
                sender.text = ""
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        vc = segue.destination as? EmbedAddSulTableViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        nameField.delegate = self
        calorieField.delegate = self
        unitField.delegate = self
        priceField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        tableDescriptionLabel.backgroundColor = colorLightBackground
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        background.backgroundColor = colorLightBackground
        foreground.backgroundColor = colorDeepBackground
        saveButton.tintColor = colorPoint
        dismissButton.tintColor = colorPoint
        
        tableDescriptionLabel.textColor = colorText
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
        if(userSetting.isThemeBright){
            nameField.keyboardAppearance = .light
            calorieField.keyboardAppearance = .light
            priceField.keyboardAppearance = .light
            unitField.keyboardAppearance = .light
        }
        else{
            nameField.keyboardAppearance = .dark
            calorieField.keyboardAppearance = .dark
            priceField.keyboardAppearance = .dark
            unitField.keyboardAppearance = .dark
        }
        
        nameField.textColor = colorPoint
        calorieField.textColor = colorPoint
        priceField.textColor = colorPoint
        unitField.textColor = colorPoint

        nameField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                             attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        calorieField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        priceField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                              attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        unitField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                              attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
    }
    override func viewDidAppear(_ animated: Bool) {
        nameField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                             attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        calorieField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        priceField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                              attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        unitField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                              attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
    }


}
