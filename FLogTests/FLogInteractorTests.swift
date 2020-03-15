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
    
    var sut: FLogInteractor!
    var fLogPresenterMock: FLogPresenterMock!
    
    var oldLoadedArray:Array<MainRoutineModel>?
    
    override func spec() {
        beforeSuite {
            self.fLogPresenterMock = FLogPresenterMock()
            self.sut = FLogInteractor()
            self.sut.presenter = self.fLogPresenterMock
        }
        
        describe("t001 Sample Data") {
            context("When app lunches more than twice") {
                beforeEach {
                    self.sut.createSampleData()
                    self.sut.dispatchRoutines()
                    self.oldLoadedArray = self.fLogPresenterMock.loadedArray
                    
                    self.sut.createSampleData()
                    self.sut.dispatchRoutines()
                }
                
                it("Should not create sample data more than once") {
                    expect(self.oldLoadedArray!.count == self.fLogPresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
        }
        
        describe("t002 replace the routines") {
            context("When a routine moved to the other position") {
                beforeEach {
                    NewRoutineInteractor().createNewRoutine(title: "test_flog", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                    
                    self.sut.dispatchRoutines()
                    self.oldLoadedArray = self.fLogPresenterMock.loadedArray
                    
                    self.sut.replaceRoutines(sourceIndex: self.oldLoadedArray!.count-1, destinationIndex: 0)
                    self.sut.dispatchRoutines()
                }
                
                it("Should moved to the target position") {
                    expect(self.oldLoadedArray![self.oldLoadedArray!.count-1].title == self.fLogPresenterMock.loadedArray[0].title).toEventually(beTrue())
                }
            }
        }

        describe("t003 remove a routine") {
            context("When a routine is removed") {
                beforeEach {
                    NewRoutineInteractor().createNewRoutine(title: "test_flog", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                    
                    self.sut.dispatchRoutines()
                    self.oldLoadedArray = self.fLogPresenterMock.loadedArray
                    
                    self.sut.deleteRoutine(index: self.oldLoadedArray!.count-1)
                    self.sut.dispatchRoutines()
                }

                it("Should have less count than before deletion") {
                    expect(self.oldLoadedArray!.count - 1 == self.fLogPresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
        }
        
        describe("t003 update routine title") {
            context("001 When the name of a routine is changed to a name not existing") {
                beforeEach {
                    self.sut.updateRoutineTitle(index: 0, newTitle: "new_test_flog")
                    self.sut.dispatchRoutines()
                }
                
                it("Should be changed to 'new_test_flog'") {
                    expect(self.fLogPresenterMock.loadedArray[0].title == "new_test_flog").toEventually(beTrue())
                }
            }
            
            context("002 When the name trying to change is the same as its own name") {
                beforeEach {
                    self.sut.updateRoutineTitle(index: 0, newTitle: "new_test_flog")
                }
                
                it("Should happen nothing") {
                    expect(self.fLogPresenterMock.loadedArray[0].title == "new_test_flog" && self.fLogPresenterMock.errorOccurred == false).toEventually(beTrue())
                }
            }
            
            context("003 When the name trying to change already exists") {
                beforeEach {
                    NewRoutineInteractor().createNewRoutine(title: "test_flog2", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                    self.sut.updateRoutineTitle(index: 0, newTitle: "test_flog2")
                }
                
                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.fLogPresenterMock.errorOccurred).toEventually(beTrue())
                }
                
                afterEach {
                    self.sut.dispatchRoutines()
                    self.sut.deleteRoutine(index: self.fLogPresenterMock.loadedArray.count-1)
                    self.sut.deleteRoutine(index: 0)
                }
            }
        }
        
        afterSuite {
            self.fLogPresenterMock = nil
            self.sut = nil
        }
    }
}

class FLogPresenterMock: FLogInteractorOutputProtocol {
    
    var dispatched = false
    var errorOccurred = false
    var loadedArray: Array<MainRoutineModel> = []
    
    func didDispatchRoutines(with mainRoutineArray: [MainRoutineModel]) {
        dispatched = true
        loadedArray = mainRoutineArray
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        errorOccurred = true
        loadedArray = []
    }
}
