# 📔 Offline-First Diary & eBook App

A modern **Flutter** application designed for writing personal diaries and reading eBooks — anytime, anywhere.  
The app follows an **Offline-First** approach, ensuring seamless functionality without an internet connection and automatic synchronization when back online.  
Built with **GetX** for state management and **Clean Architecture** for scalability and maintainability.

---

## ✨ Key Features

### 📝 Personal Diary
- Create, edit, and delete diary entries with rich text support.
- Entries automatically saved locally using **Hive / SQLite**.
- Optionally sync to **Firebase** when online.
- Secure your diary with app-level **PIN / biometric lock**.

### 📚 eBook Reader
- Browse, import, and read eBooks (EPUB or PDF).
- Resume reading from where you left off.
- Adjustable font size, night mode, and progress tracking.
- Bookmark your favorite pages or quotes.

### 🔄 Offline-First Sync
- Works seamlessly offline with local caching.
- Syncs diary entries and reading progress automatically when connected.
- Conflict-free data merge using timestamps.

### ☁️ Cloud Backup (Optional)
- Optional integration with **Firebase Firestore** or **Cloud Storage** for secure backup.
- Restore your diary or eBooks on a new device instantly.

### 🧠 Smart Search & Organization
- Search diary entries by title, date, or content.
- Organize notes and books into custom categories.
- Auto-sort by most recent or alphabetical order.

### ⚙️ Additional Features
- **GetX** for reactive state management and routing.
- **Clean Architecture** pattern for easy scaling and testing.
- **Local Notifications** for writing reminders.
- Minimal, distraction-free design for an enjoyable writing and reading experience.

---

## 🧱 Tech Stack

| Layer | Technology |
|-------|-------------|
| Framework | Flutter (Dart) |
| State Management | GetX |
| Local Database | Hive / SQLite |
| Optional Cloud Sync | Firebase Firestore / Storage |
| Architecture | Clean Architecture (Presentation, Domain, Data layers) |
| Security | Local encryption & biometric authentication |

---

## ⚙️ Getting Started

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/your-username/offline-diary-ebook.git
cd offline-diary-ebook
