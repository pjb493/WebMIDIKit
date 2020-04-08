//
//  Utils.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/30/17.
//
//

import AudioToolbox

extension MIDIObjectAddRemoveNotification {
    internal init?(_ ptr: UnsafePointer<MIDINotification>) {
        switch ptr.pointee.messageID {
        case .msgObjectAdded, .msgObjectRemoved:
            self = UnsafeRawPointer(ptr).assumingMemoryBound(to: MIDIObjectAddRemoveNotification.self).pointee
        default:
            return nil
        }
    }
}

@inline(__always) internal
func OSAssert(_ err: OSStatus, function: String = #function) {
    assert(err == noErr, "Error (osstatus: \(err)) in \(function)")
}
