//
//  RoutineDetailWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class FLogRouter: FLogRouterProtocol {
    static func createModule(with initialData: ViperEntity?) -> UIViewController {
        let navigationController = UIStoryboard(name: "FLogView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = navigationController!.children.first as? FLogView {
            
            let presenter: FLogPresenterProtocol & FLogInteractorOutputProtocol = FLogPresenter()
            let interactor: FLogInteractorInputProtocol = FLogInteractor()
            let wireFrame: FLogRouterProtocol = FLogRouter()

            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter

            return navigationController!
        }
        return UIViewController()
    }
    
    func presentRoutineDetailViewScreen(from view: ViperView, forRoutine routine: MainRoutineModel) {
        let routineDetailView = RoutineDetailWireFrame.createRoutineDetailModule(with: routine)

        if let sourceView = view as? UIViewController {
           sourceView.navigationController?.pushViewController(routineDetailView, animated: true)
        }
    }

    
    func presentNewRoutineViewScreen(from view: ViperView) {
        let newRoutineView = NewRoutineWireFrame.createNewRoutineModule()

        if let sourceView = view as? UIViewController {
           sourceView.navigationController?.pushViewController(newRoutineView, animated: true)
        }
    }
}
