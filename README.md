# Warning Light Camera

<img width="100" height="218" alt="LaunchScreen" src="https://github.com/user-attachments/assets/4056e198-9e47-40e5-b598-049793ae8770" />


## Description

**Find the answer to one of the world's most annoying questions: "What does that light on my dashboard mean?"**

Warning Light Camera is a camera-based dashboard warning light identifier — and more than that, a way to actually track your vehicle's history and hand it straight to a mechanic. With data on over 90 dashboard warning lights, plus a built-in Garage for logging issues per vehicle, this app puts both instant answers and a real maintenance record at your fingertips.

**What makes this app unique:**

* **AI-Powered Image Recognition** — Take a picture of any dashboard warning light and get instant identification with detailed explanations
* **Comprehensive Database** — An extensive encyclopedia of 90+ warning lights with descriptions, fixes, and safety recommendations
* **Safety-First Approach** — Every warning light includes clear guidance on whether it's safe to keep driving
* **Smart Predictions** — Image recognition returns multiple possible matches with confidence ratings, so you're never left guessing
* **The Garage** — Track multiple vehicles, log issues (with photos, mileage, and a tap-to-mark vehicle diagram), and generate a clean PDF report to hand straight to your mechanic

No more guessing games, frantic manual searches, or trying to describe a noise over the phone. Whether it's an unfamiliar warning light or an ongoing issue you want on record, Warning Light Camera gets you answers in seconds — and keeps a history so you're never starting from scratch.

> ⚠️ **Important Safety Notice**
> - Never use this app while driving
> - This app does not replace professional mechanic consultation

## Features

**Identify**
* 📸 **Camera-Based Recognition** — Take a picture of any dashboard warning light for instant identification
* 🔍 **Smart Predictions** — AI-powered image recognition returns multiple possible matches with confidence ratings
* 📚 **Comprehensive Database** — 90+ dashboard warning lights with detailed information
* 📖 **Warning Light Encyclopedia** — Browse and search the full library, independent of the camera
* 🛡️ **Safety Guidance** — Clear "safe to drive" recommendations for every light
* 🔧 **Repair Information** — What each light means and how to resolve it

**The Garage**
* 🚗 **Multi-Vehicle Tracking** — Log and manage issues across as many vehicles as you own
* 📝 **Issue Logging** — Record a problem with categories, notes, mileage, a photo, and a tap-to-mark vehicle diagram showing exactly where the issue is
* 🔗 **Linked Warning Lights** — Connect a logged issue to the warning lights it's related to
* 📄 **Mechanic-Ready Reports** — Generate a PDF report of active issues and warning lights, ready to share or hand off in person
* 👁️ **Live Timeline** — See every vehicle's full history, active and resolved, at a glance

**Polish**
* 🌙 **Dark Mode Support** — A dashboard-inspired dark interface throughout
* ⚡ **Instant Results** — Answers in seconds, no lengthy searches
* 💛 **No Ads, Ever** — Fully free to use, with an entirely optional tip jar for anyone who wants to support development

## Screenshots


<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/d26b08da-f1fc-4b30-aa9e-42d63281547b" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/7c02683f-21a5-44c0-b9f7-99ac196912dd" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/47a36aa0-865a-4500-aa62-d2755ae5190f" width="200"></td>
  </tr>
  <tr>
    <td align="center">Scan a warning light</td>
    <td align="center">Confident match results</td>
    <td align="center">Mechanic-ready PDF report</td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/d3931e26-627b-4b53-b106-e62290b78576" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/ef53667d-6157-4e15-9456-eeb2206b938a" width="200"></td>
    <td><img src="https://github.com/user-attachments/assets/956a46ff-68ab-4992-bfbf-7fda35f60f98" width="200"></td>
  </tr>
  <tr>
    <td align="center">90+ light encyclopedia</td>
    <td align="center">Safe-to-drive guidance</td>
    <td align="center">Garage vehicle timeline</td>
  </tr>
</table>


## Requirements
- iOS 18+

## Technologies Used
- Swift / SwiftUI
- SwiftData
- CoreML
- Vision Framework
- AVFoundation
- StoreKit 2
- QuickLook
- JSON
- MVVM
- Combine

## Usage
- **Identify a light:** Tap the camera button, point at the dashboard light, and get an instant match with a confidence rating.
- **Browse manually:** Open the Encyclopedia tab to search or scroll through all 90+ lights directly.
- **Track a vehicle:** Add a vehicle in the Garage tab, then log issues or warning lights against it over time.
- **Hand off to a mechanic:** From any vehicle, build a report — it bundles active issues and warning lights into a single PDF you can share or open on the spot.

## Architecture
MVVM, with SwiftData for persistence and a shared environment for app-wide data (e.g. the warning light dataset).

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## App Icon

<img src="https://github.com/user-attachments/assets/e6286f79-7f0a-43a2-8444-96caf762dab6" width="50">

---

*Last updated: [9/19/26]*
