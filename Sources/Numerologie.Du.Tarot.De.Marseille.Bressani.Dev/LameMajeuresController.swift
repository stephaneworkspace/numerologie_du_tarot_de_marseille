//
//  LameMajeuresController.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 01.06.2025.
//
import Foundation
import UIKit

public struct LameMajeuresController {
    let baseURL = URL(string: Const.api() + "/api/lame_majeures/")!

    private var token: String {
        guard let url = Bundle.main.url(forResource: "token", withExtension: "txt"),
              let contents = try? String(contentsOf: url) else {
            return ""
        }
        return contents.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public init() {}

    public func getLameMajeure(id: Int, completion: @Sendable @escaping (Result<LameMajeure, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/lame_majeures/\(id)")
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
                let result = try JSONDecoder().decode(LameMajeure.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func getAllLamesMajeures(completion: @Sendable @escaping (Result<[LameMajeure], Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/lame_majeures")
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
                let result = try JSONDecoder().decode([LameMajeure].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

public struct LameMajeure: Decodable {
    public let id: Int
    public let nombre: Int
    public let nombre_romain: String
    public let cartouche: String

    public var image: String {
        let num = String(format: "%02d", nombre)
        return "1980C\(num).jpg"
    }
}
