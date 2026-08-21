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

    @Test
    func `canonical(host:) reaches the L2 law through the re-export`() throws(URI.Canonicalization
        .Error)
    {
        let uri = URI(unchecked: "https://example.com/path")
        let result = try uri.canonical(host: "canonical.com")

        #expect(result == "https://canonical.com/path")
    }
}
