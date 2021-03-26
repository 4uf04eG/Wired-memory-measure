//
//  Logic.swift
//  MSS
//
//  Created by Ilya Kurin on 24/03/2021.
//

import Darwin
import Foundation

class Logic {
    
    static func runMain() {
        while true {
            print("Wired memory usage: \(getWiredMemory()) Gb\n")
            sleep(1);
        }
    }
    
    static func getWiredMemory() -> Double {
        let d = getVMStatistics64()
        
        if let d = d {
            return Double(d.wireBytes) / 1073741824
        }
        
        return 0
    }
    
    private static func getVMStatistics64() -> vm_statistics64? {
        let host_port: host_t = mach_host_self()
        
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size))
        
        var returnData:vm_statistics64 = vm_statistics64.init()
        let succeeded = withUnsafeMutablePointer(to: &returnData) {
            (p:UnsafeMutablePointer<vm_statistics64>) -> Bool in
            
            return p.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                (pp:UnsafeMutablePointer<integer_t>) -> Bool in
                
                let retvalue = host_statistics64(host_port, HOST_VM_INFO64,
                                                 pp, &host_size)
                return retvalue == KERN_SUCCESS
            }
        }
        
        return succeeded ? returnData : nil
    }
    
    static fileprivate func getPageSize() -> UInt {
        // the port number of the current machine
        let host_port: host_t = mach_host_self()
        var pagesize: vm_size_t = 0
        host_page_size(host_port, &pagesize)
        return pagesize
    }
}

extension Array where Element == Double {
    func mean() -> Double {
        return self.reduce(0, +) / Double(self.count)
    }
    
    // Standard deviation
    func std() -> Double {
        let mean = self.mean()
        let v = self.reduce(0, { $0 + ($1-mean)*($1-mean) })
        return sqrt(v / Double(self.count))
    }
    
    func shapiroWilkTest() -> Bool {
        return ShapiroWilk.test(self)
    }
    
    func kolmagorovSmirnovTest() -> Bool {
        return KolmogorovSmirnov.test(self)
    }
}

extension Double {
    func normalFunction(mean: Double, std: Double) -> Double {
        return (Double.pi * std) * exp(-0.5 * pow((self - mean) / std, 2))
        
    }
}

fileprivate extension vm_statistics64 {
    var pageSizeInBytes:UInt64 { return UInt64(Logic.getPageSize()) }
    
    var wireBytes:UInt64 { return UInt64(self.wire_count) * self.pageSizeInBytes }
}
