//
//  TimelineView+UITableViewDataSource.swift
//  FLog
//
//  Created by Yejun Park on 10/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import UIKit

extension TimelineView: UITableViewDelegate, UITableViewDataSource {
        

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineViewCell", for: indexPath) as! TimelineViewCell
        let timeline = timelineArray[indexPath.row]

        cell.titleLabel?.text = timeline.routineTitle
        cell.dateLabel?.text = timeline.logDate
        print(timeline)
        
//        let exercises = Timeline.exerciseTitles
//        let exercise: String = exercises.joined(separator: "\n")
//        cell.contentLabel.numberOfLines = exercises.count
//        
//        cell.titleLabel?.text = Timeline.title
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 5
//
//        let attrString = NSMutableAttributedString(string: exercise)
//        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
//
//        cell.editButton.tag = indexPath.row
//        cell.contentLabel?.attributedText = attrString
//        
//        cell.editButton.isHidden = !tableView.isEditing
        
        return cell
    }
}
