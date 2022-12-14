//
//  CalendarManager.swift
//  Cleaner
//
//  Created by fst on 2021/3/17.
//

import UIKit
import EventKit
class CalendarEventModel: NSObject {
    var title:String = ""
    var timeString:String = ""
    var event:EKEvent!
    
    var reminder:EKReminder!
    
    var isSelected = true
}

class CalendarAnalyseTool: NSObject {
    static let shared: CalendarAnalyseTool = {
        let instance = CalendarAnalyseTool()
        return instance
    }()
    
    private lazy var eventStore: EKEventStore = {
        let eventStore = EKEventStore()
        return eventStore
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    //获取过期日历
    func getAllOutOfDateCalendarEvents(complete:@escaping ([CalendarEventModel])->Void) {
        //授权状态
        let status = EKEventStore.authorizationStatus(for: .event)
        if status == .notDetermined {
            self.eventStore.requestAccess(to: .event) { (granted, error) in
                DispatchQueue.main.async {
                    if granted{
                        self.loadAllCalendarEvents(complete: complete)
                    }else{
                        DispatchQueue.main.async {
                            self.noticeAlert()
                        }
                    }
                }
            }
        }else if status == .authorized {//已授权
            self.loadAllCalendarEvents(complete: complete)
        }else{//拒绝授权，弹框提示
            self.noticeAlert()
        }
    }
    
    private func loadAllCalendarEvents(complete:@escaping ([CalendarEventModel])->Void) {
        let tempCalendars = self.eventStore.calendars(for: .event)
        var calendars:[EKCalendar] = []
        for tempCalendar in tempCalendars {
            if tempCalendar.type == .subscription {
                calendars.append(tempCalendar)
            }
        }
        
        let predicate = self.eventStore.predicateForEvents(withStart: Date().addingTimeInterval(-365 * 24 * 60 * 60), end: Date(), calendars: calendars)
        let events = self.eventStore.events(matching: predicate)
        var eventModels:[CalendarEventModel] = []
        for event in events {
            let eventModel = CalendarEventModel()
            eventModel.title = event.title
            eventModel.timeString = self.dateFormatter.string(from: event.endDate)
            eventModel.event = event
            eventModels.append(eventModel)
        }
        complete(eventModels)
    }
    
    //删除日历事件
    func deleteSelectEvents(eventMoels:[CalendarEventModel],compelte:(Bool)->Void) {
        for eventMoel in eventMoels {
           try? self.eventStore.remove(eventMoel.event, span: .thisEvent, commit: false)
        }
        
        if let _ = try? self.eventStore.commit() {
            print("====删除成功")
            compelte(true)
        }else{
            print("====删除失败")
            compelte(false)
        }
       
    }
    
    //弹框提示开启权限
    func noticeAlert() {
        let alert = UIAlertController(title: "此功能需要日历授权", message: "请您在设置系统中打开授权开关", preferredStyle: .alert);
        let left = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let right = UIAlertAction(title: "前往设置", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(left)
        alert.addAction(right)
        let vc = cKeyWindow!.rootViewController
        vc?.present(alert, animated: true, completion: nil)
    }
    
}

extension CalendarAnalyseTool {
    //获取过期提醒
    func getAllOutOfDateReminders(complete:@escaping ([CalendarEventModel])->Void) {
        //授权状态
        let status = EKEventStore.authorizationStatus(for: .reminder)
        if status == .notDetermined {
            self.eventStore.requestAccess(to: .reminder) { (granted, error) in
                DispatchQueue.main.async {
                    if granted{
                        self.loadAllReminders(complete: complete)
                    }else{
                        
                            self.noticeAlert()
                        }
                }
            }
        }else if status == .authorized {//已授权
            self.loadAllReminders(complete: complete)
        }else{//拒绝授权，弹框提示
            self.noticeAlert()
        }
    }
    
    private func loadAllReminders(complete:@escaping([CalendarEventModel])->Void)  {
        let eventReminders = self.eventStore.calendars(for: .reminder)
        var array:[EKCalendar] = []
        for reminder in eventReminders {
            if reminder.type == .local || reminder.type == .calDAV || reminder.type == .birthday {
                array.append(reminder)
            }
        }
        
        let cal = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        
        let predicate = self.eventStore.predicateForReminders(in: array)
        
        self.eventStore.fetchReminders(matching: predicate) { reminders in
            if let tmpReminders = reminders{
                var reminderModels:[CalendarEventModel] = []
                for reminder in tmpReminders {
                    if let cmp = reminder.dueDateComponents  {
                        //截止日期
                        let dueDate = cal.date(from: cmp) ?? Date()
                        //过期的提醒事项
                        if dueDate.compare(Date()) == .orderedAscending {
                            let reminderModel = CalendarEventModel()
                            reminderModel.title = reminder.title
                            reminderModel.timeString =  dateFormatter.string(from: dueDate)
                            reminderModel.reminder = reminder
                            reminderModels.append(reminderModel)
                            
                            print("日期===\(String(describing: reminder.title)) == \(reminderModel.timeString)")
                        }
                    }
                }
                DispatchQueue.main.async {
                    complete(reminderModels)
                }
                
            }else{
                DispatchQueue.main.async {
                    complete([])
                }
                
            }
        }
    }
    
    
    //删除提醒事项
    func deleteSelectReminders(reminderModels:[CalendarEventModel],compelte:(Bool)->Void) {
        for reminderModel in reminderModels {
            try? self.eventStore.remove(reminderModel.reminder, commit: false)
        }
        
        if let _ = try? self.eventStore.commit() {
            print("====删除成功")
            compelte(true)
        }else{
            print("====删除失败")
            compelte(false)
        }
       
    }
    
}
