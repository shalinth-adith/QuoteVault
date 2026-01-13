//
//  SupabaseService.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: Constants.Supabase.url)!,
            supabaseKey: Constants.Supabase.anonKey
        )
    }
}
