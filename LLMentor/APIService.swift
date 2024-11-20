//
//  Untitled.swift
//  LLMentor
//
//  Created by Nick Lamb on 18/11/2024.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let endpoint = "https://us-central1-medicaltextoptimiser.cloudfunctions.net/translate"

    func optimiseText(inputText: String, language: String, audience: String, tone: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "text": inputText,
            "language": language,
            "audience": audience,
            "tone": tone ?? NSNull()
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let optimisedText = json["optimisedText"] as? String {
                    completion(.success(optimisedText))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
