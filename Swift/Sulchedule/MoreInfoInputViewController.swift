import UIKit

var a: [String] = []
var b: [String] = []
var c: Int = 0

protocol AddRowMoreInfoDelegate {
    func addRow(section: Int, row: Int) -> Bool
    func keyboard(float: Bool, indexPath: IndexPath)
}

class MoreInfoInputViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AddRowMoreInfoDelegate {
    
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
    
    func keyboard(float: Bool, indexPath: IndexPath){
        if(float){
            self.tableBottom.constant += 180
        }
        else{
            self.tableBottom.constant -= 180
        }
        if(float){
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            if(a.count == 0){
                return 1
            }
            else{
                return (a.count)
            }
        case 1:
            if(b.count == 0){
                return 1
            }
            else{
                return (b.count)
            }
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
            if(indexPath.row >= a.count){
                customCell.inputField.text = ""
            }
            else{
                customCell.inputField.text = a[indexPath.row]
            }
        case 1:
            if(indexPath.row >= b.count){
                customCell.inputField.text = ""
            }
            else{
                customCell.inputField.text = b[indexPath.row]
            }
        case 2:
            if let c = gotDay?.customExpense {
                if(c == 0){
                    customCell.inputField.text = ""
                }
                else{
                    customCell.inputField.text = String(c)
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
        customCell.delegate = self
        
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
    @IBOutlet weak var tableBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "추가 정보 입력"
        self.hideKeyboardWhenTappedAround()
        
        a = gotDay?.friends ?? []
        a.append("")
        b = gotDay?.location ?? []
        b.append("")
        c = gotDay?.customExpense ?? 0
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(save))
        navigationController?.navigationItem.rightBarButtonItem?.tintColor = colorPoint
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = colorPoint
        background.backgroundColor = colorDeepBackground
        
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
    @objc func save() {
        
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
        
        setRecordDayCustomExpense(day: selectedDay, customExpense: c)
        setRecordDayLocation(day: selectedDay, location: b)
        setRecordDayFriends(day: selectedDay, friends: a)
        
        if(a.isEmpty){
            a.append("")
        }
        if(b.isEmpty){
            b.append("")
        }
        
        tableView.reloadData()

        if(!((a.count == 0) && (b.count == 0) && (c == 0))){
            snackBar(string: "추가 정보가 저장되었습니다.", buttonPlaced: true)
        }
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
            c = Int(sender.text ?? "0") ?? 0
        default:
            defaultSwitch()
        }
    }
    @IBAction func editBegan(_ sender: Any) {
        delegate?.keyboard(float: true, indexPath: IndexPath(row: row, section: section))
    }
    @IBAction func editEnded(_ sender: Any) {
        delegate?.keyboard(float: false, indexPath: IndexPath(row: row, section: section))
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
