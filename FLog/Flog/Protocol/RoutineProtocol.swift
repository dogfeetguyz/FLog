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
    /// Should call after viewDidLoad called
    func viewDidLoad()
    
    /// Should call after viewWillAppear called
    func updateView()
    
    
    func deleteCell(index: Int)
    
    
    func moveCell(sourceIndex: Int, destinationIndex: Int)
    
    
    func modifyCellTitle(index: Int, newTitle: String)
    
    func showRoutineDetail(forRoutine routine: MainRoutineModel)
    func showCreateNewRoutine() 
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
    
    func deleteRoutine(index: Int)
    
    
    func replaceRoutines(sourceIndex: Int, destinationIndex: Int)
    
    
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
    func presentRoutineDetailViewScreen(from view: RoutineViewProtocol, forRoutine routine: MainRoutineModel)
    func presentNewRoutineViewScreen(from view: RoutineViewProtocol)
}
