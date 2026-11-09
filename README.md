# GarageBook

GarageBook is an iOS app that keeps the maintenance history of your cars and motorcycles in one place. You can log services, fuel, mods and parts, see how much you spend, and get reminded when the next service is due. You can also take a photo of an invoice and let AI fill in the service details for you.

This is our final project for **420-N52-LA Mobile Application Development 2: iOS** at Champlain College Saint-Lambert (instructor: Morteza Khanjanzadeh).

## Team Members

- Elias Larhdaf
- Adam Benikhlef
- Nathan Toko Chibuike

## Project Purpose

A lot of people don't remember when they last changed their oil, what a repair cost, or which parts they put on their vehicle. We wanted a simple app that solves this: one place for the whole history of each vehicle, with spending summaries and reminders so nothing gets forgotten.

## Main Features

1. **Vehicle management:** add, edit and delete your vehicles (cars and motorcycles) with their make, model, year, mileage and a photo.
2. **Service records:** log services, fuel, mods and parts for each vehicle. You can search and filter the history.
3. **Cost dashboard:** charts that show what you spend per month and per vehicle.
4. **Service reminders:** notifications when a service is coming up, by date or by mileage.
5. **AI invoice scan:** take a photo of an invoice and the Gemini API reads it and creates the service record for you. This part is optional, the rest of the app works without it.

## Technologies Used

- Swift and SwiftUI
- MVVM architecture
- SwiftData for saving data (`Vehicle`, `ServiceRecord`, `Part`)
- NavigationStack and sheets
- Swift Charts
- Local notifications (UserNotifications)
- Photos / Camera
- Gemini API (free tier) with URLSession, async/await and Codable

## How to Run

You need a Mac with Xcode installed.

1. Clone the repo:
   ```
   git clone https://github.com/ELS20680/GarageBook.git
   ```
2. Open `GarageBook/GarageBook.xcodeproj` in Xcode.
3. Pick an iPhone simulator and press Run (⌘R).

The app works without any setup. Only the invoice scan needs an API key.

## API / AI Setup (Gemini)

The invoice scan uses the free tier of the Gemini API. We did not enable billing or add a credit card.

1. Get your own free API key from Google AI Studio.
2. Copy `Secrets.example.xcconfig` and rename the copy to `Secrets.xcconfig`.
3. Replace `YOUR_KEY_HERE` with your key.
4. Build the app again.

`Secrets.xcconfig` is in `.gitignore`, so the key is never uploaded to GitHub.

## Project Structure

Inside `GarageBook/GarageBook/`:

- `Models`: the SwiftData models
- `Views`: the SwiftUI screens and small reusable views
- `ViewModels`: the logic and state behind each screen
- `Data`: SwiftData setup and sample data
- `Services`: notifications and the Gemini API
