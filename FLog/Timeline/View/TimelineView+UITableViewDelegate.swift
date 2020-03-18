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
        if let _loadedData = loadedData as? TimelineEntityProtocol {
            return _loadedData.timelineArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineViewCell", for: indexPath) as! TimelineViewCell
        if let _loadedData = loadedData as? TimelineEntityProtocol {
            let timeline = _loadedData.timelineArray[indexPath.row]

            cell.titleLabel?.text = timeline.timelineData.routineTitle
            cell.dateLabel?.text = timeline.timelineData.logDate
            cell.contentLabel?.attributedText = timeline.content
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if let _loadedData = loadedData as? TimelineEntityProtocol {
                    if _loadedData.timelineArray.count > 0 && canCallNextTimeline {
                        if let _presenter = presenter as? TimelinePresenterProtocol {
                            _presenter.tableViewScrollToBottom()
                        }
                    }
                }
            }
        }
    }
}

