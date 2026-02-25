# Smart Quiz - Quizing & Learning Platform

A modern, high-performance Flutter mobile application for interactive learning. This app allows students to take quizzes, track their progress, and compete on leaderboards, while admins can manage quiz content and monitor participation.

## Features

### For Students
- **Interactive Quizzes**: Take quizzes across multiple categories (Math, English, Science, etc.).
- **Topic Filtering**: Easily find relevant content with smart filtering.
- **Dynamic Stats**: Track XP, Rank, and time spent on learning.
- **Leaderboards**: Compare your performance with peers.
- **Detailed History**: Review your previous scores and correct answers.

### For Administrators
- **Content Management**: Create and manage quizzes and questions.
- **Access Control**: Mark quizzes as "Shared" (Public) or "Private" (Internal).
- **Analytics**: View participation count and average scores for each quiz.

##  Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Networking**: Dio (with centralized `ApiConfig`)
- **Architecture**: Clean Architecture (Presentation, Repository, Service layers)
- **Design**: Modern UI with custom gradients and SF Pro typography.

##  Demo Credentials
To ensure a stable experience while testing, use the following predefined accounts:

| Role      | Username | Password   | Access                         |
|-----------|----------|----------  |--------------------------------|
| **Admin** | `admin`  | `admin123` | Full access + Manage options   |
| **User**  | `user`   | `user123`  | Student dashboard & Quiz flows |


##  Installation & Setup

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Check assets**
   Ensure fonts and images are correctly placed in the `assets/` directory.

4. **Run the app**
   ```bash
   flutter run
   ```



---
*Created for Mobile App Development Assignment*

##  Note
- For data we use mock API from Postman that we created.
- So if when testing or check it have any error, it may be from the API.
- We will submit with collection of mock API in case have error with it.
- The place for change is at assets/config.json
- Device that we testing is IPhone and we run on Web browser because we can run on Android Emulator.


============================= Thank you so much =========================

