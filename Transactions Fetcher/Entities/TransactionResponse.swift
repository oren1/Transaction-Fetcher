//
//  TransactionResponse.swift
//  Transactions Fetcher
//
//  Created by oren shalev on 31/03/2022.
//

import Foundation

struct TransactionsResponse: Codable {
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case result = "result"
    }
    
    var status: String
    var message: String
    var transactions: [Transaction]!
    var error: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(String.self, forKey: .status)
        message = try container.decode(String.self, forKey: .message)
        transactions = try? container.decode([Transaction].self, forKey: .result)
        if transactions == nil {
            error = try container.decode(String.self, forKey: .result)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(message, forKey: .message)
        try container.encode(transactions, forKey: .result)
    }
}
