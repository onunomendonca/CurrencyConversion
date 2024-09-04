//
//  URLSession+Ext.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 04/09/2024.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
