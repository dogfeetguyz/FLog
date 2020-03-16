//
//  RoutineDetailProtocol.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

/**
 Protocol that defines the commands sent from the View to the Presenter.
 The Presenter is responsible for connecting the other objects inside a VIPER module.
 */
public protocol RoutineDetailPresenterProtocol: class {
    /// Reference to the View (weak to avoid retain cycle).
    var view: RoutineDetailViewProtocol? {get set}
    
    /// Reference to the Interactor's interface.
    var interactor: RoutineDetailInteractorInputProtocol? {get set}
    
    /// Reference to the Router.
    var wireFrame: RoutineDetailWireFrameProtocol? {get set}
    
    
    // MARK: view -> presenter
    /// Should call after viewDidLoad called
    func viewDidLoad()
    
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

/**
 Protocol that defines the commands sent from the Interactor to the Presenter.
 */
public protocol RoutineDetailInteractorOutputProtocol: class {
    // MARK: interactor -> presenter
    
    /// Finished load max info
    /// - parameter maxInfo: The information of max data
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>)
    
    /// Finished load logs
    /// - parameter routineDetail: Routine detail data to draw the screen
    func didLogLoaded(routineDetail: RoutineDetailModel)
    
    /// finished creating new log
    func didCreateLog()
    
    /// Handles error occurred during create a log
    /// - parameter title: title for the alert
    /// - parameter message: message for the alert
    /// - parameter buttonTitle: OK Button title for the alert
    /// - parameter handler: OK Button action for the alert
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
    
    /// finished removing the targeted log
    /// - parameter removedIndex: The index removed
    func didRemoveLog(removedIndex: Int)
    
    /// Finished updating the set in exercises of a log
    /// - parameter routineDetail: Routine the updated detail data to update the screen
    func didUpdateSetData(routineDetail: RoutineDetailModel)
}

/**
 Protocol that defines the Interactor's use case.
 The Interactor is responsible for implementing business logics of the module.
 */
public protocol RoutineDetailInteractorInputProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: RoutineDetailInteractorOutputProtocol? {get set}
    
    
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
    func createSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String)
    
    /// Removes a targeted set
    /// - parameter routineDetail: Routine detail data related to this update
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func removeSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String)
    
    /// Updates the content of a set
    /// - parameter routineDetail: Routine detail data related to this update
    /// - parameter setIndex: The index to indicate which set is updated
    /// - parameter slotIdentifier :An identifier to indicate selected slot among Weight slot and Reps slot
    /// - parameter text: Updated text
    /// - parameter logDate: The date of a log related to this update
    /// - parameter exerciseTitle: The title of an exercise related to this update
    func updateSet(routineDetail: RoutineDetailModel, setIndex: Int, slotIdentifier:Slot, text: String, logDate: String, exerciseTitle: String)
}

/**
 Protocol that defines the view input methods.
 The View is responsible for displaying Routine Screen.
 */
public protocol RoutineDetailViewProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: RoutineDetailPresenterProtocol? {get set}
    
    /// Routine Detail Data for the detail screen
    var routineDetailData: RoutineDetailModel? {get set}
    
    // MARK: presenter -> view
    
    /// Shows routine detail with logs for this routine
    /// - parameter routineDetail: Routine detail data to draw the screen
    func showRoutineDetail(routineDetail: RoutineDetailModel)
    
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
    func updateTableView(routineDetail: RoutineDetailModel)
    
    /// Shows error message on the view
    /// - parameter title: title for the alert
    /// - parameter message: message for the alert
    /// - parameter buttonTitle: OK Button title for the alert
    /// - parameter handler: OK Button action for the alert
    func showError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
}

/**
 Protocol that defines the possible routes from the Routine Module.
 The Router is responsible for navigation between modules.
 */
public protocol RoutineDetailWireFrameProtocol: class {
    /// Creates Routine Detail Module
    static func createRoutineDetailModule(with routineModel: MainRoutineModel) -> UIViewController
}
