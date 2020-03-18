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
    var sut: NewRoutineInteractor!
    var newRoutinePresenterMock: NewRoutinePresenterMock!
    
    var routineArray:Array<MainRoutineModel>?
    
    override func spec() {
        beforeSuite {
            self.newRoutinePresenterMock = NewRoutinePresenterMock()
            self.sut = NewRoutineInteractor()
            self.sut.presenter = self.newRoutinePresenterMock
        }
        
        describe("Creation Result") {
            context("When NAME field and EXERCISE fields are empty") {
                beforeEach {
                    self.sut.createNewRoutine(title: "", unit: .kg, exerciseTitles: [])
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.newRoutinePresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            context("When NAME field is empty") {
                beforeEach {
                    self.sut.createNewRoutine(title: "", unit: .kg, exerciseTitles: ["exercise1"])
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.newRoutinePresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            context("When EXERCISE fields are empty") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: [])
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.newRoutinePresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            context("When EXERCISE fields are array of empty strings") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: ["", "", "", ""])
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.newRoutinePresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            context("When EXERCISE fields are array of empty strings") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: ["exercise1", "exercise1"])
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.newRoutinePresenterMock.errorOccurred).toEventually(beTrue())
                }
            }

            context("When NAME field and EXERCISE fields are filled") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: ["exercise1"])
                }

                it("Should be successfully created") {
                    expect(self.newRoutinePresenterMock.succeeded).toEventually(beTrue())
                }
            }

            context("When NAME typed already exists") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: ["exercise1"])
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: ["exercise1"])
                }

                it("Should notify the Presenter about the failure of the operation") {
                    expect(self.newRoutinePresenterMock.errorOccurred).toEventually(beTrue())
                }

                afterEach {
                    self.newRoutinePresenterMock.succeeded = true
                }
            }
            
            context("When lb is selected for UNIT") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .lb, exerciseTitles: ["exercise1"])

                    let flogInteractor = FLogInteractor()
                    flogInteractor.presenter = FLogPresenterMock()
                    flogInteractor.loadData()
                    self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
                }

                it("Should have lb as unit") {
                    expect(self.routineArray?.last?.unit == "lb").toEventually(beTrue())
                }
            }

            context("When kg is selected for UNIT") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: ["exercise1"])

                    let flogInteractor = FLogInteractor()
                    flogInteractor.presenter = FLogPresenterMock()
                    flogInteractor.loadData()
                    self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
                }

                it("Should have kg as unit") {
                    expect(self.routineArray?.last?.unit == "kg").toEventually(beTrue())
                }
            }

            context("When the number of exercises are more than one exercise") {
                beforeEach {
                    self.sut.createNewRoutine(title: "new_routine_1", unit: .kg, exerciseTitles: ["exercise1", "exercise2", "exercise3", "exercise4", "exercise5"])

                    let flogInteractor = FLogInteractor()
                    flogInteractor.presenter = FLogPresenterMock()
                    flogInteractor.loadData()
                    self.routineArray = (flogInteractor.presenter as! FLogPresenterMock).loadedArray
                }

                it("Should have the same number of exercises as request") {
                    expect(self.routineArray?.last?.exerciseTitles.count == 5).toEventually(beTrue())
                }
            }
            
            afterEach {
                if self.newRoutinePresenterMock.succeeded {
                    let flogInteractor = FLogInteractor()
                    flogInteractor.presenter = FLogPresenterMock()
                    flogInteractor.loadData()
                    
                    let lastIndex = (flogInteractor.presenter as! FLogPresenterMock).loadedArray.count - 1
                    flogInteractor.deleteRoutine(index: lastIndex)
                }
            }
        }
        
        afterSuite {
            self.newRoutinePresenterMock = nil
            self.sut = nil
            self.routineArray = nil
        }
    }
}

class NewRoutinePresenterMock: NewRoutineInteractorOutputProtocol {
    var succeeded = false
    var errorOccurred = false
    
    func didCreateNewRoutine() {
        succeeded = true
        errorOccurred = false
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        succeeded = false
        errorOccurred = true
    }
}
