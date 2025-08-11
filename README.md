# MayaApp - A Simple Flutter E-Wallet

A 4-screen Flutter e-wallet application designed for simplicity and ease of use. It demonstrates a modern Flutter development stack including Clean Architecture, Cubit for state management, and a pre-configured Strapi backend.

![MayaApp Screenshot Placeholder](https://via.placeholder.com/800x450.png?text=Add+a+Screenshot+or+GIF+of+your+App+here!)
_(Replace the image above with a screenshot or GIF of the running application)_

---

## ✨ Features

- 👤 **User Authentication:** Secure login using an 11-digit mobile number and password.
- 💰 **Balance Viewing:** A clear home screen displaying the user's current balance, with a toggle to hide/show the amount for privacy.
- 💸 **Send Money:** A user-friendly form to send funds to another user by entering their 11-digit mobile number.
- 📜 **Transaction History:** A clean, filtered list showing all incoming (credit) and outgoing (debit) transactions for the user.
- 🎨 **Creative & Friendly UI:** Designed with high-contrast elements, large fonts, and intuitive icons, making it accessible even for elderly users.

---

## 🏗️ Architecture & Tech Stack

This project is built using **Clean Architecture** to ensure a separation of concerns, making the codebase scalable, maintainable, and testable.

- **Architecture:** Clean Architecture (Domain, Data, Presentation Layers)
- **State Management:** **Cubit** (`flutter_bloc`) for simple and predictable state management.
- **Frontend:** Flutter
- **Backend:** **Strapi v5** (Headless CMS) - _Pre-configured in the backend repository._
- **API Communication:** **Dio** for robust network requests.
- **Dependency Injection:** **`get_it`** as a service locator.
- **Testing:** **`bloc_test`** and **`mockito`** for unit testing the business logic.

---

## 🚀 Getting Started

Follow these steps to get the application running on your local machine. This involves setting up both the backend and the frontend.

### Prerequisites

- Flutter SDK (version 3.x or later)
- Node.js (v18 or later) & npm
- An IDE like VS Code or Android Studio
- An Android Emulator or a physical device (iOS or Android)

### 1. Backend Setup (Strapi)

The backend is a pre-configured Strapi project provided in a separate repository.

1.  **Clone the Backend Repository:**

    ```bash
    # Replace the URL with your actual backend repository URL
    git clone https://github.com/your-username/mayaapp-backend.git
    cd mayaapp-backend
    ```

2.  **Install Dependencies:**

    ```bash
    npm install
    ```

3.  **Run the Backend in Development Mode:** This command will build the admin UI and start the server.

    ```bash
    npm run develop
    ```

4.  **Create Your First Admin User:** The first time you run the backend, it will open `http://localhost:1337/admin` in your browser. Follow the prompts to create your admin account.

5.  **Verify API Permissions:** This step is crucial. Even with a cloned repo, you should verify that the correct permissions are enabled.

    - In the Strapi Admin Panel, navigate to **Settings** -> **Roles** (under Users & Permissions Plugin).
    - Click on the **Authenticated** role.
    - Scroll down to **Permissions** and ensure the following actions are checked:

      - **Transaction**

        - [x] `create` - (Allows the backend to create transaction logs)
        - [x] `find` - (Allows users to fetch their transaction history)
        - [x] `findOne`

      - **User** (from Users & Permissions Plugin)

        - [x] `find` - (Required to populate recipient data in transactions)
        - [x] `findOne` - (Required to fetch the user's own profile and balance)

      - **Wallet** (from the custom controller)
        - [x] `send` - (Allows users to execute the send money functionality)

    - Click **Save** in the top-right corner if you made any changes.

6.  **Create Test Users:**

    - Inside the Strapi Admin Panel, navigate to the **Content Manager**.
    - Select the **User** collection type.
    - Create a few test users. For each user, make sure to set:
      - **Username:** An 11-digit mobile number (e.g., `09171234567`).
      - **Email:** A corresponding email (e.g., `09171234567.default@test.com`).
      - **Password:** A strong password.
      - **Confirmed:** `ON`.
      - **Balance:** An initial balance (e.g., `5000`).

    The backend server is now running and ready to accept requests from your Flutter app!

### 2. Frontend Setup (Flutter)

1.  **Clone the Flutter Repository:**

    ```bash
    # Replace the URL with your actual frontend repository URL
    git clone https://github.com/your-username/mayaapp.git
    cd mayaapp
    ```

2.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Configure API Endpoint URL:** This is a critical step. The code is already configured to automatically use the correct IP address depending on the platform (iOS vs. Android). No changes should be needed.

    ```dart
    // In lib/service_locator.dart
    String getBaseUrl() {
      if (Platform.isAndroid) {
        // For Android Emulator, 10.0.2.2 points to the host machine's localhost
        return 'http://10.0.2.2:1337/api';
      }
      // For iOS Simulator, Web, or Desktop, localhost works directly
      return 'http://localhost:1337/api';
    }
    ```

4.  **Run the App:**
    ```bash
    flutter run
    ```

---

## 🧪 Running Unit Tests

Unit tests are provided for the business logic controllers (Cubits).

1.  **Generate Mock Files:** `mockito` requires code generation for creating mock classes.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
2.  **Run Tests:** Execute all tests in the project.
    ```bash
    flutter test
    ```

---

## 📝 Backend API & Configuration

- **Authentication:** Uses Strapi's built-in `POST /api/auth/local` endpoint.
- **Transaction Logic:** Handled by a custom controller to ensure atomicity.
  - **Endpoint:** `POST /api/wallet/send`
  - **Functionality:** Debits the sender, credits the recipient, and creates two transaction log entries (`debit` and `credit`) in a single, secure database transaction.
- **Fetching History:** Uses `GET /api/transactions` with query parameters to populate relational data (`?populate=*`) and filter by user involvement.

---

## 📁 Project Structure

The project follows the Clean Architecture pattern, separating concerns into distinct layers.
