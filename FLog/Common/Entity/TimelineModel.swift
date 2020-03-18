//
//  TimelineModel.swift
//  FLog
//
//  Created by Yejun Park on 12/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation

/**
 Structure that is used for holding Timeline Data.
 */
public struct TimelineModel {
    
    /// Timeline data loaded from Core Data
    public var timelineData: Timeline
    
    /// Dtailed content for each timeline
    public var content: NSAttributedString
}
