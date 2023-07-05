//
//  RPCError.swift
//
//
//  Created by X Tommy on 2023/2/16.
//

import Foundation

public struct RPCError: Error, Equatable, Codable {

    public let code: Int
    public let message: String
    public let data: AnyCodable?

    public init(code: Int, message: String, data: AnyCodable? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
}

extension RPCError {

    public static let parseError = RPCError(
        code: -32700, message: "An error occurred on the server while parsing the JSON text.")
    public static let invalidRequest = RPCError(
        code: -32600, message: "The JSON sent is not a valid Request object.")
    public static let methodNotFound = RPCError(
        code: -32601, message: "The method does not exist / is not available.")
    public static let invalidParams = RPCError(
        code: -32602, message: "Invalid method parameter(s).")
    public static let internalError = RPCError(code: -32603, message: "Internal JSON-RPC error.")
}
