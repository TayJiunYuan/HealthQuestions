//
//  QuickLinksHorizontalView.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 4/6/25.
//

import SwiftUI

struct QuickLinksHorizontalView: View {
    @ObservedObject var questionnaireViewModel: QuestionnaireViewModel
    @ObservedObject var insightsViewModel: InsightsViewModel
    @Binding var path: NavigationPath

    var body: some View {
            HStack(spacing: 16) {
                // Daily Questionnaire Button
                Button(action: {
                    path.append(AppScreen.questionnaireStartScreen)
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "doc.text")
                            .font(.title)
                            .foregroundColor(.blue)

                        Text("Daily Questionnaire")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text(questionnaireViewModel.questionnaireProgress.text)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Insights Button
                Button(action: {
                    path.append(AppScreen.insightsScreen)
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "chart.bar")
                            .font(.title)
                            .foregroundColor(.purple)

                        Text("Insights")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text("View your progress")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 160)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
    }
}
