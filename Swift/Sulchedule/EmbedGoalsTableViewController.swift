import UIKit

var goalViewDelegate: CycleBorderDelegate?




class EmbedGoalsTableViewController: UITableViewController, EmbedGoalsDelegate, AddRowMoreInfoDelegate {
    func addRow(section: Int, row: Int) -> Bool {return true}
    func initIndexPath(row: Int, section: Int) {}
    
    

}
