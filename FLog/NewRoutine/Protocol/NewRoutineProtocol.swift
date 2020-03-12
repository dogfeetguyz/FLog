//
//  NewRoutineProtocol.swift
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
public protocol NewRoutinePresenterProtocol: class {
    /// Reference to the View (weak to avoid retain cycle).
    var view: NewRoutineViewProtocol? {get set}
    
    /// Reference to the Interactor's interface.
    var interactor: NewRoutineInteractorInputProtocol? {get set}
    
    /// Reference to the Router.
    var wireFrame: NewRoutineWireFrameProtocol? {get set}
    
    
    // MARK: view -> presenter
    /// Should call after viewDidLoad called
    func viewDidLoad()
    
    /// Should call when 'Create Button' clicked
    /// - parameter title: Routine Title
    /// - parameter unit: Unit used for this routine between kg and lb
    /// - parameter exerciseTitles: An array of exercise titles for this routine
    func clickCreateButton(title: String?, unit: Unit, exerciseTitles:Array<String?>)
}

/**
 Protocol that defines the commands sent from the Interactor to the Presenter.
 */
public protocol NewRoutineInteractorOutputProtocol: class {
    // MARK: interactor -> presenter
    /// Finished creating the new routine
    func didCreateNewRoutine()
    
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
public protocol NewRoutineInteractorInputProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: NewRoutineInteractorOutputProtocol? {get set}
    
    
    // MARK: prsenter -> interactor
    /// Create new routine
    /// - parameter title: Routine Title
    /// - parameter unit: Unit used for this routine between kg and lb
    /// - parameter exerciseTitles: An array of exercise titles for this routine
    func createNewRoutine(title: String?, unit: Unit, exerciseTitles:Array<String?>)
}

/**
 Protocol that defines the view input methods.
 The View is responsible for displaying Routine Screen.
 */
public protocol NewRoutineViewProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: NewRoutinePresenterProtocol? {get set}
    
    
    // MARK: presenter -> view
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
public protocol NewRoutineWireFrameProtocol: class {
    /// Creates New Routine Module
    static func createNewRoutineModule() -> UIViewController
    
    /// Dismiss New Routine Module
    /// - parameter view: This view
    func finishNewRoutineModule(from view: NewRoutineViewProtocol)
}
