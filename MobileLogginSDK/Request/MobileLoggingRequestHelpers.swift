//
//  MobileLoggingRequestHelpers.swift
//  MobileLogginSDK
//
//  Created by Inna Chystiakova on 07/09/2024.
//

import Foundation
///
///struct JSONHelper
///Helps to handle JSON data
///
struct JSONHelper {
    ///
    ///Function encodes data of any type to Data type
    ///
    static func encodeToJSON<T: Encodable>(_ model: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(model)
    }
    ///
    ///Function dencodes data of Data type to any needed type
    ///
    static func decodeFromJSON<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

