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

extension URI {
    /// Opt-in interoperability between ``URI`` and Apple's Foundation URL types
    /// (`Foundation.URL`, `Foundation.URLComponents`).
    ///
    /// This leaf exists because the ``URI`` core (re-exported from
    /// `swift-uri-standard` and, beneath it, `swift-ietf/swift-rfc-3986`) compiles
    /// without Foundation and stays that way. Only consumers that import this
    /// target pull Foundation in — the conditionality lives at the target
    /// dependency level, mirroring `JSON.Foundation` in `swift-foundations/swift-json`
    /// and `CSS Theming Foundation Integration` in `swift-foundations/swift-css`.
    ///
    /// Foundation's URL types are **not** a faithful RFC 3986 implementation: they
    /// apply their own normalization and reject or reinterpret some syntactically
    /// valid RFC 3986 references. Every conversion here is therefore explicit about
    /// its failure mode rather than silently normalizing — see
    /// ``URI/Foundation/Error`` and the `roundTrips` diagnostics on each bridge.
    public enum Foundation {}
}
