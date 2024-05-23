import SwiftUI
import FirebaseAuth

struct VotingView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject var restaurantManager: RestaurantManager
    var group: Group
    
    init(group: Group) {
        _restaurantManager = StateObject(wrappedValue: RestaurantManager(groupId: group.id))
        self.group = group
    }

    var body: some View {
        VStack {
            Text("Today's menu")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            ForEach(restaurantManager.restaurants, id: \.id) { restaurant in
                RestaurantCard(restaurant: restaurant, groupId: group.id, userId: Auth.auth().currentUser!.uid)
                    .environmentObject(restaurantManager)
            }
        }
        .padding()
        .onAppear {
            restaurantManager.fetchRestaurants()
            print("Fetching restaurants")
            for restaurant in restaurantManager.restaurants {
                print(restaurant.name)
            }
        }
    }
}

struct RestaurantCard: View {
    var restaurant: Restaurant
    var groupId: String
    var userId: String
    var alreadyVoted: Bool = false
    @EnvironmentObject var restaurantManager: RestaurantManager

    init(restaurant: Restaurant, groupId: String, userId: String) {
        self.restaurant = restaurant
        self.groupId = groupId
        self.userId = userId
        self.alreadyVoted = restaurant.usersVoted.contains(userId)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(.black)
                ForEach(restaurant.menu.meals, id: \.name) { meal in
                    HStack(content: {
                        Text(meal.name)
                            .font(.subheadline)
                            .foregroundColor(.black)
                    })
                }
            }
            Spacer()
            Text(restaurant.usersVoted.count.description)
            Button(action: {
                restaurantManager.voteForRestaurant(groupId: groupId, restaurantId: restaurant.id, userId: userId)
            }, label: {
                Text("Vote")
            })
            .disabled(alreadyVoted)
        }
        .padding()
        .background(Color.yellow.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    let sampleMeals = [Meal(name: "Meal 1"), Meal(name: "Meal 2"), Meal(name: "Meal 3")]
    let sampleMenu = DayMenu(meals: sampleMeals)
    let sampleRestaurant = Restaurant(id: UUID().uuidString, name: "Sample Restaurant", menu: sampleMenu, distance: 5)
    let sampleGroup = Group(id: "123", name: "123", owner: "123", code: "123")

    return VotingView(group: sampleGroup)
        .environmentObject(DataManager())
}
