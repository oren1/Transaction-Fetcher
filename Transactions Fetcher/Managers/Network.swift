//
//  NetworkManager.swift
//  Transactions Fetcher
//
//  Created by oren shalev on 30/03/2022.
//

import Foundation

enum NetworkError: Error {
    case url
}
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .url:
            return "wrong url"
        }
    }
}

class Network {
    
    
    static let manager = Network()
    
    func getTransactionsForAddress(address: String, page: Int, offset: Int) async throws -> [Transaction] {
        
            let urlString = "https://api.etherscan.io/api"
            + "?module=account"
            + "&action=txlist"
            + "&address=\(address)"
            + "&startblock=0"
            + "&endblock=99999999"
            + "&page=\(page)"
            + "&offset=\(offset)"
            + "&sort=asc"
            + "&apikey=6R44AVXQ7PCBVBH1YV52FHG1Q8368WVTG6"
        
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = "GET"

                let (data, _) = try await URLSession.shared.data(for: request)
                let transactions = try Parsing.manager.parseTransactions(data: data)
                return transactions
            }
            
            else {
                throw NetworkError.url
            }
    }
    
}
