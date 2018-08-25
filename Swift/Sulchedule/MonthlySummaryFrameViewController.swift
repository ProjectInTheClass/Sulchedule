import UIKit

class MonthlySummaryFrameViewController: UIViewController, VC2ControlDelegate {
    func sendData(data: Int) {
        pageOutlet.currentPage = data
    }
    
    var vc: MonthlySummaryViewController? = nil
    var delegate: Control2VCDelegate? = nil
    var positionConstraintValue = -80
    var workItem: DispatchWorkItem? = nil

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var iPhoneXBackgroundView: UIView!
    @IBOutlet weak var pageOutlet: UIPageControl!
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBAction func dismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var snackBarLabel: UILabel!
    @IBOutlet weak var snackBarView: UIView!
    @IBOutlet weak var snackBarPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var snackBarLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var snackBarRightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snackBarLabel.numberOfLines = 2

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
        
        if(UIScreen.main.nativeBounds.height == 2436){
            snackBarLeftConstraint.constant = 10
            snackBarRightConstraint.constant = 10
            positionConstraintValue = -110
        }
        
        if(userSetting.firstLaunch){
            showSnackBar(string: "지난 달의 통계를 확인하는 화면입니다.\n좌우로 밀어 다른 정보를 확인하세요.")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(snackBarWaitTime))) {
                self.showSnackBar(string: "매달 처음으로 실행할 때마다 보여드릴게요.\n마지막 페이지에서 앱 아이콘도 바꿔보세요!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarTitle.rightBarButtonItem?.tintColor = colorPoint
        pageOutlet.backgroundColor = colorDeepBackground
        pageOutlet.pageIndicatorTintColor = colorGray
        backgroundView.backgroundColor = colorLightBackground
        iPhoneXBackgroundView.backgroundColor = colorDeepBackground
        navigationBar.tintColor = colorText
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: colorText]
        pageOutlet.currentPageIndicatorTintColor = colorPoint
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
        snackBarView.backgroundColor = colorLightBackground
        snackBarLabel.textColor = colorText
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController: MonthlySummaryViewController = segue.destination as! MonthlySummaryViewController
        viewController.delegate2 = self
    }
    
    func showSnackBar(string: String) {
        let radius: CGFloat = snackBarView.frame.width / 2.0
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2 * radius, height: snackBarView.frame.height))
        snackBarView.layer.shadowColor = UIColor.black.cgColor
        snackBarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        snackBarView.layer.shadowOpacity = 0.4
        snackBarView.layer.shadowRadius = 7.0
        snackBarView.layer.masksToBounds =  false
        snackBarView.layer.shadowPath = shadowPath.cgPath
        snackBarLabel.text = string
        snackBarPositionConstraint.constant = CGFloat(positionConstraintValue)
        
        UIView.animate(withDuration: 0.25, delay: 0.05, options: [.curveEaseInOut], animations: {
            self.snackBarView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion:nil)
        workItem = DispatchWorkItem { self.hideSnackBar() }
        DispatchQueue.main.asyncAfter(deadline: .now() + snackBarWaitTime, execute: workItem!)
    }
    
    func hideSnackBar(){
        snackBarPositionConstraint.constant = 0
        workItem!.cancel()
        UIView.animate(withDuration: 0.25, delay: 0.05, options: [.curveEaseInOut], animations: {
            self.snackBarView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion:nil)
    }
}
