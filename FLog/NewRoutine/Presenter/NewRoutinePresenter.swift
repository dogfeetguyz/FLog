//
//  NewRoutinePresenter.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class NewRoutinePresenter: NewRoutinePresenterProtocol {
    weak var view: NewRoutineViewProtocol?
    var wireFrame: NewRoutineWireFrameProtocol?
    var interactor: NewRoutineInteractorInputProtocol?
    
    func viewDidLoad() {
    }
    
    func clickCreateButton(title: String?, unit: Unit, exerciseTitles:Array<String?>) {
        interactor?.createNewRoutine(title: title, unit: unit, exerciseTitles: exerciseTitles)
    }
}

extension NewRoutinePresenter: NewRoutineInteractorOutputProtocol {
    func didCreateNewRoutine() {
        wireFrame?.finishNewRoutineModule(from: view!)
    }
    
    func onError(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) {
        view?.showError(title: title, message: message, buttonTitle: buttonTitle, handler: handler)
    }
}
