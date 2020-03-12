//
//  RoutineProtocol.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

/**
 Protocol that defines the commands sent from the View to the Presenter.
 The Presenter is responsible for connecting the other objects inside a VIPER module.
 */
public protocol RoutinePresenterProtocol: class {
    /// Reference to the View (weak to avoid retain cycle).
    var view: RoutineViewProtocol? {get set}
    
    /// Reference to the Interactor's interface.
    var interactor: RoutineInteractorInputProtocol? {get set}
    
    /// Reference to the Router.
    var wireFrame: RoutineWireFrameProtocol? {get set}
    
    
    // MARK: view -> presenter
    /// Should call after viewDidLoad is called
    func viewDidLoad()
    
    /// Should call after viewWillAppear is called
    func updateView()
    
    /// Should call after a cell is deleted
    /// - parameter index: the index of routine to delete
    func deleteCell(index: Int)
    
    /// Should call after a cell is moved
    /// - parameter sourceIndex: the index of routine to left
    /// - parameter destinationIndex: the index of routine to go
    func moveCell(sourceIndex: Int, destinationIndex: Int)
    
    /// Should call when the title of a cell is requested to modify
    /// - parameter index: the index of routine to modify
    /// - parameter newTitle: newly typed title
    func modifyCellTitle(index: Int, newTitle: String)
    
    /// Should call when a cell is clicked
    /// - parameter routine: Routine clicked
    func clickRoutineCell(forRoutine routine: MainRoutineModel)
    
    /// Should call when 'New Button' is cllicked
    func clickNewButton()
}

/**
 Protocol that defines the commands sent from the Interactor to the Presenter.
 */
public protocol RoutineInteractorOutputProtocol: class {
    // MARK: interactor -> presenter
    /// Finished dispatching Routines from UserDefaults
    /// - parameter mainRoutineModelArray: An array of MainRoutineModel loaded from UserDefaults
    func didDispatchRoutines(with mainRoutineArray: [MainRoutineModel])
}

/**
 Protocol that defines the Interactor's use case.
 The Interactor is responsible for implementing business logics of the module.
 */
public protocol RoutineInteractorInputProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: RoutineInteractorOutputProtocol? {get set}
    
    /// Create Sample Data for the first execution
    func createSampleData()
    
    /// Create Best Data for the first execution
    func createBestData()
    
    
    // MARK: prsenter -> interactor
    /// Dispatches Routine from UserDefaults
    func dispatchRoutines()
    
    /// Deletes Routines from UserDefaults
    /// - parameter index: the index of routine to delete
    func deleteRoutine(index: Int)
    
    /// Replaces Routines from UserDefaults
    /// - parameter sourceIndex: the index of routine to left
    /// - parameter destinationIndex: the index of routine to go
    func replaceRoutines(sourceIndex: Int, destinationIndex: Int)
    
    /// Updates Routine Title from UserDefaults
    /// - parameter index: the index of routine to modify
    /// - parameter newTitle: newly typed title
    func updateRoutineTitle(index: Int, newTitle: String)
}

/**
 Protocol that defines the view input methods.
 The View is responsible for displaying Routine Screen.
 */
public protocol RoutineViewProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: RoutinePresenterProtocol? {get set}
    
    
    // MARK: presenter -> view
    /// Shows Routines on Main Screen
    /// - parameter mainRoutineArray: loaded routines from UserDefaults
    func showRoutines(with mainRoutineArray: [MainRoutineModel])
}

/**
 Protocol that defines the possible routes from the Routine Module.
 The Router is responsible for navigation between modules.
 */
public protocol RoutineWireFrameProtocol: class {
    /// Creates Routine Module
    static func createRoutineModule() -> UIViewController
    
    /// Presents Routine Detail Module
    /// - parameter view: this view
    /// - parameter routine: targeted routine to go detail module
    func presentRoutineDetailViewScreen(from view: RoutineViewProtocol, forRoutine routine: MainRoutineModel)
    
    /// Presents New Routine Module
    /// - parameter view: this view
    func presentNewRoutineViewScreen(from view: RoutineViewProtocol)
}
