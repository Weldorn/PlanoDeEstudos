import Foundation
import UserNotifications

class StudyManager {
    
    // MARK: - Properties
    static let shared = StudyManager()
    let ud = UserDefaults.standard
    var studyPlans: [StudyPlan] = []
    
    // MARK: - Methods
    private init() {
        if let data = ud.data(forKey: "studyPlans"),
            let plans = try? JSONDecoder().decode([StudyPlan].self, from: data) {
            self.studyPlans = plans
        }
    }

    func savePlans() {
        if let data = try? JSONEncoder().encode(studyPlans) {
            ud.set(data, forKey: "studyPlans")
        }
    }
    
    func addPlan(_ studyPlan: StudyPlan) {
        studyPlans.append(studyPlan)
        savePlans()
    }
    
    func removePlan(at index: Int) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [studyPlans[index].id])
        studyPlans.remove(at: index)
        savePlans()
    }
    
    func setPlanDone(id: String) {
        if let studyPlan = studyPlans.first(where: {$0.id == id}) {
            studyPlan.done = true
            savePlans()
        }
    }
    
}
