//
//  TimelineWireFrame.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class TimelineWireFrame: TimelineWireFrameProtocol {
    
    class func createTimelineModule() -> UIViewController {
        
        let navigationController = UIStoryboard(name: "TimelineView", bundle: Bundle.main).instantiateInitialViewController()
        if let view = navigationController!.children.first as? TimelineView {
            
            let presenter: TimelinePresenterProtocol & TimelineInteractorOutputProtocol = TimelinePresenter()
            let interactor: TimelineInteractorInputProtocol = TimelineInteractorInput()
            let wireFrame: TimelineWireFrameProtocol = TimelineWireFrame()

            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter

            return navigationController!
        }
        return UIViewController()
    }
}
