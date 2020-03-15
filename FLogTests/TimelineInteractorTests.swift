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

class TimelineInteractorTests: QuickSpec {
    var sut: TimelineInteractor!
    var timelinePresenterMock: TimelinePresenterMock!
    
    var oldLoadedArray:Array<TimelineModel>?
    
    override func spec() {
        beforeSuite {
            self.timelinePresenterMock = TimelinePresenterMock()
            self.sut = TimelineInteractor()
            self.sut.presenter = self.timelinePresenterMock
        }
        
        describe("Dispatch Timeline data") {
            beforeEach {
                self.sut.createTimelineData()
                
                self.createRoutine()
                for _ in Range(0 ... 100) {
                    self.createLog()
                    self.updateSet(at: 0, weight: "10", reps: "10")
                }

            }
            
            context("When the timeline data is dispatched") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should have 10 or less than 10 timelines") {
                    expect(self.timelinePresenterMock.loadedArray.count <= 10).toEventually(beTrue())
                }
            }
            
            context("When the every timeline data is loaded") {
                beforeEach {
                    while true {
                        let currentFetchOffset = self.sut.fetchOffset
                        self.sut.dispatchTimelines(isInitial: false)
                        
                        if currentFetchOffset == self.sut.fetchOffset {
                            break
                        }
                    }
                }
                
                it("Should indicate the occurrenc of an error") {
                    expect(self.timelinePresenterMock.errorOccurred == true).toEventually(beTrue())
                }
            }
            
            afterEach {
                self.removeLastRoutine()
            }
        }
        
        describe("Create a routine") {
            context("When a user creates a routine") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.createRoutine()
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            afterEach {
                self.removeLastRoutine()
            }
        }
        
        describe("Create a log") {
            beforeEach {
                self.createRoutine()
            }
            
            context("When a user creates a log") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.createLog()
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            afterEach {
                self.removeLastRoutine()
            }
        }
        
        describe("Create a set") {
            beforeEach {
                self.createRoutine()
                self.createLog()
            }
            
            context("When a user create a set") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.createSet()
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            afterEach {
                self.removeLastRoutine()
            }
        }
        
        describe("Update set on a log") {
            beforeEach {
                self.createRoutine()
                self.createLog()
                self.createSet()
            }
            
            context("When a user sets only weight data on a log") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "10", reps:"")
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            context("When a user sets only reps data on a log") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "", reps:"10")
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            context("When a user sets Weight and reps data on a log") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "10", reps: "10")
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should appear 1 timeline after setting weight and reps") {
                    expect(self.oldLoadedArray!.count + 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes weight on a set on a log") {
                beforeEach {
                    self.updateSet(at: 1, weight: "10", reps:"10")
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "", reps:"10")
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should disappear 1 timeline after removing weight") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes reps on a set on a log") {
                beforeEach {
                    self.updateSet(at: 1, weight: "10", reps:"10")
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "10", reps:"")
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should disappear 1 timeline after removing reps") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            afterEach {
                self.removeLastRoutine()
            }
        }
        
        describe("Remove a set") {
            beforeEach {
                self.createRoutine()
                self.createLog()
            }
            
            context("When a user remove a set having no data") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeSet()
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes a set having weight and reps data") {
                beforeEach {
                    self.updateSet(at: 0, weight: "10", reps:"10")
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeSet()
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should disappear 1 timeline after removing the set") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            afterEach {
                self.removeLastRoutine()
            }
        }
        
        describe("Remove a log") {
            beforeEach {
                self.createRoutine()
                self.createLog()
            }
            
            context("When a user removes a log having no data") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeLog()
                    self.sut.dispatchTimelines(isInitial: true)
                }

                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes a log having valid set data") {
                beforeEach {
                    self.updateSet(at: 0, weight: "10", reps:"10")
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray

                    self.removeLog()
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should disappear 1 timeline after removing the log") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            afterEach {
                self.removeLastRoutine()
            }
        }
        
        describe("Remove a routine") {
            beforeEach {
                self.createRoutine()
                self.createLog()
            }
            
            context("When a user remove a routine having no data") {
                beforeEach {
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeLastRoutine()
                    self.sut.dispatchTimelines(isInitial: true)
                }

                it("Should have no difference on the count of timelines between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes a routine having valid log data") {
                beforeEach {
                    self.updateSet(at: 0, weight: "10", reps: "10")
                    self.sut.dispatchTimelines(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray

                    self.removeLastRoutine()
                    self.sut.dispatchTimelines(isInitial: true)
                }
                
                it("Should disappear 1 timeline after removing the log") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
            }
        }
        
        afterSuite {
            self.timelinePresenterMock = nil
            self.sut = nil
            self.oldLoadedArray = nil
        }
    }
    
    func createRoutine() {
        let newRoutineInteractor = NewRoutineInteractor()
        newRoutineInteractor.createNewRoutine(title: "test_timeline", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
    }
    
    func removeLastRoutine() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.dispatchRoutines()
        flogInteractor.deleteRoutine(index: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.count) - 1)
    }
    
    func createLog() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.dispatchRoutines()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.createNewFitnessLog(date: Date(), routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
    }
    
    func removeLog() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.dispatchRoutines()

        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.deleteFitnessLog(deleteIndex: 0, routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)

    }
    
    func createSet() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.dispatchRoutines()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.loadLogs(routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
        
        let routineDetailData = (routineDetailInteractor.presenter as! RoutineDetailPresenterMock).loadedData
        routineDetailInteractor.createNewSet(routineDetail: routineDetailData!, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
    }
    
    func updateSet(at index:Int, weight: String, reps: String) {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.dispatchRoutines()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.loadLogs(routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
        
        let routineDetailData = (routineDetailInteractor.presenter as! RoutineDetailPresenterMock).loadedData
        routineDetailInteractor.updateSet(routineDetail: routineDetailData!, tag: "\(index)0", text: weight, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
        routineDetailInteractor.updateSet(routineDetail: routineDetailData!, tag: "\(index)1", text: reps, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
    }
    
    func removeSet() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.dispatchRoutines()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.loadLogs(routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
        
        let routineDetailData = (routineDetailInteractor.presenter as! RoutineDetailPresenterMock).loadedData
        
        routineDetailInteractor.removeSet(routineDetail: routineDetailData!, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
        
    }
}

class TimelinePresenterMock: TimelineInteractorOutputProtocol {
    var dispatched = false
    var errorOccurred = false
    var loadedArray:Array<TimelineModel> = []
    
    func didDispatchTimelines(with timelineArray: [TimelineModel]) {
        loadedArray = timelineArray
        dispatched = true
        errorOccurred = false
    }
    
    func onError() {
        loadedArray = []
        dispatched = false
        errorOccurred = true
    }
}
