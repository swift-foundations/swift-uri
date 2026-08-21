public import URI

extension URI.Foundation {

    public enum Error: Swift.Error, Sendable, Hashable {

        case notRepresentableInFoundation(value: String)

        case notRepresentableAsURI(foundationValue: String)

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
