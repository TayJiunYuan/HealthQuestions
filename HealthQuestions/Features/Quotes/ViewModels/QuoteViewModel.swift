//
//  QuoteViewModel.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 3/6/25.
//

import Foundation

@MainActor
// [LEARNING] UI updates must happen on the main thread.
// [LEARNING] @MainActor ensures that everything inside the class (methods, properties, etc.) runs on the main thread by default.

class QuoteViewModel: ObservableObject {
    // [LEARNING] ObserverableObject allows the view model to broadcast changes to SwiftUI views.
    // [LEARNING] When a @Published property (like products) changes, any SwiftUI View observing this ViewModel will re-render automatically.
    
    @Published var quotes: [Quote] = []
    @Published var isLoading: Bool = false
    
    let quoteClient: QuoteClient
    
    init(quoteClient: QuoteClient) {
        self.quoteClient = quoteClient
    }
    
    func fetchQuotes() async {
        isLoading = true
        do {
            let fetchedQuotes = try await quoteClient.fetchThreeRandomQuotes()
            self.quotes = fetchedQuotes
        } catch {
            print(error) // [TODO] Maybe display error at View?
        }
        isLoading = false
    }
}
