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
        if routineDetailData?.dailyExercises.count == 0 {
            return 0
        } else {
            return routineDetailData?.routine.exerciseTitles.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineDetailTableViewCell", for: indexPath) as! RoutineDetailTableViewCell
        
        let currentIndex = self.segmentedControl.numberOfSegments - 1 - self.segmentedControl.selectedSegmentIndex
        let exerciseOfTheDay = routineDetailData?.dailyExercises[currentIndex]
        let thisExercise = exerciseOfTheDay?.exercises[indexPath.row]
        
        
        cell.titleLabel?.text = thisExercise?.title
        cell.weightUnitLabel?.text = routineDetailData?.routine.unit
        cell.addButton.addTarget(cell, action: #selector(cell.addButtonAction), for: .touchUpInside)
        cell.removeButton.addTarget(cell, action: #selector(cell.removeButtonAction), for: .touchUpInside)
        
        cell.presenter = presenter
        cell.maxInfoData = maxInfoData
        cell.exerciseData = thisExercise!
        cell.exerciseTimeStamp = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        
        cell.buildStackView()
        
        return cell
    }
}
