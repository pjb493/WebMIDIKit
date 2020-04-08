//
//  MIDIClient.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 12/13/16.
//
//

import Foundation
import CoreMIDI

internal extension Notification.Name {
    static let MIDISetupNotification = Notification.Name(rawValue: "\(MIDIObjectAddRemoveNotification.self)")
}

/// Kind of like a session, context or handle, it doesn't really do anything
/// besides being passed around. Also dispatches notifications.
internal final class MIDIClient {
    var ref: MIDIClientRef = 0
    var outPort: MIDIPortRef = 0
    var inPort: MIDIPortRef = 0
    
    private var sources: [MIDIEndpointRef] = []
    private var destinations: [MIDIEndpointRef] = []

    internal init() {
        OSAssert(MIDIClientCreateWithBlock("WebMIDIKit" as CFString, &ref) {
            print($0.pointee)
            _ = MIDIObjectAddRemoveNotification($0).map({
                NotificationCenter.default.post(name: .MIDISetupNotification, object: $0)
            })
        })
//        OSAssert(MIDIOutputPortCreate(ref, "WebMIDIKitOutPort" as CFString, &outPort))
//        OSAssert(MIDIInputPortCreate(ref, "WebMIDIKitInPort" as CFString, readIncomingMIDI, nil, &inPort))
        
        getSourcesAndDestinations()
        
        connectSources()
    }

    deinit {
        OSAssert(MIDIClientDispose(ref))
    }
    
    func getSourcesAndDestinations() {
        for i in 0..<MIDIGetNumberOfDestinations() {
            let endpoint = MIDIGetDestination(i)
            if endpoint != 0 {
                destinations.append(endpoint)
            }
        }
        for i in 0..<MIDIGetNumberOfSources() {
            let endpoint = MIDIGetSource(i)
            if endpoint != 0 {
                sources.append(endpoint)
            }
        }
    }
    
    func connectSources() {
        for (i, _) in sources.enumerated() {
            MIDIPortConnectSource(inPort, sources[i], &sources[i])
        }
    }
}

extension MIDIClient: Equatable, Comparable, Hashable {
    var hashValue: Int {
        return ref.hashValue
    }

    static func ==(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref == rhs.ref
    }

    static func <(lhs: MIDIClient, rhs: MIDIClient) -> Bool {
        return lhs.ref < rhs.ref
    }
}

fileprivate func readIncomingMIDI(pktList: UnsafePointer<MIDIPacketList>, readProcRefCon: UnsafeMutableRawPointer?, srcConnRefCon: UnsafeMutableRawPointer?) {
//    print(pktList.pointee)
}

fileprivate func myMIDINotifyProc(_ notification: UnsafePointer<MIDINotification>, _ refCon: UnsafeMutableRawPointer?) {
    
}
