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

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = APIKEY.allCases.randomElement()?.rawValue ?? "Error ApiKey"
    
    func fetchData(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
        let url = URL(string: urlString)!
    
        return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: SearchResults.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }
    
    private init() {}
}


// func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
//              URLSession.shared.dataTaskPublisher(for: url)             // 1
//               .map { $0.data}                                          // 2
//               .decode(type: T.self, decoder: APIConstants.jsonDecoder) // 3
//               .receive(on: RunLoop.main)                               // 4
//               .eraseToAnyPublisher()                                   // 5
//}
