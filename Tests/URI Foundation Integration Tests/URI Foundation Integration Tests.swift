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

import Foundation
import Testing
import URI
@testable import URI_Foundation_Integration

@Suite
struct `URI Foundation Integration Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `URI Foundation Integration Tests`.Integration {
    @Test
    func `URL bridge round-trips a canonical HTTPS URI`() throws {
        let uri = try URI("https://example.com/path?query=value#fragment")
        let url = try uri.foundationURLRoundTripping()
        #expect(url.absoluteString == uri.value)
        #expect(try url.uri().value == uri.value)
    }

    @Test
    func `URLComponents bridge round-trips a canonical HTTPS URI`() throws {
        let uri = try URI("https://example.com/path?query=value#fragment")
        let components = try uri.foundationURLComponentsRoundTripping()
        #expect(try components.uri().value == uri.value)
    }
}

extension `URI Foundation Integration Tests`.Unit {
    @Test
    func `relative reference bridges to URL without a scheme`() throws {
        let uri = try URI("/path/to/resource?x=1")
        let url = try uri.foundationURL()
        #expect(url.scheme == nil)
    }

    @Test
    func `the typed error carries a human-readable description for every case`() {
        let errors: [URI.Foundation.Error] = [
            .notRepresentableInFoundation(value: "//[invalid"),
            .notRepresentableAsURI(foundationValue: "not a uri"),
            .lossyRoundTrip(original: "a", roundTripped: "b"),
        ]
        for error in errors {
            #expect(!error.description.isEmpty)
        }
    }
}

extension `URI Foundation Integration Tests`.`Edge Case` {
    /// Foundation's `URL`/`URLComponents` parsers resolve dot-segments and
    /// otherwise normalize some syntactically valid RFC 3986 references. A
    /// URI containing a dot-segment is expected to fail the strict
    /// round-trip check even though the non-strict bridge succeeds — this
    /// asserts the lossiness is surfaced as a typed error, never silently
    /// accepted.
    @Test
    func `lossy round-trip is surfaced explicitly, not silently normalized`() throws {
        let uri = try URI("https://example.com/a/../b")

        // The non-strict bridge must not throw merely because of normalization.
        _ = try uri.foundationURL()

        // If Foundation normalized the value away from the original string,
        // the strict entry point must surface that as a typed, explicit
        // failure rather than silently accepting the mismatch. If Foundation
        // happens not to normalize this particular string, the strict call
        // succeeds and there is nothing to assert.
        do throws(URI.Foundation.Error) {
            let strict = try uri.foundationURLRoundTripping()
            #expect(strict.absoluteString == uri.value)
        } catch {
            guard case .lossyRoundTrip = error else {
                Issue.record("Expected .lossyRoundTrip, got \(error)")
                return
            }
        }
    }

    /// `URLComponents().string == ""`, which RFC 3986 treats as a valid
    /// (empty) relative reference — so this is a success path, not a
    /// failure path. The failure path is `.notRepresentableAsURI`, taken
    /// whenever `.string` is `nil` (see the `guard let value = string` in
    /// `URLComponents.uri()`).
    @Test
    func `an empty URLComponents bridges to the empty relative-reference URI`() throws {
        let uri = try URLComponents().uri()
        #expect(uri.value.isEmpty)
    }
}
