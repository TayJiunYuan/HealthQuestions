//
//  QuoteClient.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 3/6/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case missingConfig
    case invalidResponse
    case decodingError
}

struct QuoteClient {
    func fetchThreeRandomQuotes() async throws -> [Quote] {
        var quotes: [Quote] = []
        
        guard let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String,
              let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            print("[QuoteClient] - Missing API URL or API Key in Info.plist")
            throw APIError.missingConfig
        }

        
        guard let url = URL(string: apiURL) else {
            throw APIError.invalidURL
        }
        
        // Loop fetch 3 times
        for _ in 0..<3 {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("[QuoteClient] - Invalid Response")
                throw APIError.invalidResponse
            }
            
            do {
                print("[QuoteClient] - Raw Data:", String(data: data, encoding: .utf8) ?? "Unable to decode data")
                let decodedQuotes = try JSONDecoder().decode([Quote].self, from: data)
                if let firstQuote = decodedQuotes.first {
                    quotes.append(firstQuote)
                }
            } catch {
                print("[QuoteClient] - Decoding Error")
                throw APIError.decodingError
            }
        }
        return quotes
    }
}
