public import Foundation
public import URI

extension URL {

    public func uri() throws(URI.Foundation.Error) -> URI {
        do throws(RFC_3986.Error) {
            return try URI(absoluteString)
        } catch {
            throw .notRepresentableAsURI(foundationValue: absoluteString)
        }
    }
}
