import Foundation

public struct TNumerologieController: Sendable {
    public init(token: String) {
        self.token = token
    }

    let baseURL = URL(string: Const.apiT())!
    var token: String

    @available(macOS 12.0, iOS 15.0, *)
    private func request<T: Decodable>(_ path: String, method: String = "GET", body: Data? = nil) async throws -> T {
        guard !token.isEmpty else {
            throw NSError(domain: "Auth", code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "Token vide"])
        }

        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if let body = body {
            request.httpBody = body
        }

        let (data, _) = try await URLSession.shared.data(for: request)

        if T.self == EmptyResponse.self && data.isEmpty {
            return EmptyResponse() as! T
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    @available(macOS 12.0, iOS 15.0, *)
    public func getShow(numerologie_type: Int) async throws -> [NumerologieLight] {
        try await request("/api/numerologie_light/type/\(numerologie_type)", method: "GET")
    }

    @available(macOS 12.0, iOS 15.0, *)
    public func getIndex(id: Int) async throws -> Numerologie {
        try await request("/api/numerologie/\(id)", method: "GET")
    }

    @available(macOS 12.0, iOS 15.0, *)
    public func deleteNumerologie(id: Int) async throws {
        _ = try await request("/api/numerologie/\(id)", method: "DELETE") as EmptyResponse
    }
}

public struct EmptyResponse: Decodable {}


// MARK: - Modèle
public struct Numerologie: Decodable, Sendable, Hashable {
    public let id: Int
    public let numerologie_type: Int
    public let resume_rapide: String
    public let text: String
    public let png_b64: String
    public let jour: Int
    public let mois: Int
    public let annee: Int
}
public struct NumerologieLight: Decodable, Sendable, Hashable {
    public let id: Int
    public let numerologie_type: Int
    public let resume_rapide: String
    public let text: String
    public let jour: Int
    public let mois: Int
    public let annee: Int
}
