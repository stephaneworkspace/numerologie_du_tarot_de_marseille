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

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
                print(String(data: data, encoding: .utf8)!)
            }
        }
        
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
    public func postNumerologie(resumeRapide: String, text: String, numerologieType: Int, jour: Int, mois: Int, annee: Int) async throws -> Numerologie {
        struct PostData: Encodable {
            let resume_rapide: String
            let text: String
            let numerologie_type: Int
            let jour: Int
            let mois: Int
            let annee: Int
        }

        let postData = PostData(
            resume_rapide: resumeRapide,
            text: " ",
            numerologie_type: numerologieType,
            jour: jour,
            mois: mois,
            annee: annee
        )

        let body = try JSONEncoder().encode(postData)
        
        if let jsonStr = String(data: body, encoding: .utf8) {
            print("JSON envoyé :", jsonStr)
        }
        
        // Envoie la requête POST
        return try await request("/api/numerologie", method: "POST", body: body)
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
