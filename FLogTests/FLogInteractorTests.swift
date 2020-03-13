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

class FLogInteractorTests: QuickSpec {
    let userDefaultsSuiteName = "TestDefaults"
    var userDefaultsValues: Dictionary<String, Any>?
    
    var sut: FLogInteractor!
    var fLogPresenterMock: FLogPresenterMock!
    
    var oldRoutineArray:Array<MainRoutineModel>?
    
    override func spec() {
        beforeSuite {
            self.userDefaultsValues = UserDefaults.standard.persistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.setPersistentDomain(Dictionary(), forName: Bundle.main.bundleIdentifier!)
            
            self.fLogPresenterMock = FLogPresenterMock()
            self.sut = FLogInteractor()
            self.sut.presenter = self.fLogPresenterMock
        }
        
        describe("t001 First execution") {
            context("When this app is executed for the first time") {
                beforeEach {
                    self.sut.createSampleData()
                    self.sut.dispatchRoutines()
                }
                
                it("Should have 1 sample routine in the list") {
                    expect(self.fLogPresenterMock.mainRoutineArray != nil && self.fLogPresenterMock.mainRoutineArray?.count == 1).toEventually(beTrue())
                }
            }
        }
        
        describe("t002 Second execution") {
            context("When this app is executed for the second time") {
                beforeEach {
                    self.sut.createSampleData()
                    self.sut.dispatchRoutines()
                }
                
                it("Should have 1 sample routine in the list") {
                    expect(self.fLogPresenterMock.mainRoutineArray != nil && self.fLogPresenterMock.mainRoutineArray?.count == 1).toEventually(beTrue())
                }
            }
        }
        
        describe("t003 remove the sample routine") {
            context("When the sample routine is removed") {
                beforeEach {
                    self.sut.deleteRoutine(index: 0)
                    self.sut.dispatchRoutines()
                }
                
                it("Should have 0 sample routines in the list") {
                    expect(self.fLogPresenterMock.mainRoutineArray != nil && self.fLogPresenterMock.mainRoutineArray?.count == 0).toEventually(beTrue())
                }
            }
        }
        
        describe("t004 replace the routines") {
            context("When a routine moved to the other position") {
                beforeEach {
                    
                    let newRoutineInteractor = NewRoutineInteractor()
                    newRoutineInteractor.createNewRoutine(title: "test1", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                    newRoutineInteractor.createNewRoutine(title: "test2", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                    newRoutineInteractor.createNewRoutine(title: "test3", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                    newRoutineInteractor.createNewRoutine(title: "test4", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                    self.sut.dispatchRoutines()
                    
                    self.oldRoutineArray = self.fLogPresenterMock.mainRoutineArray
                    self.sut.replaceRoutines(sourceIndex: 0, destinationIndex: self.oldRoutineArray!.count-1)
                    self.sut.dispatchRoutines()
                }
                
                it("Should moved to the target position") {
                    expect(self.oldRoutineArray![0].title == self.fLogPresenterMock.mainRoutineArray![self.oldRoutineArray!.count-1].title).toEventually(beTrue())
                }
            }
        }
        
        describe("t005 update routine title") {
            context("t005_1 When the name of a routine is changed to a name not existing") {
                beforeEach {
                    self.sut.updateRoutineTitle(index: 0, newTitle: "test5")
                    self.sut.dispatchRoutines()
                }
                
                it("Should be changed to 'test5'") {
                    expect(self.fLogPresenterMock.mainRoutineArray![0].title == "test5").toEventually(beTrue())
                }
            }
            
            context("t005_2 When the name trying to change is the same as its own name") {
                beforeEach {
                    self.sut.updateRoutineTitle(index: 0, newTitle: "test5")
                }
                
                it("Should happen nothing") {
                    expect(self.fLogPresenterMock.mainRoutineArray![0].title == "test5" && self.fLogPresenterMock.errorOccurred == false).toEventually(beTrue())
                }
            }
            
            context("t005_3 When the name trying to change already exists") {
                beforeEach {
                    self.sut.updateRoutineTitle(index: 0, newTitle: "test4")
                }
                
                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.fLogPresenterMock.errorOccurred).toEventually(beTrue())
                }
            }
        }
        
        afterSuite {
            UserDefaults.standard.setPersistentDomain(self.userDefaultsValues!, forName: Bundle.main.bundleIdentifier!)
            
            self.fLogPresenterMock = nil
            self.sut = nil
        }
    }
}

class FLogPresenterMock: FLogInteractorOutputProtocol {
    
    var dispatched = false
    var errorOccurred = false
    var mainRoutineArray: Array<MainRoutineModel>?
    
    func didDispatchRoutines(with mainRoutineArray: [MainRoutineModel]) {
        dispatched = true
        self.mainRoutineArray = mainRoutineArray
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        errorOccurred = true
    }
}
