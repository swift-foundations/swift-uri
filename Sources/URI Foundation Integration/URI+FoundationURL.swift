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

public import Foundation
public import URI

extension URI {
    /// Bridges this RFC 3986 URI to a Foundation `URL`.
    ///
    /// Foundation's `URL` is not a faithful RFC 3986 implementation: its parser
    /// is stricter in some places (for example some percent-encoding and empty
    /// authority edge cases) and it may normalize the value it stores. This
    /// conversion never silently normalizes on the caller's behalf — a value
    /// that Foundation cannot represent throws
    /// ``URI/Foundation/Error/notRepresentableInFoundation(value:)`` instead of
    /// returning `nil` or a best-effort guess.
    ///
    /// To learn whether the produced `URL` round-trips back to an identical
    /// ``URI`` value string, use ``foundationURLRoundTripping()``.
    public func foundationURL() throws(URI.Foundation.Error) -> URL {
        guard let url = URL(string: value) else {
            throw .notRepresentableInFoundation(value: value)
        }
        return url
    }

    /// Bridges this URI to a Foundation `URL`, additionally verifying that the
    /// conversion round-trips byte-for-byte.
    ///
    /// Foundation's `URL` can normalize a syntactically-valid RFC 3986 string
    /// (for example, resolving `.`/`..` path segments or re-casing percent
    /// escapes) so that `URL(string:).absoluteString` differs from the input
    /// even though both denote the same RFC-3986-equivalent resource. Use this
    /// entry point when exact fidelity matters (e.g. before persisting or
    /// re-transmitting the string form); use ``foundationURL()`` when only an
    /// RFC-3986-equivalent `URL` is required.
    public func foundationURLRoundTripping() throws(URI.Foundation.Error) -> URL {
        let url = try foundationURL()
        let roundTripped = url.absoluteString
        guard roundTripped == value else {
            throw .lossyRoundTrip(original: value, roundTripped: roundTripped)
        }
        return url
    }
}
