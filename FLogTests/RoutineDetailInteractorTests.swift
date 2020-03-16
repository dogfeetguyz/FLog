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
                    let routine = (self.routineArray?.last)!
                    
                    self.sut.loadLogs(routine: routine)
                }

                it("Should show a popup request creating a new log") {
                    expect(self.routineDetailPresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            context("When routine have more one log") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                }

                it("Should include Routine Detail Data") {
                    expect(self.routineDetailPresenterMock.loadedData != nil).toEventually(beTrue())
                }
            }

            context("When routine have more than two logs") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    
                    var oneweekago = Date()
                    oneweekago.addTimeInterval(-(60*60*24*7))
                    self.sut.createLog(date: oneweekago, routine: routine)
                    self.sut.createLog(date: Date(), routine:routine)

                    self.sut.loadLogs(routine: routine)
                }

                it("Should include Routine Detail data") {
                    expect(self.routineDetailPresenterMock.loadedData != nil).toEventually(beTrue())
                }
            }

            context("When a user try to create a log with a new date") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: Date(), routine: routine)
                }

                it("Should be successful") {
                    expect(self.routineDetailPresenterMock.succeeded).toEventually(beTrue())
                }
            }

            context("When a user try to create a log with existing date") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.createLog(date: Date(), routine: routine)
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.routineDetailPresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            context("When a user removes a log and there are no logs after the removal") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.removeLog(removeIndex: 0, routine: routine)
                    self.sut.loadLogs(routine: routine)
                }

                it("Should show a popup to request creating a new log") {
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
            var oldLoadedData: RoutineDetailModel?
            
            beforeEach {
                NewRoutineInteractor().createNewRoutine(title: "test_routine_detail", unit: .kg, exerciseTitles: ["exercise1", "exercise2", "exercise3"])

                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
            }
            
            context("When a user creates a log") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    
                    var oneweekago = Date()
                    oneweekago.addTimeInterval(-(60*60*24*7))
                    self.sut.createLog(date: oneweekago, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    oldLoadedData = self.routineDetailPresenterMock.loadedData
                    
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                }
                
                it("Should be increased by 1") {
                    expect((oldLoadedData?.dailyLogs.count)! + 1 == self.routineDetailPresenterMock.loadedData!.dailyLogs.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes a log") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    
                    var oneweekago = Date()
                    oneweekago.addTimeInterval(-(60*60*24*7))
                    self.sut.createLog(date: oneweekago, routine: routine)
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    oldLoadedData = self.routineDetailPresenterMock.loadedData
                    
                    self.sut.removeLog(removeIndex: 0, routine: routine)
                    self.sut.loadLogs(routine: routine)
                }
                
                it("should be decreased by 1") {
                    expect((oldLoadedData?.dailyLogs.count)! - 1 == self.routineDetailPresenterMock.loadedData!.dailyLogs.count).toEventually(beTrue())
                }
            }

            afterEach {
                oldLoadedData = nil
                
                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                flogInteractor.deleteRoutine(index: (flogInteractor.presenter as! FLogPresenterMock).loadedArray.count-1)
            }
        }

        describe("A Log") {
            var oldLoadedData: RoutineDetailModel?
            
            beforeEach {
                NewRoutineInteractor().createNewRoutine(title: "test_routine_detail", unit: .kg, exerciseTitles: ["exercise1", "exercise2", "exercise3"])

                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
            }
            
            context("When a user creates a log") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                }
                
                it("Should have one set for each exercise") {
                    for exerciseLog in (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs)! {
                        expect(exerciseLog.set.count == 1).toEventually(beTrue())
                    }
                }
            }
            
            context("When a user creates a set in an exercise") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    oldLoadedData = self.routineDetailPresenterMock.loadedData
                    
                    self.sut.createSet(routineDetail: oldLoadedData!, logDate: oldLoadedData!.dailyLogs[0].logDate, exerciseTitle: (oldLoadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!)
                }
                
                it("Shoud have the increased number of sets in the exercise") {
                    expect((oldLoadedData?.dailyLogs[0].exerciseLogs[0].set.count)! + 1 == self.routineDetailPresenterMock.loadedData!.dailyLogs[0].exerciseLogs[0].set.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes a set in an exercise") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let loadedData = self.routineDetailPresenterMock.loadedData
                    
                    self.sut.createSet(routineDetail: loadedData!, logDate: loadedData!.dailyLogs[0].logDate, exerciseTitle: (loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!)
                    self.sut.createSet(routineDetail: loadedData!, logDate: loadedData!.dailyLogs[0].logDate, exerciseTitle: (loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!)
                    self.sut.createSet(routineDetail: loadedData!, logDate: loadedData!.dailyLogs[0].logDate, exerciseTitle: (loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!)
                    self.sut.loadLogs(routine: routine)
                    oldLoadedData = self.routineDetailPresenterMock.loadedData
                    
                    self.sut.removeSet(routineDetail: oldLoadedData!, logDate: oldLoadedData!.dailyLogs[0].logDate, exerciseTitle: (oldLoadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!)
                    self.sut.loadLogs(routine: routine)
                }
                
                it("Shoud have the decreased number of sets in the exercise") {
                    expect((oldLoadedData?.dailyLogs[0].exerciseLogs[0].set.count)! - 1 == self.routineDetailPresenterMock.loadedData!.dailyLogs[0].exerciseLogs[0].set.count).toEventually(beTrue())
                }
            }
            
            context("When a user removes the only set in an exercise") {
                beforeEach {
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    oldLoadedData = self.routineDetailPresenterMock.loadedData
                    
                    self.sut.removeSet(routineDetail: oldLoadedData!, logDate: oldLoadedData!.dailyLogs[0].logDate, exerciseTitle: (oldLoadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!)
                    self.sut.loadLogs(routine: routine)
                }
                
                it("Shoud happen nothing since it is not permitted to do in the UI") {
                    expect((oldLoadedData?.dailyLogs[0].exerciseLogs[0].set.count)! == self.routineDetailPresenterMock.loadedData!.dailyLogs[0].exerciseLogs[0].set.count).toEventually(beTrue())
                }
            }

            afterEach {
                oldLoadedData = nil
                
                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                flogInteractor.deleteRoutine(index: (flogInteractor.presenter as! FLogPresenterMock).loadedArray.count-1)
            }
        }
        
        describe("Max Weight") {
            var prevMaxWeight: String?
            var currentMaxWeight: String?
            
            beforeEach {
                NewRoutineInteractor().createNewRoutine(title: "test_routine_detail", unit: .kg, exerciseTitles: ["exercise1", "exercise2", "exercise3"])

                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
            }
            
            context("When a maximum weight is typed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //""
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should be updated to the typed weight") {
                    expect(prevMaxWeight != currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a maximum weight is typed in the other log") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"100"
                    
                    
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should be updated to the typed weight") {
                    expect(prevMaxWeight != currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a lower weight is typed in the other log") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"100000"
                }
                
                it("Should NOT be updated to the typed weight") {
                    expect(prevMaxWeight == currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a lower weight is typed in the other slot") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated to the typed weight") {
                    expect(prevMaxWeight == currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a lower weight is typed in the same slot having the max weight") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"100"
                }
                
                it("Should be updated to the typed weight") {
                    expect(prevMaxWeight != currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a set containing the maximum weight is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "1000", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:2, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    // remove "10000"
                    self.sut.removeSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"1000"
                }
                
                it("Should be updated") {
                    expect(prevMaxWeight != currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When the maximum weight in the other log is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "", logDate: logDate, exerciseTitle: exerciseTitle)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"100"
                }
                
                it("Should be updated") {
                    expect(prevMaxWeight != currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a lower weight in the same log is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:2, slotIdentifier: .weight, text: "1000", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    // remove "1000"
                    self.sut.removeSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated") {
                    expect(prevMaxWeight == currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a lower weight in the other log is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated") {
                    expect(prevMaxWeight == currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a log containing the maximum weight is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.removeLog(removeIndex: 0, routine: routine)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //""
                }
                
                it("Should be updated") {
                    expect(prevMaxWeight != currentMaxWeight).toEventually(beTrue())
                }
            }
            
            context("When a log containing lower weights is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10000", logDate: logDate, exerciseTitle: exerciseTitle)
                    
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.removeLog(removeIndex: 1, routine: routine)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxWeight = self.getMaxWeight(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated") {
                    expect(prevMaxWeight == currentMaxWeight).toEventually(beTrue())
                }
            }
            
            afterEach {
                prevMaxWeight = ""
                currentMaxWeight = ""
                
                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                flogInteractor.deleteRoutine(index: (flogInteractor.presenter as! FLogPresenterMock).loadedArray.count-1)
            }
        }
        
        describe("Max Total") {
            var prevMaxTotal: String?
            var currentMaxTotal: String?

            beforeEach {
                NewRoutineInteractor().createNewRoutine(title: "test_routine_detail", unit: .kg, exerciseTitles: ["exercise1", "exercise2", "exercise3"])

                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
            }

            context("When a maximum weight and reps are typed in a log") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!

                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //""

                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }

                it("Should be updated to the typed Weight x Reps") {
                    expect(prevMaxTotal != currentMaxTotal).toEventually(beTrue())
                }
            }

            context("When a weight and reps are typed in a log having maximum total") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!

                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"20000"
                }

                it("Should be updated") {
                    expect(prevMaxTotal != currentMaxTotal).toEventually(beTrue())
                }
            }

            context("When the maximum weight and reps are typed in the other log") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"


                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "1000", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "1000", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"1000000"
                }

                it("Should be updated") {
                    expect(prevMaxTotal != currentMaxTotal).toEventually(beTrue())
                }
            }

            context("When lower weight and reps are typed in the other log") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"


                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }

                it("Should NOT be updated") {
                    expect(prevMaxTotal == currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a reps related to the maximum total is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!

                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"20000"
                    
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should be updated") {
                    expect(prevMaxTotal != currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a weight related to the maximum total is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!

                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"20000"
                    
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should be updated") {
                    expect(prevMaxTotal != currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a weight and reps related to the maximum total is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!

                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"20000"
                    
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should be updated") {
                    expect(prevMaxTotal != currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a set related to the maximum total is removed ") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!

                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"20000"
                    
                    
                    self.sut.removeSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should be updated") {
                    expect(prevMaxTotal != currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a reps not related to the maximum total is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)

                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated") {
                    expect(prevMaxTotal == currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a weight not related to the maximum total is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)

                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated") {
                    expect(prevMaxTotal == currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a weight and reps not related to the maximum total is removed") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)

                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated") {
                    expect(prevMaxTotal == currentMaxTotal).toEventually(beTrue())
                }
            }
            
            context("When a set not related to the maximum total is removed ") {
                beforeEach {
                    var aMonthAgo = Date()
                    aMonthAgo.addTimeInterval(-(60*60*24*30))
                    let routine = (self.routineArray?.last)!
                    self.sut.createLog(date: aMonthAgo, routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let logDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[0].logDate
                    let exerciseTitle = (self.routineDetailPresenterMock.loadedData?.dailyLogs[0].exerciseLogs[0].exerciseTitle)!
                    
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .weight, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:0, slotIdentifier: .reps, text: "100", logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: logDate)

                    self.sut.createLog(date: Date(), routine: routine)
                    self.sut.loadLogs(routine: routine)
                    let newLogDate = self.routineDetailPresenterMock.loadedData!.dailyLogs[1].logDate
                    self.sut.createSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .weight, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateSet(routineDetail: self.routineDetailPresenterMock.loadedData!, setIndex:1, slotIdentifier: .reps, text: "10", logDate: newLogDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    prevMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                    
                    
                    self.sut.removeSet(routineDetail: self.routineDetailPresenterMock.loadedData!, logDate: logDate, exerciseTitle: exerciseTitle)
                    self.sut.updateMaxValueIfNeeded(routineTitle: routine.title, logDate: newLogDate)
                    currentMaxTotal = self.getMaxVolume(exerciseTitle: exerciseTitle) //"10000"
                }
                
                it("Should NOT be updated") {
                    expect(prevMaxTotal == currentMaxTotal).toEventually(beTrue())
                }
            }
            
            afterEach {
                prevMaxTotal = ""
                currentMaxTotal = ""

                let flogInteractor = FLogInteractor()
                flogInteractor.presenter = FLogPresenterMock()
                flogInteractor.dispatchRoutines()
                flogInteractor.deleteRoutine(index: (flogInteractor.presenter as! FLogPresenterMock).loadedArray.count-1)
            }
        }
        
        afterSuite {
            self.routineDetailPresenterMock = nil
            self.sut = nil
            self.routineArray = nil
        }
    }
    
    func getMaxVolume(exerciseTitle: String) -> String {
        return self.routineDetailPresenterMock.maxInfo?[exerciseTitle]?["best_max_volume"] ?? ""
    }
    
    func getMaxWeight(exerciseTitle: String) -> String {
        return self.routineDetailPresenterMock.maxInfo?[exerciseTitle]?["best_max_weight"] ?? ""
    }
    
}

class RoutineDetailPresenterMock: RoutineDetailInteractorOutputProtocol {
    var succeeded = false
    var errorOccurred = false
    var loadedData: RoutineDetailModel?
    var maxInfo: Dictionary<String, Dictionary<String, String>>?
    
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>) {
        self.maxInfo = maxInfo
        errorOccurred = false
        succeeded = true
    }
    
    func didLogLoaded(routineDetail: RoutineDetailModel) {
        loadedData = routineDetail
        errorOccurred = false
        succeeded = true
    }
    
    func didCreateLog() {
        errorOccurred = false
        succeeded = true
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        errorOccurred = true
        succeeded = false
    }
    
    func didRemoveLog(removedIndex: Int) {
        errorOccurred = false
        succeeded = true
    }
    
    func didUpdateSetData(routineDetail: RoutineDetailModel) {
        loadedData = routineDetail
        errorOccurred = false
        succeeded = true
    }
}
