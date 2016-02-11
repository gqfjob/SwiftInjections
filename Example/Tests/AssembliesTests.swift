//
//  AssembliesTests.swift
//  SwiftInjections
//
//  Created by Andrey Zarembo on 22.01.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftInjections

class AssembliesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAssemblyReturnsInjectedObject() {
        
        // GIVEN
        let assembly = TestAssembly.instance()
        
        // WHEN
        let objectAfterInjection = assembly.testObject

        // THEN
        XCTAssertEqual(objectAfterInjection.testNumber, 20)
        let testObjectCycle = objectAfterInjection.testNumberService?.testObject
        XCTAssertEqual(unsafeAddressOf(testObjectCycle!), unsafeAddressOf(objectAfterInjection))
    }
    
    func testAssemblyCreatesIndependedObjectGraphs() {
        
        // GIVEN
        let assembly = TestAssembly.instance()
        
        // WHEN
        let objectAfterInjection = assembly.testObject
        let objectAfterInjection2 = assembly.testObject
        
        // THEN
        XCTAssertEqual(objectAfterInjection.testNumber, 20)
        XCTAssertEqual(objectAfterInjection2.testNumber, 20)
        XCTAssertNotEqual(unsafeAddressOf(objectAfterInjection), unsafeAddressOf(objectAfterInjection2))
    }
    
    func testSingleton() {
        
        // GIVEN
        let assembly = TestAssembly.instance()
        
        // WHEN
        let singleton = assembly.testSingletonBlueprint.instance
        TestSingleton.staticTestValue = 10
        let singleton2 = assembly.testSingletonBlueprint.instance
        
        // THEN
        XCTAssertEqual(unsafeAddressOf(singleton), unsafeAddressOf(singleton2))
        XCTAssertEqual(singleton.testValue, 0)
        XCTAssertEqual(singleton.testValue, 0)
    }
    
}

class TestAssembly: Assembly {
    
    lazy var testServiceAssembly = TestServiceAssembly.instance()
    
    lazy var testObjectBlueprint:ObjectBlueprint<TestObject> = self.bluePrint(withScope: .ObjectGraph,
        objectInitBlock:   { TestObject() },
        objectInjectBlock: { (testObject:TestObject) in
            testObject.testNumberService = self.testServiceAssembly.testService.instance
            return testObject
    })
    var testObject:TestObject {
        return self.testObjectBlueprint.instance
    }
    
    lazy var testSingletonBlueprint:ObjectBlueprint<TestSingleton> = self.bluePrint(withScope: .Singleton,
        objectInitBlock:   { TestSingleton() },
        objectInjectBlock: { (testSingleton:TestSingleton) in
            return testSingleton
    })
    
    lazy var testWeakSingletonBlueprint:ObjectBlueprint<TestSingleton> = self.bluePrint(withScope: .WeakSingleton,
        objectInitBlock:   { TestSingleton() },
        objectInjectBlock: { (testSingleton:TestSingleton) in
            return testSingleton
    })
}

class TestServiceAssembly: Assembly {
    
    lazy var testAssembly = TestAssembly.instance()
    
    lazy var testService:ObjectBlueprint<TestService> = self.bluePrint(withScope: .ObjectGraph,
        objectInitBlock: { TestService() },
        objectInjectBlock: { (testService) in
            
            testService.testObject = self.testAssembly.testObject
            return testService
    })
    
    lazy var testVC:TestViewController? = nil
}
    
class TestObject {
    
    var testNumberService:TestService? = nil
    
    var testNumber:Int? {
        get {
            return self.testNumberService?.getResult()
        }
    }
    
    var numberForService:Int = 20
}

class TestService {
    
    weak var testObject:TestObject? = nil
    
    func getResult() -> Int {
        return self.testObject?.numberForService ?? 10
    }
}

class TestSingleton {
    static var staticTestValue:Int = 0
    var testValue:Int
    init() {
        self.testValue = TestSingleton.staticTestValue
    }
}

class TestViewController: UIViewController {
    
}