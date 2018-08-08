import UIKit
import AudioToolbox.AudioServices

class SettingsTableViewController: UITableViewController {

    @IBOutlet var backgroundView: UITableView!
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var vibrationSwitch: UISwitch!
    @IBAction func darkThemeSwitch(_ sender: UISwitch) {
        if(isVibrationOn){
            AudioServicesPlaySystemSound(peek)
        }
        isBrightTheme.toggle()
        
        if(isBrightTheme){
            colorPoint = hexStringToUIColor(hex: "#0067B2")
            colorLightBackground = hexStringToUIColor(hex: "#EAEAEA")
            colorDeepBackground = hexStringToUIColor(hex: "#FFFFFF")
            UINavigationBar.appearance().tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
            UITabBar.appearance().unselectedItemTintColor = .black
            UILabel.appearance().textColor = UIColor.black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
            
            darkThemeSwitch.tintColor = colorPoint
            darkThemeSwitch.thumbTintColor = colorLightBackground
            darkThemeSwitch.onTintColor = colorPoint
            vibrationSwitch.tintColor = colorPoint
            vibrationSwitch.thumbTintColor = colorLightBackground
            vibrationSwitch.onTintColor = colorPoint
        }
        else{
            colorPoint = hexStringToUIColor(hex:"FFDC67")
            colorLightBackground = hexStringToUIColor(hex:"252B53")
            colorDeepBackground = hexStringToUIColor(hex:"0B102F")
            UINavigationBar.appearance().tintColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            UITabBar.appearance().unselectedItemTintColor = .white
            UILabel.appearance().textColor = UIColor.white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            
            darkThemeSwitch.tintColor = colorPoint
            darkThemeSwitch.thumbTintColor = UIColor.white
            darkThemeSwitch.onTintColor = colorPoint
            vibrationSwitch.tintColor = colorPoint
            vibrationSwitch.thumbTintColor = UIColor.white
            vibrationSwitch.onTintColor = colorPoint
        }
        
        UINavigationBar.appearance().barTintColor = colorLightBackground
        UINavigationBar.appearance().backgroundColor = colorLightBackground
        UITabBar.appearance().tintColor = colorPoint
        UITabBar.appearance().barTintColor = colorLightBackground
        
        backgroundView.backgroundColor = colorDeepBackground
        cell1.backgroundColor = colorDeepBackground
        cell2.backgroundColor = colorDeepBackground
        cell3.backgroundColor = colorDeepBackground
        
        backgroundView.reloadData()
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(isBrightTheme){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
    }
    @IBAction func vibrationSwitch(_ sender: UISwitch) {
        if(!isVibrationOn){
            AudioServicesPlaySystemSound(peek)
        }
        isVibrationOn.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = colorLightBackground
        UINavigationBar.appearance().backgroundColor = colorLightBackground
        UITabBar.appearance().tintColor = colorPoint
        UITabBar.appearance().barTintColor = colorLightBackground
        
        backgroundView.backgroundColor = colorDeepBackground
        cell1.backgroundColor = colorDeepBackground
        cell2.backgroundColor = colorDeepBackground
        cell3.backgroundColor = colorDeepBackground
        
        darkThemeSwitch.tintColor = colorPoint
        darkThemeSwitch.thumbTintColor = .white
        darkThemeSwitch.onTintColor = colorPoint
        vibrationSwitch.tintColor = colorPoint
        vibrationSwitch.thumbTintColor = .white
        vibrationSwitch.onTintColor = colorPoint
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
