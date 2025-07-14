//
//  ThemeController.swift
//  Numerologie.Du.Tarot.De.Marseille.Bressani.Dev
//
//  Created by Stéphane Bressani on 14.07.2025.
//

import Foundation

public struct ThemeController {
    public init(password: String? = nil) {
        self.password = password
    }
    
    let baseURL = URL(string: Const.api())!
    var password: String? = nil
    
    private var token: String {
        AuthTokenProvider.token(for: baseURL, password: password)
    }
    public func downloadXlsx(prenoms: String, noms: String, date: String, completion: @escaping (Result<URL, Error>) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("api/pdf/xlsx"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "prenoms", value: prenoms),
            URLQueryItem(name: "noms", value: noms),
            URLQueryItem(name: "date", value: date)
        ]

        guard let url = components.url else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.unknown)))
                return
            }

            var fileName = "exemple.xlsx"
            if #available(macOS 10.15, *), let httpResponse = response as? HTTPURLResponse {
                if let contentDisposition = httpResponse.value(forHTTPHeaderField: "Content-Disposition") {
                    fileName = contentDisposition
                        .components(separatedBy: ";")
                        .compactMap { part -> String? in
                            let trimmed = part.trimmingCharacters(in: .whitespaces)
                            if trimmed.starts(with: "filename=") {
                                return trimmed
                                    .replacingOccurrences(of: "filename=", with: "")
                                    .replacingOccurrences(of: "\"", with: "")
                            }
                            return nil
                        }
                        .first ?? "exemple.xlsx"
                }
            }

            let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

            do {
                try data.write(to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
