# QuoteVault Setup Guide

This guide will help you set up QuoteVault with Supabase backend.

## Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- Supabase account (free tier available at [supabase.com](https://supabase.com))

## Step 1: Add Supabase Swift Package

1. Open `QuoteVault.xcodeproj` in Xcode
2. Go to **File > Add Packages...**
3. In the search bar, paste: `https://github.com/supabase/supabase-swift`
4. Select version: **2.0.0** or later
5. Click **Add Package**
6. Select the following products to add:
   - **Supabase** (main library)
   - **Auth** (authentication)
   - **PostgREST** (database)
   - **Realtime** (real-time subscriptions)
7. Click **Add Package**

## Step 2: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **New Project**
3. Fill in:
   - **Name**: QuoteVault
   - **Database Password**: (create a strong password - save it!)
   - **Region**: Choose closest to you
4. Click **Create New Project**
5. Wait for the project to finish setting up (2-3 minutes)

## Step 3: Get Supabase Credentials

1. In your Supabase dashboard, go to **Settings > API**
2. Copy the following:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public key** (long string starting with `eyJ...`)

## Step 4: Configure QuoteVault

1. Open `QuoteVault/Core/Utilities/Constants.swift`
2. Replace the placeholder values:

```swift
enum Supabase {
    static let url = "YOUR_SUPABASE_URL"  // Paste your Project URL here
    static let anonKey = "YOUR_SUPABASE_ANON_KEY"  // Paste your anon key here
}
```

## Step 5: Set Up Database Schema

1. In Supabase dashboard, go to **SQL Editor**
2. Click **New Query**
3. Copy and paste the SQL schema from `database-schema.sql` (will be created next)
4. Click **Run** to execute the schema
5. Verify tables are created in **Table Editor**

## Step 6: Seed Database with Quotes

1. In SQL Editor, create a new query
2. Copy and paste the SQL from `seed-quotes.sql` (will be created next)
3. Click **Run** to insert quotes
4. Verify data in **Table Editor > quotes** (should see 100+ quotes)

## Step 7: Configure Authentication

1. In Supabase dashboard, go to **Authentication > Providers**
2. Make sure **Email** is enabled
3. Under **Email > Email Templates**, customize templates if desired
4. Under **Authentication > URL Configuration**:
   - Add redirect URL: `quotevault://auth-callback`

## Step 8: Build and Run

1. In Xcode, select a simulator or device
2. Press **Cmd + R** to build and run
3. The app should launch successfully!

## Troubleshooting

### Build Errors
- Make sure you added all Supabase products (Supabase, Auth, PostgREST, Realtime)
- Clean build folder: **Product > Clean Build Folder** (Cmd + Shift + K)
- Restart Xcode

### Authentication Errors
- Double-check your Supabase URL and anon key in Constants.swift
- Make sure email auth is enabled in Supabase dashboard

### Database Errors
- Verify all tables are created in Table Editor
- Check Row Level Security (RLS) policies are set correctly
- Review SQL query errors in Supabase dashboard

## Next Steps

Once setup is complete, you can:
- Sign up with a test account
- Browse quotes
- Add favorites and collections
- Test daily quote notifications
- Customize themes and settings

## Need Help?

- Supabase Documentation: https://supabase.com/docs
- Supabase Swift SDK: https://github.com/supabase/supabase-swift
- QuoteVault Issues: https://github.com/shalinth-adith/QuoteVault/issues
