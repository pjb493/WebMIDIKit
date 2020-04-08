//
//  MIDIEvent.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 5/14/17.
//
//

import AVFoundation

public struct MIDIEvent : Equatable {
    let timestamp : MIDITimeStamp
    let data : Data

    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.data == rhs.data
    }

    

//    internal init(_ ptr: UnsafePointer<MIDIPacket>) {
//        self.timestamp = ptr.pointee.timeStamp
//        self.data = Data(bytes: ptr, count: Int(ptr.pointee.length))
//    }
}

extension MIDIEvent: CustomStringConvertible {
    public var description: String {
        return "\(timestamp): \(data.hexString)"
    }
}

extension UInt8 {
    var hexString: String {
        return String(format: "%02x", UInt(self)).capitalized
    }
}

extension Collection where Element == UInt8 {
    var hexString: String {
        return self
            .map { $0.hexString }
            .joined(separator: " ")
    }
}
