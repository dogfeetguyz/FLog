//
//  TimelineWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class TimelineRouter: TimelineRouterProtocol {
    class func createModule(with initialData: ViperEntity?) -> UIViewController {
        
        let navigationController = UIStoryboard(name: "TimelineView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = navigationController!.children.first as? TimelineView {
            
            let presenter: TimelinePresenterProtocol & TimelineInteractorOutputProtocol = TimelinePresenter()
            let interactor: TimelineInteractorInputProtocol = TimelineInteractor()
            let router: TimelineRouterProtocol = TimelineRouter()

            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            interactor.presenter = presenter

            return navigationController!
        }
        return UIViewController()
    }
}
