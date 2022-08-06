//
//  NetworkManager.swift
//  Financial App
//
//  Created by Maksim  on 04.08.2022.
//

import Foundation
import Combine

enum APIKEY: String, CaseIterable {
    case alphaVintageKeyOne = "FC6IT3JSCG8DUE1X"
    case alphaVintageKeyTwo = "EYZ54UFGZMM4ADIY"
    case alphaVintageKeyThere = "T9L1HBB7B26SKHHX"
}

enum APIServiceError: Error {
    case encoding
    case errorURL
}


class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = APIKEY.allCases.randomElement()?.rawValue ?? "Error ApiKey"
    
    func fetchData(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else
                  { return Fail(error: APIServiceError.encoding).eraseToAnyPublisher() }
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else { return Fail(error: APIServiceError.errorURL).eraseToAnyPublisher()}
    
        return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        
    }
    
    func fetchTimeSeriesMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
        
        guard let keywords = keywords.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else
                  { return Fail(error: APIServiceError.encoding).eraseToAnyPublisher() }
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(keywords)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else { return Fail(error: APIServiceError.errorURL).eraseToAnyPublisher()}
        
        
        return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        
    }
    
    private init() {}
    
}



