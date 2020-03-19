//
//  TabBarWireframe.swift
//  FLog
//
//  Created by Yejun Park on 12/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//
import Foundation
import UIKit

/**
TabBarWireframe is responsible for navigation between AppDelegate and Initial View Controller.
This provides navigation to tabs on TabBarController.
 */
public class TabBarWireframe {
    
    /// Creates initial modules of each tab
    public class func createInitialModule() -> UIViewController {
        
        let tabbarController = UIStoryboard(name: "TabBarController", bundle: Bundle.main).instantiateInitialViewController() as? UITabBarController
        
        var viewControllers = [UIViewController]()
        viewControllers.append(FLogRouter.createModule())
        viewControllers.append(TimelineRouter.createModule())
        
        tabbarController!.viewControllers = viewControllers
        return tabbarController ?? UIViewController()
    }
    
}

