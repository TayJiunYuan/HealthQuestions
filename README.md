# HealthQuestions – A Mood Tracker iOS App

**HealthQuestions** is a simple iOS mood tracker app that includes:

- 🧠 A daily questionnaire to check in on your **mood, anxiety, sleep**, and **safety**
- 📈 Charts to visualize your progress in each category
- ✨ Motivational quotes to brighten your day


https://github.com/user-attachments/assets/c18750dd-9789-4095-b267-afda21f0ca91



---

## 🎯 Objective

This app is my first iOS project! The primary goal was to **practice iOS development**, focusing on:

- Swift and SwiftUI
- MVVM architecture
- Core Data and state management

> ⚠️ **Note:** This app is not optimized for production use or user experience (UX/UI). It's primarily a **learning project**, so you'll find comments tagged with `[LEARNING]` throughout the code — these are my personal notes and observations.

---

## 🧪 Compatibility

- Tested on: **Xcode 15.2**, **iOS 17.2**
- Known issue: **iOS 18.5** breaks navigation

---

## 🛠️ Topics & Techniques Explored

Below are the iOS and Swift concepts I explored while building this app. This section serves more as a mental note for me to refer back to in the future. Click to expand each section:

<details>
<summary>🧱 MVVM Architecture</summary>
The core structure of the app is based on the MVVM (Model-View-ViewModel) architecture. In this pattern:

- The **ViewModel** is responsible for managing the state and business logic.
- It updates the **Views** reactively when the underlying data changes.

I’ve adopted a **one ViewModel per feature** approach. This decision was made because each feature’s views tend to share the same set of states, which keeps the state management clean and modular.

> More details on how state is managed can be found in the sections below.
</details>

<details>
<summary>🎨 App Icon and Splash Screen</summary>
Xcode makes generating app icons and splash screens incredibly simple using built-in tools.

- **App Icon**:  
  To set up your app icon, upload a **1024x1024** image to the **Assets** folder under the `AppIcon` entry. Xcode will automatically generate all the required sizes for various devices.

- **Splash Screen**:  
  Create a new **LaunchScreen** storyboard or SwiftUI view, and upload any required images to **Assets**. Then reference these images directly in your splash screen layout.

> These features help streamline the setup process and ensure your app has a professional appearance with minimal effort.
</details>

<details>
<summary>📦 CoreData with Transformative Types</summary>
Setting up Core Data is quite straightforward in Xcode:

1. **Create the data model** using the GUI (`.xcdatamodeld` file).
2. **Initialize a persistent container** that references the model.

📄 File: `/Persistence/CoreDataProvider.swift`
```swift
persistentContainer = NSPersistentContainer(name: "AppModel")
```

---

#### ⚙️ Code Generation Options

When defining entities in the data model, Xcode allows three levels of code generation:

- **Manual/None** – You write all model code yourself.
- **Category/Extension** – Xcode generates properties in an extension, so you can add custom logic.
- **Class Definition** – Xcode fully generates the class for you.

Choose the level that suits your customization needs.

---

#### 🔁 Using Transformable Types

For unsupported types in Core Data (e.g. `[String]`), you can:

- Set the attribute type as `Transformable`.
- Under the **Custom Class** section, specify the underlying storage type (e.g. `NSArray`).
- In your code, cast the value explicitly when saving or retrieving.

📄 File: `/Features/Questionnaire/ViewModel/QuestionnaireViewModel.swift`
```swift
questionnaire.emotions = Array(selectedEmotions) as NSArray
```

> This allows Core Data to store complex Swift types like arrays while maintaining compatibility.
</details>

<details>
<summary>🔁 Singleton Core Data Context</summary>

### 🌍 Global Access to Core Data with Singleton Pattern

To expose the Core Data model globally throughout the app, a **singleton instance** of the Core Data provider is used.

📄 File: `/Persistence/CoreDataProvider.swift`

This singleton is then **injected** into the SwiftUI environment at the app's root:

```swift
.environment(\.managedObjectContext, provider.context)
```

This makes the `NSManagedObjectContext` accessible from any view or view model in the hierarchy.

---

#### ✅ Usage in Views and ViewModels

To interact with Core Data (e.g., save or fetch data), you can declare the context as a property:

```swift
private let context: NSManagedObjectContext
init(context: NSManagedObjectContext = CoreDataProvider.shared.context) {
        self.context = context
    }
```

Or in SwiftUI Views:

```swift
@Environment(\.managedObjectContext) private var context
```

> This pattern ensures consistent access to Core Data and avoids passing context around manually.
</details>

<details>
<summary>🧩 Extensions</summary>
Extensions are a powerful way to add new functionality to existing classes, structs, or other types without modifying their original implementation.

For example, here's an extension to the `String` class that provides a computed property to convert a string into a `Date` using a specific format:

```swift
extension String {
    var asDate_yyyyMMdd: Date? {
        DateFormatter.yyyyMMdd.date(from: self)
    }
}
```

> This keeps your code modular and reusable, and improves readability by attaching utility functions directly to the types they operate on.
</details>

<details>
<summary>🧭 Global Navigation using NavigationStack and NavigationPath</summary>
### 🧭 Navigation with `NavigationStack` and `NavigationPath`

`NavigationStack` enables **stack-like view management**, ideal for sequential navigation through multiple screens. This modern navigation approach replaces `NavigationView` and is more flexible and powerful.

To navigate between screens, you can define a `@State` variable for the navigation path and use a `switch` statement to render each destination.

```swift
@State private var path = NavigationPath()

var body: some Scene {
    WindowGroup {
        NavigationStack(path: $path) {
            ContentView(
                questionnaireViewModel: questionnaireViewModel,
                insightsViewModel: insightsViewModel,
                path: $path
            )
            .environment(\.managedObjectContext, provider.context)
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .questionnaireStartScreen:
                    QuestionnaireStartScreen(viewModel: questionnaireViewModel, path: $path)
                case .moodQuestionnaireScreen:
                    MoodQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                case .anxietyQuestionnaireScreen:
                    AnxietyQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                case .sleepQuestionnaireScreen:
                    SleepQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                case .safetyQuestionnaireScreen:
                    SafetyQuestionnaireScreen(viewModel: questionnaireViewModel, path: $path)
                case .insightsScreen:
                    InsightsScreen(viewModel: insightsViewModel)
                }
            }
        }
    }
}
```

---

#### 📲 Navigating Between Screens

Inside each screen, bind the navigation path to the view so you can control navigation directly.

```swift
@Binding var path: NavigationPath

var body: some View {
    VStack {
        Text("Hey! How are you doing today? Our daily questionnaire consists of questions from several topics that help track your mood.")
        
        Button("Next") {
            path.append(AppScreen.moodQuestionnaireScreen)
        }
    }
}
```

To **reset the stack** (e.g. go back to the root), use:

```swift
path.removeLast(path.count)
```

> This structure gives you full control over view navigation and works seamlessly with programmatic routing.
</details>

<details>
<summary>🧠 Managing State with ViewModels (@ObservableObject, @Published, @ObservedObject)</summary>

In SwiftUI, `ViewModel`s are typically created by conforming to the `ObservableObject` protocol. This enables the use of `@Published` properties, which automatically notify and update any views observing them when they change.

#### ✅ Declaring the ViewModel

```swift
@MainActor
class QuestionnaireViewModel: ObservableObject {
    @Published var freezedDateString: String?
    @Published var todayQuestionnaire: Questionnaire?
    @Published var showCompletion: Bool = false
}
```

- `@Published` marks properties that will notify the UI when they change.
- The `@MainActor` annotation ensures all UI updates happen on the main thread.

---

#### 📌 Creating the ViewModel in a Parent View

```swift
@StateObject private var questionnaireViewModel = QuestionnaireViewModel()
```

- `@StateObject` should be used **once** when the view model is first created and owned by the parent.
- This tells SwiftUI to **manage the lifecycle** of the observable object.

---

#### 📎 Passing to a Child View

```swift
@ObservedObject var questionnaireViewModel: QuestionnaireViewModel
```

- Child views should use `@ObservedObject` to **observe an already-existing** `ObservableObject`.
- This ensures the view updates automatically when any `@Published` properties in the ViewModel change.

---

#### 🔄 Automatic UI Updates

Any change to a `@Published` property will **automatically refresh** the parts of the UI that depend on it.

```swift
questionnaireViewModel.showCompletion = true // Will trigger a view update
```

> 💡 This pattern helps you separate your UI logic from your business logic, keeping your views lightweight and declarative while the ViewModel handles state and data manipulation.
</details>

<details>
<summary>📍 Managing Local View State with @State</summary>
SwiftUI provides multiple ways to manage state depending on the scope and direction of data flow:

#### 🔹 `@State`
- Use `@State` to manage **local view state**.
- When a `@State` variable changes, **the view is re-rendered**.
- However, `@State` **does not persist across screens** or parent-child views.

```swift
@State private var isToggled: Bool = false
```

---

#### 🔹 `@ObservableObject` + `@Published`
- Use this combo to manage **shared state** across views.
- Ideal for **Parent → Child** data flow.
- Changes to `@Published` properties will automatically notify and update any observing views.

```swift
class MyViewModel: ObservableObject {
    @Published var counter: Int = 0
}
```

---

#### 🔹 `@Binding`
- Use `@Binding` for **Child → Parent** data flow.
- This creates a two-way connection to a piece of state owned by a parent view.

```swift
@Binding var isPresented: Bool
```

> 💡 Choose the right state management tool based on the ownership and lifespan of the data. Keeping state logic clean is key to building scalable and maintainable SwiftUI apps.
</details>

<details>
<summary>🌐 API Calls and Decoding</summary>

Swift's networking with `URLSession` is relatively straightforward. Here's a breakdown of how to make API calls, handle responses, and decode JSON into usable Swift types.

---

### 📡 Sending a Request

To make a request, create a `URLRequest`, specify the HTTP method, add headers (like API keys), and then use `URLSession` to perform the call.

📄 `Networking/QuoteClient.swift`

```swift
var request = URLRequest(url: url)
request.httpMethod = "GET"
request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

let (data, response) = try await URLSession.shared.data(for: request)

guard let httpResponse = response as? HTTPURLResponse,
      httpResponse.statusCode == 200 else {
    print("[QuoteClient] - Invalid Response")
    throw APIError.invalidResponse
}

do {
    print("[QuoteClient] - Raw Data:", String(data: data, encoding: .utf8) ?? "Unable to decode data")
    let decodedQuotes = try JSONDecoder().decode([Quote].self, from: data)
    if let firstQuote = decodedQuotes.first {
        quotes.append(firstQuote)
    }
} catch {
    print("[QuoteClient] - Decoding Error")
    throw APIError.decodingError
}
```

---

### 📦 Decoding JSON Data

To decode JSON, define a `Decodable` struct that matches the structure of the data. It does not have to match all the fields, just the ones that you are interested in.

```swift
struct Quote: Decodable, Identifiable {
    let id: UUID = UUID()
    let quote: String
    let author: String

    enum CodingKeys: String, CodingKey {
        case quote = "q"
        case author = "a"
    }
}
```

- Use `CodingKeys` to map JSON keys (`q`, `a`) to more readable property names (`quote`, `author`).
- `UUID` is generated locally since the API doesn't provide it.
- `Identifiable` makes it easier to use in SwiftUI views.

---

### 💡 Notes

- The response must be a 200 status code to proceed.
- Use `try await` with `URLSession.shared.data` for async operations.
- Always handle decoding errors gracefully.
</details>

<details>
<summary>🧱 SwiftUI View Components (HStacks, VStacks, Text, Charts, etc.)</summary>

SwiftUI View Components are intuitive and composable building blocks of the UI. Common components like `HStack`, `VStack`, and `Text` conform to the `View` protocol and are used to structure and display content.

### 🧩 Basics

- **Stacks** (`HStack`, `VStack`, `ZStack`) arrange views horizontally, vertically, or in depth respectively.
- **Parameters** like `alignment`, `spacing`, and `padding` allow control over layout and spacing.
- **Trailing closures** are used to place nested views within the container.
- **View modifiers** such as `.padding`, `.frame`, `.background`, etc. are chained after a view to apply styling or layout changes.

---

### 💡 Example: A Custom Button Using `HStack`, `VStack`, and Modifiers

```swift
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
}
```

### 📝 Notes

- The `HStack` arranges its children horizontally.
- Inside the `Button`, a `VStack` arranges content vertically with spacing.
- Modifiers like `.padding()`, `.frame()`, `.background()`, and `.shadow()` are used to control the appearance and layout.
- `Spacer()` is used to push content within a stack.

> SwiftUI’s declarative syntax makes UI building clean, flexible, and easy to reason about.

</details>

<details>
<summary>🔐 Storing Non-Sensitive Variables (e.g. Public API URLs)</summary>

To manage non-sensitive configuration values like public API URLs in a secure and scalable way, you can use `.xcconfig` files in your Xcode project. Here's a step-by-step guide:

---

### 🛠️ 1. Create an `.xcconfig` File

Create a new file named something like `Config.xcconfig`. Add key-value pairs for your configuration. For example:

```plaintext
API_URL = https://api.example.com/v1
```

> 💡 Use different `.xcconfig` files for Debug, Release, and other build configurations if needed.

---

### ⚙️ 2. Link `.xcconfig` to Info.plist

To expose the value from your `.xcconfig` in your app, you need to reference it in your `Info.plist`. If it doesn't already exist, create or modify your `Info.plist` like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_URL</key>
    <string>$(API_URL)</string>
</dict>
</plist>
```

This will allow Xcode to substitute the value of `API_URL` from the `.xcconfig` file at build time.

---

### 🧪 3. Access It in Code

You can now access the value in your Swift code:

```swift
guard let apiURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
    fatalError("API_URL not found in Info.plist")
}
```

---

### ✅ Summary

- ✅ `.xcconfig` allows for environment-specific config values.
- ✅ `Info.plist` bridges the build settings to your app runtime.
- ✅ Safe and effective for non-sensitive data like public endpoints or flags.

> ⚠️ Don't store secrets like API keys or tokens this way—use the Keychain, environment variables via CI/CD, or other secure methods instead.
</details>

<details>
<summary>🔓 Unwrapping Optionals (Coming Soon)</summary>
> Please refer to online guides on the different ways of unwrapping variables (guard, ??, if let etc.. )
</details>

<details>
<summary>🔓 Closures (Coming Soon)</summary>
> Please refer to online guides on closure (closure syntax, passing variables into closures, passing and accepting closures as paramters, trailing closure)
</details>
