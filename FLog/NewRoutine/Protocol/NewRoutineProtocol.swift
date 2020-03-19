//
//  NewRoutineProtocol.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

protocol NewRoutineViewProtocol: ViperView {
}

protocol NewRoutineInteractorInputProtocol: ViperInteractorInput {
    // MARK: prsenter -> interactor
    /// Create new routine
    /// - parameter title: Routine Title
    /// - parameter unit: Unit used for this routine between kg and lb
    /// - parameter exerciseTitles: An array of exercise titles for this routine
    func createNewRoutine(title: String?, unit: Unit, exerciseTitles:Array<String?>)
}

protocol NewRoutineInteractorOutputProtocol: ViperInteractorOutput {
    // MARK: interactor -> presenter
    /// Finished creating the new routine
    func didCreateNewRoutine()
}

protocol NewRoutinePresenterProtocol: ViperPresenter {
    
    /// Should call when 'Create Button' clicked
    /// - parameter title: Routine Title
    /// - parameter unit: Unit used for this routine between kg and lb
    /// - parameter exerciseTitles: An array of exercise titles for this routine
    func clickCreateButton(title: String?, unit: Unit, exerciseTitles:Array<String?>)
}

protocol NewRoutineRouterProtocol: ViperRouter {
    /// Dismiss New Routine Module
    /// - parameter view: This view
    func finishNewRoutineModule(from view: ViperView)
}
