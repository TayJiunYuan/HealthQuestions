//
//  QuoteModel.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 3/6/25.
//

import Foundation

struct Quote: Decodable, Identifiable {
    let id: UUID = UUID() // [LEARNING] UUID is generated locally, used to conform to Identifiable. For some reason using var instead of let here will cause the decoder to fail.
    let quote: String
    let author: String
    
    
    //    enum CodingKeys: String, CodingKey { // [LEARNING] This is not used anymore but you can use CodingKey to map decoding eg. "q" -> quote and "a" -> author
    //            case quote = "q"
    //            case author = "a"
    //        }
    
    // [LEARNING] This is currently not being used but you could add computed properties like these
    var truncatedQuote: String {
        if quote.count > 10 {
            let endIndex = quote.index(quote.startIndex, offsetBy: 10)  // [LEARNING] Index is used to get the index of object of a certain element (In Swift, we cant just use integers to access elements of a string)
            return quote[..<endIndex] + " ..."
        } else {
            return quote
        }
    }
}
