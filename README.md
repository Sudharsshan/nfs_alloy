# NFS Alloy

A premium wallpaper discovery and download platform built with Flutter Web, featuring a dynamic glassmorphism-inspired interface, responsive masonry layouts, and a Sanity.io-powered content backend.

![Flutter](https://img.shields.io/badge/Flutter-Web-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Live preview

> Visit the website live at: [Vercel Deployment](https://nfs-alloy.vercel.app)
## 📖 Overview

NFS Alloy is a modern wallpaper gallery designed to showcase high-resolution wallpapers through an immersive and visually appealing user experience.

The application combines:

- Dynamic background wallpapers
- Glassmorphism UI elements
- Infinite scrolling image galleries
- Responsive masonry grid layouts
- Category-based wallpaper filtering
- Full-resolution image viewing
- Wallpaper downloads

The platform uses **Sanity.io** as a headless CMS, allowing wallpaper collections to be managed without modifying application code.

---

## ✨ Features

### 🎨 Modern User Interface

- Glassmorphism-inspired design
- Dynamic spotlight cursor effect
- Smooth animations and transitions
- Responsive layout for desktop and mobile browsers

### 🖼 Wallpaper Gallery

- Infinite scrolling image feed
- High-resolution wallpaper previews
- Full-screen wallpaper viewer
- Masonry-style grid layout
- Optimized image loading and caching

### 📂 Category Management

- Dynamic category loading from backend
- Category-based wallpaper filtering
- Easily expandable content structure

### ⚡ Performance Optimizations

- Cached image loading
- Chunk-based pagination
- Lazy loading for large galleries
- Responsive image sizing

### 📥 Downloads

- Download wallpapers in original quality
- Browser-compatible image saving

---

## 🏗 Architecture

### Frontend

Built using:

- Flutter Web
- Material Design
- Google Fonts
- Cached Network Image
- Flutter Staggered Grid View
- Flutter Staggered Animations

### Backend

Powered by:

- Sanity.io Headless CMS

Responsibilities:

- Wallpaper storage
- Category management
- Image delivery
- Content updates

---

## 📁 Project Structure

```text
lib/
├── assets/
│   └── bg.png
│
├── models/
│   ├── game_categories.dart
│   ├── tile_span.dart
│   └── wallpaper_loader.dart
│
├── pages/
│   ├── landing_page.dart
│   └── wallpapers.dart
│
├── widgets/
│   ├── custom_app_bar.dart
│   ├── custom_drop_down_menu.dart
│   ├── game_selector.dart
│   ├── image_pop_up.dart
│   ├── liquid_glass_button.dart
│   ├── liquid_glass_menu_item.dart
│   ├── reveal_text.dart
│   └── credits.dart
│
└── misllaneous/
    ├── sanity_service.dart
    ├── image_downloader.dart
    ├── spotlight_painter.dart
    ├── tile_weights.dart
    └── url_launcher.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9+
- Dart SDK
- Sanity.io backend configuration

### Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/nfs-alloy.git
cd nfs-alloy
```

Install dependencies:

```bash
flutter pub get
```

Run locally:

```bash
flutter run -d chrome
```

Build for production:

```bash
flutter build web --release
```

---

## 🔧 Dependencies

| Package | Purpose |
|----------|----------|
| cached_network_image | Efficient image caching |
| flutter_staggered_grid_view | Masonry grid layouts |
| flutter_staggered_animations | Entrance animations |
| google_fonts | Typography |
| http | Backend communication |
| lottie | Animations |
| font_awesome_flutter | Icons |

---

## 🎯 Technical Highlights

- Infinite scrolling implementation
- Dynamic wallpaper loading from CMS
- Responsive grid generation
- Glass blur rendering effects
- Cursor-tracked spotlight effects
- Image caching and optimization
- Modular Flutter architecture

---

## 🌐 Backend Integration

The application communicates with Sanity.io to:

- Fetch wallpaper collections
- Retrieve active categories
- Load random hero backgrounds
- Deliver optimized image assets

This allows content creators to update the gallery without redeploying the frontend.

---

## 📈 Future Improvements

- User accounts
- Favorites collection
- Search functionality
- Wallpaper recommendations
- Dark/Light themes
- Progressive Web App enhancements
- Offline caching support
- Wallpaper upload portal

---

## 📸 Screenshots
*This section will be updated soon*
Add screenshots here:

```text
screenshots/
├── landing-page.png
├── gallery-view.png
├── wallpaper-preview.png
└── mobile-view.png
```

---

## 👨‍💻 Author

Developed by RipJVw

A custom Flutter Web experience focused on delivering high-quality wallpaper browsing through modern UI design and scalable backend architecture.

---

## 📜 License

This project is licensed under the MIT License.
