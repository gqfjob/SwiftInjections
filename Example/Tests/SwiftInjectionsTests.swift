//
//  SwiftInjectionsTests.swift
//  SwiftInjections
//
//  Created by Andrey Zarembo on 10.03.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

class SwiftInjectionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAssemblyInstantiation() {
        
        // GIVEN
        
        // WHEN
        let assembly = Assembly1.instance()
        
        // THEN
        XCTAssertNotNil(assembly)
    }

    func testObjectFromObjectGraph() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object1 = assembly.object1
        
        // THEN
        XCTAssertNotNil(object1)
    }
    
    func testObjectFromObjectGraphCreatesDifferentObjects() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        let object1 = assembly.object1
        
        // WHEN
        let anotherObject1 = assembly.object1
        
        // THEN
        XCTAssertNotNil(anotherObject1)
        XCTAssertNotEqual(object1, anotherObject1)
    }
    
    func testObjectFromObjectGraphWithInjection() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object1 = assembly.object1
        
        // THEN
        XCTAssertNotNil(object1.object2)
    }

    func testObjectFromObjectGraphWithCircularDependenciesInjection() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object1 = assembly.object1
        
        // THEN
        XCTAssertNotNil(object1.object2)
        XCTAssertEqual(object1.object2.object1, object1)
    }
    
    func testSigletonObject() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object5 = assembly.object5
        
        // THEN
        XCTAssertNotNil(object5)
    }
    
    func testSigletonObjectIsTheSame() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        let object5 = assembly.object5
        
        // WHEN
        let anotherObject5 = assembly.object5
        
        // THEN
        XCTAssertNotNil(anotherObject5)
        XCTAssertEqual(object5, anotherObject5)
    }
    
    func testPrototypeObject() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object4 = assembly.object4
        
        // THEN
        XCTAssertNotNil(object4)
    }
    
    func testPrototypeObjectCreatesDifferentObjects() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        let object4 = assembly.object4
        
        // WHEN
        let anotherObject4 = assembly.object4
        
        // THEN
        XCTAssertNotNil(anotherObject4)
        XCTAssertNotEqual(object4, anotherObject4)
    }

    func testPrototypeObjectInjectsDifferentObjects() {
        
        // GIVEN
        let assembly = Assembly1.instance()

        // WHEN
        let object3 = assembly.object3
        
        // THEN
        for object4LeftIndex in 0..<object3.objects4.count {
            for object4RightIndex in (object4LeftIndex+1)..<object3.objects4.count {
                
                let leftObject4 = object3.objects4[object4LeftIndex]
                let rightObject4 = object3.objects4[object4RightIndex]
                XCTAssertNotEqual(leftObject4, rightObject4)
            }
        }
    }
    
    func testInjectsSameObjectIntoPrototypeObjectsAtTheSameObjectGraph() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object3 = assembly.object3

        // THEN
        for object4 in object3.objects4 {
            XCTAssertEqual(object3, object4.object3)
        }
    }
    
    func testInjectsDataIntoSingleton() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object5 = assembly.object5
        
        // THEN
        XCTAssertNotNil(object5.object6)
    }

    func testReInjectsDataIntoSingleton() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        var object5 = assembly.object5
        let firstObject6 = object5.object6
        
        // WHEN
        object5 = assembly.object5
        
        // THEN
        XCTAssertNotEqual(firstObject6, object5.object6)
    }
    
    func testCreatesObjectByProtocol() {
        
        // GIVEN
        let assembly = Assembly1.instance()
        
        // WHEN
        let object7:TestObjectProtocol? = assembly.object7
        
        // THEN
        XCTAssertNotNil(object7)
    }
}
