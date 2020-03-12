//
//  RoutineDetailWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineWireFrame: RoutineWireFrameProtocol {
    
    class func createRoutineModule() -> UIViewController {
        
        let navigationController = UIStoryboard(name: "RoutineView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = navigationController!.children.first as? RoutineView {
            
            let presenter: RoutinePresenterProtocol & RoutineInteractorOutputProtocol = RoutinePresenter()
            let interactor: RoutineInteractorInputProtocol = RoutineInteractorInput()
            let wireFrame: RoutineWireFrameProtocol = RoutineWireFrame()

            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter

            return navigationController!
        }
        return UIViewController()
    }
    
    func presentRoutineDetailViewScreen(from view: RoutineViewProtocol, forRoutine routine: MainRoutineModel) {
        let routineDetailView = RoutineDetailWireFrame.createRoutineDetailModule(with: routine)

        if let sourceView = view as? UIViewController {
           sourceView.navigationController?.pushViewController(routineDetailView, animated: true)
        }
    }

    
    func presentNewRoutineViewScreen(from view: RoutineViewProtocol) {
        let newRoutineView = NewRoutineWireFrame.createNewRoutineModule()

        if let sourceView = view as? UIViewController {
           sourceView.navigationController?.pushViewController(newRoutineView, animated: true)
        }
    }
}
