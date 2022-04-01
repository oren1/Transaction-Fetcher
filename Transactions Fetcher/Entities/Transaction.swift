//
//  Transaction.swift
//  Transactions Fetcher
//
//  Created by oren shalev on 30/03/2022.
//

import Foundation

struct Transaction: Codable {
    var timeStamp: String
    var from: String
    var to: String
    var value: String
    var confirmations: String
    var hash: String
}
