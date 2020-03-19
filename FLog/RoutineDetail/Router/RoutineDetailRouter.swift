//
//  RoutineDetailWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineDetailRouter: RoutineDetailRouterProtocol {
    class func createModule(with initialData: ViperEntity?) -> UIViewController {
        let viewController = UIStoryboard(name: "RoutineDetailView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = viewController as? RoutineDetailView {
            let presenter: RoutineDetailPresenterProtocol & RoutineDetailInteractorOutputProtocol = RoutineDetailPresenter()
            let interactor: RoutineDetailInteractorInputProtocol = RoutineDetailInteractor()
            let router: RoutineDetailRouterProtocol = RoutineDetailRouter()

            if let _initialData = initialData as? RoutineDetailEntityProtocol {
                view.title = _initialData.routine.title
            }
            view.presenter = presenter
            view.loadedData = initialData
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            interactor.presenter = presenter

            return viewController!
        }
        return UIViewController()
    }
}
