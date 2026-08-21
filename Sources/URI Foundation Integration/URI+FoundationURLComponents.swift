public import Foundation
public import URI

extension URI {

    public func foundationURLComponents() throws(URI.Foundation.Error) -> URLComponents {
        guard let components = URLComponents(string: value) else {
            throw .notRepresentableInFoundation(value: value)
        }
        return components
    }

    public func foundationURLComponentsRoundTripping() throws(URI.Foundation.Error) -> URLComponents
    {
        let components = try foundationURLComponents()
        guard let roundTripped = components.string, roundTripped == value else {
            throw .lossyRoundTrip(original: value, roundTripped: components.string ?? "")
        }
        return components
    }
}
