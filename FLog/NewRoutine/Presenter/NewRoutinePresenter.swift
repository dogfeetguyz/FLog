//
//  NewRoutinePresenter.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class NewRoutinePresenter: NewRoutinePresenterProtocol {
    var view: ViperView?
    var interactor: ViperInteractorInput?
    var router: ViperRouter?
    
    func viewDidLoad() { }
    
    func clickCreateButton(title: String?, unit: Unit, exerciseTitles:Array<String?>) {
        if let _interactor = interactor as? NewRoutineInteractorInputProtocol {
            _interactor.createNewRoutine(title: title, unit: unit, exerciseTitles: exerciseTitles)
        }
    }
}

extension NewRoutinePresenter: NewRoutineInteractorOutputProtocol {
    func didDataLoaded(with loadedData: ViperEntity) { }
    
    func didCreateNewRoutine() {
        if let _router = router as? NewRoutineRouter {
            _router.finishNewRoutineModule(from: view!)
        }
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        view?.showError(title: title, message: message, buttonTitle: buttonTitle, handler: handler)
    }
}
