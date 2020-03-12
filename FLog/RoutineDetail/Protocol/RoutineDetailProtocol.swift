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
    func loadLogs()
    func loadMaxInfo()
    func textfieldUpdated(tag: String, text: String, logDate: String, exerciseTitle: String)
    func finishedInputData(logDate: String)
    func newLogAction(date: Date)
    func deleteLogAction(deleteIndex: Int)
    func updateMaxInfo(exerciseTitle: String)
    func addSetAction(logDate: String, exerciseTitle: String)
    func removeSetAction(logDate: String, exerciseTitle: String)
}

/**
 Protocol that defines the commands sent from the Interactor to the Presenter.
 */
public protocol RoutineDetailInteractorOutputProtocol: class {
    // MARK: interactor -> presenter
    
    func needsFirstLog()
    func didLogLoaded(routineDetail: RoutineDetailModel)
    func didUpdateLog(routineDetail: RoutineDetailModel)
    func didMaxInfoLoaded(maxInfo: Dictionary<String, Dictionary<String, String>>)
    func didCreateNewFitnessLog()
    func didDeleteFitnessLog(deletedIndex: Int)
    
    /// Handles error occurred during dispatching Account Detail
    /// - parameter title: title for the alert
    /// - parameter message: message for the alert
    /// - parameter buttonTitle: OK Button title for the alert
    /// - parameter handler: OK Button action for the alert
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
}

/**
 Protocol that defines the Interactor's use case.
 The Interactor is responsible for implementing business logics of the module.
 */
public protocol RoutineDetailInteractorInputProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: RoutineDetailInteractorOutputProtocol? {get set}
    
    
    // MARK: prsenter -> interactor
    func loadLogs(routine: MainRoutineModel)
    func loadMaxInfo(routineTitle: String)
    func checkNewMaxInfo(routineTitle: String, logDate: String)
    
    /// Create new routine
    func createNewFitnessLog(date: Date, routine: MainRoutineModel)
    func deleteFitnessLog(deleteIndex: Int, routine: MainRoutineModel)
    func refindMaxValue(routineTitle: String, exerciseTitle: String)
    func createNewSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String)
    func removeSet(routineDetail: RoutineDetailModel, logDate: String, exerciseTitle: String)
    func updateSet(routineDetail: RoutineDetailModel, tag: String, text: String, logDate: String, exerciseTitle: String)
}

/**
 Protocol that defines the view input methods.
 The View is responsible for displaying Routine Screen.
 */
public protocol RoutineDetailViewProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: RoutineDetailPresenterProtocol? {get set}
    var routineDetailData: RoutineDetailModel? {get set}
    
    // MARK: presenter -> view
    
    func showRoutineDetail(routineDetail: RoutineDetailModel)
    func showCreateDialog(isFirst: Bool)
    func updateLogView(segmentIndex: Int)
    func updateMaxInfoView(maxInfo: Dictionary<String, Dictionary<String, String>>)
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
