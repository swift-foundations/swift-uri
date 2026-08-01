// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-uri open source project
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp and the swift-uri project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Testing
import URI

@Suite
struct `URI Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `URI Tests`.Unit {
    @Test
    func `URI module re-exports URI_Standard`() {
    }
}

extension `URI Tests`.Integration {
    /// The RFC 3986 canonicalization law lives in the L2 owner
    /// (swift-uri-standard); this asserts it is reachable through the
    /// `@_exported` re-export when consuming `import URI` alone.
    @Test
    func `canonical(host:) reaches the L2 law through the re-export`() throws(URI.Canonicalization.Error) {
        let uri = URI(unchecked: "https://example.com/path")
        let result = try uri.canonical(host: "canonical.com")

        #expect(result == "https://canonical.com/path")
    }
}
