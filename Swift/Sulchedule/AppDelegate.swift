import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        addNewRecordDay(newRecordDay: dummyA)
//        addNewRecordDay(newRecordDay: dummyB)
//        addNewRecordDay(newRecordDay: dummyC)
//        addNewRecordDay(newRecordDay: dummyD)
//        addNewRecordDay(newRecordDay: dummyE)
//        addNewRecordDay(newRecordDay: dummyF)
//        addNewRecordDay(newRecordDay: dummyG)
//        addNewRecordDay(newRecordDay: dummyH)
        loadRecordDayList()
        loadRecordMonthList()
        loadUserData()
        
        
        if(userData.isThemeBright){
            colorPoint = hexStringToUIColor(hex: "#0067B2")
            colorLightBackground = hexStringToUIColor(hex: "#EAEAEA")
            colorDeepBackground = hexStringToUIColor(hex: "#FFFFFF")
        }
        
        if(userData.isThemeBright){
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
        
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 17)!,
                NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        
        UITabBar.appearance().layer.borderWidth = 0.10
        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        UITabBar.appearance().clipsToBounds = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        saveUserData()
        saveRecordMonthList()
        saveRecordDayList()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveUserData()
        saveRecordMonthList()
        saveRecordDayList()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveUserData()
        saveRecordMonthList()
        saveRecordDayList()
    }


}

