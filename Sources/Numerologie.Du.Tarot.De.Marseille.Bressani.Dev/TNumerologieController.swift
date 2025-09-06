//
//  TNumerologieController.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 06.09.2025.
//

import Foundation

public struct TNumerologieController {
    public init(token: String) {
        self.token = token
    }
    
    let baseURL = URL(string: Const.apiT())!
    var token: String

    public func getShow(numerologie_type: Int, completion: @Sendable @escaping (Result<[Numerologie], Error>) -> Void) {
        guard !token.isEmpty else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token vide"])))
            return
        }
        
        let url = baseURL.appendingPathComponent("/api/numerologie/type/\(numerologie_type)")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            do {
                let result = try JSONDecoder().decode([Numerologie].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getIndex(id: Int, completion: @Sendable @escaping (Result<Numerologie, Error>) -> Void) {
        guard !token.isEmpty else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Token vide"])))
            return
        }
        
        let url = baseURL.appendingPathComponent("/api/numerologie/\(id)")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }

            do {
                let result = try JSONDecoder().decode(Numerologie.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

public struct Numerologie: Decodable {
    public let id: Int
    public let numerologie_type: Int
    public let resume_rapide: String
    public let text: String
    public let png_b64: String
    public let jour: Int
    public let mois: Int
    public let annee: Int
    /*
    public var image: String {
        let num = String(format: "%02d", nombre)
        return "1980C\(num).jpg"
    }*/
}
