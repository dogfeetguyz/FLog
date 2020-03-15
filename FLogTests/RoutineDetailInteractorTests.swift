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
    var sut: RoutineDetailInteractor!
    var routineDetailPresenterMock: RoutineDetailPresenterMock!
    
    var routineArray:Array<MainRoutineModel>?
    
    override func spec() {
        beforeSuite {
            
            self.routineDetailPresenterMock = RoutineDetailPresenterMock()
            self.sut = RoutineDetailInteractor()
            self.sut.presenter = self.routineDetailPresenterMock
        }
        
        describe("Result") {
            beforeEach {
                NewRoutineInteractor().createNewRoutine(title: "test_routine_detail", unit: .kg, exerciseTitles: ["exercise1", "exercise2", "exercise3"])
                
                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
            }
            
            context("When a routine doesn't have any logs") {
                beforeEach {
                    self.sut.loadLogs(routine: (self.routineArray?.last)!)
                }
                
                it("Should show a popup to create a new log") {
                    expect(self.routineDetailPresenterMock.requestNewLog).toEventually(beTrue())
                }
            }
            
            context("When routine have more one log") {
                beforeEach {
                    self.sut.createNewFitnessLog(date: Date(), routine: (self.routineArray?.last)!)
                    self.sut.loadLogs(routine: (self.routineArray?.last)!)
                }
                
                it("should have Routine Detail Data") {
                    expect(self.routineDetailPresenterMock.loadedData != nil).toEventually(beTrue())
                }
            }
            
            context("When routine have more than two logs") {
                beforeEach {
                    self.sut.createNewFitnessLog(date: Date(), routine: (self.routineArray?.last)!)

                    var oneweekago = Date()
                    oneweekago.addTimeInterval(-(60*60*24*7))
                    self.sut.createNewFitnessLog(date: oneweekago, routine: (self.routineArray?.last)!)
                    
                    self.sut.loadLogs(routine: (self.routineArray?.last)!)
                }
                
                it("should have Routine Detail data") {
                    expect(self.routineDetailPresenterMock.loadedData != nil).toEventually(beTrue())
                }
            }

            context("When a user try to create a log with a new date") {
                beforeEach {
                    self.sut.createNewFitnessLog(date: Date(), routine: (self.routineArray?.last)!)
                }

                it("Should be successful") {
                    expect(self.routineDetailPresenterMock.created).toEventually(beTrue())
                }
            }

            context("When a user try to create a log with already logged date") {
                beforeEach {
                    self.sut.createNewFitnessLog(date: Date(), routine: (self.routineArray?.last)!)
                    self.sut.createNewFitnessLog(date: Date(), routine: (self.routineArray?.last)!)
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.routineDetailPresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            afterEach {
                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                flogInteractor.deleteRoutine(index: (flogInteractor.presenter as! FLogPresenterMock).loadedArray.count-1)
            }
        }
        
        
        describe("The number of logs") {
            
        }

        describe("The number of sets") {
            
        }
        
        describe("Max data") {
            
        }
        
        afterSuite {
            self.routineDetailPresenterMock = nil
            self.sut = nil
            self.routineArray = nil
        }
    }
}

class RoutineDetailPresenterMock: RoutineDetailInteractorOutputProtocol {
    var created = false
    var errorOccurred = false
    
    var dispatched = false
    var requestNewLog = true
    var loadedData: RoutineDetailModel?
    
    func didCreateNewFitnessLog() {
        errorOccurred = false
        created = true
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        errorOccurred = true
        created = false
    }
    
    func didDeleteFitnessLog(deletedIndex: Int) {
        requestNewLog = false
    }
    
    func needsFirstLog() {
        loadedData = nil
        requestNewLog = true
        dispatched = false
    }
    
    func didLogLoaded(routineDetail: RoutineDetailModel) {
        loadedData = routineDetail
        requestNewLog = false
        dispatched = true
    }
    
    func didUpdateLog(routineDetail: RoutineDetailModel) {
        loadedData = routineDetail
    }
    
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>) {
    }
}
