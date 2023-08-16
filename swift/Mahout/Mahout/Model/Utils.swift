//
//  Utils.swift
//  Mahout
//
//  Created by Chandrasekaran, Gopinath on 8/13/23.
//

import Foundation

struct Utils {
    static func getMockActivities() -> [ActivityTypes] {
        var a1 = ActivityTypes()
        var a2 = ActivityTypes()
        
        a1.image = "elliptical"
        a1.info = "Elliptical"
        a2.image = "treadmill"
        a2.info = "Treadmill"
        
        return [a1, a2]
    }
}
