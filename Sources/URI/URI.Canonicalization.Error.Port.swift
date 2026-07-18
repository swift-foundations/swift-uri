//
//  URI.Canonicalization.Error.Port.swift
//  swift-uri
//
//  This source file is part of the swift-uri open source project
//
//  Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-uri project authors
//  Licensed under Apache License 2.0
//
//  See LICENSE for license information
//
//

extension RFC_3986.URI.Canonicalization.Error {
    public enum Port: Equatable, Sendable {
        case invalid(String)
        case range(Int)
    }
}
