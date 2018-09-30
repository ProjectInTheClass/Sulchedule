//데이터 형식

import Foundation

class Day : NSObject, NSCoding {
    var year: Int
    var month: Int
    var day: Int?
    
    init(year: Int, month: Int, day: Int?){
        self.year = year
        self.month = month
        if let date = day {
            self.day = date
        }
    }
    
    public func encode(with aCoder:NSCoder) {
        aCoder.encode(self.year, forKey: "year")
        aCoder.encode(self.month, forKey: "month")
        aCoder.encode(self.day, forKey: "day")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        if let year = aDecoder.decodeInteger(forKey: "year") as? Int{
            self.year = year
        } else {
            self.year = 0
        }
        if let month = aDecoder.decodeInteger(forKey: "month") as? Int{
            self.month = month
        } else {
            self.month = 0
        }
        if let day = aDecoder.decodeObject(forKey: "day") as? Int{
            self.day = day
        } else {
            self.day = 0
        }
        super.init()
    }
}

class RecordDay : NSObject, NSCoding {
    var today: Day
    
    var location: [String]?
    var friends:[String]?
    var expense: Int? //값을 입력하지 않은 경우 사용
    var customExpense: Int? //값을 입력한 경우 사용
    var calories: Int?
    var firstLaunchToday = true
    
    var drinks:[Int:Int]? //index : bottles
    
    init (today:Day, location:[String]?, friends:[String]?, expense:Int?, customExpense:Int?, calories:Int?, drinks:[Int:Int]?) {
        self.today = today
        if let loca = location {
            self.location = loca
        }
        if let fri = friends {
            self.friends = fri
        }
        if let exp = expense {
            self.expense = exp
        }
        if let custom = customExpense {
            self.customExpense = custom
        }
        if let kcal = calories {
            self.calories = kcal
        }
        if let dri = drinks {
            self.drinks = dri
        }
    }
    
    public func encode(with aCoder:NSCoder) {
        aCoder.encode(self.today, forKey: "today")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.friends, forKey: "friends")
        aCoder.encode(self.expense, forKey: "expense")
        aCoder.encode(self.customExpense, forKey: "customExpense")
        aCoder.encode(self.calories, forKey: "calories")
        aCoder.encode(self.drinks, forKey: "drinks")
        aCoder.encode(self.firstLaunchToday, forKey: "firstLaunchToday")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        if let today = aDecoder.decodeObject(forKey: "today") as? Day{
            self.today = today
        } else {
            self.today = Day(year: 0, month: 0, day: nil)
        }
        if let location = aDecoder.decodeObject(forKey: "location") as? [String]{
            self.location = location
        } else {
            self.location = []
        }
        if let friends = aDecoder.decodeObject(forKey: "friends") as? [String]{
            self.friends = friends
        } else {
            self.friends = []
        }
        if let expense = aDecoder.decodeObject(forKey: "expense") as? Int{
            self.expense = expense
        } else {
            self.expense = 0
        }
        if let customExpense = aDecoder.decodeObject(forKey: "customExpense") as? Int{
            self.customExpense = customExpense
        } else {
            self.customExpense = nil
        }
        if let calories = aDecoder.decodeObject(forKey: "calories") as? Int{
            self.calories = calories
        } else {
            self.calories = 0
        }
        if let drinks = aDecoder.decodeObject(forKey: "drinks") as? [Int:Int]{
            self.drinks = drinks
        } else {
            self.drinks = [:]
        }
        if let firstLaunchToday = aDecoder.decodeBool(forKey: "firstLaunchToday") as? Bool{
            self.firstLaunchToday = firstLaunchToday
        } else {
            self.firstLaunchToday = true
        }
        super.init()
    }
}

class RecordMonth : NSObject, NSCoding {
    var thisMonth: Day
    var isDaysOfMonthEnabled: Bool
    var isStreakOfMonthEnabled: Bool
    var isCaloriesOfMonthEnabled: Bool
    var isCurrentExpenseEnabled: Bool
    var firstLaunchMonth: Bool = true
    var goal_DaysOfMonth: Int? //총 마신 날
    var goal_StreakOfMonth: Int? //연속으로 마신 날
    var goal_CaloriesOfMonth: Int? //칼로리 목표
    var goal_TotalExpense: Int? //총 지출액
    
    init(thisMonth : Day, isDaysOfMonthEnabled: Bool, isStreakOfMonthEnabled: Bool, isCaloriesOfMonthEnabled: Bool, isCurrentExpenseEnabled: Bool) {
        self.thisMonth = thisMonth
        self.isDaysOfMonthEnabled = isDaysOfMonthEnabled
        self.isStreakOfMonthEnabled = isStreakOfMonthEnabled
        self.isCurrentExpenseEnabled = isCurrentExpenseEnabled
        self.isCaloriesOfMonthEnabled = isCaloriesOfMonthEnabled
    }
    
    public func encode(with aCoder:NSCoder) {
        aCoder.encode(self.thisMonth, forKey: "thisMonth")
        aCoder.encode(self.isDaysOfMonthEnabled, forKey: "isDaysOfMonthEnabled")
        aCoder.encode(self.isStreakOfMonthEnabled, forKey: "isStreakOfMonthEnabled")
        aCoder.encode(self.isCaloriesOfMonthEnabled, forKey: "isCaloriesOfMonthEnabled")
        aCoder.encode(self.isCurrentExpenseEnabled, forKey: "isCurrentExpenseEnabled")
        aCoder.encode(self.firstLaunchMonth, forKey: "firstLaunchMonth")
        aCoder.encode(self.goal_DaysOfMonth, forKey: "goal_DaysOfMonth")
        aCoder.encode(self.goal_StreakOfMonth, forKey: "goal_MaxStreakOfMonth")
        aCoder.encode(self.goal_CaloriesOfMonth, forKey: "goal_CaloriesOfMonth")
        aCoder.encode(self.goal_TotalExpense, forKey: "goal_TotalExpense")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let thisMonth = aDecoder.decodeObject(forKey: "thisMonth") as? Day{
            self.thisMonth = thisMonth
        } else {
            self.thisMonth = Day(year: 0, month: 0, day: nil)
        }
        if let isDaysOfMonthEnabled = aDecoder.decodeBool(forKey: "isDaysOfMonthEnabled") as? Bool{
            self.isDaysOfMonthEnabled = isDaysOfMonthEnabled
        } else {
            self.isDaysOfMonthEnabled = false
        }
        if let isStreakOfMonthEnabled = aDecoder.decodeBool(forKey: "isStreakOfMonthEnabled") as? Bool{
            self.isStreakOfMonthEnabled = isStreakOfMonthEnabled
        } else {
            self.isStreakOfMonthEnabled = false
        }
        if let isCaloriesOfMonthEnabled = aDecoder.decodeBool(forKey: "isCaloriesOfMonthEnabled") as? Bool{
            self.isCaloriesOfMonthEnabled = isCaloriesOfMonthEnabled
        } else {
            self.isCaloriesOfMonthEnabled = false
        }
        if let isCurrentExpenseEnabled = aDecoder.decodeBool(forKey: "isCurrentExpenseEnabled") as? Bool{
            self.isCurrentExpenseEnabled = isCurrentExpenseEnabled
        } else {
            self.isCurrentExpenseEnabled = false
        }
        if let firstLaunchMonth = aDecoder.decodeBool(forKey: "firstLaunchMonth") as? Bool{
            self.firstLaunchMonth = firstLaunchMonth
        } else {
            self.firstLaunchMonth = true
        }
        if let goal_DaysOfMonth = aDecoder.decodeObject(forKey: "goal_DaysOfMonth") as? Int{
            self.goal_DaysOfMonth = goal_DaysOfMonth
        } else {
            self.goal_DaysOfMonth = 0
        }
        if let goal_StreakOfMonth = aDecoder.decodeObject(forKey: "goal_MaxStreakOfMonth") as? Int{
            self.goal_StreakOfMonth = goal_StreakOfMonth
        } else {
            self.goal_StreakOfMonth = 0
        }
        if let goal_CaloriesOfMonth = aDecoder.decodeObject(forKey: "goal_CaloriesOfMonth") as? Int{
            self.goal_CaloriesOfMonth = goal_CaloriesOfMonth
        } else {
            self.goal_CaloriesOfMonth = 0
        }
        if let goal_TotalExpense = aDecoder.decodeObject(forKey: "goal_TotalExpense") as? Int{
            self.goal_TotalExpense = goal_TotalExpense
        } else {
            self.goal_TotalExpense = 0
        }
        super.init()
    }
}

class UserSetting : NSObject, NSCoding {
    var favorites: [Int] = []
    var succeededLastMonth = false
    
    var adIsOff: Bool?
    var newSul: [Sul] = []
    var firstLaunch: Bool = true
    var showYesterdayFirst = true
    var isVibrationEnabled = true
    var isThemeBright = false
    var isShowDrunkDaysEnabled = true
    //    var maxBottlesPerSul: [Int:Int]? //술 종류당 한도 병 수
    
    init(adIsOff: Bool) {
        self.adIsOff = adIsOff
    }
    
    public func encode(with aCoder:NSCoder) {
        aCoder.encode(self.favorites, forKey: "favorites")
        aCoder.encode(self.succeededLastMonth, forKey: "succeededLastMonth")
        
        aCoder.encode(self.adIsOff, forKey: "adIsOff")
        aCoder.encode(self.newSul, forKey: "newSul")
        aCoder.encode(self.firstLaunch, forKey: "firstLaunch")
        aCoder.encode(self.showYesterdayFirst, forKey: "showYesterdayFirst")
        aCoder.encode(self.isVibrationEnabled, forKey: "isVibrationEnabled")
        aCoder.encode(self.isThemeBright, forKey: "isThemeBright")
        aCoder.encode(self.isShowDrunkDaysEnabled, forKey: "isShowDrunkDaysEnabled")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let favorites = aDecoder.decodeObject(forKey: "favorites") as? [Int]{
            self.favorites = favorites
        } else {
            self.favorites = []
        }
        if let succeededLastMonth = aDecoder.decodeBool(forKey: "succeededLastMonth") as? Bool{
            self.succeededLastMonth = succeededLastMonth
        } else {
            self.succeededLastMonth = false
        }
        
        if let adIsOff = aDecoder.decodeObject(forKey: "adIsOff") as? Bool{
            self.adIsOff = adIsOff
        } else {
            self.adIsOff = false
        }
        if let newSul = aDecoder.decodeObject(forKey: "newSul") as? [Sul]{
            self.newSul = newSul
        } else {
            self.newSul = []
        }
        if let firstLaunch = aDecoder.decodeBool(forKey: "firstLaunch") as? Bool{
            self.firstLaunch = firstLaunch
        } else {
            self.firstLaunch = true
        }
        if let showYesterdayFirst = aDecoder.decodeBool(forKey: "showYesterdayFirst") as? Bool{
            self.showYesterdayFirst = showYesterdayFirst
        } else {
            self.showYesterdayFirst = true
        }
        if let isVibrationEnabled = aDecoder.decodeBool(forKey: "isVibrationEnabled") as? Bool{
            self.isVibrationEnabled = isVibrationEnabled
        } else {
            self.isVibrationEnabled = true
        }
        if let isThemeBright = aDecoder.decodeBool(forKey: "isThemeBright") as? Bool{
            self.isThemeBright = isThemeBright
        } else {
            self.isThemeBright = false
        }
        if let isShowDrunkDaysEnabled = aDecoder.decodeBool(forKey: "isShowDrunkDaysEnabled") as? Bool{
            self.isShowDrunkDaysEnabled = isShowDrunkDaysEnabled
        } else {
            self.isShowDrunkDaysEnabled = true
        }
        super.init()
    }
}

//class CurrentGoalStatus {
//    var thisMonth: Day
//    var daysOfMonth: Int? //총 마신 날
//    var streakOfMonth: Int? //연속으로 마신 날
//    var caloriesOfMonth: Int? //칼로리 목표
//    var currentExpense: Int? //총 지출액
//    //    var BottlePerSul: [Int:Int]? //술 종류당 한도 병 수
//    init(thisMonth: Day, daysOfMonth: Int?, streakOfMonth: Int?, caloriesOfMonth: Int?, currentExpense: Int?) {
//        self.thisMonth = thisMonth
//        if let daysOfMon = daysOfMonth {
//            self.daysOfMonth = daysOfMon
//        }
//        if let streakOfMon = streakOfMonth {
//            self.streakOfMonth = streakOfMon
//        }
//        if let caloriesOfMon = caloriesOfMonth {
//            self.caloriesOfMonth = caloriesOfMon
//        }
//        if let currentExp = currentExpense {
//            self.currentExpense = currentExp
//        }
//    }
//}

class Sul : NSObject, NSCoding  {
    var displayName: String
    var baseCalorie: Int //단위 당 kcal (예 : 소주 = 300)
    var basePrice: Int
    var colorTag: String //컬러 코드에 # 포함 (예: "#FFFFFF")
    var unit: String
    var enabled: Bool = true
    
    init(displayName: String, baseCalorie: Int, basePrice: Int, colorTag: String, unit: String) {
        self.displayName = displayName
        self.baseCalorie = baseCalorie
        self.basePrice = basePrice
        self.colorTag = colorTag
        self.unit = unit
    }
    
    public func encode(with aCoder:NSCoder) {
        aCoder.encode(self.displayName, forKey: "displayName")
        aCoder.encode(self.baseCalorie, forKey: "baseCalorie")
        aCoder.encode(self.basePrice, forKey: "basePrice")
        aCoder.encode(self.colorTag, forKey: "colorTag")
        aCoder.encode(self.unit, forKey: "unit")
        aCoder.encode(self.enabled, forKey: "enabled")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        if let displayName = aDecoder.decodeObject(forKey: "displayName") as? String{
            self.displayName = displayName
        } else {
            self.displayName = " "
        }
        if let baseCalorie = aDecoder.decodeInteger(forKey: "baseCalorie") as? Int{
            self.baseCalorie = baseCalorie
        } else {
            self.baseCalorie = 0
        }
        if let basePrice = aDecoder.decodeInteger(forKey: "basePrice") as? Int{
            self.basePrice = basePrice
        } else {
            self.basePrice = 0
        }
        if let colorTag = aDecoder.decodeObject(forKey: "colorTag") as? String{
            self.colorTag = colorTag
        } else {
            self.colorTag = " "
        }
        if let unit = aDecoder.decodeObject(forKey: "unit") as? String{
            self.unit = unit
        } else {
            self.unit = " "
        }
        if let enabled = aDecoder.decodeBool(forKey: "enabled") as? Bool{
            self.enabled = enabled
        } else {
            self.enabled = false
        }
        super.init()
    }
}

