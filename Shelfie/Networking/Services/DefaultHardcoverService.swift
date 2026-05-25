//
//  DefaultHardcoverService.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct DefaultHardcoverService: HardcoverService {
    
    func fetchBook(by id: String) async throws -> Book {
        let books = try await searchBook(for: id)
        guard let book = books.first else {
            throw APIError.invalidResponse
        }
        return book
    }
    
    func searchBook(for searchTerm: String) async throws -> [Book] {
        let query = makeSearchQuery(for: searchTerm)
        let request = try buildURLRequest(query: query)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let apiSearchResponse: APISearchResponse = try JSONDecoder().decode(APISearchResponse.self, from: data)
            
            return apiSearchResponse.data.search.results.hits.map { $0.document }
        } catch let error as DecodingError {
            throw APIError.decoding(error)
        } catch let error as URLError {
            throw APIError.networkError(error)
        }
    }
    
    private func buildURLRequest(query: [String: Any]) throws -> URLRequest {
        guard let url = URL(string: "https://api.hardcover.app/v1/graphql") else {
            throw APIError.invalidURL
        }
        
        let bodyData = try JSONSerialization.data(withJSONObject: query)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.hardcoverAPIKey, forHTTPHeaderField: "authorization")
        request.httpBody = bodyData
        
        return request
    }
    
    private func makeSearchQuery(for searchTerm: String) -> [String: Any] {
        let query = """
        query SearchBooks($q: String!) {
          search(
            query: $q,
            per_page: 20,
            sort: "activities_count:desc",
            query_type: "books"
          ) {
            results
          }
        }
        """
        return [
            "query": query,
            "variables": ["q": searchTerm]
        ]
    }
}
