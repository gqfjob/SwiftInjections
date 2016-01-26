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
        print("\(testObjectCycle) / \(objectAfterInjection)")
    }

}

class TestAssembly: Assembly {
    
    lazy var testServiceAssembly = TestServiceAssembly.instance()
    
    lazy var testObjectDefinition:Definition<TestObject> = self.definition(withScope: .ObjectGraph,
        objectInitBlock: { TestObject() },
        objectInjectBlock: { (testObject:TestObject) in
            testObject.testNumberService = self.testServiceAssembly.testService
            return testObject
    })
    
    lazy var testObject:TestObject = self.object(fromDefinition: self.testObjectDefinition)
}

class TestServiceAssembly: Assembly {
    
    lazy var testAssembly = TestAssembly.instance()

    
    lazy var testServiceDefinition:Definition<TestService> = self.definition(withScope: .ObjectGraph,
        objectInitBlock: { TestService() },
        objectInjectBlock: { (testService:TestService) in
            testService.testObject = self.testAssembly.testObject
            return testService
    })
    lazy var testService:TestService = self.object(fromDefinition: self.testServiceDefinition)
    
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

class TestViewController: UIViewController {
    
}