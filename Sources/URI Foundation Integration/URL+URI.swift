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

extension URL {
    /// Bridges this Foundation `URL` to an RFC 3986 ``URI``.
    ///
    /// `URL.absoluteString` is used as the RFC 3986 source text. This throws
    /// rather than silently discarding data if, for any reason, Foundation
    /// produced a string this package's RFC-3986-conformant parser rejects.
    public func uri() throws(URI.Foundation.Error) -> URI {
        do throws(RFC_3986.Error) {
            return try URI(absoluteString)
        } catch {
            throw .notRepresentableAsURI(foundationValue: absoluteString)
        }
    }
}
