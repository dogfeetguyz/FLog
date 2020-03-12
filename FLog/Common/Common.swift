//
//  Common.swift
//  FLog
//
//  Created by Yejun Park on 25/2/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

class Common {
    class Define {
        static let mainRoutine = "main_routine"
        static let mainRoutineTitle = "title"
        static let mainRoutineUnit = "unit"
        static let mainRoutineUnitKg = "kg"
        static let mainRoutineUnitLb = "lb"
        static let mainRoutineExercises = "routine"
        
        static let routineDetail = "_detail"
        static let routineDetailLogDate = "title"
        static let routineDetailWeight = "weight"
        static let routineDetailReps = "reps"
        
        static let routineBest = "_best"
        static let routineBestMaxVolume = "best_max_volume"
        static let routineBestMaxVolumeDate = "best_max_volume_date"
        static let routineBestMaxWeight = "best_max_weight"
        static let routineBestMaxWeightDate = "best_max_weight_date"
        
        static let checkBestCreatedBefore = "best_data_created"
        static let checkTimelineCreatedBefore = "timeline_data_created"
    }
    
    class View {
        static func showAlertWithTwoButtons(viewController: UIViewController, title: String, message: String, cancelButtonTitle: String, OKButtonTitle: String, OKHandler: ((UIAlertAction) -> Void)? = nil) {

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: { (_) in
            }))
            alert.addAction(UIAlertAction(title: OKButtonTitle, style: .default, handler: OKHandler))
            viewController.present(alert, animated: true, completion: nil)
        }
        
        static func showAlertWithOneButton(viewController: UIViewController, title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
