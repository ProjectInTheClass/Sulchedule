import UIKit

protocol CycleBorderDelegate{
    func manipulateCircle(value: Int)
}

class GoalsViewController: UIViewController, CycleBorderDelegate {
    func manipulateCircle(value: Int) {
        cycleCircleBorder(cursor: value)
    }
    
    
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var howYouDoingLabel: UILabel!
    @IBOutlet weak var topBackgroundView: UIView!
    
    var viewController:EmbedGoalsTableViewController? = nil
    
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 18,y: 18), radius: CGFloat(18), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    
    let redCircle = CAShapeLayer()
    let yellowCircle = CAShapeLayer()
    let greenCircle = CAShapeLayer()
    
    let date = Date()
    let formatter = DateFormatter()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewController = segue.destination as? EmbedGoalsTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalViewDelegate = self
    
        initCircle()
        formatter.dateFormat = "M월의 목표"
        self.navigationItem.title = formatter.string(from: date)
        
        
        if(userSetting.firstLaunch){
            snackBar(string: "목표를 설정해 건강을 지키세요!\n우측 상단에 목표 수정 버튼이 있습니다.", buttonPlaced: false)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(Int(snackBarWaitTime))){
                snackBar(string: "목표를 달성하면 다음 달에 광고를 제거할 수 있습니다!", buttonPlaced: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        topBackgroundView.backgroundColor = colorLightBackground
        navigationItem.rightBarButtonItem?.tintColor = colorPoint
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:colorText]
        self.tabBarController?.tabBar.barTintColor = colorLightBackground
        self.tabBarController?.tabBar.tintColor = colorPoint
        self.tabBarController?.tabBar.unselectedItemTintColor = colorText
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func initCircle(){
        redView.layer.addSublayer(redCircle)
        yellowView.layer.addSublayer(yellowCircle)
        greenView.layer.addSublayer(greenCircle)
        
        redCircle.path = circlePath.cgPath
        redCircle.fillColor = colorRed.cgColor
        yellowCircle.path = circlePath.cgPath
        yellowCircle.fillColor = colorYellow.cgColor
        greenCircle.path = circlePath.cgPath
        greenCircle.fillColor = colorGreen.cgColor
    }
    
    func cycleCircleBorder(cursor: Int){
        let alpha: CGFloat = 0.2
        switch (cursor){
        case 3:
            redView.alpha = alpha
            yellowView.alpha = alpha
            greenView.alpha = alpha
            howYouDoingLabel.text = "목표를 설정하세요!"
        case 2:
            redView.alpha = 1.0
            yellowView.alpha = alpha
            greenView.alpha = alpha
            howYouDoingLabel.text = "어떡하려고 그래요...?"
        case 1:
            redView.alpha = alpha
            yellowView.alpha = 1.0
            greenView.alpha = alpha
            howYouDoingLabel.text = "아슬아슬해요!!!"
        case 0:
            redView.alpha = alpha
            yellowView.alpha = alpha
            greenView.alpha = 1.0
            howYouDoingLabel.text = "목표한 대로 잘하고 있어요!"
        default:
            print("Not Accepted Switch Value")
        }
    }

}
