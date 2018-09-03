import UIKit

var a: [String] = []
var b: [String] = []
var c: Int = 0

protocol AddRowMoreInfoDelegate {
    func addRow(section: Int, row: Int) -> Bool
    func keyboard(pullUp: Bool, row: Int, section: Int)
    func initIndexPath(row: Int, section: Int)
}

class MoreInfoInputViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AddRowMoreInfoDelegate {
    var keyboardHeight: CGFloat = 0
    var tempRow = 0
    var tempSection = 0
    
    func initIndexPath(row: Int, section: Int){
        tempRow = row
        tempSection = section
    }
    func addRow(section: Int, row: Int) -> Bool{
        var flag = true
        if(section == 0){
            for item in a{
                if(item == ""){
                    flag = false
                    break
                }
            }
        }
        else{
            for item in b{
                if(item == ""){
                    flag = false
                    break
                }
            }
        }
        
        if(flag){
            tableView.beginUpdates()
            let index = IndexPath(row: row + 1, section: section)
            if(section == 0){
                a.append("")
            }
            else{
                b.append("")
            }
            tableView.insertRows(at: [index], with: UITableViewRowAnimation.automatic)
            tableView.endUpdates()
        }
        return flag
    }
    
    func keyboard(pullUp: Bool, row: Int, section: Int){
        if(pullUp){
            self.tableBottom.constant = keyboardHeight
        }
        else{
            self.tableBottom.constant = 0
        }
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.height
        keyboard(pullUp: true, row: tempRow, section: tempSection)
    }
    
    @objc func keyboardFixed(notification: NSNotification) {
        tableView.scrollToRow(at: IndexPath(row:tempRow, section:tempSection), at: .bottom, animated: true)
    }
    
    @objc func keyboardHidden(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.height
        keyboard(pullUp: false, row: tempRow, section: tempSection)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return (a.count)
        case 1:
            return (b.count)
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "additionO", for: indexPath) as! AdditionalInputTableViewCell
        
        if((indexPath.section == 0 && indexPath.row == a.count - 1) || (indexPath.section == 1 && indexPath.row == b.count - 1)){
            customCell.addButtonWidth.constant = 60
            customCell.textFieldRightSpace.constant = 45
        }
        else{
            customCell.addButtonWidth.constant = 0
            customCell.textFieldRightSpace.constant = 0
        }
        
        switch indexPath.section {
        case 0:
            customCell.inputField.text = a[indexPath.row]
        case 1:
            customCell.inputField.text = b[indexPath.row]
        case 2:
            if let c = gotDay?.customExpense {
                customCell.inputField.text = String(c)
            }
            else{
                customCell.inputField.text = ""
            }
        default:
            defaultSwitch()
        }
        
        customCell.row = indexPath.row
        customCell.section = indexPath.section
        customCell.delegate = self
        
        if(indexPath.section == 2){
            customCell.inputField.keyboardType = .numberPad
        }
        else{
            customCell.inputField.keyboardType = .default
        }
        
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

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var background: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    @IBOutlet weak var topBackground: UIView!
    @IBAction func close(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func save(_ sender: Any) {
        view.endEditing(true)
        
        if(!a.isEmpty){
            for i in 0...(a.count - 1) {
                while(a[i].hasSuffix(" ")){
                    a[i].removeLast()
                }
                while(a[i].hasPrefix(" ")){
                    a[i].removeFirst()
                }
            }
        }
        
        if(!b.isEmpty){
            for i in 0...(b.count - 1) {
                while(b[i].hasSuffix(" ")){
                    b[i].removeLast()
                }
                while(b[i].hasPrefix(" ")){
                    b[i].removeFirst()
                }
            }
        }
        
        a = a.filter { $0 != "" }
        b = b.filter { $0 != "" }
        
        setRecordDayLocation(day: selectedDay, location: b)
        setRecordDayFriends(day: selectedDay, friends: a)
        if(c == -1){
            setRecordDayCustomExpense(day: selectedDay, customExpense: nil)
        }
        else{
            setRecordDayCustomExpense(day: selectedDay, customExpense: c)
        }
        
        a.append("")
        b.append("")
        
        
        tableView.reloadData()
        
        dismiss(animated: true, completion: {
            if(!((a.count == 0) && (b.count == 0) && (c == 0))){
            snackBar(string: "추가 정보가 저장되었습니다.", buttonPlaced: true)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        a = gotDay?.friends ?? []
        b = gotDay?.location ?? []
        a = a.filter { $0 != "" }
        b = b.filter { $0 != "" }
        a.append("")
        b.append("")
        c = gotDay?.customExpense ?? -1
        
        navigationBar.tintColor = colorPoint
        tableView.sectionIndexTrackingBackgroundColor = colorLightBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFixed), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        background.backgroundColor = colorDeepBackground
        tableView.backgroundColor = colorDeepBackground
        tableView.separatorColor = colorLightBackground
        topBackground.backgroundColor = colorLightBackground

        
//        friendsField.attributedPlaceholder = NSAttributedString(string: "터치하세요",
//                                                                attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    
}

class AdditionalInputTableViewCell: UITableViewCell{
    
    var section = 0
    var row = 0
    var delegate: AddRowMoreInfoDelegate?
    
    @IBOutlet weak var inputField: NoEditUITextFieldForSection!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var addButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var textFieldRightSpace: NSLayoutConstraint!
    
    @IBAction func inputEnded(_ sender: UITextField) {
        switch section {
        case 0:
            if(a.count >= row + 1){
                a[row] = sender.text ?? ""
            }
            else{
                a.insert(sender.text ?? "", at: row)
            }
            
        case 1:
            if(b.count >= row + 1){
                b[row] = sender.text ?? ""
            }
            else{
                b.insert(sender.text ?? "", at: row)
            }
        case 2:
            c = Int(sender.text ?? "") ?? -1
        default:
            defaultSwitch()
        }
    }
    @IBAction func editBegan(_ sender: Any) { 
        delegate?.initIndexPath(row: row, section: section)
    }
    @IBAction func editEnded(_ sender: Any) {
//        delegate?.keyboard(float: false, indexPath: IndexPath(row: row, section: section))
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if((delegate?.addRow(section: section, row: row))!){
            addButtonWidth.constant = 0
            textFieldRightSpace.constant = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.tintColor = colorPoint
        inputField.textColor = colorText
        inputField.attributedPlaceholder = NSAttributedString(string: "터치하세요", attributes: [NSAttributedStringKey.foregroundColor: colorPoint])
        
        if(userSetting.isThemeBright){
            inputField.keyboardAppearance = .light
        }
        else{
            inputField.keyboardAppearance = .dark
        }
    }
}

class NoEditUITextFieldForSection: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if(self.keyboardType == .numberPad){
            if action == #selector(UIResponderStandardEditActions.paste(_:)){
                return false
            }
            if action == #selector(UIResponderStandardEditActions.cut(_:)){
                return false
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
