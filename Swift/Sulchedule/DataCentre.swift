//실질적 값의 대입 - 직접 대입하거나 Manipulator의 메소드 사용

import Foundation

let dataCentre: DataCentre = DataCentre()

class DataCentre{
    //    public var arr = Sul(displayName: "hello", baseCalorie: 300, basePrice: 4000, colorTag: "#FFFFFF")
    //    var k: Int = test()
    
    var sul:[Sul] = []
    
    init() {
        
        sul.append(Sul(displayName: "소주", baseCalorie: 300, basePrice: 4000, colorTag: "#FFFFFF", type: "병"))
        sul.append(Sul(displayName: "병맥주 330ml", baseCalorie: 122, basePrice: 2000, colorTag: "#FFFFFF", type: "병"))
        sul.append(Sul(displayName: "병맥주 500ml", baseCalorie: 185, basePrice: 3000, colorTag: "#FFFFFF", type: "병"))
        sul.append(Sul(displayName: "생맥주 500cc", baseCalorie: 185, basePrice: 4000, colorTag: "#FFFFFF", type: "잔"))
        sul.append(Sul(displayName: "캔맥주 355ml", baseCalorie: 152, basePrice: 2000, colorTag: "FFFFFFF", type: "캔"))
        sul.append(Sul(displayName: "와인 잔", baseCalorie: 84, basePrice: 12000, colorTag: "FFFFFF", type: "잔"))
        sul.append(Sul(displayName: "막걸리", baseCalorie: 345, basePrice: 2000, colorTag: "FFFFFF", type: "병"))
        sul.append(Sul(displayName: "칵테일", baseCalorie: 0, basePrice: 0, colorTag: "FFFFFF", type: "잔"))
    }
}

var dummyA = RecordDay(today: Day(year: 2018, month: 08, day: 10), location: ["홍대", "합정"], friends: ["공대호", "이재연", "홍창범"], expense: 48000, customExpense: 90000, calories: 1968, drinks: [0:6, 5:2])

var dummyB = RecordDay(today: Day(year: 2018, month: 08, day: 08), location: ["흑석"], friends: ["공대호", "임규헌", "조준오"], expense: 20000, customExpense: 40000, calories: 1500, drinks: [0:5])

var dummyC = RecordDay(today: Day(year: 2018, month: 08, day: 07), location: ["흑석"], friends: ["임규헌", "조준오", "공대호"], expense: 19000, customExpense: 20000, calories: 1385, drinks: [0:4, 2:1])

var dummyD = RecordDay(today: Day(year: 2018, month: 08, day: 06), location: ["강남", "신사"], friends: ["공대호", "하경목", "임아현"], expense: 6000, customExpense: 50000, calories: 456, drinks: [4:3])

var dummyE = RecordDay(today: Day(year: 2018, month: 08, day: 05), location: ["강남"], friends: ["공대호", "장지연", "이성준"], expense: 8000, customExpense: 24000, calories: 600, drinks: [0:2])

var dummyF = RecordDay(today: Day(year: 2018, month: 08, day: 04), location: ["신촌"], friends: ["조준오", "임규헌", "고준일"], expense: 8000, customExpense: 90000, calories: 488, drinks: [1:4])

var dummyG = RecordDay(today: Day(year: 2018, month: 06, day: 03), location: ["판교"], friends: ["고준일", "딩가딩", "링고스타"], expense: 12000, customExpense: 40000, calories: 2070, drinks: [6:6])

var dummyH = RecordDay(today: Day(year: 2018, month: 06, day: 02), location: ["흑석"], friends: ["공대호", "임규헌", "조준오", "이규백", "안홍석"], expense: 12000, customExpense: 902, calories: nil, drinks: [0:2, 4:2])
