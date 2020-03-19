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
        
        describe("Timeline data") {
            beforeEach {
                self.sut.createTimelineData()
                
                self.createRoutine()
                for i in Range(0 ... 100) {
                    
                    var date = Date()
                    date.addTimeInterval(TimeInterval(-(60*60*24*i)))
                    self.createLog(date: date)

                    let flogInteractor = FLogInteractor()
                    flogInteractor.presenter = FLogPresenterMock()
                    flogInteractor.loadData()
                    
                    let routineDetailInteractor = RoutineDetailInteractor()
                    routineDetailInteractor.presenter = RoutineDetailPresenterMock()
                    routineDetailInteractor.loadLogs(routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
                    let routineDetailData = (routineDetailInteractor.presenter as! RoutineDetailPresenterMock).loadedData as? RoutineDetailEntity
                    let logDate = (routineDetailData?.dailyLogs[i].logDate)!
                    let exerciseTitle = (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!
                    
                    let weight = Int.random(in: Range(0 ... 100)) % 2 == 0 ? "10" : ""
                    let reps = Int.random(in: Range(0 ... 100)) % 2 == 0 ? "10" : ""
                    
                    routineDetailInteractor.updateSet(routine: routineDetailData!.routine, setIndex:0, slotIdentifier: .weight, text: weight, logDate: logDate, exerciseTitle: exerciseTitle)
                    routineDetailInteractor.updateSet(routine: routineDetailData!.routine, setIndex:0, slotIdentifier: .reps, text: reps, logDate: logDate, exerciseTitle: exerciseTitle)
                }

            }
            
            context("When the data is dispatched once") {
                beforeEach {
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should have 10 or less than 10 timelines") {
                    expect(self.timelinePresenterMock.loadedArray.count <= 10).toEventually(beTrue())
                }
            }
            
            context("When the every timeline data is loaded") {
                beforeEach {
                    while true {
                        let currentFetchOffset = self.sut.fetchOffset
                        self.sut.loadData(isInitial: false)
                        
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
        
        describe("Timeline list") {
            context("When a user created a routine") {
                beforeEach {
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.createRoutine()
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user creates a log") {
                beforeEach {
                    self.createRoutine()
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.createLog(date: Date())
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user creates a set") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.createSet()
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user sets only weight data on a log") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.createSet()
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "10", reps:"")
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user sets only reps data on a log") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.createSet()
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "", reps:"10")
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user sets Weight and reps data on a log") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.createSet()
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "10", reps: "10")
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should be increased by 1 after setting weight and reps") {
                    expect(self.oldLoadedArray!.count + 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user removes weight on a set on a log") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.createSet()
                    self.updateSet(at: 1, weight: "10", reps:"10")
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "", reps:"10")
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should be decreased by 1 after removing weight") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user removes reps on a set on a log") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.createSet()
                    self.updateSet(at: 1, weight: "10", reps:"10")
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.updateSet(at: 1, weight: "10", reps:"")
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should be decreased by 1 after removing reps") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user remove a set having no data") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeSet()
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user removes a set having weight and reps data") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.createSet()
                    self.updateSet(at: 1, weight: "10", reps:"10")
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeSet()
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should be decreased by 1 after removing the set") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user removes a log having no data") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeLog()
                    self.sut.loadData(isInitial: true)
                }

                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user removes a log having valid set data") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.updateSet(at: 0, weight: "10", reps:"10")
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray

                    self.removeLog()
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should be decreased by 1 after removing the log") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterEach {
                    self.removeLastRoutine()
                }
            }
            
            context("When a user remove a routine having no data") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray
                    
                    self.removeLastRoutine()
                    self.sut.loadData(isInitial: true)
                }

                it("Should have no difference on the count between befor and after") {
                    expect(self.oldLoadedArray!.count == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterSuite {
                    self.timelinePresenterMock = nil
                    self.sut = nil
                    self.oldLoadedArray = nil
                }
            }
            
            context("When a user removes a routine having valid log data") {
                beforeEach {
                    self.createRoutine()
                    self.createLog(date: Date())
                    self.updateSet(at: 0, weight: "10", reps: "10")
                    self.sut.loadData(isInitial: true)
                    self.oldLoadedArray = self.timelinePresenterMock.loadedArray

                    self.removeLastRoutine()
                    self.sut.loadData(isInitial: true)
                }
                
                it("Should be decreased by 1 after removing the log") {
                    expect(self.oldLoadedArray!.count - 1 == self.timelinePresenterMock.loadedArray.count).toEventually(beTrue())
                }
                
                afterSuite {
                    self.timelinePresenterMock = nil
                    self.sut = nil
                    self.oldLoadedArray = nil
                }
            }
        }
    }
    
    func createRoutine() {
        let newRoutineInteractor = NewRoutineInteractor()
        newRoutineInteractor.presenter = NewRoutinePresenterMock()
        newRoutineInteractor.createNewRoutine(title: "test_timeline", unit: .kg, exerciseTitles: ["exercise1", "exercise2"])
    }
    
    func removeLastRoutine() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.loadData()
        flogInteractor.deleteRoutine(index: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.count) - 1)
    }
    
    func createLog(date: Date) {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.loadData()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.createLog(date: date, routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
    }
    
    func removeLog() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.loadData()

        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.removeLog(removeIndex: 0, routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)

    }
    
    func createSet() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.loadData()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.loadLogs(routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
        
        let routineDetailData = (routineDetailInteractor.presenter as! RoutineDetailPresenterMock).loadedData as? RoutineDetailEntity
        routineDetailInteractor.createSet(routine: routineDetailData!.routine, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
    }
    
    func updateSet(at index:Int, weight: String, reps: String) {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.loadData()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.loadLogs(routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
        
        let routineDetailData = (routineDetailInteractor.presenter as! RoutineDetailPresenterMock).loadedData as? RoutineDetailEntity
        routineDetailInteractor.updateSet(routine: routineDetailData!.routine, setIndex:index, slotIdentifier: .weight, text: weight, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
        routineDetailInteractor.updateSet(routine: routineDetailData!.routine, setIndex:index, slotIdentifier: .reps, text: reps, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
    }
    
    func removeSet() {
        let flogInteractor = FLogInteractor()
        flogInteractor.presenter = FLogPresenterMock()
        flogInteractor.loadData()
        
        let routineDetailInteractor = RoutineDetailInteractor()
        routineDetailInteractor.presenter = RoutineDetailPresenterMock()
        routineDetailInteractor.loadLogs(routine: ((flogInteractor.presenter as! FLogPresenterMock).loadedArray.last)!)
        
        let routineDetailData = (routineDetailInteractor.presenter as! RoutineDetailPresenterMock).loadedData as? RoutineDetailEntity
        routineDetailInteractor.removeSet(routine: routineDetailData!.routine, logDate: (routineDetailData?.dailyLogs.first!.logDate)!, exerciseTitle: (routineDetailData?.dailyLogs.first!.exerciseLogs.first!.exerciseTitle)!)
        
    }
}

class TimelinePresenterMock: TimelineInteractorOutputProtocol {
    var isInitial: Bool = false
    
    var dispatched = false
    var errorOccurred = false
    var loadedArray:Array<TimelineModel> = []
    
    func didDataLoaded(with loadedData: ViperEntity) {
        if let _loadedData = loadedData as? TimelineEntityProtocol {
            loadedArray = _loadedData.timelineArray
        }
        dispatched = true
        errorOccurred = false
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        loadedArray = []
        dispatched = false
        errorOccurred = true
    }
}
