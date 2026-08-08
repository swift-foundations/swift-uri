// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-uri open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-uri project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import URI
public import Foundation

extension URLComponents {
    /// Bridges this Foundation `URLComponents` to an RFC 3986 ``URI``.
    ///
    /// Uses `.string` (the percent-encoded, reassembled form) as the RFC 3986
    /// source text. Throws ``URI/Foundation/Error/notRepresentableAsURI(foundationValue:)``
    /// if `.string` is `nil` (an incomplete `URLComponents`, e.g. one missing a
    /// required component) or if the reassembled string is not itself valid
    /// per RFC 3986.
    public func uri() throws(URI.Foundation.Error) -> URI {
        guard let value = string else {
            throw .notRepresentableAsURI(foundationValue: "")
        }
        do throws(RFC_3986.Error) {
            return try URI(value)
        } catch {
            throw .notRepresentableAsURI(foundationValue: value)
        }
    }
}
