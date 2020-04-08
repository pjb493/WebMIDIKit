//
//  MIDIPortMap.swift
//  WebMIDIKit
//
//  Created by Adam Nemecek on 1/31/17.
//
//

import CoreMIDI

public class MIDIPortMap<Value: MIDIPort> : Collection, Encodable {
    public typealias Key = Int
    public typealias Index = Dictionary<Key, Value>.Index

    public final var startIndex: Index {
        return _content.startIndex
    }

    public final var endIndex: Index {
        return _content.endIndex
    }

    public final subscript (key: Key) -> Value? {
        get {
            return _content[key]
        }
        set {
            _content[key] = newValue
        }
    }

    public final subscript(index: Index) -> (Key, Value) {
        return _content[index]
    }

    public final func index(after i: Index) -> Index {
        return _content.index(after: i)
    }

    public func port(with name: String) -> Value? {
        return _content.first { $0.value.displayName == name }?.value
    }
    

    internal final func add(_ port: Value) -> Value? {
        assert(self[port.id] == nil)
        self[port.id] = port
        return port
    }

    internal final func remove(_ endpoint: MIDIEndpoint) -> Value? {
        // disconnect?
        guard let port = self[endpoint] else { assert(false); return nil }
        self[port.id] = nil
        return port
    }

    fileprivate init(client: MIDIClient, ports: [Value]) {
        self._client = client
        self._content = .init(uniqueKeysWithValues: ports.lazy.map { ($0.id, $0) } )
    }

    private final subscript (endpoint: MIDIEndpoint) -> Value? {
        return _content.first { $0.value.endpoint == endpoint }?.value
    }

    private final var _content: [Key: Value]
    fileprivate final weak var _client: MIDIClient!
    
    // MARK: Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(_content.map({ $0.1 }))
    }
}

extension MIDIPortMap : CustomStringConvertible {
    public var description: String {
        return dump(_content).description
    }
}


public final class MIDIInputMap : MIDIPortMap<MIDIInput> {
    internal init(client: MIDIClient) {
        let inputs = MIDISources().map { MIDIInput(client: client, endpoint: $0) }
        super.init(client: client, ports: inputs)
    }

    internal final func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
        return add(MIDIInput(client: _client, endpoint: endpoint))
    }
}

public final class MIDIOutputMap : MIDIPortMap<MIDIOutput> {
    internal init(client: MIDIClient) {
        let outputs = MIDIDestinations().map { MIDIOutput(client: client, endpoint: $0) }
        super.init(client: client, ports: outputs)
    }

    internal final func add(_ endpoint: MIDIEndpoint) -> MIDIPort? {
        return add(MIDIOutput(client: _client, endpoint: endpoint))
    }
}


@inline(__always) fileprivate
func MIDISources() -> [MIDIEndpoint] {
    return (0..<MIDIGetNumberOfSources()).map {
        .init(ref: MIDIGetSource($0))
    }
}

@inline(__always) fileprivate
func MIDIDestinations() -> [MIDIEndpoint] {
    return (0..<MIDIGetNumberOfDestinations()).map {
        .init(ref: MIDIGetDestination($0))
    }
}
