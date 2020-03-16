//
//  TimelineProtocol.swift
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
public protocol TimelinePresenterProtocol: class {
    /// Reference to the View (weak to avoid retain cycle).
    var view: TimelineViewProtocol? {get set}
    
    /// Reference to the Interactor's interface.
    var interactor: TimelineInteractorInputProtocol? {get set}
    
    /// Reference to the Router.
    var wireFrame: TimelineWireFrameProtocol? {get set}
    
    
    // MARK: view -> presenter
    /// Should call after viewDidLoad is called
    func viewDidLoad()
    
    /// Should call after the user scrolls the tableview to the bottom
    func tableViewScrollToBottom()
}

/**
 Protocol that defines the commands sent from the Interactor to the Presenter.
 */
public protocol TimelineInteractorOutputProtocol: class {
    // MARK: interactor -> presenter
    /// Finished dispatching Timelines from Core Data
    /// - parameter timelineArray: An array of TimelineModel including Timeline Data loaded from Core Data and Content processed from UserDefaults
    /// - parameter isInitial: check If it is an initial request or paging request
    func didDispatchTimelines(with timelineArray: [TimelineModel], isInitial: Bool)
    
    /// Handles error occurred during dispatching Timeline
    /// - parameter isInitial: check If it is an initial request or paging request 
    func onError(isInitial: Bool)
}

/**
 Protocol that defines the Interactor's use case.
 The Interactor is responsible for implementing business logics of the module.
 */
public protocol TimelineInteractorInputProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: TimelineInteractorOutputProtocol? {get set}
    var fetchOffset: Int {get set}
    
    /// Creates TImeline data for the first execute
    func createTimelineData()
    
    // MARK: prsenter -> interactor
    /// Dispatches Timeline from Core Data
    /// - parameter isInitial: check If it is an initial request or paging request
    func dispatchTimelines(isInitial: Bool)
}

/**
 Protocol that defines the view input methods.
 The View is responsible for displaying Timeline Screen.
 */
public protocol TimelineViewProtocol: class {
    /// Reference to the Presenter's interface.
    var presenter: TimelinePresenterProtocol? {get set}
    
    
    // MARK: presenter -> view
    /// Shows timeline data on tableview
    /// - parameter timelineArray: An array of TimelineModel including Timeline Data loaded from Core Data and Content processed from UserDefaults
    /// - parameter isInitial: check If it is an initial request or paging request
    func showTimelines(with timelineArray: [TimelineModel], isInitial: Bool)
    
    /// Handles error occurred during dispatching Timeline
    /// - parameter isInitial: check If it is an initial request or paging request
    func onError(isInitial: Bool)
}

/**
 Protocol that defines the possible routes from the Timeline Module.
 The Router is responsible for navigation between modules.
 */
public protocol TimelineWireFrameProtocol: class {
    /// Creates Timeline Module
    static func createTimelineModule() -> UIViewController
}
