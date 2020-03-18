//
//  FLogPresenter.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class FLogPresenter: FLogPresenterProtocol {
    var view: ViperView?
    var interactor: ViperInteractorInput?
    var wireFrame: ViperRouter?
    
    func viewDidLoad() {
        if let _interactor = interactor as? FLogInteractorInputProtocol {
            _interactor.createSampleData()
        }
    }
    
    func needsUpdate() {
        if let _interactor = interactor as? FLogInteractorInputProtocol {
            _interactor.loadData()
        }
    }
    
    func deleteCell(index: Int) {
        if let _interactor = interactor as? FLogInteractorInputProtocol {
            _interactor.deleteRoutine(index: index)
        }
    }
    
    func moveCell(sourceIndex: Int, destinationIndex: Int) {
        if let _interactor = interactor as? FLogInteractorInputProtocol {
            _interactor.replaceRoutines(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
        }
    }
    
    func modifyCellTitle(index: Int, newTitle: String) {
        if let _interactor = interactor as? FLogInteractorInputProtocol {
            _interactor.updateRoutineTitle(index: index, newTitle: newTitle)
        }
    }
    
    func clickRoutineCell(forRoutine routine: MainRoutineModel) {
        if let _wireFrame = wireFrame as? FLogRouterProtocol {
            _wireFrame.presentRoutineDetailViewScreen(from: view!, forRoutine: routine)
        }
    }
    
    func clickNewButton() {
        if let _wireFrame = wireFrame as? FLogRouterProtocol {
            _wireFrame.presentNewRoutineViewScreen(from: view!)
        }
    }
}

extension FLogPresenter: FLogInteractorOutputProtocol {
    func didDataLoaded(with loadedData: ViperEntity) {
        view?.updateVIew(with: loadedData)
    }

    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        view?.showError(title: title, message: message, buttonTitle: buttonTitle, handler: handler)
    }
}
