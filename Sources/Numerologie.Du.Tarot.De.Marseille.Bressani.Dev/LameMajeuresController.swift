//
//  LameMajeuresController.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 01.06.2025.
//
import Foundation

public struct LameMajeuresController {
    let baseURL = URL(string: Const.api())!

    public init() {}

    public func getLameMajeure(id: Int, completion: @Sendable @escaping (Result<LameMajeure, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/lame_majeures/\(id)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
