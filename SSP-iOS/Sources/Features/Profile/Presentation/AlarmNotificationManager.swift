//
//  AlarmNotificationManager.swift
//  SSP-iOS
//
//  Created by 황상환 on 6/2/25.
//

import UserNotifications
import Foundation

final class AlarmNotificationManager {
    static let shared = AlarmNotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("알림 권한 요청 오류: \(error.localizedDescription)")
            } else {
                print("알림 권한 요청 결과: \(granted ? "허용됨" : "거부됨")")
            }
        }
    }

    // 루틴 알람 기본 시간: 08:30
    func scheduleRoutineAlarm() {
        scheduleRoutineAlarm(hour: 8, minute: 30)
    }

    // 퀴즈 알람 기본 시간: 20:00
    func scheduleQuizAlarm() {
        scheduleQuizAlarm(hour: 20, minute: 0)
    }

    func scheduleRoutineAlarm(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "오늘의 루틴을 시작해볼까요?"
        content.body = "오늘의 루틴을 잊지 말고 체크하세요!"
        content.sound = .default

        var date = DateComponents()
        date.hour = hour
        date.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "routineAlarm", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("루틴 알람 등록 실패: \(error.localizedDescription)")
            } else {
                print("루틴 알람 등록 완료: \(hour):\(minute)")
            }
        }
    }

    func scheduleQuizAlarm(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "퀴즈 복습 시간이에요!"
        content.body = "복습으로 더 오래 기억해보세요."
        content.sound = .default

        var date = DateComponents()
        date.hour = hour
        date.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "quizAlarm", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("퀴즈 알람 등록 실패: \(error.localizedDescription)")
            } else {
                print("퀴즈 알람 등록 완료: \(hour):\(minute)")
            }
        }
    }

    func cancelRoutineAlarm() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["routineAlarm"])
        print("루틴 알람 취소됨")
    }

    func cancelQuizAlarm() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["quizAlarm"])
        print("퀴즈 알람 취소됨")
    }

    func scheduleTestAlarm() {
        let content = UNMutableNotificationContent()
        content.title = "테스트 알람"
        content.body = "지금 알림이 울려야 합니다!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testAlarm", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("테스트 알람 등록 실패: \(error.localizedDescription)")
            } else {
                print("테스트 알람 등록됨")
            }
        }
    }
}
