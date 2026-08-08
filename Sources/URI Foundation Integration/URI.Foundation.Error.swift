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

extension URI.Foundation {
    /// A failure produced while bridging between ``URI`` and a Foundation URL type.
    public enum Error: Swift.Error, Sendable, Hashable {
        /// Foundation's `URL(string:)`/`URLComponents(string:)` rejected a value
        /// string that this package's ``URI`` accepted as syntactically valid
        /// per RFC 3986. Foundation's parser is stricter or differently opinionated
        /// in places (for example: some percent-encoding edge cases, empty-host
        /// authorities, and certain relative references).
        case notRepresentableInFoundation(value: String)

        /// Foundation produced a `URL`/`URLComponents` whose string form this
        /// package's ``URI`` could not parse as RFC 3986. This should not occur
        /// for a `URL`/`URLComponents` Foundation itself produced, but the typed
        /// error exists so a caller never receives a silently-invalid ``URI``.
        case notRepresentableAsURI(foundationValue: String)

        /// The conversion succeeded on both sides but did not round-trip:
        /// re-deriving a value string from the Foundation representation does not
        /// equal the original ``URI`` value string. This is surfaced explicitly —
        /// never silently accepted — because Foundation normalizes some URIs
        /// (for example percent-encoding case, or dot-segment resolution) in ways
        /// RFC 3986 treats as a different, merely equivalent, string. Callers that
        /// need exact byte-for-byte fidelity should treat this as a failure;
        /// callers that only need RFC-3986-equivalence may catch and ignore it.
        case lossyRoundTrip(original: String, roundTripped: String)
    }
}

extension URI.Foundation.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notRepresentableInFoundation(let value):
            return "URI '\(value)' is valid per RFC 3986 but Foundation could not represent it."
        case .notRepresentableAsURI(let foundationValue):
            return "Foundation value '\(foundationValue)' could not be parsed as an RFC 3986 URI."
        case .lossyRoundTrip(let original, let roundTripped):
            return
                "URI '\(original)' round-trips through Foundation as '\(roundTripped)', which is not byte-identical."
        }
    }
}
