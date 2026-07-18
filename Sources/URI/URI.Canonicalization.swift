//
//  URI.Canonicalization.swift
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

/// Canonical URI authority replacement for consumers that select one host.
extension RFC_3986.URI {
    public enum Canonicalization {}
}

extension RFC_3986.URI {
    /// Returns `uri` with its authority host replaced by `host`.
    ///
    /// The path, query, fragment, and optional scheme are preserved. Omitting a
    /// port from `host` removes any port from the result. This operation only
    /// constructs a canonical URI; redirect policy belongs to the HTTP layer.
    public func canonical(
        host: String
    ) throws(RFC_3986.URI.Canonicalization.Error) -> RFC_3986.URI {
        guard !host.isEmpty else {
            throw .host(.empty)
        }

        let authority: RFC_3986.URI.Authority
        do throws(RFC_3986.URI.Authority.Error) {
            authority = try RFC_3986.URI.Authority(host)
        } catch {
            if let port = Self.port(in: host) {
                if let value = Int(port) {
                    throw .port(.range(value))
                }
                throw .port(.invalid(port))
            }
            throw .host(.invalid(host))
        }

        if let port = authority.port, port.value == 0 {
            throw .port(.range(0))
        }

        var value = ""
        if let scheme = self.scheme {
            value += "\(scheme.value):"
        }
        value += "//\(authority.host.description)"
        if let port = authority.port {
            value += ":\(port.value)"
        }
        value += self.path?.description ?? ""
        if let query = self.query {
            value += "?\(query.description)"
        }
        if let fragment = self.fragment {
            value += "#\(fragment.value)"
        }

        return RFC_3986.URI(unchecked: value)
    }

    private static func port(in authority: String) -> String? {
        if authority.hasPrefix("[") {
            guard let close = authority.firstIndex(of: "]") else {
                return nil
            }
            let suffix = authority[authority.index(after: close)...]
            guard suffix.first == ":" else {
                return nil
            }
            return String(suffix.dropFirst())
        }

        guard let colon = authority.firstIndex(of: ":") else {
            return nil
        }
        return String(authority[authority.index(after: colon)...])
    }
}
