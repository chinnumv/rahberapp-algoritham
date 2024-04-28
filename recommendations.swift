//
//  recommendations.swift
//  rahberapp-algoritham
//
//  Created by Chinnu M V on 28/04/2024.
//


struct Course {
    let id: Int
    let title: String
    let topic: String
    let instructor: String
    let popularity: Int  
}

struct User {
    let id: Int
    let interests: [String]
    let previousEnrollments: [Int]
}

// Sample courses data
let courses = [
    Course(id: 1, title: "Course A", topic: "Programming", instructor: "John Doe", popularity: 100),
    Course(id: 2, title: "Course B", topic: "Data Science", instructor: "Jane Smith", popularity: 150),
    Course(id: 3, title: "Course C", topic: "Artificial Intelligence", instructor: "Alice Johnson", popularity: 80),
     
]

// Sample users data
let users = [
    User(id: 1, interests: ["Programming", "Data Science"], previousEnrollments: [1, 2]),
    User(id: 2, interests: ["Artificial Intelligence"], previousEnrollments: [3]),
    
]

// Function to recommend courses to a user
func recommendCourses(for user: User) -> [Course] {
     
    var recommendedCourses: [Course] = []
    
    // Collaborative Filtering: Recommend popular courses based on similar users' enrollments
    let similarUsers = users.filter { $0.id != user.id && !$0.previousEnrollments.isEmpty && !$0.interests.isDisjoint(with: user.interests) }
    let similarEnrollments = similarUsers.flatMap { $0.previousEnrollments }
    let popularCourses = courses.filter { !user.previousEnrollments.contains($0.id) && similarEnrollments.contains($0.id) }
    recommendedCourses += popularCourses.sorted { $0.popularity > $1.popularity }
    
    // Content-Based Filtering: Recommend courses based on user interests
    let interestBasedCourses = courses.filter { !user.previousEnrollments.contains($0.id) && $0.topic == user.interests.first }
    recommendedCourses += interestBasedCourses
    
    // Popularity-Based Recommendations: Recommend popular courses
    let topPopularityCourses = courses.filter { !user.previousEnrollments.contains($0.id) }
                                      .sorted { $0.popularity > $1.popularity }
                                      .prefix(3)
    recommendedCourses += topPopularityCourses
    
    return recommendedCourses
}

// Example usage:
let currentUser = users[0]
let recommendedCourses = recommendCourses(for: currentUser)
print("Recommended  for User \(currentUser.id):")
for course in recommendedCourses {
    print("- \(course.title)")
}