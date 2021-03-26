//
//  ShapiroWilk.swift
//  MSS
//
//  Created by Ilya Kurin on 25/03/2021.
//

import Foundation
import PythonKit

class ShapiroWilk: NormalityTest {
    static let significanceLevel = 0.01
    
    static func test(_ data: Array<Double>) -> Bool {
        let probability = walk(data)
        return probability > significanceLevel
    }
    
    // 😞😞😞
    static func walk(_ data: Array<Double>) -> Double {
        if (data.count >= 3) {
            let scipy = Python.import("scipy.stats")
            return Double(scipy.shapiro(data)[1])!
        }
        
        return 0
    }
}
