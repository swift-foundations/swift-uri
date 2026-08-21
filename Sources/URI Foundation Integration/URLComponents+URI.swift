public import Foundation
public import URI

extension URLComponents {

    public func uri() throws(URI.Foundation.Error) -> URI {
        guard let value = string else {
            throw .notRepresentableAsURI(foundationValue: "")
        }
        do throws(RFC_3986.Error) {
            return try URI(value)
        } catch {
            throw .notRepresentableAsURI(foundationValue: value)
        }
    }
}
