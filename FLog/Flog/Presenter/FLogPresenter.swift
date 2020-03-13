//
//  FLogPresenter.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class FLogPresenter: FLogPresenterProtocol {
    weak var view: FLogViewProtocol?
    var wireFrame: FLogWireFrameProtocol?
    var interactor: FLogInteractorInputProtocol?
    
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
    
    func clickRoutineCell(forRoutine routine: MainRoutineModel) {
        wireFrame?.presentRoutineDetailViewScreen(from: view!, forRoutine: routine)
    }
    
    func clickNewButton() {
        wireFrame?.presentNewRoutineViewScreen(from: view!)
    }
}

extension FLogPresenter: FLogInteractorOutputProtocol {
    // MARK: interactor -> presenter
    /// Finished dispatching Routines from UserDefaults
    /// - parameter mainRoutineModelArray: An array of MainRoutineModel loaded from UserDefaults
    func didDispatchRoutines(with mainRoutineArray: [MainRoutineModel]) {
        view?.showRoutines(with: mainRoutineArray)
    }
}
