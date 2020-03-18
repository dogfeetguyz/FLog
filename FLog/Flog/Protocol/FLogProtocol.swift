//
//  FLogProtocol.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit


public protocol FLogViewProtocol: ViperView {
}

public protocol FLogInteractorInputProtocol: ViperInteractorInput {
    /// Create Sample Data for the first execution
    func createSampleData()
    
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

public protocol FLogPresenterProtocol: ViperPresenter {
    
    /// Should call after viewWillAppear is called
    func needsUpdate()
    
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

public protocol FLogInteractorOutputProtocol: ViperInteractorOutput {
}

public protocol FLogEntityProtocol: ViperEntity {
    var flogArray: Array<MainRoutineModel>? {get set}
}

public protocol FLogRouterProtocol: ViperRouter {
    /// Presents Routine Detail Module
    /// - parameter view: this view
    /// - parameter routine: targeted routine to go detail module
    func presentRoutineDetailViewScreen(from view: ViperView, forRoutine routine: MainRoutineModel)
    
    /// Presents New Routine Module
    /// - parameter view: this view
    func presentNewRoutineViewScreen(from view: ViperView)
}
