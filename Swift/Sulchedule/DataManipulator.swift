
//데이터의 연산 - 함수

import Foundation

var sul = dataCentre.sul


//getRecordDay(day: Day) -> RecordDay    day: Day    RecordDay    Day를 드리면 그 날에 해당하는 RecordDay를 리턴

var recordDayList:[RecordDay] = []

func addNewRecordDay(newRecordDay: RecordDay){
    recordDayList.append(newRecordDay)
}

func getRecordDay(day: Day) -> RecordDay?{
    if recordDayList.count == 0 {
        return nil
    } else {
        for i in 0...recordDayList.count - 1 {
            if recordDayList[i].today.year == day.year
                ,recordDayList[i].today.month == day.month
                ,recordDayList[i].today.day == day.day{
                return recordDayList[i]
            } else {
                var defalutRecordDay:RecordDay = RecordDay(today: day, location: nil, friends: nil, expense: nil, customExpense: nil, calories: nil, drinks: nil)
                return defalutRecordDay
            }
        }
        return nil
    }
}


//getRecordMonth(month: Day) -> RecordMonth    month: Day(day가 nil)    RecordMonth    Day를 드리면 그 달에 해당하는 RecordMonth를 리턴

var recordMonthList:[RecordMonth] = []

func addNewRecordMonth(newRecordMonth: RecordMonth){
    recordMonthList.append(newRecordMonth)
}

func getRecordMonth(day: Day) -> RecordMonth?{
    if recordMonthList.count == 0 {
        return nil
    } else {
        for i in 0...recordMonthList.count - 1 {
            if recordMonthList[i].thisMonth.year == day.year
                ,recordMonthList[i].thisMonth.month == day.month{
                return recordMonthList[i]
            } else {
                var defalutRecordMonth:RecordMonth = RecordMonth(thisMonth: day, bestLocation: nil, bestFriend: nil, totalExpense: nil, totalCalories: nil, isDaysOfMonthEnabled: false, isStreakOfMonth: false, isCaloriesOfMonth: false, isCurrentExpense: false)
                return defalutRecordMonth
            }
        }
        return nil
    }
}

//getRecordDayBottles(day: Day, index: Int) -> Int    day: 지정한 날짜, index: 술의 인덱스    Int(몇 병 마셨는지)    Day와 인덱스를 드리면 그 날 인덱스에 해당하는 술을 몇 병 마셨는지 정수로 리턴

func getRecordDayBottles(day: Day, index : Int) -> Int?{
    var recordDay = getRecordDay(day: day)
    
    if let drinks = recordDay?.drinks {
        return (drinks[index])!
    }else{
        return nil
    }
}

//setRecordDayForSul(index: Int, bottles: Int)    index: 술의 인덱스, bottles: 그 술의 병 수
//인덱스에 해당하는 술을 몇 병 마셨는지 설정하는 함수입니다. 설정되면 RecordDay의 expense, calories, drinks가 업데이트돼야 합니다. 그에 따라 RecordDay도...

//// 얘가 젤 문제

func setRecordDayForSul(day: Day, index: Int, bottles: Int) {
    var recordDay = getRecordDay(day: day)
    // 드링크 딕셔너리에 값이 추가가 안됨
    recordDay?.drinks = [index : bottles]
    //익스펜스랑 칼로리는 그냥 위에 어레이만 잘 되면 그냥 그냥 함수로 그냥그냥 하면 해결될듯!
    recordDay?.expense = sul[index].basePrice * bottles
    recordDay?.calories = sul[index].baseCalorie * bottles
}

//        let setRecord = setRecordDayForSul(day: Day(year: 2018, month: 08, day: 05), index: 0, bottles: 4)
//        let setRecord2 = setRecordDayForSul(day: Day(year: 2018, month: 08, day: 06), index: 1, bottles: 5)
//        let setRecord3 = setRecordDayForSul(day: Day(year: 2018, month: 08, day: 07), index: 1, bottles: 3)
//        let setRecord4 = setRecordDayForSul(day: Day(year: 2018, month: 08, day: 08), index: 2, bottles: 1)
//        let setRecord5 = setRecordDayForSul(day: Day(year: 2018, month: 08, day: 09), index: 0, bottles: 5)


//setRecordDayCustomExpense(day: Day, customExpense: Int)    day: 지정한 날짜, customExpense: 사용자가 직접 입력한 지출액        Day에 해당하는 RecordDay의 customExpense를 설정합니다.

func setRecordDayCustomExpense(day: Day, customExpense: Int?){
    var recordDay = getRecordDay(day: day)
    recordDay?.customExpense = customExpense
}

let setCustomExpense = setRecordDayCustomExpense(day: Day(year: 2018, month: 08, day: 05), customExpense: 32000)
/*
 //getFavoriteSul() -> [Int]        [Int](즐겨찾기한 술 인덱스의 배열)    즐겨찾기로 설정된 술 인덱스의 배열을 반환(UserData - favorites)
 */
// userData 의 초기화 값이 있어야 활성화가 되서
var userData = UserData(dangerLever: nil, favorites: nil, succeededLastMonth: false, goal_maxDaysOfMonth: nil, maxStreakOfMonth: nil, maxCaloriesOfMonth: nil, totalExpense: nil)

func getFavoriteSul() -> [Int]?{
    return userData.favorites
}

//setRecordDayLocation(day: Day, location: String)    day: 지정한 날짜, location: 장소 문자열        location을 해당 RecordDay에 저장해주세요!

func setRecordDayLocation(day: Day, location: [String]?){
    var recordDay = getRecordDay(day: day)
    recordDay?.location = location
}

let setLocation = setRecordDayLocation(day: Day(year: 2018, month: 08, day: 05), location: ["홍대"])
//        setRecordDayLocation(day: Day(year: 2018, month: 08, day: 06), location: ["홍대"])
//        setRecordDayLocation(day: Day(year: 2018, month: 08, day: 07), location: ["홍대"])
//        setRecordDayLocation(day: Day(year: 2018, month: 08, day: 08), location: ["상수"])
//        setRecordDayLocation(day: Day(year: 2018, month: 08, day: 09), location: ["강남"])
//        setRecordDayLocation(day: Day(year: 2018, month: 08, day: 10), location: ["중앙대"])
//        setRecordDayLocation(day: Day(year: 2018, month: 08, day: 11), location: ["홍대"])



//setRecordDayFriends(day:Day, friends: [String]    day: 지정한 날짜, friends: 친구들의 배열        friends를 해당 RecordDay에 저장해주세요!

func setRecordDayFriends(day:Day, friends: [String]?){
    var recordDay = getRecordDay(day: day)
    recordDay?.friends = friends
}


//getRecordDayCalorie(day: Day) -> Int    day: Day    Int(오늘의 칼로리)    오늘 칼로리를 반환
//성공
func getRecordDayCalorie(day: Day) -> Int?{
    var recordDay = getRecordDay(day: day)
    if let kcal = recordDay?.calories {
        return kcal
    }
    return nil
}



//getRecordMonthBestFriends(month: Day) -> [String: Int]    month: Day(day가 nil)    [String: 이번 달 술친구 이름, Int: 그 친구와 마신 횟수] 최상위 세 명의 딕셔너리로 만든 배열    참고: https://stackoverflow.com/questions/27531195/return-multiple-values-from-a-function-in-swift

//단상 화면에 사용할 용도이므로 탑3만! 디자인 가이드 참고

func getRecordMonthBestFriends(month: Day) -> [[String: Int]?]?{
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    
    let count = recordDayList.count - 1
    
    var thisMonth:[String] = []
    
    for i in 0...count {
        if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
            // force unwrapping을 하긴 햇는데 불안함.
            if var recordList = recordDayList[i].friends {
                thisMonth += recordList
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
    
    var toplated:[[String:Int]?] = []
    
    var count1 = sortedMonthWithWho.count
    if count1 == 0 {
        return nil
    } else if count1 < 2 {
        for i in 0...count1 - 1 {
            toplated.append([sortedMonthWithWho[i].key :sortedMonthWithWho[i].value])
        }
    } else {
        for i in 0...2 {
            toplated.append([sortedMonthWithWho[i].key :sortedMonthWithWho[i].value])
        }
    }
    
    
    
    return toplated
}

//getRecordMonthBestSul(month: Day) -> [Int:[Int, Int, Int]]    month: Day(day가 nil)    [Int(술의 인덱스):[Int(그 술 마시면서 얻은 칼로리):, Int(그 술로 지출한 추정 액수), Int(그 술 몇 번 마셨는지)]]의 배열을 포함한 딕셔너리의 배열    단상 화면에 사용할 용도이므로 탑3만! 디자인 가이드 참고
//이거 하려면 RecordMonth에 [술 인덱스:그 술에 대한 정보] 딕셔너리 배열(3칸짜리)이 추가돼야 합니다.
//'그 술에 대한 정보'의 경우 struct를 하나 더 만드시는 게 좋을 것 같습니다. [Int(그 술 마시면서 얻은 칼로리), Int(그 술로 지출한 추정 액수), Int(그 술 몇 번 마셨는지)]

func monthlyKcalPerSul(month: Day) -> [Int:Int] {
    var dictionary:[Int:Int] = [:]
    var count = recordDayList.count - 1
    var kcal:[[Int:Int]] = []
    for i in 0...count {
        if recordDayList[i].today.year == month.year,
            recordDayList[i].today.month == month.month {
            if var drinks = recordDayList[i].drinks {
                kcal.append(drinks)
            }
        }
    }
    
    for j in 0...sul.count - 1 {
        var sum: Int = Int()
        for index in kcal{
            // 왜 포스 언래핑?
            if var ind = index[j]{
                sum += ind
            }
        }
        dictionary[j] = sum * sul[j].baseCalorie
    }
    
    return dictionary
}

let getMonthlyKcal = monthlyKcalPerSul(month: Day(year: 2018, month: 08, day: nil))

func monthlyPricePerSul(month: Day) -> [Int:Int] {
    var dictionary:[Int:Int] = [:]
    var count = recordDayList.count - 1
    var price:[[Int:Int]] = []
    for i in 0...count {
        if recordDayList[i].today.year == month.year,
            recordDayList[i].today.month == month.month {
            if var drinks = recordDayList[i].drinks {
                price.append(drinks)
            }
        }
    }
    var sum: Int = Int()
    for j in 0...sul.count - 1 {
        var sum: Int = Int()
        for index in price{
            // 왜 포스 언래핑?
            if var ind = index[j]{
                sum += ind
            }
        }
        dictionary[j] = sum * sul[j].basePrice
    }
    
    return dictionary
}

let getMonthlyPrice = monthlyPricePerSul(month: Day(year: 2018, month: 08, day: nil))

func monthlybottlesPerSul(month: Day) -> [Int:Int] {
    var dictionary:[Int:Int] = [:]
    var count = recordDayList.count - 1
    var price:[[Int:Int]] = []
    for i in 0...count {
        if recordDayList[i].today.year == month.year,
            recordDayList[i].today.month == month.month {
            if var drinks = recordDayList[i].drinks {
                price.append(drinks)
            }
        }
    }
    
    for j in 0...sul.count {
        var sum: Int = Int()
        for index in price {
            // 왜 포스 언래핑?
            if var ind = index[j]{
                sum += ind
            }
            dictionary[j] = sum
        }
    }
    return dictionary
}

let getMonthlyBottles = monthlybottlesPerSul(month: Day(year: 2018, month: 08, day: nil))

func getRecordMonthBestSul(month: Day) -> [[Int:[Int?]]]? {
    
    
    var kcal = monthlyKcalPerSul(month: month)
    var price = monthlyPricePerSul(month: month)
    var bottles = monthlybottlesPerSul(month: month)
    
    var dictionary:[[Int:[Int?]]] = []
    
    if bottles.count == 0 {
        return nil
    } else {
        let sort = bottles.sorted(by: {$0.1 > $1.1})
        
        var array:[Int] = [sort[0].key, sort[1].key, sort[2].key]
        
        
        
        //            for i in 0...2 {
        //                // as! 가 불안함니다.
        //                dictionary[array[i]] = ([kcal[array[i]], price[array[i]], bottles[array[i]]] as! [Int])
        //            }
        for i in 0...2 {
            dictionary += [[array[i] : [kcal[array[i]], price[array[i]], bottles[array[i]]]]]
        }
    }
    
    
    return dictionary
}

//getRecordMonthBestLocation(month: Day) -> [String: Int]    month: Day(day가 nil)    [String: 이번 달 가장 많이 마신 장소, Int: 그곳에서 마신 횟수] 최상위 세 곳의 딕셔너리로 만든 배열    단상 화면에 사용할 용도이므로 탑3만! 디자인 가이드 참고

// 탑 3만 가져오는 함수를 추가하면 댈듯
func getRecordMonthBestLocation(month: Day) -> [[String: Int]]?{
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    // 총 기록 딕셔너리에 Day값을 집어 넣을 수 있어야 함
    
    let count = recordDayList.count - 1
    
    var thisMonth:[String] = []
    
    for i in 0...count {
        if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
            // force unwrapping을 하긴 햇는데 불안함.
            if var recordList = recordDayList[i].location {
                thisMonth += recordList
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
    
    var toplated:[[String:Int]] = []
    
    var count1 = sortedMonthWhere.count - 1
    if drinkWhereAndTimes == nil {
        return toplated
    } else if count1 < 2 {
        for i in 0...count1 {
            toplated.append([sortedMonthWhere[i].key :sortedMonthWhere[i].value])
        }
    } else {
        for i in 0...2 {
            toplated.append([sortedMonthWhere[i].key :sortedMonthWhere[i].value])
        }
    }
    
    
    
    return toplated
}

//getRecordMonthExpense(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 지출액)

func getRecordMonthExpense(month: Day) -> Int?{
    
    let count = recordDayList.count - 1
    
    var thisMonth:[Int] = []
    
    for i in 0...count {
        if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
            if recordDayList[i].customExpense == nil {
                // force unwrapping을 하긴 햇는데 불안함.
                if var reco = recordDayList[i].expense {
                    thisMonth += [reco]
                }
            } else {
                if var reco = recordDayList[i].customExpense {
                    thisMonth += [reco]
                }
            }
        }
    }
    let sum = thisMonth.reduce(0, {x, y in x+y})
    return sum
}

//getRecordMonthCalorie(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 칼로리)

func getRecordMonthCalorie(month: Day) -> Int?{
    let count = recordDayList.count - 1
    
    var thisMonth:[Int] = []
    
    for i in 0...count {
        if recordDayList[i].today.year == month.year, recordDayList[i].today.month == month.month {
            // force unwrapping을 하긴 햇는데 불안함.
            if var reco = recordDayList[i].calories {
                thisMonth += [reco]
            }
        }
    }
    let sum = thisMonth.reduce(0, {x, y in x+y})
    return sum
}

//getWeeklyFriend(day: Day) -> [String: Int]    day: Day    [String: 같이 마신 사람, Int: 사람별 횟수] 딕셔너리의 배열    이건 정렬/탑3/선별 등 없이 그냥 주간 데이터 다 던져주시면 됩니다.
func getWeeklyFriend() -> [String: Int] {
    
    var pastfriends:Array<String> = []
    
    
    for i in 0...13  {
        //근 7일이므로 7번 돌린다.
        let pastdays = Calendar.current.date(byAdding: .day, value: -i, to: Date())
        print(pastdays)
        //돌릴때마다 호출하는 날짜가 하나씩 줄어든다.
        let calendar = Calendar.current
        
        let pastyear = calendar.component(.year, from: pastdays!)
        let pastmonth = calendar.component(.month, from: pastdays!)
        let pastday = calendar.component(.day, from: pastdays!)
        
        
        let newday = Day(year: pastyear, month: pastmonth, day: pastday)
        
        if let abc = getRecordDay(day: newday)?.friends {
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
    
    var pastSul:[Int:Int]
    var weeklySulDictionary : [[Int:Int]]? = [[0:0]]
    var weeklySulSummery : [Int:Int] = [:]
    
    
    
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
        
        if getRecordDay(day: newday)?.drinks != nil {
            weeklySulDictionary?.append((getRecordDay(day: newday)?.drinks)!)
        }
        
        
        //     weeklySulDictionary?.append((getRecordDay(day: newday)?.drinks))
        
        //        print(getRecordDay(day: newday)?.drinks)
   //     print (weeklySulDictionary)
    }
  //  print(weeklySulDictionary)
    
    var keyArray:Array<Int> = []
    
    var count = (weeklySulDictionary?.count)!-1
    for j in 0...count {
        let index = weeklySulDictionary!
        keyArray += index[j].keys
    }
    //   print(keyArray)
    
    let sortedkeyArray = keyArray.sorted(by : >)
    
    //   print(sortedkeyArray)
    print(sortedkeyArray[0])
    let largestKeyNumber = sortedkeyArray[0]
    for i in 0...largestKeyNumber{
        var sumofIndexBottleNumber = 0
        for person in weeklySulDictionary!{
            if let indexbottlenumber = person[i]{
                sumofIndexBottleNumber += indexbottlenumber
            }
        }
        weeklySulSummery[i] = sumofIndexBottleNumber
    }
    //    print(weeklySulSummery)
    
    return weeklySulSummery
}



//getWeeklyLocation(day: Day) -> [String: Int]    day: Day    [String: 마신 장소, Int: 장소별 횟수] 딕셔너리의 배열    이건 정렬/탑3/선별 등 없이 그냥 주간 데이터 다 던져주시면 됩니다.
func getWeeklyLoation() -> [String: Int] {
    
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
        
        if let abc = getRecordDay(day: newday)?.location {
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
        if let onedayExpense = getRecordDay(day: newday)?.expense {
            weeklyExpense = weeklyExpense + onedayExpense
        }
        if let onedayCustomExpense = getRecordDay(day: newday)?.customExpense{
            weeklyExpense = weeklyExpense + onedayCustomExpense
        }
        
        
        
        print(weeklyExpense)
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
        if let onedayCalorie = (getRecordDay(day: newday)?.calories){
            weeklyCalorie = weeklyCalorie + onedayCalorie
        }
        print(weeklyCalorie)
    }
    return weeklyCalorie
}


// 목표
//getDaysOfMonthLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 마신 일 수 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

var currentGoalStatusList:[CurrentGoalStatus] = []

func addNewGoalStatusList(newGoalStatus: CurrentGoalStatus){
    currentGoalStatusList.append(newGoalStatus)
}

func getCurrentGoalStatusList(month: Day) -> CurrentGoalStatus?{
    
    for i in 0...currentGoalStatusList.count - 1 {
        if currentGoalStatusList[i].thisMonth.year == month.year
            ,currentGoalStatusList[i].thisMonth.month == month.month{
            return currentGoalStatusList[i]
        }
    }
    return nil
}


func getDaysOfMonthLimit(month: Day) -> Int?{
    guard var daysLimit = getCurrentGoalStatusList(month: month)?.daysOfMonth else{
        return nil
    }
    return daysLimit
}

//getStreakOfMonthLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 연속으로 마신 일 수 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func getStreakOfMonthLimit(month: Day) -> Int?{
    guard var streakLimit = getCurrentGoalStatusList(month: month)?.streakOfMonth else{
        return nil
    }
    return streakLimit
}

//getCaloriesOfMonthLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 칼로리 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func getCaloriesOfMonthLimit(month: Day) -> Int?{
    guard var caloriesLimit = getCurrentGoalStatusList(month: month)?.caloriesOfMonth else{
        return nil
    }
    return caloriesLimit
}


//getCurrentExpenseLimit(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 설정 지출액 한도)    이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func getCurrentExpenseLimit(month: Day) -> Int?{
    guard var expenseLimit = getCurrentGoalStatusList(month: month)?.currentExpense else{
        return nil
    }
    return expenseLimit
}

//getDaysOfMonthStatus(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 1일부터 오늘까지 마신 일 수)    month가 현재 달보다 이전이면 1일부터 말일까지 합
func getDaysOfMonthStatus(month:Day) -> Int {
    
    let inputMonth = month.month
    //    print(inputMonth)
    let inputYear = month.year
    //   print(inputYear)
    
    let todaycount = 31
    var monthDayCount = 0
    
    for i in 1...todaycount  {
        
        let newday = Day(year: inputYear, month: inputMonth, day: i)
        //        print(newday.day)
        let recordMonth = getRecordDay(day: newday)
        //       print(recordMonth)
        if recordMonth != nil{
            monthDayCount += 1
        }else {
            monthDayCount += 0
        }
    }
    return monthDayCount
}


//getStreakOfMonthStatus(month: Day) -> Int    month: Day(day가 nil)    Int(이번 달 1일부터 오늘까지 마신 연속 일 수 최고기록)    month가 현재 달보다 이전이면 1일부터 말일까지 합산
func getStreakOfMonthStatus(month:Day) -> Int {
    
    let inputMonth = month.month
    let inputYear = month.year
    
    var getStreakOfMonthStatus = 0
    
    
    
    var monthRecordList : [RecordDay?] = []
    
    
    for i in 1...31 {
        let newday = Day(year: inputYear, month: inputMonth, day: i)
        monthRecordList.append(getRecordDay(day: newday))
        print(monthRecordList)
    }
    let countMonThRecordList = monthRecordList.count - 1
    
    var counting1 = 0
    var steakArray:Array<Int> = []
    
    for i in 0...countMonThRecordList{
        if monthRecordList[i] != nil {
            counting1 += 1
        }else{
            counting1 = 0
        }
        steakArray += [counting1]
    }
    
    print(steakArray)
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
        let recordDailyCount = getRecordDay(day: newday)?.calories
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
        let recordDailyCount = getRecordDay(day: newday)?.expense
        let recordDailyCount2 = getRecordDay(day: newday)?.customExpense
        //       print(recordMonth)
        if recordDailyCount != nil {
            monthlyExpenseSum += recordDailyCount!
        }
        
        if recordDailyCount2 != nil {
            monthlyExpenseSum += recordDailyCount2!
        }
        print(monthlyExpenseSum)
    }
    return monthlyExpenseSum
}



//isDaysOfMonthEnabled(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지 마신 일 수'가 활성화돼있으면 true, 비활이면 false)    isDaysOfMonthEnabled: Bool를 RecordMonth에 추가해주세요!

//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

////
func isDaysOfMonthEnabled(month: Day) -> Bool {
    if getCurrentGoalStatusList(month: month)?.daysOfMonth == nil {
        return false
    } else {
        var monthEnabled =  getRecordMonth(day: month)?.isDaysOfMonthEnabled
        monthEnabled = true
        
        return true
    }
}

//isStreakOfMonth(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지 마신 연속 일 수 최고기록'이 활성화돼있으면 true, 비활이면 false)    isStreakOfMonth: Bool를 RecordMonth에 추가해주세요!
//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func isStreakOfMonth(month: Day) -> Bool {
    if getCurrentGoalStatusList(month: month)?.streakOfMonth == nil {
        return false
    } else {
        var monthEnabled =  getRecordMonth(day: month)?.isStreakOfMonth
        monthEnabled = true
        return true
    }
}

//isCaloriesOfMonth(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지의 칼로리'가 활성화돼있으면 true, 비활이면 false)    isCaloriesOfMonth: Bool를 RecordMonth에 추가해주세요!
//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func isCaloriesOfMonth(month: Day) -> Bool {
    if getCurrentGoalStatusList(month: month)?.caloriesOfMonth == nil {
        return false
    } else {
        var monthEnabled =  getRecordMonth(day: month)?.isCaloriesOfMonth
        monthEnabled = true
        return true
    }
}

//isCurrentExpense(month: Day) -> Bool    month: Day(day가 nil)    Bool(이번 달 목표로 '오늘까지 쓴 돈'이 활성화돼있으면 true, 비활이면 false)    isCurrentExpense: Bool를 RecordMonth에 추가해주세요!
//이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func isCurrentExpense(month: Day) -> Bool {
    if getCurrentGoalStatusList(month: month)?.currentExpense == nil {
        return false
    } else {
        var monthEnabled =  getRecordMonth(day: month)?.isCurrentExpense
        monthEnabled = true
        return true
    }
}

//setDaysOfMonthLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 마신 일 수 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setDaysOfMonthLimit(month: Day, value: Int) {
    if var insert = getCurrentGoalStatusList(month: month)?.daysOfMonth {
        insert = value
    }
}


//setStreakOfMonthLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 연속으로 마신 일 수 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setStreakOfMonthLimit(month: Day, value: Int) {
    if var insert = getCurrentGoalStatusList(month: month)?.streakOfMonth {
        insert = value
    }
}

//setCaloriesOfMonthLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 칼로리 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setCaloriesOfMonthLimit(month: Day, value: Int) {
    if var insert = getCurrentGoalStatusList(month: month)?.caloriesOfMonth {
        insert = value
    }
}


//setCurrentExpenseLimit(month: Day, value: Int)    month: Day(day가 nil), value: 이번 달 설정 지출액 한도 설정값        이번 달 : 매개변수 month에 해당하는 달을 말합니다.

func setCurrentExpenseLimit(month: Day, value: Int) {
    if var insert = getCurrentGoalStatusList(month: month)?.currentExpense {
        insert = value
    }
}






