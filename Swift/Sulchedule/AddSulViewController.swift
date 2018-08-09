import UIKit

class AddSulViewController: UIViewController {

    @IBOutlet var background: UIView!
    @IBOutlet weak var foreground: UIView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        //save temporary Sul to array
    }
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var calorieField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBAction func nameField(_ sender: UITextField) {
        //pass to temporary Sul
    }
    @IBAction func calorieField(_ sender: UITextField) {
        //pass to temporary Sul
    }
    @IBAction func priceField(_ sender: UITextField) {
        //pass to temporary Sul
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        background.backgroundColor = colorLightBackground
        foreground.backgroundColor = colorDeepBackground
        saveButton.tintColor = colorPoint
        dismissButton.tintColor = colorPoint
        if(isBrightTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
            nameField.keyboardAppearance = .light
            calorieField.keyboardAppearance = .light
            priceField.keyboardAppearance = .light
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
            nameField.keyboardAppearance = .dark
            calorieField.keyboardAppearance = .dark
            priceField.keyboardAppearance = .dark
        }
        
        nameField.textColor = colorPoint
        calorieField.textColor = colorPoint
        priceField.textColor = colorPoint
        
        nameField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                             attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        calorieField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        priceField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
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
