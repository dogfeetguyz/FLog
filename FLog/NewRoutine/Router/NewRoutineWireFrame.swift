//
//  NewRoutineWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class NewRoutineWireFrame: NewRoutineWireFrameProtocol {
    
    class func createNewRoutineModule() -> UIViewController {
        let newRoutine = UIStoryboard(name: "NewRoutineView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = newRoutine as? NewRoutineView {
            let presenter: NewRoutinePresenterProtocol & NewRoutineInteractorOutputProtocol = NewRoutinePresenter()
            let interactor: NewRoutineInteractorInputProtocol = NewRoutineInteractor()
            let wireFrame: NewRoutineWireFrameProtocol = NewRoutineWireFrame()

            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.wireFrame = wireFrame
            interactor.presenter = presenter

            return newRoutine!
        }
        return UIViewController()
    }
    
    func finishNewRoutineModule(from view: NewRoutineViewProtocol) {
        if let sourceView = view as? UIViewController {
            sourceView.navigationController!.popViewController(animated: true)
        }
    }
}
