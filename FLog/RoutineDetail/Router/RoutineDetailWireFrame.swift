//
//  RoutineDetailWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class RoutineDetailWireFrame: RoutineDetailWireFrameProtocol {
    
    class func createRoutineDetailModule(with routineModel:MainRoutineModel) -> UIViewController {
        let viewController = UIStoryboard(name: "RoutineDetailView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = viewController as? RoutineDetailView {
            let presenter: RoutineDetailPresenterProtocol & RoutineDetailInteractorOutputProtocol = RoutineDetailPresenter()
            let interactor: RoutineDetailInteractorInputProtocol = RoutineDetailInteractor()
            let wireFrame: RoutineDetailWireFrameProtocol = RoutineDetailWireFrame()

            view.presenter = presenter
            view.routineDetailData = RoutineDetailModel(routine: routineModel, dailyExercises: [])
            presenter.view = view
            presenter.interactor = interactor
            presenter.wireFrame = wireFrame
            interactor.presenter = presenter

            return viewController!
        }
        return UIViewController()
    }
    
    func finishNewRoutineModule(from view: NewRoutineViewProtocol) {
        if let sourceView = view as? UIViewController {
            sourceView.navigationController!.popViewController(animated: true)
        }
    }
}
