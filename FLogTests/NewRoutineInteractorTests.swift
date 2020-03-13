//
//  FLogTests.swift
//  FLogTests
//
//  Created by Yejun Park on 13/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

@testable import FLog
import Quick
import Nimble

class NewRoutineInteractorTests: QuickSpec {
    let userDefaultsSuiteName = "TestDefaults"
    var userDefaultsValues: Dictionary<String, Any>?
    
    var sut: NewRoutineInteractor!
    var newRoutinePresenterMock: NewRoutinePresenterMock!
    
    var oldRoutineArray:Array<MainRoutineModel>?
    
    override func spec() {
        beforeSuite {
            self.userDefaultsValues = UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.setPersistentDomain(Dictionary(), forName: Bundle.main.bundleIdentifier!)
            
            self.newRoutinePresenterMock = NewRoutinePresenterMock()
            self.sut = NewRoutineInteractor()
            self.sut.presenter = self.newRoutinePresenterMock
        }
        
        afterSuite {
            UserDefaults.standard.setPersistentDomain(self.userDefaultsValues!, forName: Bundle.main.bundleIdentifier!)
            
            self.newRoutinePresenterMock = nil
            self.sut = nil
        }
    }
}

class NewRoutinePresenterMock: NewRoutineInteractorOutputProtocol {
    var dispatched = false
    var errorOccurred = false
    
    func didCreateNewRoutine() {
        dispatched = true
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        errorOccurred = true
    }
}
