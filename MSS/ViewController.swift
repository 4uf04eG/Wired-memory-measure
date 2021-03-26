//
//  ViewController.swift
//  MSS
//
//  Created by Ilya Kurin on 25/03/2021.
//

import Cocoa
import Charts
import TinyConstraints
import PythonKit

class ViewController: NSViewController {
    @IBOutlet weak var statsLabel: NSTextField!
    
    @IBOutlet weak var testResultLable: NSTextField!
    
    lazy var chartView: LineChartView = {
        let chartView  = LineChartView()
        
        chartView.chartDescription?.textAlign = NSTextAlignment.right
        chartView.chartDescription?.text = "Wired memory chart"
        
        return chartView
    }()
    
    var values: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chartView)
        chartView.centerXToSuperview()
        chartView.width(to: view, offset: -10)
        chartView.height(to: view, offset: -50)
        
        DispatchQueue.global(qos: .background).async {
            self.measureLoop()
        }
    }
    
    func measureLoop() {
        let measurePeriod: UInt32 = 5
        var measureNum = 1.0
        
        while true {
            let measure = Double(Logic.getWiredMemory())
            
            DispatchQueue.main.async {
                self.values.append(ChartDataEntry(x: measureNum, y: measure))
                self.setData()
                self.updateStats()
                self.updateTests()
            }
            
            sleep(measurePeriod)
            measureNum += 1
        }
    }
    
    override open func viewWillAppear() {
        chartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    private func setData() {
        let dataSet = LineChartDataSet(entries: values, label: "Measures")
        chartView.data = LineChartData(dataSet: dataSet)
    }
    
    private func updateStats() {
        let measures = values.map({$0.y})
        let mean = measures.mean()
        let std = measures.std()
        
        statsLabel.stringValue = "Mean: \(String(format:"%.3f", mean)) Gb, Standard deviation: \(String(format:"%.3f", std)) Gb"
    }
    
    private func updateTests(){
        let measures = values.map({$0.y})
        let swTest = measures.shapiroWilkTest()
        let ksTest = measures.kolmagorovSmirnovTest()
        
        testResultLable.stringValue = "Shapirov-Wilk test \(swTest ? "" : "not ")passed, Kolmagorov-Smirnov test \(ksTest ? "" : "not ")passed"
    }
}
