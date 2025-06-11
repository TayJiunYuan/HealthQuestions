//import Foundation
import SwiftUI

struct MoodQuestionnaireScreen: View {
    @ObservedObject var viewModel: QuestionnaireViewModel
    @Binding var path: NavigationPath
    
    @State private var selectedMoodOrdinal: MoodOrdinal? = nil
    @State private var selectedEmotions: Set<String> = []
    @State private var selectedMoodRating: Double = 5
    
    private var isFormValid: Bool {
        !selectedEmotions.isEmpty && (selectedMoodOrdinal != nil)
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("How was your mood today? ")) {
                    ForEach(MoodOrdinal.allCases) { mood in
                        HStack {
                            Text(mood.rawValue)
                            Spacer()
                            Image(systemName: selectedMoodOrdinal == mood ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(.blue)
                        }
                        .onTapGesture {
                            selectedMoodOrdinal = mood
                        }
                    }
                }
                Section(header: Text("Select any emotions you felt today: (Check all that apply)")) {
                    ForEach(allEmotions, id: \.self) { emotion in
                        HStack {
                            Text(emotion)
                            Spacer()
                            Image(systemName: selectedEmotions.contains(emotion) ? "checkmark.square.fill" : "square")
                                .foregroundColor(.blue)
                        }
                        .onTapGesture {
                            if selectedEmotions.contains(emotion) {
                                selectedEmotions.remove(emotion)
                            } else {
                                selectedEmotions.insert(emotion)
                            }
                        }
                    }
                }
                Section(header: Text("Mood rating (0 = Worst, 10 = best)")) {
                    HStack {
                        Slider(value: $selectedMoodRating, in: 0...10, step: 1)
                        Text("\(Int(selectedMoodRating))")
                            .frame(width: 30, alignment: .leading)
                    }
                }
            }
            Button {
                viewModel.saveMoodSection(
                    selectedMoodOrdinal: selectedMoodOrdinal,
                    selectedEmotions: selectedEmotions,
                    selectedMoodRating: selectedMoodRating
                )
                path.append(AppScreen.anxietyQuestionnaireScreen)
            } label: {
                Text("Save and Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])
            .disabled(!isFormValid)
        }
        .navigationTitle("Mood & Emotions")
        .onAppear {
            if let existing = viewModel.todayQuestionnaire {
                selectedMoodOrdinal = MoodOrdinal(rawValue: existing.moodOrdinal ?? "")
                // [LEARNING] if raw value is not an case in the enum, the initializer will return nil and not crash
                // [LEARNING] Initializing can only be used with enum with raw value eg. ENUMTYPE(rawValue: "something"). If no raw value, you can use the enum as is without initializing
                selectedEmotions = Set(existing.emotions as? [String] ?? [])
                selectedMoodRating = existing.moodRating
            }
        }
    }
}
