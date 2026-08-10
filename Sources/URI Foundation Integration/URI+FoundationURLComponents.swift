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
    /// Bridges this RFC 3986 URI to Foundation `URLComponents`.
    ///
    /// `URLComponents` is Foundation's component-wise URL model. Like `URL`, it
    /// is not a faithful RFC 3986 implementation and may reject or normalize
    /// syntactically valid RFC 3986 references (see ``foundationURL()``). This
    /// non-strict conversion accepts Foundation's representation and throws
    /// only when Foundation rejects the value. Use
    /// ``foundationURLComponentsRoundTripping()`` when byte-for-byte fidelity
    /// is required.
    public func foundationURLComponents() throws(URI.Foundation.Error) -> URLComponents {
        guard let components = URLComponents(string: value) else {
            throw .notRepresentableInFoundation(value: value)
        }
        return components
    }

    /// Bridges this URI to Foundation `URLComponents`, additionally verifying
    /// that the conversion round-trips byte-for-byte via `.string`.
    ///
    /// See ``foundationURLRoundTripping()`` for why this distinct entry point
    /// exists rather than always checking.
    public func foundationURLComponentsRoundTripping() throws(URI.Foundation.Error) -> URLComponents {
        let components = try foundationURLComponents()
        guard let roundTripped = components.string, roundTripped == value else {
            throw .lossyRoundTrip(original: value, roundTripped: components.string ?? "")
        }
        return components
    }
}
