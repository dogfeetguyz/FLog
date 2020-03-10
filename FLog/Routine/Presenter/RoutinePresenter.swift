//
//  RoutinePresenter.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutinePresenter: RoutinePresenterProtocol {
    weak var view: RoutineViewProtocol?
    var wireFrame: RoutineWireFrameProtocol?
    var interactor: RoutineInteractorInputProtocol?
    
    func viewDidLoad() {
        interactor?.createSampleData()
        interactor?.createBestData()
    }
    
    func updateView() {
        interactor?.dispatchRoutines()
    }
    
    func deleteCell(index: Int) {
        interactor?.deleteRoutine(index: index)
    }
    
    func moveCell(sourceIndex: Int, destinationIndex: Int) {
        interactor?.replaceRoutines(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
    }
    
    func modifyCellTitle(index: Int, newTitle: String) {
        interactor?.updateRoutineTitle(index: index, newTitle: newTitle)
    }
    
    func showCreateNewRoutine() {
        wireFrame?.presentNewRoutineViewScreen(from: view!)
    }
    
    func showRoutineDetail() {
        
    }
}

extension RoutinePresenter: RoutineInteractorOutputProtocol {
    // MARK: interactor -> presenter
    /// Finished dispatching Routines from UserDefaults
    /// - parameter mainRoutineModelArray: An array of MainRoutineModel loaded from UserDefaults
    func didDispatchRoutines(with mainRoutineArray: [MainRoutineModel]) {
        view?.showRoutines(with: mainRoutineArray)
    }
}
