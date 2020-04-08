//
//  MIDIEvent.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 5/14/17.
//
//

import CoreMIDI

protocol MIDIEvent: Equatable, Encodable {}

public struct MIDIConnectionEvent : MIDIEvent {
    let port: MIDIPort
    
    public init(port: MIDIPort) {
        self.port = port
    }
}

public struct MIDIMessageEvent : MIDIEvent {
    public let timestamp : MIDITimeStamp
    public let data : Data
}

extension MIDIMessageEvent : CustomStringConvertible {
    public var description: String {
        return "\(timestamp): \(data.hexString)"
    }
}
