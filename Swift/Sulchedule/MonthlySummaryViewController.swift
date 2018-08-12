import UIKit

var isLastMonth = 0

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
        
        self.delegate = self
        self.dataSource = self
        
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id1")
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id2")
        let p3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id3")
        
        pages.append(p1)
        pages.append(p2)
        pages.append(p3)
        
        setViewControllers([p1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
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
        
        isLastMonth = -1
    }
    override func viewWillDisappear(_ animated: Bool) {
        isLastMonth = 0
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
