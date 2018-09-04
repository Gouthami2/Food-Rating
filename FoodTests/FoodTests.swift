//
//  FoodTests.swift
//  FoodTests
//
//  Created by Gouthami Reddy on 8/14/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import XCTest
@testable import Food

class FoodTests: XCTestCase {
   
    
    func testMealIntializationSucceeds() {
        let ZeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(ZeroRatingMeal)
        
        let positiveRatingMeal = Meal.init(name: "positive",photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    func testMealInitialozationFails() {
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        let emptyRatingMeal = Meal.init(name: "empty", photo: nil, rating: 0)
        XCTAssertNil(emptyRatingMeal)
        
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
    }
}
