//
//  NetworkManager.swift
//  Financial App
//
//  Created by Maksim  on 04.08.2022.
//

import Foundation
import Combine  // ???? Нахуя


// Можно ли в перечислении делать массивы??
//enum API: [String] {
//    case allApiKey = "",
//
//
////    case apiKey = "FC6IT3JSCG8DUE1X"
////    case apiKey2 = "EYZ54UFGZMM4ADIY"
////    case apiKey3 = "T9L1HBB7B26SKHHX"
//}

class ApiService {
    let apiAll = ["FC6IT3JSCG8DUE1X", "EYZ54UFGZMM4ADIY", "T9L1HBB7B26SKHHX"]
    
    var apiKey: String {
        return apiAll.randomElement() ?? ""
    }
    
    
    //???
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(apiKey)"
        let url = URL(string: urlString)!
    
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    
}
