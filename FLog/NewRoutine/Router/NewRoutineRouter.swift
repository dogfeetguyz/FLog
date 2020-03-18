//
//  NewRoutineWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class NewRoutineRouter: NewRoutineRouterProtocol {
    
    class func createModule(with initialData: ViperEntity?) -> UIViewController {
        let viewController = UIStoryboard(name: "NewRoutineView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = viewController as? NewRoutineView {
            let presenter: NewRoutinePresenterProtocol & NewRoutineInteractorOutputProtocol = NewRoutinePresenter()
            let interactor: NewRoutineInteractorInputProtocol = NewRoutineInteractor()
            let router: NewRoutineRouterProtocol = NewRoutineRouter()

            view.presenter = presenter
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            interactor.presenter = presenter

            return viewController!
        }
        return UIViewController()
    }
    
    func finishNewRoutineModule(from view: ViperView) {
        if let sourceView = view as? UIViewController {
            sourceView.navigationController!.popViewController(animated: true)
        }
    }
}
