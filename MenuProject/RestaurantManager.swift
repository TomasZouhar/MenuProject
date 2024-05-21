import SwiftUI
import Foundation
import Firebase

class RestaurantManager: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    private var groupId: String
    
    init(groupId: String) {
        self.groupId = groupId
        fetchRestaurants()
    }
    
    func fetchRestaurants() {
        let db = Firestore.firestore()
        let groupRef = db.collection("Groups")
        
        // Restaurants are stored in votingRestaurants attribute in Firebase group collection (groupRef.document(groupId).votingRestaurants)
        groupRef.document(groupId).addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            if let snapshot = snapshot {
                self.restaurants.removeAll()
                
                let data = snapshot.data()
                // Convert data to Restaurant objects
                if let restaurants = data?["votingRestaurants"] as? [[String: Any]] {
                    for restaurant in restaurants {
                        let id = restaurant["id"] as? String ?? ""
                        let name = restaurant["name"] as? String ?? ""
                        let distance = restaurant["distance"] as? Int ?? 0
                        let menu = restaurant["menu"] as? [String: Any] ?? [:]
                        let meals = menu["meals"] as? [String] ?? []
                        let usersVoted = restaurant["usersVoted"] as? [String] ?? []
                        
                        var dayMenu = DayMenu()
                        for meal in meals {
                            dayMenu.addMeal(Meal(name: meal))
                        }
                        
                        let newRestaurant = Restaurant(id: id, name: name, menu: dayMenu, distance: distance, usersVoted: usersVoted)
                        self.restaurants.append(newRestaurant)
                    }
                }
                
                print(self.restaurants)
            }
        }
    }
    
    func updateRestaurantsInGroup(){
        let db = Firestore.firestore()
        let groupRef = db.collection("Groups").document(groupId)
        
        // Update the votingRestaurants attribute in the group with the new list of restaurants
        groupRef.updateData([
            "votingRestaurants": restaurants.map { restaurant in
                [
                    "id": restaurant.id,
                    "name": restaurant.name,
                    "distance": restaurant.distance,
                    "menu": [
                        "meals": restaurant.menu.meals.map { meal in
                            meal.name
                        }
                    ],
                    "usersVoted": restaurant.usersVoted
                ]
            }
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Restaurants updated in group")
        }
    }

    func voteForRestaurant(groupId: String, restaurantId: String, userId: String){
        let db = Firestore.firestore()
        let groupRef = db.collection("Groups").document(groupId)

        var restaurantToVote = restaurants.first { $0.id == restaurantId }
        if let index = restaurants.firstIndex(where: { $0.id == restaurantId }) {
            restaurantToVote?.usersVoted.append(userId)
            restaurants[index] = restaurantToVote!
        }

        updateRestaurantsInGroup()
    }
}
