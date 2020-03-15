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
        
        describe("Sample Data") {
            context("When app lunches more than twice") {
                beforeEach {
                    self.sut.createSampleData()
                    self.sut.dispatchRoutines()
                    self.oldLoadedArray = self.fLogPresenterMock.loadedArray
                    
                    self.sut.createSampleData()
                    self.sut.dispatchRoutines()
                }
                
                it("Should not be created more than once") {
                    expect(self.oldLoadedArray!.count == self.fLogPresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
        }
        
        describe("Routine") {
            beforeEach {
                NewRoutineInteractor().createNewRoutine(title: "test_flog", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
            }
            
            context("When the routine moved to the other position") {
                beforeEach {
                    self.sut.dispatchRoutines()
                    self.oldLoadedArray = self.fLogPresenterMock.loadedArray
                    
                    self.sut.replaceRoutines(sourceIndex: self.oldLoadedArray!.count-1, destinationIndex: 0)
                    self.sut.dispatchRoutines()
                }
                
                it("Should be moved to the target position") {
                    expect(self.oldLoadedArray![self.oldLoadedArray!.count-1].title == self.fLogPresenterMock.loadedArray[0].title).toEventually(beTrue())
                }
                
                afterEach {
                    self.sut.deleteRoutine(index: 0)
                }
            }
            
            context("When the routine is removed") {
                beforeEach {
                    self.sut.dispatchRoutines()
                    self.oldLoadedArray = self.fLogPresenterMock.loadedArray
                    
                    self.sut.deleteRoutine(index: self.oldLoadedArray!.count-1)
                    self.sut.dispatchRoutines()
                }

                it("Should have less count than before removal") {
                    expect(self.oldLoadedArray!.count - 1 == self.fLogPresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
        }
        
        describe("Routine Name") {
            beforeEach {
                NewRoutineInteractor().createNewRoutine(title: "test_flog", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
                self.sut.dispatchRoutines()
                self.oldLoadedArray = self.fLogPresenterMock.loadedArray
                self.sut.replaceRoutines(sourceIndex: self.oldLoadedArray!.count-1, destinationIndex: 0)
            }
            
            context("When the name is changed to a name not existing") {
                beforeEach {
                    self.sut.updateRoutineTitle(index: 0, newTitle: "new_test_flog")
                    self.sut.dispatchRoutines()
                }
                
                it("Should be changed to intended name") {
                    expect(self.fLogPresenterMock.loadedArray[0].title == "new_test_flog").toEventually(beTrue())
                }
            }
            
            context("When the name trying to change is the same as its own name") {
                beforeEach {
                    self.sut.updateRoutineTitle(index: 0, newTitle: "test_flog")
                }
                
                it("Should happen nothing") {
                    expect(self.fLogPresenterMock.loadedArray[0].title == "test_flog" && self.fLogPresenterMock.errorOccurred == false).toEventually(beTrue())
                }
            }
            
            context("When the name trying to change already exists") {
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
                }
            }
            
            afterEach {                
                self.sut.deleteRoutine(index: 0)
            }
        }
        
        afterSuite {
            self.fLogPresenterMock = nil
            self.sut = nil
            self.oldLoadedArray = nil
        }
    }
}

class FLogPresenterMock: FLogInteractorOutputProtocol {
    
    var dispatched = false
    var errorOccurred = false
    var loadedArray: Array<MainRoutineModel> = []
    
    func didDispatchRoutines(with mainRoutineArray: [MainRoutineModel]) {
        loadedArray = mainRoutineArray
        dispatched = true
        errorOccurred = false
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        loadedArray = []
        dispatched = false
        errorOccurred = true
    }
}
