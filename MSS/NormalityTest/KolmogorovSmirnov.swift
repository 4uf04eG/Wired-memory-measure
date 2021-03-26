//
//  KolmagorovPetrov.swift
//  MSS
//
//  Created by Ilya Kurin on 25/03/2021.
//

import Foundation

/**
 *
 *  Based on
 *  https://www.itl.nist.gov/div898/handbook/eda/section3/eda35g.htm
 *  https://github.com/accord-net/framework/blob/master/Sources/Accord.Statistics/Testing/KolmogorovSmirnovTest.cs
 *
 */
class KolmogorovSmirnov: NormalityTest {
    static let criticalValue = 0.895
    
    static func test(_ data: Array<Double>) -> Bool {
        let probability = walk(data)
        return probability < criticalValue
    }
    
    static func walk(_ data: Array<Double>) -> Double {
        let sortedData = data.sorted()
        let n = data.count
        
        var maxDiff = 0.0
        var i = 0
        
        while i < n {
            let f = sortedData[i].normalFunction(mean: 0, std: 1)
            
            let a = abs(Double(i + 1) / Double(n) - f)
            let b = abs(f - (Double(i) / Double(n)))
            
            maxDiff = max(maxDiff, a, b)
            i += 1
        }
        
        return maxDiff
    }
}
