//
//  RoutineDetailProtocol.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

protocol RoutineDetailViewProtocol: ViperView {
    // MARK: presenter -> view
    
    /// Shows routine detail with logs for this routine
    /// - parameter routineDetail: Routine detail data to draw the screen
    func showRoutineDetail(routineDetail: ViperEntity)
    
    /// Shows a dialog to create new log
    /// - parameter isFirst: Indicates whetere is the first log or not
    func showCreateDialog(isFirst: Bool)
    
    /// Updates the targeted log
    /// - parameter segmentIndex: Current segment index after create, update, and remove
    func updateLogView(segmentIndex: Int)
    
    /// Update max info view
    /// - parameter maxInfo: Updated max info
    func updateMaxInfoView(maxInfo: Dictionary<String, Dictionary<String, String>>)
    
    /// Update TableView
    /// - parameter routineDetail: Updated routine detail data
    func updateTableView(routineDetail: ViperEntity)
}

protocol RoutineDetailInteractorInputProtocol: ViperInteractorInput {
    // MARK: prsenter -> interactor
    /// Loads logs from UserDefaults
    /// - parameter routine: Routine Data to load the detail data
    func loadLogs(routine: MainRoutineModel)
    
    /// Loads max info from UserDefaults
    /// - parameter routineTitle: The routine title related to this loading
    func loadMaxInfo(routineTitle: String)
    
    /// Creates new Log for the selected routine
    /// - parameter date: The date of a newly created log
    /// - parameter routine: Routine Data for this routine
    func createLog(date: Date, routine: MainRoutineModel)
    
    /// Removes the targeted log
    /// - parameter removeIndex: The index of log to be removed
    /// - parameter routine: Routine Data for this routine
    func removeLog(removeIndex: Int, routine: MainRoutineModel)
    
    /// Updates max value if needed
    /// - parameter routineTitle: The routine title related to this checking
    /// - parameter logDate: The date of a log to check the targeted max info
    func updateMaxValueIfNeeded(routineTitle: String, logDate: String)
    
    /// Refinds the max info when it is needed
    /// - parameter routineTitle: The routine title related to this refinding
    /// - parameter exerciseTitle: The title of an exercise  to look up the max info
    func refindMaxValue(routineTitle: String, exerciseTitle: String)
    
    /// Creates a new set for the exercise on the log
    /// - parameter routineDetail:Routine detail data related to this update
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func createSet(routine: MainRoutineModel, logDate: String, exerciseTitle: String)
    
    /// Removes a targeted set
    /// - parameter routineDetail: Routine detail data related to this update
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func removeSet(routine: MainRoutineModel, logDate: String, exerciseTitle: String)
    
    /// Updates the content of a set
    /// - parameter routineDetail: Routine detail data related to this update
    /// - parameter setIndex: The index to indicate which set is updated
    /// - parameter slotIdentifier :An identifier to indicate selected slot among Weight slot and Reps slot
    /// - parameter text: Updated text
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func updateSet(routine: MainRoutineModel, setIndex: Int, slotIdentifier:Slot, text: String, logDate: String, exerciseTitle: String)
}

protocol RoutineDetailInteractorOutputProtocol: ViperInteractorOutput {
    // MARK: interactor -> presenter
    
    /// Finished load max info
    /// - parameter maxInfo: The information of max data
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>)
    
    /// Finished load logs
    /// - parameter routineDetail: Routine detail data to draw the screen
    func didLogLoaded(routineDetail: ViperEntity)
    
    /// finished creating new log
    func didCreateLog()
    
    /// finished removing the targeted log
    /// - parameter removedIndex: The index removed
    func didRemoveLog(removedIndex: Int)
    
    /// Finished updating the set in exercises of a log
    /// - parameter routineDetail: Routine the updated detail data to update the screen
    func didUpdateSetData(routineDetail: ViperEntity)
}

protocol RoutineDetailPresenterProtocol: ViperPresenter {
    /// Should call when the contents of logs were updated
    func loadLogs()
    
    /// Should call when the more/less button for maxInfo clicked
    func loadMaxInfo()
    
    /// Should call when the textfield is updated
    /// - parameter setIndex: The index to indicate which set is updated
    /// - parameter slotIdentifier :An identifier to indicate selected slot among Weight slot and Reps slot
    /// - parameter text: Updated text
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func textfieldUpdated(setIndex: Int, slotIdentifier:Slot, text: String, logDate: String, exerciseTitle: String)
    
    /// Should call when typing on textfields is finished
    /// - parameter logDate: The date of a log related to this update
    func finishedInputData(logDate: String)
    
    /// Should call when a new log is created
    /// - parameter date: The date of a newly created log
    func newLogAction(date: Date)
    
    /// Should call when a log is removed
    /// - parameter removeIndex: The index of log to be removed
    func removeLogAction(removeIndex: Int)
    
    /// Should call when a new set is created
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func addSetAction(logDate: String, exerciseTitle: String)
    
    /// Should call when a set is removed
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func removeSetAction(logDate: String, exerciseTitle: String)
}

protocol RoutineDetailEntityProtocol: ViperEntity {
    /// Main Routine data for this Routine Detail data
    var routine: MainRoutineModel { get set }
    
    /// Daily logs data that can be selected in SegmentedControl
    var dailyLogs: [DailyLogModel] { get set }
}

protocol RoutineDetailRouterProtocol: ViperRouter {
}
