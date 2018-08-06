import UIKit

class GoalsViewController: UIViewController {
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var howYouDoingLabel: UILabel!
    
    
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 18,y: 18), radius: CGFloat(18), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
    
    let redCircle = CAShapeLayer()
    let yellowCircle = CAShapeLayer()
    let greenCircle = CAShapeLayer()
    
    let date = Date()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCirlce()
        formatter.dateFormat = "MM월 dd일"
        self.title = formatter.string(from: date)
        howYouDoingLabel.text = "잘 돼가요?"
    }
    
    func initCirlce(){
        redView.layer.addSublayer(redCircle)
        yellowView.layer.addSublayer(yellowCircle)
        greenView.layer.addSublayer(greenCircle)
        
        redCircle.path = circlePath.cgPath
        redCircle.fillColor = hexStringToUIColor(hex: "#FF6060").cgColor
        yellowCircle.path = circlePath.cgPath
        yellowCircle.fillColor = hexStringToUIColor(hex: "#FFC400").cgColor
        greenCircle.path = circlePath.cgPath
        greenCircle.fillColor = hexStringToUIColor(hex: "#72FF7D").cgColor
        
        cycleCircleBorder(cursor: 0)
    }
    
    func cycleCircleBorder(cursor: Int){
        let alpha: CGFloat = 0.3
        switch (cursor){
        case 2:
            redView.alpha = 1.0
            yellowView.alpha = alpha
            greenView.alpha = alpha
        case 1:
            redView.alpha = alpha
            yellowView.alpha = 1.0
            greenView.alpha = alpha
        case 0:
            redView.alpha = alpha
            yellowView.alpha = alpha
            greenView.alpha = 1.0
        default:
            print("wtf")
        }
    }

}
