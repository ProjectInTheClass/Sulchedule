import UIKit
import GoogleMobileAds

let request = GADRequest()

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        loadRecordDayList()
        loadRecordMonthList()
        loadUserData()
        sul.append(contentsOf: userSetting.newSul)
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-4587910042719801~6894810485")
        request.testDevices = [ "f02b5d64da4ded542745d20af9cbbfcd" ] //remove before release
        
        if(userSetting.isThemeBright){
            colorPoint = hexStringToUIColor(hex: "#0067B2")
            colorLightBackground = hexStringToUIColor(hex: "#EAEAEA")
            colorDeepBackground = hexStringToUIColor(hex: "#FFFFFF")
        }
        
        if(userSetting.isThemeBright){
            UINavigationBar.appearance().tintColor = UIColor.black
            UIApplication.shared.statusBarStyle = .default
            UITabBar.appearance().unselectedItemTintColor = .black
            UILabel.appearance().textColor = UIColor.black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        }
        else{
            UINavigationBar.appearance().tintColor = UIColor.white
            UIApplication.shared.statusBarStyle = .lightContent
            UITabBar.appearance().unselectedItemTintColor = .white
            UILabel.appearance().textColor = UIColor.white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        
        UINavigationBar.appearance().barTintColor = colorLightBackground
        UINavigationBar.appearance().backgroundColor = colorLightBackground
        UITabBar.appearance().tintColor = colorPoint
        UITabBar.appearance().barTintColor = colorLightBackground
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        UINavigationBar.appearance().barTintColor = colorLightBackground
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = colorLightBackground
        UITabBar.appearance().tintColor = colorPoint
        UITabBar.appearance().barTintColor = colorLightBackground

        
        
        UITabBar.appearance().layer.borderWidth = 0.10
        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        UITabBar.appearance().clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)

        return true
    }
    
    @objc func calendarDayDidChange(_ notification : Notification)
    {
        monthmonth = dateToMonthConverter(date: Calendar.current.date(byAdding: .month, value: isLastMonth, to: Date())!)
        selectedDay = dateToDayConverter(date: Date())
        gotDay = getRecordDay(day: selectedDay)
//        calendar.select(Date(), scrollToDate: true)
//        newDaySelected(date: Date())
//        calendar.reloadData()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        saveUserData()
        saveRecordMonthList()
        saveRecordDayList()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

