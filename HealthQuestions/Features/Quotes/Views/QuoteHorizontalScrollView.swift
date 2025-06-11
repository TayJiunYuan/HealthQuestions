//
//  QuoteCellView.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 3/6/25.
//

import Foundation
import SwiftUI

struct QuoteCellView: View {
    let quote: Quote
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 5)
            VStack(alignment: .leading, spacing: 12) {
                Text("“") // Opening quote
                    .font(.system(size: 40))
                    .padding(.top, -10)
                    .padding(.leading, -4)
                
                Text(quote.quote)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                    Spacer() // [LEARNING] HStack + Spacer() to push the closing quote to the bottom
                    Text("”") // Closing quote
                        .font(.system(size: 40))
                        .padding(.bottom, -10)
                        .padding(.trailing, -4)
                }
                Text("- \(quote.author)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }
            .padding()
        }
        .frame(width: 250, height: 250)
    }
}

struct QuoteCellViewSkeleton: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 5)
            VStack(alignment: .leading, spacing: 12) {
                Text("“") // Opening quote
                    .font(.system(size: 40))
                    .padding(.top, -10)
                    .padding(.leading, -4)
                
//                Text(quote.quote)
//                    .font(.body)
//                    .foregroundColor(.primary)
//                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                    Spacer() // [LEARNING] HStack + Spacer() to push the closing quote to the bottom
                    Text("”") // Closing quote
                        .font(.system(size: 40))
                        .padding(.bottom, -10)
                        .padding(.trailing, -4)
                }
//                Text("- \(quote.author)")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .padding(.top, 4)
            }
            .padding()
        }
        .frame(width: 250, height: 250)
    }
}


struct QuoteFullView: View {
    let quote: Quote
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Opening Quote Mark
                Text("“")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                    .padding(.leading, -2)
                    .padding(.top, 16)
                
                // Quote Text
                Text(quote.quote)
                    .font(.title3)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                // Closing Quote Mark
                HStack {
                    Spacer()
                    Text("”")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .padding(.trailing, -2)
                }
                
                // Author
                Text("- \(quote.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 24)
        }
    }
}


struct QuoteHorizontalScrollView: View {
    @StateObject private var viewModel = QuoteViewModel(quoteClient: QuoteClient())
    // [LEARNING] Instantiating both the QuoteViewModel class and the QuoteClient struct
    // [LEARNING] @StateObject - Tell SwiftUI to observe the created ViewModel, and keep it alive as long as this view is alive.
    // [LEARNING] We could also instantiate the viewmodel in a parent class, and pass into this view. This allow for easier testing of this class as we can mock the viewmodel.
    @State private var selectedQuote: Quote?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                if viewModel.isLoading {
                    ForEach(0..<3){
                        _ in QuoteCellViewSkeleton()
                    }
                } else {
                    ForEach(viewModel.quotes) { quote in
                        QuoteCellView(quote: quote).onTapGesture {
                            selectedQuote = quote
                        }
                    }
                }
            }
            .padding()
        }
        .task {
            await viewModel.fetchQuotes()
        }
        .sheet(item: $selectedQuote) { quote in
            QuoteFullView(quote: quote)
        }
    }
}

