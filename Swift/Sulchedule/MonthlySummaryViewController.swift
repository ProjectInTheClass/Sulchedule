import UIKit



class MonthlySummaryViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, Control2VCDelegate {
    func sendData(data: Int) {
        setViewControllers([pages[data]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }

    var pages = [UIViewController]()
    var pageControlSelectedPage: Int = 0
    var delegate2: VC2ControlDelegate? = nil
    var vc:GoalsViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLastMonth = -1
        monthmonth = dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)
        
        self.delegate = self
        self.dataSource = self
        
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id1")
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id2")
        let p3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id3")
        
        pages.append(p1)
        pages.append(p2)
        pages.append(p3)
        
        var isEnabled:[Int] = []
        if(isDaysOfMonthEnabled(month: monthmonth)){
            isEnabled.append(0)
        }
        if(isStreakOfMonthEnabled(month: monthmonth)){
            isEnabled.append(1)
        }
        if(isCurrentExpenseEnabled(month: monthmonth)){
            isEnabled.append(2)
        }
        if(isCaloriesOfMonthEnabled(month: monthmonth)){
            isEnabled.append(3)
        }
        
        var i = 0
        var goalValue:[Float] = []
        for item in isEnabled{
            switch item {
            case 0 :
                if(isDaysOfMonthEnabled(month: monthmonth)){
                    goalValue.append(Float(getDaysOfMonthStatus(month: monthmonth)) / Float(getDaysOfMonthLimit(month: monthmonth)))
                }
            case 1 :
                if(isStreakOfMonthEnabled(month: monthmonth)){
                    goalValue.append(Float(getStreakOfMonthStatus(month: monthmonth)) / Float(getStreakOfMonthLimit(month: monthmonth)))
                }
            case 2 :
                if(isCurrentExpenseEnabled(month: monthmonth)){
                    goalValue.append(Float(getCurrentExpenseStatus(month: monthmonth)) / Float(getCurrentExpenseLimit(month: monthmonth)))
                }
            case 3 :
                if(isCaloriesOfMonthEnabled(month: monthmonth)){
                    goalValue.append(Float(getCaloriesOfMonthStatus(month: monthmonth)) / Float(getCaloriesOfMonthLimit(month: monthmonth)))
                }
            default :
                defaultSwitch()
            }
            i += 1
        }
        for item in goalValue{
            if item > 1.0{
                userSetting.succeededLastMonth = false
                userSetting.adIsOff = false
                break
            }
            else{
                userSetting.succeededLastMonth = true
            }
        }
        
        
        setViewControllers([p1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        isLastMonth = 0
        monthmonth = dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        delegate2!.sendData(data: cur)
        
//        if cur == 0 { return nil }
        
        var prev = (cur - 1) % 3
        if(prev<0){
            prev+=3
        }
        return pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        delegate2!.sendData(data: cur)
        
//        if cur == (pages.count - 1) { return nil }
        
        var nxt = (cur + 1) % 3
        if(nxt>2){
            nxt-=3
        }
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController: MonthlySummaryFrameViewController = segue.destination as! MonthlySummaryFrameViewController
        viewController.delegate = self
        
        vc = segue.destination as? GoalsViewController
    }
}
