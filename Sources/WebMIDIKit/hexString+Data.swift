//
//  File.swift
//  
//
//  Created by Peter Bloxidge on 05/11/2019.
//

import Foundation

extension Data {
    internal var hexString: String {
        return map { String(format: "%02hhX", $0) }.joined(separator: " ")
    }
}
