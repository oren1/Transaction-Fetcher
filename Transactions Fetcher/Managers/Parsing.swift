//
//  Parsing.swift
//  Transactions Fetcher
//
//  Created by oren shalev on 30/03/2022.
//

import Foundation

enum ParsingError: Error {
    case response(message: String)
    case responseStructure
}
extension ParsingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .responseStructure:
            return "Response structure wasn't as expected"
        case .response(let message):
            return message
        }
    }
}

class Parsing {
    static let manager = Parsing()
    
    func parseTransactions(data: Data) throws -> [Transaction] {
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(TransactionsResponse.self, from: data)

        if let error = response.error {
            throw ParsingError.response(message: error)
        }
        
        return response.transactions
    }
}
