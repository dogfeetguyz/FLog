//
//  FLogEntity.swift
//  FLog
//
//  Created by Yejun Park on 18/3/20.
//  Copyright © 2020 Yejun Park. All rights reserved.
//

import Foundation

class FLogEntity: FLogEntityProtocol {
    var flogArray: Array<MainRoutineModel>
    
    init(flogArray: Array<MainRoutineModel>) {
        self.flogArray = flogArray
    }
}
