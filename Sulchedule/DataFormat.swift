//
//  DataFormat.swift
//  Sulchedule
//
//  Created by 조준오 on 2018/08/01.
//  Copyright © 2018 CAUAD10. All rights reserved.
//
//데이터 형식

import Foundation

struct Day {
    var year: Int
    var month: Int
    var day: Int?
}

struct RecordDay {
    var today: Day
    
    var location: String?
    var friends: String?
    var expense: Int //값을 입력하지 않은 경우 사용
    var customExpense: Int? //값을 입력한 경우 사용
    var calories: Int
    
    var drinks:[Int:Int] //index : bottles
}

struct RecordMonth {
    var thisMonth: Day
    
    var bestLocation: String?
    var bestFriend: String?
    var totalExpense: Int
    var totalCalories: Int
}

struct UserData {
    var dangerLevel: Int //0:초록, 1:노랑, 2:빨강
    var favorites: [Int] //index
    var succeededLastMonth: Bool
    
    var goal_maxDaysOfMonth: Int? //총 마신 날
    var maxStreakOfMonth: Int? //연속으로 마신 날
    var maxCaloriesOfMonth: Int? //칼로리 목표
    var totalExpense: Int? //총 지출액
    var maxBottlesPerSul: [Int:Int]? //술 종류당 한도 병 수
}

struct Sul {
    var displayName: String
    var baseCalorie: Float //단위 당 kcal (예 : 소주 = 300)
    var basePrice: Int
    var colorTag: String //컬러 코드에 # 포함 (예: "#FFFFFF")
}
