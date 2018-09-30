//데이터의 연산 - 함수
import Foundation

var sul = dataCentre.sul


//getRecordDay(day: Day) -> RecordDay    day: Day    RecordDay    Day를 드리면 그 날에 해당하는 RecordDay를 리턴

var recordDayList:[RecordDay] = []

func addNewRecordDay(newRecordDay: RecordDay){
    recordDayList.append(newRecordDay)
}

func getRecordDay(day: Day) -> RecordDay{
    if recordDayList.isEmpty {
        let firstRecordDay:RecordDay = RecordDay(today: dateToDayConverter(date: Date()), location: [], friends: [], expense: 0, customExpense: nil, calories: 0, drinks: [:])
        addNewRecordDay(newRecordDay: firstRecordDay)
        return firstRecordDay
    } else {
        for i in 0...recordDayList.count - 1 {
            if recordDayList[i].today.year == day.year
                ,recordDayList[i].today.month == day.month
                ,recordDayList[i].today.day == day.day{
                return recordDayList[i]
            }
        }
        let defaultRecordDay:RecordDay = RecordDay(today: day, location: [], friends: [], expense: 0, customExpense: nil, calories: 0, drinks: [:])
        addNewRecordDay(newRecordDay: defaultRecordDay)
        return defaultRecordDay
    }
}


//getRecordMonth(month: Day) -> RecordMonth    month: Day(day가 nil)    RecordMonth    Day를 드리면 그 달에 해당하는 RecordMonth를 리턴

var recordMonthList:[RecordMonth] = []

func addNewRecordMonth(newRecordMonth: RecordMonth){
    recordMonthList.append(newRecordMonth)
}

func transferGoalFromLastRecordMonth(){
    let newRecordMonth = getRecordMonth(month: dateToMonthConverter(date: Date()))
    var month = dateToMonthConverter(date: Date()).month - 1
    var year = dateToMonthConverter(date: Date()).year
    if(month == 0){
        year -= 1
        month = 12
    }
    let lastMonth = getRecordMonth(month: Day(year: year, month: month, day: nil))
    newRecordMonth.goal_DaysOfMonth = lastMonth.goal_DaysOfMonth
    newRecordMonth.goal_TotalExpense = lastMonth.goal_TotalExpense
    newRecordMonth.goal_StreakOfMonth = lastMonth.goal_StreakOfMonth
    newRecordMonth.goal_CaloriesOfMonth = lastMonth.goal_CaloriesOfMonth
    newRecordMonth.isDaysOfMonthEnabled = lastMonth.isDaysOfMonthEnabled
    newRecordMonth.isStreakOfMonthEnabled = lastMonth.isStreakOfMonthEnabled
    newRecordMonth.isCurrentExpenseEnabled = lastMonth.isCurrentExpenseEnabled
    newRecordMonth.isCaloriesOfMonthEnabled = lastMonth.isCaloriesOfMonthEnabled
}

func getRecordMonth(month: Day) -> RecordMonth{
    if recordMonthList.isEmpty {
        let firstRecordMonth:RecordMonth = RecordMonth(thisMonth: month, isDaysOfMonthEnabled: false, isStreakOfMonthEnabled: false, isCaloriesOfMonthEnabled: false, isCurrentExpenseEnabled: false)
        addNewRecordMonth(newRecordMonth: firstRecordMonth)
        return firstRecordMonth
    }
    else {
        for i in 0...recordMonthList.count - 1 {
            if recordMonthList[i].thisMonth.year == month.year
                ,recordMonthList[i].thisMonth.month == month.month{
                return recordMonthList[i]
            }
            
        }
        let defaultRecordMonth:RecordMonth = RecordMonth(thisMonth: month, isDaysOfMonthEnabled: false, isStreakOfMonthEnabled: false, isCaloriesOfMonthEnabled: false, isCurrentExpenseEnabled: false)
        addNewRecordMonth(newRecordMonth: defaultRecordMonth)
        return defaultRecordMonth
    }
}

//getRecordDayBottles(day: Day, index: Int) -> Int    day: 지정한 날짜, index: 술의 인덱스    Int(몇 병 마셨는지)    Day와 인덱스를 드리면 그 날 인덱스에 해당하는 술을 몇 병 마셨는지 정수로 리턴

func getRecordDayBottles(day: Day, index : Int) -> Int?{
    let recordDay = getRecordDay(day: day)
    
    guard let drinks = recordDay.drinks else{
        return 0
    }
    return drinks[index]
}

//setRecordDayForSul(index: Int, bottles: Int)    index: 술의 인덱스, bottles: 그 술의 병 수
//인덱스에 해당하는 술을 몇 병 마셨는지 설정하는 함수입니다. 설정되면 RecordDay의 expense, calories, drinks가 업데이트돼야 합니다. 그에 따라 RecordDay도...

//// 얘가 젤 문제

func setRecordDayForSul(day: Day, index: Int, bottles: Int){
    //     print(recordDay?.drinks)
    
    
    //        if getRecordDay(day: day)?.drinks != nil  {
    //            getRecordDay(day: day)?.drinks = getRecordDay(day: day)?.drinks
    //            //      print(recordDay?.drinks)
    //        }else {
    //            getRecordDay(day: day)?.drinks = [:]
    //        }
    getRecordDay(day: day).drinks![index] = bottles
    
    
    //익스펜스랑 칼로리는 그냥 위에 어레이만 잘 되면 그냥 그냥 함수로 그냥그냥 하면 해결될듯!
    
    var arrayOfGetRecordDay:[Int] = []
    var expenseSum = 0
    var calorySum = 0
    
    if let getre = getRecordDay(day: day).drinks?.keys{
        arrayOfGetRecordDay += getre
    }
    
    if((getRecordDay(day: day).drinks?.count)! != 0){
        for i in 0...(getRecordDay(day: day).drinks?.count)! - 1 {
            expenseSum += sul[arrayOfGetRecordDay[i]].basePrice * (getRecordDay(day: day).drinks![arrayOfGetRecordDay[i]])!
        }
    }
    getRecordDay(day: day).expense = expenseSum
    
    if(getRecordDay(day: day).drinks?.count != 0){
        for i in 0...(getRecordDay(day: day).drinks?.count)! - 1 {
            calorySum += sul[arrayOfGetRecordDay[i]].baseCalorie * (getRecordDay(day: day).drinks![arrayOfGetRecordDay[i]])!
        }
    }
    getRecordDay(day: day).calories = calorySum
}



//setRecordDayCustomExpense(day: Day, customExpense: Int)    day: 지정한 날짜, customExpense: 사용자가 직접 입력한 지출액        Day에 해당하는 RecordDay의 customExpense를 설정합니다.

func setRecordDayCustomExpense(day: Day, customExpense: Int?){
    getRecordDay(day: day).customExpense = customExpense
}

/*
 //getFavoriteSul() -> [Int]        [Int](즐겨찾기한 술 인덱스의 배열)    즐겨찾기로 설정된 술 인덱스의 배열을 반환(UserData - favorites)
 */
// userSetting 의 초기화 값이 있어야 활성화가 되서


func getFavouriteSulIndex() -> [Int]{
    var returnArray: [Int] = []
    for index in userSetting.favorites{
        if(sul[index].enabled){
            returnArray.append(index)
        }
    }
    return returnArray
}

func getDeletedSulIndex() -> [Int]{
    var returnArray: [Int] = []
    for i in 0...sul.count - 1{
        if(!sul[i].enabled){
            returnArray.append(i)
        }
    }
    return returnArray
}

func getDeletedSulTotalCalorieForDay(day: Day) -> Int{
    let k = getDeletedSulIndex()
    var returnValue = 0
    for i in k{
        returnValue += getRecordDayBottles(day: day, index: i) ?? 0
    }
    return returnValue
}
//setRecordDayLocation(day: Day, location: String)    day: 지정한 날짜, location: 장소 문자열        location을 해당 RecordDay에 저장해주세요!

func setRecordDayLocation(day: Day, location: [String]?){
    getRecordDay(day: day).location = location
}


//setRecordDayFriends(day:Day, friends: [String]    day: 지정한 날짜, friends: 친구들의 배열        friends를 해당 RecordDay에 저장해주세요!

func setRecordDayFriends(day:Day, friends: [String]?){
    getRecordDay(day: day).friends = friends
}


//getRecordDayCalorie(day: Day) -> Int    day: Day    Int(오늘의 칼로리)    오늘 칼로리를 반환
//성공
func getRecordDayCalorie(day: Day) -> Int?{
    if let kcal = getRecordDay(day: day).calories {
        return kcal
    }
    return 0
}



func getRecordMonthBestFriends(month: Day) -> [[String: Int]?]?{
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    
    let count = recordDayList.count - 1
    
    var thisMonth:[String] = []
    
    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
                // force unwrapping을 하긴 햇는데 불안함.
                if let recordList = recordDayList[i].friends {
                    thisMonth += recordList
                }
            }
        }
    }
    
    var drinkWhoAndTimes:[String : Int] = [:]
    
    for word in thisMonth {
        if drinkWhoAndTimes[word] == nil {
            drinkWhoAndTimes[word] = 1
        } else {
            drinkWhoAndTimes[word]! += 1
        }
    }
    let sortedMonthWithWho = drinkWhoAndTimes.sorted(by: {$0.1 > $1.1})
    
    var topRated:[[String:Int]?] = []
    
    let count1 = sortedMonthWithWho.count
    if(count1 == 0){
        return topRated
    }
    for i in 0...count1 - 1{
        if(i==3){
            break
        }
        topRated.append([sortedMonthWithWho[i].key :sortedMonthWithWho[i].value])
    }
    return topRated
}

func getRecordMonthAllFriends(month: Day) -> [[String: Int]?]?{
    let count = recordDayList.count - 1
    var thisMonth:[String] = []
    
    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
                // force unwrapping을 하긴 햇는데 불안함.
                if let recordList = recordDayList[i].friends {
                    thisMonth += recordList
                }
            }
        }
    }
    
    var drinkWhoAndTimes:[String : Int] = [:]
    
    for word in thisMonth {
        if drinkWhoAndTimes[word] == nil {
            drinkWhoAndTimes[word] = 1
        } else {
            drinkWhoAndTimes[word]! += 1
        }
    }
    
    let sortedMonthWithWho = drinkWhoAndTimes.sorted(by: {$0.1 > $1.1})
    var topRated:[[String:Int]?] = []
    let count1 = sortedMonthWithWho.count
    if(count1 == 0){
        return topRated
    }
    for i in 0...count1 - 1{
        topRated.append([sortedMonthWithWho[i].key :sortedMonthWithWho[i].value])
    }
    return topRated
}

//getRecordMonthBestSul(month: Day) -> [Int:[Int, Int, Int]]    month: Day(day가 nil)    [Int(술의 인덱스):[Int(그 술 마시면서 얻은 칼로리):, Int(그 술로 지출한 추정 액수), Int(그 술 몇 번 마셨는지)]]의 배열을 포함한 딕셔너리의 배열    단상 화면에 사용할 용도이므로 탑3만! 디자인 가이드 참고
//이거 하려면 RecordMonth에 [술 인덱스:그 술에 대한 정보] 딕셔너리 배열(3칸짜리)이 추가돼야 합니다.
//'그 술에 대한 정보'의 경우 struct를 하나 더 만드시는 게 좋을 것 같습니다. [Int(그 술 마시면서 얻은 칼로리), Int(그 술로 지출한 추정 액수), Int(그 술 몇 번 마셨는지)]

func monthlyKcalPerSul(month: Day) -> [Int:Int] {
    var dictionary:[Int:Int] = [:]
    let count = recordDayList.count - 1
    var kcal:[[Int:Int]] = []
    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year,
                recordDayList[i].today.month == month.month {
                if let drinks = recordDayList[i].drinks {
                    kcal.append(drinks)
                }
            }
        }
    }
    
    for j in 0...sul.count - 1 {
        var sum: Int = Int()
        for index in kcal{
            if let ind = index[j]{
                sum += ind
            }
        }
        if(sul[j].enabled){
            dictionary[j] = sum * sul[j].baseCalorie
        }
    }
    
    return dictionary
}

func monthlyPricePerSul(month: Day) -> [Int:Int] {
    var dictionary:[Int:Int] = [:]
    let count = recordDayList.count - 1
    var price:[[Int:Int]] = []
    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year,
                recordDayList[i].today.month == month.month {
                if let drinks = recordDayList[i].drinks {
                    price.append(drinks)
                }
            }
        }
    }
    for j in 0...sul.count - 1 {
        var sum: Int = Int()
        for index in price{
            if let ind = index[j]{
                sum += ind
            }
        }
        if(sul[j].enabled){
            dictionary[j] = sum * sul[j].basePrice
        }
    }
    
    return dictionary
}

func monthlyBottlesPerSul(month: Day) -> [Int:Int] {
    var dictionary:[Int:Int] = [:]
    let count = recordDayList.count - 1
    var price:[[Int:Int]] = []
    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year,
                recordDayList[i].today.month == month.month {
                if let drinks = recordDayList[i].drinks {
                    price.append(drinks)
                }
            }
        }
    }
    
    for j in 0...sul.count - 1 {
        var sum: Int = Int()
        for index in price {
            if let ind = index[j]{
                sum += ind
            }
            if(sul[j].enabled){
                dictionary[j] = sum
            }
        }
    }
    return dictionary
}

func getRecordMonthBestSul(month: Day) -> [[Int:[Int?]]]? {
    
    
    var kcal = monthlyKcalPerSul(month: month)
    var price = monthlyPricePerSul(month: month)
    var bottles = monthlyBottlesPerSul(month: month)
    
    var dictionary:[[Int:[Int?]]] = []
    
    
    if bottles.isEmpty {
        return []
    } else {
        
        var sort = bottles.sorted(by: {$0.1 > $1.1})

        var array:[Int] = [sort[0].key, sort[1].key, sort[2].key]
        for i in 0...2 {
            dictionary += [[array[i] : [kcal[array[i]], price[array[i]], bottles[array[i]]]]]
            if(bottles[array[i]] == 0){
                dictionary.removeLast()
            }
        }
    }
    
    return dictionary
}

func getRecordMonthAllSul(month: Day) -> [[Int:[Int?]]]? {
    var kcal = monthlyKcalPerSul(month: month)
    var price = monthlyPricePerSul(month: month)
    var bottles = monthlyBottlesPerSul(month: month)
    
    var dictionary:[[Int:[Int?]]] = []
    
    if bottles.isEmpty {
        return []
    } else {
        let sort = bottles.sorted(by: {$0.1 > $1.1})
        var array:[Int] = []
        for item in sort{
            array.append(item.key)
        }
        for item in array {
            dictionary += [[item : [kcal[item], price[item], bottles[item]]]]
            if(bottles[item] == 0){
                dictionary.removeLast()
            }
        }
        return dictionary
    }
}

//getRecordMonthBestLocation(month: Day) -> [String: Int]    month: Day(day가 nil)    [String: 이번 달 가장 많이 마신 장소, Int: 그곳에서 마신 횟수] 최상위 세 곳의 딕셔너리로 만든 배열    단상 화면에 사용할 용도이므로 탑3만! 디자인 가이드 참고

// 탑 3만 가져오는 함수를 추가하면 댈듯
func getRecordMonthBestLocation(month: Day) -> [[String: Int]]?{
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    
    let count = recordDayList.count - 1
    
    var thisMonth:[String] = []
    
    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
                if let recordList = recordDayList[i].location {
                    thisMonth += recordList
                }
            }
        }
    }
    
    var drinkWhereAndTimes:[String : Int] = [:]
    
    for word in thisMonth {
        if drinkWhereAndTimes[word] == nil {
            drinkWhereAndTimes[word] = 1
        } else {
            drinkWhereAndTimes[word]! += 1
        }
    }
    let sortedMonthWhere = drinkWhereAndTimes.sorted(by: {$0.1 > $1.1})
    
    var topRated:[[String:Int]] = []
    
    let count1 = sortedMonthWhere.count - 1
    if count1 == -1 {
        return topRated
    } else if count1 < 2 {
        for i in 0...count1 {
            topRated.append([sortedMonthWhere[i].key :sortedMonthWhere[i].value])
        }
    } else {
        for i in 0...2 {
            topRated.append([sortedMonthWhere[i].key :sortedMonthWhere[i].value])
        }
    }
    
    
    
    return topRated
}

func getRecordMonthAllLocation(month: Day) -> [[String: Int]]?{
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    
    let count = recordDayList.count - 1
    
    var thisMonth:[String] = []
    
    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
                if let recordList = recordDayList[i].location {
                    thisMonth += recordList
                }
            }
        }
    }
    else{
        return []
    }
    
    var drinkWhereAndTimes:[String : Int] = [:]
    
    for word in thisMonth {
        if drinkWhereAndTimes[word] == nil {
            drinkWhereAndTimes[word] = 1
        } else {
            drinkWhereAndTimes[word]! += 1
        }
    }
    let sortedMonthWhere = drinkWhereAndTimes.sorted(by: {$0.1 > $1.1})
    
    var topRated:[[String:Int]] = []
    
    let count1 = sortedMonthWhere.count - 1
    if count1 == -1 {
        return topRated
    }
    else {
        for i in 0...count1 {
            topRated.append([sortedMonthWhere[i].key :sortedMonthWhere[i].value])
        }
    }
    return topRated
}

//getRecordMonthExpense(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 지출액)

func getRecordMonthExpense(month: Day) -> Int?{
    
    let count = recordDayList.count - 1
    
    var thisMonth:[Int] = []

    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
                if recordDayList[i].customExpense == nil || recordDayList[i].customExpense == 0 {
        
                    if let reco = recordDayList[i].expense {
                        thisMonth += [reco]
                    }
                } else {
                    if let reco = recordDayList[i].customExpense {
                        thisMonth += [reco]
                    }
                }
            }
        }
    }
    else{
        return 0
    }

    let sum = thisMonth.reduce(0, {x, y in x+y})
    return sum
}

//getRecordMonthCalorie(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 칼로리)

func getRecordMonthCalorie(month: Day) -> Int?{
    let count = recordDayList.count - 1
    
    var thisMonth:[Int] = []

    if(count != -1){
        for i in 0...count {
            if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
                // force unwrapping을 하긴 햇는데 불안함.
                if let reco = recordDayList[i].calories {
                    thisMonth += [reco]
                }
            }
        }
        let sum = thisMonth.reduce(0, {x, y in x+y})
        return sum
    }
    else{
        return 0
    }
}

//getWeeklyFriend(day: Day) -> [String: Int]    day: Day    [String: 같이 마신 사람, Int: 사람별 횟수] 딕셔너리의 배열    이건 정렬/탑3/선별 등 없이 그냥 주간 데이터 다 던져주시면 됩니다.
func getWeeklyFriend() -> [String: Int] {
    
    var pastfriends:Array<String> = []
    
    
    for i in 0...13  {
        //근 7일이므로 7번 돌린다.
        let pastdays = Calendar.current.date(byAdding: .day, value: -i, to: Date())
//        print(pastdays)
        //돌릴때마다 호출하는 날짜가 하나씩 줄어든다.
        let calendar = Calendar.current
        
        let pastyear = calendar.component(.year, from: pastdays!)
        let pastmonth = calendar.component(.month, from: pastdays!)
        let pastday = calendar.component(.day, from: pastdays!)
        
        
        let newday = Day(year: pastyear, month: pastmonth, day: pastday)
        
        if let abc = getRecordDay(day: newday).friends {
            pastfriends += abc
        }
        //어레이에 날짜에 해당하는 값을 하나씩 넣어준다.
        
    }//포문으로 사람 이름을 다 넣어주는 어레이를 만든다.
    
    let drinkWhoCountindata:Array<String> = pastfriends
    //최근 7일 간 사람이름이 들어있는 변수 생성
    var drinkweeklyWhoAndTimes:[String:Int] = [:]
    //사람이름과 횟수를 넣는 변수 생성
    
    for word in drinkWhoCountindata {
        if drinkweeklyWhoAndTimes[word] == nil {
            drinkweeklyWhoAndTimes[word] = 1
        }
        else {
            drinkweeklyWhoAndTimes[word]! += 1
        }
    }
    
    
    return drinkweeklyWhoAndTimes
}


//getWeeklySul(day: Day) -> [Int: Int]    day: Day    [Int: 마신 술 인덱스, Int: 술별 횟수] 딕셔너리의 배열    이건 정렬/탑3/선별 등 없이 그냥 주간 데이터 다 던져주시면 됩니다.
func getWeeklySul() -> [Int: Int] {
    
    var weeklySulDictionary : [[Int:Int]]? = [[:]]
    var weeklySulSummary : [Int:Int] = [:]
    
    
    
    for i in 0...13  {
        //근 7일이므로 7번 돌린다.
        let pastdays = Calendar.current.date(byAdding: .day, value: -i, to: Date())
   //     print(pastdays)
        //돌릴때마다 호출하는 날짜가 하나씩 줄어든다.
        let calendar = Calendar.current
        
        let pastyear = calendar.component(.year, from: pastdays!)
        let pastmonth = calendar.component(.month, from: pastdays!)
        let pastday = calendar.component(.day, from: pastdays!)
        
        let newday = Day(year: pastyear, month: pastmonth, day: pastday)
        
        if getRecordDay(day: newday).drinks != nil {
            weeklySulDictionary?.append((getRecordDay(day: newday).drinks)!)
        }
        
        
        //     weeklySulDictionary?.append((getRecordDay(day: newday)?.drinks))
        
        //        print(getRecordDay(day: newday)?.drinks)
   //     print (weeklySulDictionary)
    }
  //  print(weeklySulDictionary)
    
    var keyArray:Array<Int> = []
    
    let count = (weeklySulDictionary?.count)!-1
    if(count != -1){
        for j in 0...count {
            keyArray.append(j)
//            keyArray += index[j].keys
        }
        
        let sortedkeyArray = keyArray.sorted(by : >)
        
        
        let largestKeyNumber = sortedkeyArray[0]
        for i in 0...largestKeyNumber{
            var sumofIndexBottleNumber = 0
            for person in weeklySulDictionary!{
                if let indexbottlenumber = person[i]{
                    sumofIndexBottleNumber += indexbottlenumber
                }
            }
            if(sumofIndexBottleNumber != 0){
                weeklySulSummary[i] = sumofIndexBottleNumber
            }
        }
        return weeklySulSummary
    }
    else{
        return [:]
    }
}



//getWeeklyLocation(day: Day) -> [String: Int]    day: Day    [String: 마신 장소, Int: 장소별 횟수] 딕셔너리의 배열    이건 정렬/탑3/선별 등 없이 그냥 주간 데이터 다 던져주시면 됩니다.
func getWeeklyLocation() -> [String: Int] {
    
    var pastlocation:Array<String> = []
    
    
    for i in 0...13  {
        //근 7일이므로 7번 돌린다.
        let pastdays = Calendar.current.date(byAdding: .day, value: -i, to: Date())
   //     print(pastdays)
        //돌릴때마다 호출하는 날짜가 하나씩 줄어든다.
        let calendar = Calendar.current
        
        let pastyear = calendar.component(.year, from: pastdays!)
        let pastmonth = calendar.component(.month, from: pastdays!)
        let pastday = calendar.component(.day, from: pastdays!)
        
        
        let newday = Day(year: pastyear, month: pastmonth, day: pastday)
        
        if let abc = getRecordDay(day: newday).location {
            pastlocation += abc
        }
        //어레이에 날짜에 해당하는 값을 하나씩 넣어준다.
        
    }//포문으로 사람 이름을 다 넣어주는 어레이를 만든다.
    
    let drinkLocationCountindata:Array<String> = pastlocation
    //최근 7일 간 사람이름이 들어있는 변수 생성
    var drinkweeklyLocationAndTimes:[String:Int] = [:]
    //사람이름과 횟수를 넣는 변수 생성
    
    for word in drinkLocationCountindata {
        if drinkweeklyLocationAndTimes[word] == nil {
            drinkweeklyLocationAndTimes[word] = 1
        }
        else {
            drinkweeklyLocationAndTimes[word]! += 1
        }
    }
    
    
    return drinkweeklyLocationAndTimes
}



//getWeeklyExpense(day: Day) -> Int    day: Day    Int(이번 주 사용한 돈)
func getWeeklyExpense() -> Int {
    
    var weeklyExpense : Int = 0
    
    for i in 0...13  {
        //근 7일이므로 7번 돌린다.
        let pastdays = Calendar.current.date(byAdding: .day, value: -i, to: Date())
   //     print(pastdays)
        //돌릴때마다 호출하는 날짜가 하나씩 줄어든다.
        let calendar = Calendar.current
        
        let pastyear = calendar.component(.year, from: pastdays!)
        let pastmonth = calendar.component(.month, from: pastdays!)
        let pastday = calendar.component(.day, from: pastdays!)
        
        
        let newday = Day(year: pastyear, month: pastmonth, day: pastday)
        if let onedayExpense = getRecordDay(day: newday).expense {
            weeklyExpense = weeklyExpense + onedayExpense
        }
        if let onedayCustomExpense = getRecordDay(day: newday).customExpense{
            weeklyExpense = weeklyExpense + onedayCustomExpense
        }
        
        
        
//        print(weeklyExpense)
    }//포문으로  가격을 다 더해준다.
    
    return weeklyExpense
}



//getWeeklyCalorie(day: Day) -> Int    day: Day    Int(이번 주 칼로리)
func getWeeklyCalorie() -> Int {
    var weeklyCalorie : Int = 0
    
    for i in 0...13 {
        let pastdays = Calendar.current.date(byAdding: .day, value: -i, to: Date())
   //     print(pastdays)
        //돌릴때마다 호출하는 날짜가 하나씩 줄어든다.
        let calendar = Calendar.current
        
        let pastyear = calendar.component(.year, from: pastdays!)
        let pastmonth = calendar.component(.month, from: pastdays!)
        let pastday = calendar.component(.day, from: pastdays!)
        
        
        let newday = Day(year: pastyear, month: pastmonth, day: pastday)
        if let onedayCalorie = (getRecordDay(day: newday).calories){
            weeklyCalorie = weeklyCalorie + onedayCalorie
        }
//        print(weeklyCalorie)
    }
    return weeklyCalorie
}


// 목표
//getDaysOfMonthLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 마신 일 수 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

//var currentGoalStatusList:[CurrentGoalStatus] = []
//
//func addNewGoalStatusList(newGoalStatus: CurrentGoalStatus){
//    currentGoalStatusList.append(newGoalStatus)
//}
//
//func getCurrentGoalStatusList(month: Day) -> CurrentGoalStatus?{
//
//    if currentGoalStatusList.isEmpty {
//        let todayGoal = CurrentGoalStatus(thisMonth: dateToMonthConverter(date: Date()), daysOfMonth: 5, streakOfMonth: 5, caloriesOfMonth: 5, currentExpense: 5)
//        addNewGoalStatusList(newGoalStatus: todayGoal)
//        return todayGoal
//    } else {
//    for i in 0...currentGoalStatusList.count - 1 {
//        if currentGoalStatusList[i].thisMonth.year == month.year
//            ,currentGoalStatusList[i].thisMonth.month == month.month{
//            return currentGoalStatusList[i]
//        }
//        }
//        let defaultGoal:CurrentGoalStatus = CurrentGoalStatus(thisMonth: month, daysOfMonth: 0, streakOfMonth: 0, caloriesOfMonth: 0, currentExpense: 0)
//        addNewGoalStatusList(newGoalStatus: defaultGoal)
//        return defaultGoal
//    }
//}


func getDaysOfMonthLimit(month: Day) -> Int{
    guard let daysLimit = getRecordMonth(month: month).goal_DaysOfMonth else{
        return 0
    }
    return daysLimit
}

//getStreakOfMonthLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 연속으로 마신 일 수 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func getStreakOfMonthLimit(month: Day) -> Int{
    guard let streakLimit = getRecordMonth(month: month).goal_StreakOfMonth else{
        return 0
    }
    return streakLimit
}

//getCaloriesOfMonthLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 칼로리 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func getCaloriesOfMonthLimit(month: Day) -> Int{
    guard let caloriesLimit = getRecordMonth(month: month).goal_CaloriesOfMonth else{
        return 0
    }
    return caloriesLimit
}


//getCurrentExpenseLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 지출액 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func getCurrentExpenseLimit(month: Day) -> Int{
    guard let expenseLimit = getRecordMonth(month: month).goal_TotalExpense else{
        return 0
    }
    return expenseLimit
}

//getDaysOfMonthStatus(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 1일부터 오늘까지 마신 일 수)    month가 현재 달보다 이전이면 1일부터 말일까지 합
func getDaysOfMonthStatus(month:Day) -> Int {
    
    let inputMonth = month.month
    //    print(inputMonth)
    let inputYear = month.year
    //   print(inputYear)
    
    var monthDayCount = 0
    
    for i in 1...31  {
        
        let newday = Day(year: inputYear, month: inputMonth, day: i)
        //        print(newday.day)
        let recordMonth = getRecordDay(day: newday)
        //       print(recordMonth)
        if (recordMonth.customExpense != 0 && recordMonth.customExpense != nil) || recordMonth.expense != 0 || (recordMonth.location!.count != 0 && recordMonth.location != nil) || (recordMonth.friends!.count != 0 && recordMonth.friends != nil) {
            monthDayCount += 1
        }
    }
    return monthDayCount
}


//getStreakOfMonthStatus(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 1일부터 오늘까지 마신 연속 일 수 최고기록)    month가 현재 달보다 이전이면 1일부터 말일까지 합산
func getStreakOfMonthStatus(month:Day) -> Int {
    
    let inputMonth = month.month
    let inputYear = month.year
    
    var monthRecordList : [RecordDay?] = []
    
    
    for i in 1...31 {
        let newday = Day(year: inputYear, month: inputMonth, day: i)
        monthRecordList.append(getRecordDay(day: newday))
//        print(monthRecordList)
    }
    let countMonthRecordList = monthRecordList.count - 1
    
    var counting1 = 0
    var steakArray:Array<Int> = []
    
    for i in 0...countMonthRecordList{
        if (monthRecordList[i]?.customExpense != 0 && monthRecordList[i]?.customExpense != nil) || monthRecordList[i]?.expense != 0 || (monthRecordList[i]?.location!.count != 0 && monthRecordList[i]?.location != nil) || (monthRecordList[i]?.friends!.count != 0 && monthRecordList[i]?.friends != nil) {
            counting1 += 1
        }else{
            counting1 = 0
        }
        steakArray += [counting1]
    }
    
//    print(steakArray)
    var sortedSteakArray = steakArray.sorted(by: >)
    
    return sortedSteakArray[0]
}


//getCaloriesOfMonthStatus(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 1일부터 오늘까지의 칼로리)    month가 현재 달보다 이전이면 1일부터 말일까지 합산
func getCaloriesOfMonthStatus(month: Day) -> Int {
    
    let inputMonth = month.month
    //    print(inputMonth)
    let inputYear = month.year
    //   print(inputYear)
    
    let todaycount = 31
    var monthlyCalorySum = 0
    
    for i in 1...todaycount  {
        
        let newday = Day(year: inputYear, month: inputMonth, day: i)
        //        print(newday.day)
        let recordDailyCount = getRecordDay(day: newday).calories
        //       print(recordMonth)
        if recordDailyCount != nil{
            monthlyCalorySum += recordDailyCount!
        }
    }
    return monthlyCalorySum
}


//getCurrentExpenseStatus(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 1일부터 오늘까지 쓴 돈)    month가 현재 달보다 이전이면 1일부터 말일까지 합산

func getCurrentExpenseStatus(month:Day) -> Int {
    let inputMonth = month.month
    //    print(inputMonth)
    let inputYear = month.year
    //   print(inputYear)
    
    let todaycount = 31
    var monthlyExpenseSum = 0
    
    for i in 1...todaycount  {
        
        let newday = Day(year: inputYear, month: inputMonth, day: i)
        //        print(newday.day)
        let recordDailyCount = getRecordDay(day: newday).expense
        let recordDailyCount2 = getRecordDay(day: newday).customExpense
        //       print(recordMonth)
        if recordDailyCount != nil {
            monthlyExpenseSum += recordDailyCount!
        }
        
        if recordDailyCount2 != nil {
            monthlyExpenseSum += recordDailyCount2!
        }
//        print(monthlyExpenseSum)
    }
    return monthlyExpenseSum
}



//isDaysOfMonthEnabled(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지 마신 일 수'가 활성화돼있으면 true, 비활이면 false)    isDaysOfMonthEnabled: Bool를 RecordMonth에 추가해주세요!

//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

////
func isDaysOfMonthEnabled(month: Day) -> Bool {
    return (getRecordMonth(month: month).isDaysOfMonthEnabled)
}

//isStreakOfMonth(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지 마신 연속 일 수 최고기록'이 활성화돼있으면 true, 비활이면 false)    isStreakOfMonth: Bool를 RecordMonth에 추가해주세요!
//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func isStreakOfMonthEnabled(month: Day) -> Bool {
    return (getRecordMonth(month: month).isStreakOfMonthEnabled)
}

//isCaloriesOfMonth(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지의 칼로리'가 활성화돼있으면 true, 비활이면 false)    isCaloriesOfMonth: Bool를 RecordMonth에 추가해주세요!
//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func isCaloriesOfMonthEnabled(month: Day) -> Bool {
    return (getRecordMonth(month: month).isCaloriesOfMonthEnabled)
}

//isCurrentExpense(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지 쓴 돈'이 활성화돼있으면 true, 비활이면 false)    isCurrentExpense: Bool를 RecordMonth에 추가해주세요!
//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func isCurrentExpenseEnabled(month: Day) -> Bool {
    return (getRecordMonth(month: month).isCurrentExpenseEnabled)
}

//setDaysOfMonthLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 마신 일 수 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setDaysOfMonthLimit(month: Day, value: Int) {
    getRecordMonth(month: month).goal_DaysOfMonth = value
}


//setStreakOfMonthLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 연속으로 마신 일 수 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setStreakOfMonthLimit(month: Day, value: Int) {
    getRecordMonth(month: month).goal_StreakOfMonth = value
}

//setCaloriesOfMonthLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 칼로리 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setCaloriesOfMonthLimit(month: Day, value: Int) {
    getRecordMonth(month: month).goal_CaloriesOfMonth = value
}


//setCurrentExpenseLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 지출액 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setCurrentExpenseLimit(month: Day, value: Int) {
    getRecordMonth(month: month).goal_TotalExpense = value
}

func getSulIndexByName(sulName: String) -> Int?{
    let count = sul.count - 1
    for i in 0...count {
        if sul[i].displayName == sulName {
            return i
        }
    }
    return 0
}

func getSulUnit(index : Int) -> String{
    let unit = sul[index].unit
    return unit
}

func setSulUnit(index : Int, unit : String){
    sul[index].unit = unit
}

func addUserSul(newSul : Sul) -> Bool{
    var flag = true
    for i in 0...sul.count - 1 {
        if newSul.displayName == sul[i].displayName {
            if sul[i].enabled {
                flag = false
                break
            }
            else {
                flag = true
            }
        }
    }
    if(flag){
        userSetting.newSul.append(newSul)
        sul.append(newSul)
        return true
    }
    else{
        return false
    }
}
    
//    if userSetting.newSul.isEmpty {
//        userSetting.newSul.append(newSul)
//        sul.append(newSul)
//        return true
//    }
//    else {
//        var flag = true
//        for i in 0...userSetting.newSul.count - 1 {
//            if newSul.displayName == userSetting.newSul[i].displayName {
//                if userSetting.newSul[i].enabled {
//                    flag = false
//                    break
//                }
//                else {
//                    flag = true
//                }
//            }
//        }
//        if(flag){
//            userSetting.newSul.append(newSul)
//            sul.append(newSul)
//            return true
//        }
//        else{
//            return false
//        }
//    }


func getUserSulDictionary() ->[Int:Sul]{
    var userSul: [Int:Sul] = [:]
    //[actual index:Sul]

    if userSetting.newSul.count != 0 {
        for i in 0...userSetting.newSul.count - 1{
            if userSetting.newSul[i].enabled {
                userSul[i] = userSetting.newSul[i]
                }
            }
        }
    return userSul
}

func setAdIsOff(adIsOff: Bool){
    userSetting.adIsOff = adIsOff
}

func setFavouriteSul(index: Int, set: Bool){
    userSetting.favorites = Array(Set(userSetting.favorites).subtracting(Set([index])))
    if(set){
        userSetting.favorites.insert(index, at:0)
    }
}

func setSulDisabled(index : Int){
    if userSetting.newSul.count != 0 {
    userSetting.newSul[index].enabled = false
    }
}

func setFirstLaunchTodayFalse(){
    getRecordDay(day: dateToDayConverter(date: Date())).firstLaunchToday = false
}

func setFirstLaunchMonthFalse(){
    getRecordMonth(month: dateToMonthConverter(date: Date())).firstLaunchMonth = false
}

func isFirstLaunchToday() -> Bool{
    return getRecordDay(day: dateToDayConverter(date: Date())).firstLaunchToday
}

func isFirstLaunchMonth() -> Bool{
    return getRecordMonth(month: dateToMonthConverter(date: Date())).firstLaunchMonth
}

func setFirstLaunchFalse(){
    userSetting.firstLaunch = false
}

func setShowYesterdayFirst(yesterday : Bool) {
    userSetting.showYesterdayFirst = yesterday
}

func getShowYesterdayFirst() -> Bool{
    let yesterday = userSetting.showYesterdayFirst
    return yesterday
}

func getSulDictionary() -> [Int:Sul]{
    var enabledSul:[Int:Sul] = [:]
    for i in 0...sul.count - 1 {
        if sul[i].enabled == true {
            enabledSul[i] = sul[i]
        }
    }
    return enabledSul
}

func setDaysOfMonthEnabled(enabled: Bool){
    getRecordMonth(month: dateToDayConverter(date: Date())).isDaysOfMonthEnabled = enabled
}

func setStreakOfMonthEnabled(enabled: Bool){
    getRecordMonth(month: dateToDayConverter(date: Date())).isStreakOfMonthEnabled = enabled
}

func setCaloriesOfMonthEnabled(enabled: Bool){
    getRecordMonth(month: dateToDayConverter(date: Date())).isCaloriesOfMonthEnabled = enabled
}

func setCurrentExpenseEnabled(enabled: Bool){
    getRecordMonth(month: dateToDayConverter(date: Date())).isCurrentExpenseEnabled = enabled
}

func isShowDrunkDaysEnabled() -> Bool{
    return userSetting.isShowDrunkDaysEnabled
}
func setIsShowDrunkDays(enabled: Bool){
    userSetting.isShowDrunkDaysEnabled = enabled
}


func getAllDrunkDays() -> [Day] {
    var getAllDrunkDaysArray:[Day] = []
    
    if(recordDayList.count != 0){
        for i in 0...recordDayList.count - 1  {
            if (recordDayList[i].customExpense != 0 && recordDayList[i].customExpense != nil) || recordDayList[i].expense != 0 || (recordDayList[i].location!.count != 0 && recordDayList[i].location != nil) || (recordDayList[i].friends!.count != 0 && recordDayList[i].friends != nil) {
                getAllDrunkDaysArray += [recordDayList[i].today]
            }
        }
    }
    return getAllDrunkDaysArray
}

func removeEmptyDays(){
    
    for item in recordDayList{
        if (item.customExpense != 0 && item.customExpense != nil) || item.expense != 0 || (item.location!.count != 0 && item.location != nil) || (item.friends!.count != 0 && item.friends != nil) {}
        else{
            recordDayList = recordDayList.filter { $0 != item }
        }
    }
}


/////// 아카이빙 함수

func saveRecordDayList() {
    let filePath = getFilePath(withFileName: "RecordDay.dat")
    NSKeyedArchiver.archiveRootObject(recordDayList, toFile: filePath)
}

func saveRecordMonthList() {
    let filePath = getFilePath(withFileName: "RecordMonth.dat")
    NSKeyedArchiver.archiveRootObject(recordMonthList, toFile: filePath)
}

func saveUserData() {
    let filePath = getFilePath(withFileName: "UserSetting.dat")
    NSKeyedArchiver.archiveRootObject(userSetting, toFile: filePath)
}

func loadRecordDayList() {
    let filePath = getFilePath(withFileName: "RecordDay.dat")
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath) {
        if let savedRecordDayList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [RecordDay] {
            recordDayList = savedRecordDayList
        }
    }
}

func loadRecordMonthList() {
    let filePath = getFilePath(withFileName: "RecordMonth.dat")
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath) {
        if let savedRecordMonthList = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [RecordMonth] {
            recordMonthList = savedRecordMonthList
        }
    }
}

func loadUserData() {
    let filePath = getFilePath(withFileName: "UserSetting.dat")
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath) {
        if let savedUserData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserSetting {
            userSetting = savedUserData
        }
    }
}

func getFilePath(withFileName fileName:String) -> String{
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    let docDir = dirPath[0] as NSString
    
    let filePath = docDir.appendingPathComponent(fileName)
    return filePath
}

func resetApp(){
    recordDayList.removeAll()
    recordMonthList.removeAll()
    sul.removeAll()
    sul.append(Sul(displayName: "소주", baseCalorie: 300, basePrice: 4000, colorTag: "#FFFFFF", unit: "병"))
    sul.append(Sul(displayName: "소주 잔", baseCalorie: 50, basePrice: 650, colorTag: "FFFFFF", unit: "잔"))
    sul.append(Sul(displayName: "병맥주 330ml", baseCalorie: 122, basePrice: 2000, colorTag: "#FFFFFF", unit: "병"))
    sul.append(Sul(displayName: "병맥주 500ml", baseCalorie: 185, basePrice: 3000, colorTag: "#FFFFFF", unit: "병"))
    sul.append(Sul(displayName: "생맥주 500cc", baseCalorie: 185, basePrice: 4000, colorTag: "#FFFFFF", unit: "잔"))
    sul.append(Sul(displayName: "캔맥주 355ml", baseCalorie: 152, basePrice: 2000, colorTag: "FFFFFFF", unit: "캔"))
    sul.append(Sul(displayName: "레드와인 잔", baseCalorie: 84, basePrice: 12000, colorTag: "FFFFFF", unit: "잔"))
    sul.append(Sul(displayName: "화이트와인 잔", baseCalorie: 74, basePrice: 12000, colorTag: "FFFFFF", unit: "잔"))
    sul.append(Sul(displayName: "막걸리", baseCalorie: 345, basePrice: 2000, colorTag: "FFFFFF", unit: "병"))
    userSetting = UserSetting(adIsOff: false)
    rootViewDelegate?.showAd(true)
    setFirstLaunchMonthFalse()
    setFirstLaunchTodayFalse()
    setFirstLaunchFalse()
}

func getAdIsOff() -> Bool{
    if(userSetting.adIsOff == nil){
        print("///forced false")
        return false
    }
    else{
        return userSetting.adIsOff!
//        return false //remove before release
    }
}
