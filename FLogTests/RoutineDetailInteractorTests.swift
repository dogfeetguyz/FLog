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

class RoutineDetailInteractorTests: QuickSpec {
    let userDefaultsSuiteName = "TestDefaults"
    var userDefaultsValues: Dictionary<String, Any>?
    
    var sut: RoutineDetailInteractor!
    var routineDetailPresenterMock: RoutineDetailPresenterMock!
    
    var oldRoutineArray:Array<MainRoutineModel>?
    
    override func spec() {
        beforeSuite {
            self.userDefaultsValues = UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.setPersistentDomain(Dictionary(), forName: Bundle.main.bundleIdentifier!)
            
            self.routineDetailPresenterMock = RoutineDetailPresenterMock()
            self.sut = RoutineDetailInteractor()
            self.sut.presenter = self.routineDetailPresenterMock
        }
        
        afterSuite {
            UserDefaults.standard.setPersistentDomain(self.userDefaultsValues!, forName: Bundle.main.bundleIdentifier!)
            
            self.routineDetailPresenterMock = nil
            self.sut = nil
        }
    }
}

class RoutineDetailPresenterMock: RoutineDetailInteractorOutputProtocol {
    var dispatched = false
    var errorOccurred = false
    
    func needsFirstLog() {
        dispatched = true
    }
    
    func didLogLoaded(routineDetail: RoutineDetailModel) {
        dispatched = true
    }
    
    func didUpdateLog(routineDetail: RoutineDetailModel) {
        dispatched = true
    }
    
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>) {
        dispatched = true
    }
    
    func didCreateNewFitnessLog() {
        dispatched = true
    }
    
    func didDeleteFitnessLog(deletedIndex: Int) {
        dispatched = true
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        errorOccurred = false
    }
    
    
    
}
