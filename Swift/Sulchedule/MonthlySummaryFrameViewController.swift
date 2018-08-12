import UIKit

class MonthlySummaryFrameViewController: UIViewController, VC2ControlDelegate {
    func sendData(data: Int) {
        pageOutlet.currentPage = data
    }
    
    var vc: MonthlySummaryViewController? = nil
    var delegate: Control2VCDelegate? = nil

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var pageOutlet: UIPageControl!
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        var lastMonth = Int(formatter.string(from: Date())) ?? 1
        formatter.dateFormat = "yyyy"
        var year = Int(formatter.string(from: Date())) ?? 2000
        lastMonth -= 1
        if(lastMonth == 0){
            year -= 1
            lastMonth = 12
        }
        
        navigationBarTitle.title = "지난 달(\(lastMonth)월)의 통계"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(userData.isThemeBright){
            navigationBarTitle.rightBarButtonItem?.tintColor = colorPoint
            pageOutlet.backgroundColor = colorDeepBackground
            pageOutlet.pageIndicatorTintColor = .gray
            backgroundView.backgroundColor = colorLightBackground
            navigationBar.tintColor = .black
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        }
        pageOutlet.currentPageIndicatorTintColor = colorPoint
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        if(userData.isThemeBright){
            self.tabBarController?.tabBar.unselectedItemTintColor = .black
        }
        else{
            self.tabBarController?.tabBar.unselectedItemTintColor = .white
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController: MonthlySummaryViewController = segue.destination as! MonthlySummaryViewController
        viewController.delegate2 = self
    }
}
