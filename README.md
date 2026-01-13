# QuoteVault

A complete quote discovery and collection app with user accounts, cloud sync, and personalization features. Built with SwiftUI and Supabase.

## Features

### Authentication & User Accounts
- ✅ Sign up with email/password
- ✅ Login/logout functionality
- ✅ Password reset flow
- ✅ User profile screen (name, avatar)
- ✅ Session persistence (stay logged in)

### Quote Browsing & Discovery
- ✅ Home feed displaying quotes (infinite scroll)
- ✅ Browse quotes by category (Motivation, Love, Success, Wisdom, Humor)
- ✅ Search quotes by keyword
- ✅ Search/filter by author
- ✅ Pull-to-refresh functionality
- ✅ Loading states and empty states

### Favorites & Collections
- ✅ Save quotes to favorites
- ✅ View all favorited quotes
- ✅ Create custom collections
- ✅ Add/remove quotes from collections
- ✅ Cloud sync across devices

### Daily Quote & Notifications
- ✅ Quote of the Day on home screen
- ✅ Daily quote rotation
- ✅ Local push notifications
- ✅ Customizable notification time

### Sharing & Export
- ✅ Share quote as text
- ✅ Generate shareable quote cards
- ✅ Save quote card as image
- ✅ 3+ card styles/templates

### Personalization & Settings
- ✅ Dark mode / Light mode toggle
- ✅ Additional themes (Ocean, Sunset)
- ✅ Font size adjustment
- ✅ Settings sync to user profile

### Widget
- ✅ Home screen widget with daily quote
- ✅ Daily updates
- ✅ Tap to open app

## Tech Stack

- **Framework**: SwiftUI
- **Backend**: Supabase (Auth + Database)
- **Architecture**: MVVM (Model-View-ViewModel)
- **Minimum iOS Version**: iOS 17.0
- **Xcode Version**: 15.0+

## Project Structure

```
QuoteVault/
├── Core/
│   ├── Models/          # Data models (Quote, User, Collection)
│   ├── Services/        # API services (Auth, Quote, Favorite, Collection)
│   ├── Managers/        # State managers (Theme, Settings, DailyQuote)
│   └── Utilities/       # Constants, Extensions, Helpers
├── Features/
│   ├── Authentication/  # Login, Signup, Profile views
│   ├── Home/           # Home feed, Daily quote
│   ├── Browse/         # Categories, Search
│   ├── Favorites/      # Favorite quotes list
│   ├── Collections/    # Collections management
│   ├── Share/          # Quote card generation
│   └── Settings/       # App settings
└── Navigation/         # Tab bar, Routing
```

## Architecture

This app follows **MVVM (Model-View-ViewModel)** architecture with clear separation of concerns:

- **Models**: Pure data structures (Quote, User, Collection, etc.)
- **Services**: Handle all API calls and data operations (AuthService, QuoteService, etc.)
- **ViewModels**: Business logic, state management, service orchestration
- **Views**: SwiftUI views with minimal logic
- **Managers**: Singleton managers for app-wide state (ThemeManager, SettingsManager)

### Key Design Patterns

- **Service Layer**: Centralized API communication
- **Repository Pattern**: Abstract data sources (Supabase, UserDefaults)
- **Dependency Injection**: Services injected into ViewModels
- **ObservableObject**: State management with Combine

## Setup Instructions

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- Supabase account (free tier available)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/shalinth-adith/QuoteVault.git
   cd QuoteVault
   ```

2. **Open in Xcode**
   ```bash
   open QuoteVault.xcodeproj
   ```

3. **Add Supabase Swift Package**
   - In Xcode, go to **File > Add Packages...**
   - Paste: `https://github.com/supabase/supabase-swift`
   - Select version **2.0.0** or later
   - Add products: **Supabase**, **Auth**, **PostgREST**, **Realtime**

4. **Set up Supabase Backend**
   - Create account at [supabase.com](https://supabase.com)
   - Create new project
   - Copy Project URL and anon key from Settings > API
   - Update `QuoteVault/Core/Utilities/Constants.swift`:
     ```swift
     enum Supabase {
         static let url = "YOUR_SUPABASE_URL"
         static let anonKey = "YOUR_SUPABASE_ANON_KEY"
     }
     ```

5. **Set up Database**
   - In Supabase dashboard, go to SQL Editor
   - Run `database-schema.sql` to create tables
   - Run `seed-quotes.sql` to populate 120 quotes

6. **Build and Run**
   - Select a simulator or device
   - Press **Cmd + R** to build and run

For detailed setup instructions, see [SETUP.md](SETUP.md)

## AI Tools Used in Development

This project was built leveraging AI coding assistants to accelerate development:

### Development Workflow

1. **Architecture Planning**
   - Used AI to design MVVM architecture
   - Generated comprehensive folder structure
   - Planned database schema and relationships

2. **Code Generation**
   - AI-assisted creation of Models, Services, and ViewModels
   - Boilerplate code generation for CRUD operations
   - SwiftUI view scaffolding

3. **Supabase Integration**
   - AI-generated SQL schema with RLS policies
   - Seed data generation (120 quotes across categories)
   - Service layer implementation

4. **Best Practices**
   - Code review and refactoring suggestions
   - Error handling patterns
   - Swift naming conventions

### AI Tools Stack

- **Primary IDE Assistant**: For real-time code completion and suggestions
- **Code Review**: For architecture decisions and code quality
- **Documentation**: For generating comprehensive setup guides
- **Database**: For SQL schema design and optimization

### Prompting Strategies

- **Specific Requirements**: Detailed feature specifications with acceptance criteria
- **Context Sharing**: Provided existing code patterns for consistency
- **Iterative Refinement**: Multiple rounds of review and improvement
- **Code Review**: Asked AI to review generated code for best practices

## Database Schema

### Tables

- **quotes**: All quotes with text, author, category
- **user_profiles**: User information and settings
- **user_favorites**: User's favorited quotes
- **collections**: User-created collections
- **collection_quotes**: Quotes in collections
- **daily_quotes**: Daily quote rotation

### Security

- Row Level Security (RLS) enabled on all tables
- Users can only access their own favorites and collections
- Quotes are publicly readable
- Automatic user profile creation on signup

## Known Limitations

- Widget refresh limited by iOS background refresh policies
- Offline mode queues actions but requires connection to sync
- Avatar upload requires additional storage configuration
- Search is case-insensitive but doesn't support fuzzy matching

## Future Enhancements

- [ ] Social features (share collections with friends)
- [ ] Quote submission by users
- [ ] Advanced search filters
- [ ] Export collections as PDF
- [ ] Multiple language support
- [ ] Dark mode auto-scheduling
- [ ] Apple Watch companion app

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available for educational and portfolio purposes.

## Contact

**GitHub**: [@shalinth-adith](https://github.com/shalinth-adith)

**Project Link**: [https://github.com/shalinth-adith/QuoteVault](https://github.com/shalinth-adith/QuoteVault)

---

Built with ❤️ using SwiftUI and Supabase
