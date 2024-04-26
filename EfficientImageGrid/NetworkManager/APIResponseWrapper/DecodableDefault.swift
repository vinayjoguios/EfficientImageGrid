//
//  DecodableDefault.swift
//  EfficientImageGrid

import Foundation
protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

enum DecodableDefault {}

extension DecodableDefault {
    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        typealias Value = Source.Value
        var wrappedValue = Source.defaultValue
    }
}

extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral
    
    enum Sources {
        enum Decimal: Source {
            static var defaultValue: Double { 0.0 }
        }
        
        enum Integer: Source {
            static var defaultValue: Int { 0 }
        }
        
        enum True: Source {
            static var defaultValue: Bool { true }
        }
        
        enum False: Source {
            static var defaultValue: Bool { false }
        }
        
        enum EmptyString: Source {
            static var defaultValue: String { "" }
        }
        
        enum EmptyList<T: List>: Source {
            static var defaultValue: T { [] }
        }
        
        enum EmptyMap<T: Map>: Source {
            static var defaultValue: T { [:] }
        }
    }
}

extension DecodableDefault {
    typealias Decimal = Wrapper<Sources.Decimal>
    typealias Integer = Wrapper<Sources.Integer>
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
}

extension DecodableDefault.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type,
                   forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
