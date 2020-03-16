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

        cell.titleLabel?.text = timeline.timelineData.routineTitle
        cell.dateLabel?.text = timeline.timelineData.logDate        
        cell.contentLabel?.attributedText = timeline.content
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if canCallNextTimeline {
                    presenter?.tableViewScrollToBottom()
                }
            }
        }
    }
}

