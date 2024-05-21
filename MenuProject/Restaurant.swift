import Foundation

struct Meal {
    var name: String
}

struct DayMenu {
    var meals: [Meal] = []
    mutating func addMeal(_ meal: Meal) {
        meals.append(meal)
    }
}

struct Restaurant: Identifiable {
    var id: String
    var name: String
    var menu: DayMenu
    var distance: Int
    var usersVoted: [String] = []
}

func getMockData(maxRestaurants: Int) -> [Restaurant] {
    var restaurants: [Restaurant] = []
    for i in 0..<maxRestaurants {
        var id = UUID().uuidString
        var restaurant = Restaurant(id: id, name: "Restaurant \(i)", menu: DayMenu(), distance: Int.random(in: 1...10), usersVoted: [])
        for j in 0..<5 {
            restaurant.menu.addMeal(Meal(name: "Meal \(j)"))
        }
        restaurants.append(restaurant)
    }
    return restaurants
}
