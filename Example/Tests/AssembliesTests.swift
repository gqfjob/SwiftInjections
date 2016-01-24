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
        let assembly = AssemblyResolver<TestAssembly>()
        
        // WHEN
        let objectAfterInjection = assembly.object(fromDefinition: assembly.instance().testObject())

        // THEN
        XCTAssertEqual(objectAfterInjection.testNumber, 20)
    }

}

class TestAssembly: Assembly {
    
    var testServiceAssembly = AssemblyResolver<TestServiceAssembly>()
    /*
    func testObject()->TestObject? {
        return self.inject(intoObject: TestObject()) { (object) in
            object.testNumberService = self.testServiceAssembly.instance().testService()
            return object
        }
    }
    */
    func testObject()->Definition<TestObject> {
        return Definition<TestObject>(withScope: .ObjectGraph,
            objectInitBlock: { TestObject() },
            objectInjectBlock: { (testObject:TestObject) in
             
                testObject.testNumberService = self.testServiceAssembly.object(fromDefinition: self.testServiceAssembly.instance().testService())
                return testObject
        })
    }
}

class TestServiceAssembly: Assembly {
    
    var testAssembly = AssemblyResolver<TestAssembly>()
    
    func testService()->Definition<TestService> {
        return Definition<TestService>(withScope: .ObjectGraph,
            objectInitBlock: { TestService() },
            objectInjectBlock: { (testService:TestService) in
            
                testService.testObject = self.testAssembly.object(fromDefinition: self.testAssembly.instance().testObject())
            
            return testService
        })
    }
    /*
    func testService()->TestService? {
        return self.instantiate(withScope:ObjectGraphScope{ TestService() }) { (object:TestService) in
            object.testObject = self.testAssembly.instance().testObject()
            return object
        }
    }*/
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