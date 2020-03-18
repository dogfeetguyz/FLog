//
//  ViperProtocol.swift
//  FLog
//
//  Created by Yejun Park on 18/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit


/**
 Protocol that defines the view input methods.
 The View is responsible for displaying Routine Screen.
 */
public protocol ViperView: class {
    /// Reference to the Presenter's interface.
    var presenter: ViperPresenter? {get set}
    
    /// Reference to the loaded data from presenter.
    var loadedData: ViperEntity? {get set}

    // MARK: presenter -> view
    /// Update View with loaded data
    /// - parameter entity: loaded data from presenter
    func updateVIew(with entity: ViperEntity)

    /// Shows error message on the view
    /// - parameter title: title for the alert
    /// - parameter message: message for the alert
    /// - parameter buttonTitle: OK Button title for the alert
    /// - parameter handler: OK Button action for the alert
    func showError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
}

/**
 Protocol that defines the Interactor's use case.
 The Interactor is responsible for implementing business logics of the module.
 */
public protocol ViperInteractorInput: class {
    /// Reference to the Presenter's interface.
    var presenter: ViperInteractorOutput? {get set}
    
    // MARK: prsenter -> interactor
    /// Dispatches Routine from UserDefaults
    func loadData(with initialData: ViperEntity?)
}

extension ViperInteractorInput {
    func loadData() {
        return loadData(with: nil)
    }
}

/**
 Protocol that defines the commands sent from the Interactor to the Presenter.
 */
public protocol ViperInteractorOutput: class {
    // MARK: interactor -> presenter
    /// Finished dispatching Viper Entity
    /// - parameter loadedData: a Viper Entity loaded from UserDefaults
    func didDataLoaded(with loadedData: ViperEntity)
    
    /// Handles error occurred during dispatching Viper Entity
    /// - parameter title: title for the alert
    /// - parameter message: message for the alert
    /// - parameter buttonTitle: OK Button title for the alert
    /// - parameter handler: OK Button action for the alert
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?)
}

/**
 Protocol that defines the commands sent from the View to the Presenter.
 The Presenter is responsible for connecting the other objects inside a VIPER module.
 */
public protocol ViperPresenter: class {
    /// Reference to the View (weak to avoid retain cycle).
    var view: ViperView? {get set}
    /// Reference to the Interactor's interface.
    var interactor: ViperInteractorInput? {get set}
    /// Reference to the Router.
    var wireFrame: ViperRouter? {get set}

    // MARK: view -> presenter
    /// Should call after viewDidLoad is called
    func viewDidLoad()
}

public protocol ViperEntity: Any {
}

/**
 Protocol that defines the possible routes from the Routine Module.
 The Router is responsible for navigation between modules.
 */
public protocol ViperRouter: class {
    
    /// Creates Routine Module
    static func createModule(with initialData: ViperEntity?) -> UIViewController
}

extension ViperRouter {
    /// Creates Routine Module
    static func createModule() -> UIViewController {
        return createModule(with: nil)
    }
}

