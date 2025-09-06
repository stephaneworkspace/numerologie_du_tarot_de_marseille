import Foundation

public struct TNumerologieController: Sendable {
    public init(token: String) {
        self.token = token
    }

    let baseURL = URL(string: Const.apiT())!
    var token: String

    @available(macOS 12.0, iOS 15.0, *)
    private func fetch<T: Decodable>(_ path: String) async throws -> T {
        guard !token.isEmpty else {
            throw NSError(domain: "Auth", code: 401,
                          userInfo: [NSLocalizedDescriptionKey: "Token vide"])
        }
        
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }

    @available(macOS 12.0, iOS 15.0, *)
    public func getShow(numerologie_type: Int) async throws -> [NumerologieLight] {
        try await fetch("/api/numerologie_light/type/\(numerologie_type)")
    }

    @available(macOS 12.0, iOS 15.0, *)
    public func getIndex(id: Int) async throws -> Numerologie {
        try await fetch("/api/numerologie/\(id)")
    }
}

// MARK: - Modèle
public struct Numerologie: Decodable, Sendable, Hashable {
    public let id: Int
    public let numerologie_type: Int
    public let resume_rapide: String
    public let text: String
    public let png_b64: String?
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
