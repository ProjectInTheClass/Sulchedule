//실질적 값의 대입 - 직접 대입하거나 Manipulator의 메소드 사용

import Foundation

let dataCentre: DataCentre = DataCentre()

class DataCentre{
    //    public var arr = Sul(displayName: "hello", baseCalorie: 300, basePrice: 4000, colorTag: "#FFFFFF")
    //    var k: Int = test()
    
    var sul:[Sul] = []
    
    init() {
        
        sul.append(Sul(displayName: "소주", baseCalorie: 300, basePrice: 4000, colorTag: "#FFFFFF", unit: "병"))
        sul.append(Sul(displayName: "병맥주 330ml", baseCalorie: 122, basePrice: 2000, colorTag: "#FFFFFF", unit: "병"))
        sul.append(Sul(displayName: "병맥주 500ml", baseCalorie: 185, basePrice: 3000, colorTag: "#FFFFFF", unit: "병"))
        sul.append(Sul(displayName: "생맥주 500cc", baseCalorie: 185, basePrice: 4000, colorTag: "#FFFFFF", unit: "잔"))
        sul.append(Sul(displayName: "캔맥주 355ml", baseCalorie: 152, basePrice: 2000, colorTag: "FFFFFFF", unit: "캔"))
        sul.append(Sul(displayName: "와인 잔", baseCalorie: 84, basePrice: 12000, colorTag: "FFFFFF", unit: "잔"))
        sul.append(Sul(displayName: "막걸리", baseCalorie: 345, basePrice: 2000, colorTag: "FFFFFF", unit: "병"))
        sul.append(Sul(displayName: "칵테일", baseCalorie: 0, basePrice: 0, colorTag: "FFFFFF", unit: "잔"))
    }
}

var userSetting = UserSetting(purchased: false)

