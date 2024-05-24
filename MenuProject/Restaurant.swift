import Foundation

struct Meal {
    var name: String
}

struct DayMenu {
    var meals: [Meal] = []
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
            restaurant.menu.meals.append(Meal(name: "Meal \(j)"))
        }
        restaurants.append(restaurant)
    }
    return restaurants
}

func getDataFromAPI(completion: @escaping ([Restaurant]?) -> Void) {
    guard let url = URL(string: "https://menuparser.azurewebsites.net/api/menu/parse?url=https://www.menicka.cz/brno.html") else {
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(error.localizedDescription)
            completion(nil)
            return
        }
        
        guard let data = data else {
            completion(nil)
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            let restaurants = json?.compactMap { restaurantData -> Restaurant? in
                guard let name = restaurantData["Name"] as? String,
                      let distance = restaurantData["Distance"] as? Int,
                      let menuData = restaurantData["Menu"] as? [String: Any],
                      let mealsData = menuData["Meals"] as? [[String: Any]] else {
                    return nil
                }
                
                var dayMenu = DayMenu()
                for mealData in mealsData {
                    guard let mealName = mealData["Name"] as? String else {
                        continue
                    }
                    dayMenu.meals.append(Meal(name: mealName))
                    print("DayMenu" + mealName)
                }
                
                let id = UUID().uuidString
                return Restaurant(id: id, name: name, menu: dayMenu, distance: distance, usersVoted: [])
            }
            completion(restaurants)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    task.resume()
}
