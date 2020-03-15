//
//  RoutineDetailView+UITableViewDelegate.swift
//  FLog
//
//  Created by Yejun Park on 11/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

extension RoutineDetailView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if routineDetailData?.dailyLogs.count == 0 {
            return 0
        } else {
            return routineDetailData?.routine.exerciseTitles.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineDetailTableViewCell", for: indexPath) as! RoutineDetailTableViewCell
        
        let currentIndex = self.segmentedControl.numberOfSegments - 1 - self.segmentedControl.selectedSegmentIndex
        let exerciseOfTheDay = routineDetailData?.dailyLogs[currentIndex]
        let thisExerciseLog = exerciseOfTheDay?.exerciseLogs[indexPath.row]
        
        
        cell.titleLabel?.text = thisExerciseLog?.exerciseTitle
        cell.weightUnitLabel?.text = routineDetailData?.routine.unit
        cell.addButton.addTarget(cell, action: #selector(cell.addButtonAction), for: .touchUpInside)
        cell.removeButton.addTarget(cell, action: #selector(cell.removeButtonAction), for: .touchUpInside)
        
        if (thisExerciseLog?.set.count)! > 1 {
            cell.removeButton.isEnabled = true
        } else {
            cell.removeButton.isEnabled = false
        }
        
        cell.presenter = presenter
        cell.maxInfoData = maxInfoData
        cell.exerciseLogData = thisExerciseLog!
        cell.logDate = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        
        cell.buildStackView()
        
        return cell
    }
}
