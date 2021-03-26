//
//  NormalityTest.swift
//  MSS
//
//  Created by Ilya Kurin on 25/03/2021.
//

import Foundation

protocol NormalityTest {
    static func test(_ data: Array<Double>) -> Bool
    
    static func walk(_ data: Array<Double>) -> Double
}
