//
//  FormatterManager.swift
//  HealthCommunity
//
//  Created by 전준영 on 8/25/24.
//

import Foundation

final class FormatterManager {
    
    static let shared = FormatterManager()
    
    private init() { }
    
    private let formatter = DateFormatter()
    
    func formatDate(from dateString: String) -> String? {
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let currentTime = Date()
        let duration = currentTime.timeIntervalSince(date)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .year], from: date, to: currentTime)
        let daysAgo = components.day ?? 0
        let yearsAgo = components.year ?? 0
        
        if duration < 60 {
            return "방금 전"
        } else if duration < 10 * 60 {
            let minutesAgo = Int(duration / 60)
            return "\(minutesAgo)분 전"
        } else if daysAgo < 1 {
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "a hh:mm"
            return formatter.string(from: date)
        } else if daysAgo < 2 {
            return "어제"
        } else if yearsAgo < 1 {
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일"
            return formatter.string(from: date)
        } else {
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: date)
        }
    }
    
    func formatCalendarDate(_ date: Date) -> String {
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func formatStringToDate(_ date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date) ?? Date()
    }
    
    func getCurrentDate() -> String {
        return formatCalendarDate(Date())
    }
}

