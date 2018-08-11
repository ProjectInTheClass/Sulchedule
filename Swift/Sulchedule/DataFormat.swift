//데이터 형식

import Foundation

class Day {
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
}

class RecordDay {
    var today: Day
    
    var location: [String]?
    var friends:[String]?
    var expense: Int? //값을 입력하지 않은 경우 사용
    var customExpense: Int? //값을 입력한 경우 사용
    var calories: Int?
    
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
}

class RecordMonth {
    var thisMonth: Day
    var bestLocation: String?
    var bestFriend: String?
    var totalExpense: Int?
    var totalCalories: Int?
    var isDaysOfMonthEnabled: Bool
    var isStreakOfMonth: Bool
    var isCaloriesOfMonth: Bool
    var isCurrentExpense: Bool
    
    init(thisMonth : Day, bestLocation: String?, bestFriend: String?, totalExpense: Int?, totalCalories: Int?, isDaysOfMonthEnabled: Bool, isStreakOfMonth: Bool, isCaloriesOfMonth: Bool, isCurrentExpense: Bool) {
        self.thisMonth = thisMonth
        if let bestLoca = bestLocation {
            self.bestLocation = bestLoca
        }
        if let bestFri = bestFriend {
            self.bestFriend = bestFri
        }
        if let totalExp = totalExpense {
            self.totalExpense = totalExp
        }
        if let totalCal = totalCalories {
            self.totalCalories = totalCal
        }
        self.isDaysOfMonthEnabled = isDaysOfMonthEnabled
        self.isStreakOfMonth = isStreakOfMonth
        self.isCurrentExpense = isCurrentExpense
        self.isCaloriesOfMonth = isCaloriesOfMonth
    }
}

class UserData {
    var dangerLevel: Int? //0:초록, 1:노랑, 2:빨강
    var favorites: [Int]? //index
    var succeededLastMonth: Bool
    
    var goal_maxDaysOfMonth: Int? //총 마신 날
    var maxStreakOfMonth: Int? //연속으로 마신 날
    var maxCaloriesOfMonth: Int? //칼로리 목표
    var totalExpense: Int? //총 지출액
    var purchased: Bool
    var newSul: [Sul] = []
    //    var maxBottlesPerSul: [Int:Int]? //술 종류당 한도 병 수
    
    init(dangerLever : Int?, favorites: [Int]?, succeededLastMonth: Bool, goal_maxDaysOfMonth: Int?, maxStreakOfMonth: Int?, maxCaloriesOfMonth: Int?, totalExpense: Int?, purchased: Bool) {
        if let dangerLev = dangerLever {
            self.dangerLevel = dangerLev
        }
        if let favo = favorites {
            self.favorites = favo
        }
        self.succeededLastMonth = succeededLastMonth
        
        if let goal = goal_maxDaysOfMonth {
            self.goal_maxDaysOfMonth = goal
        }
        if let maxStreak = maxStreakOfMonth {
            self.maxStreakOfMonth = maxStreak
        }
        if let maxKcal = maxCaloriesOfMonth {
            self.maxCaloriesOfMonth = maxKcal
        }
        if let totalExp = totalExpense {
            self.totalExpense = totalExp
        }
        self.purchased = purchased
    }
}

class CurrentGoalStatus {
    var thisMonth: Day
    var daysOfMonth: Int? //총 마신 날
    var streakOfMonth: Int? //연속으로 마신 날
    var caloriesOfMonth: Int? //칼로리 목표
    var currentExpense: Int? //총 지출액
    //    var BottlePerSul: [Int:Int]? //술 종류당 한도 병 수
    init(thisMonth: Day, daysOfMonth: Int?, streakOfMonth: Int?, caloriesOfMonth: Int?, currentExpense: Int?) {
        self.thisMonth = thisMonth
        if let daysOfMon = daysOfMonth {
            self.daysOfMonth = daysOfMon
        }
        if let streakOfMon = streakOfMonth {
            self.streakOfMonth = streakOfMon
        }
        if let caloriesOfMon = caloriesOfMonth {
            self.caloriesOfMonth = caloriesOfMon
        }
        if let currentExp = currentExpense {
            self.currentExpense = currentExp
        }
    }
}

class Sul {
    var displayName: String
    var baseCalorie: Int //단위 당 kcal (예 : 소주 = 300)
    var basePrice: Int
    var colorTag: String //컬러 코드에 # 포함 (예: "#FFFFFF")
    var type: String
    
    init(displayName: String, baseCalorie: Int, basePrice: Int, colorTag: String, type: String) {
        self.displayName = displayName
        self.baseCalorie = baseCalorie
        self.basePrice = basePrice
        self.colorTag = colorTag
        self.type = type
    }
}
