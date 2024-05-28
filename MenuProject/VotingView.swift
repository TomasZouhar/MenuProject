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
        ScrollView {
            VStack {
                Text("Today's menu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(goldOrange)
                    .frame(maxWidth: .infinity, alignment: .center)
                ForEach(restaurantManager.restaurants, id: \.id) { restaurant in
                    RestaurantCard(restaurant: restaurant, groupId: group.id, userId: Auth.auth().currentUser!.uid)
                        .environmentObject(restaurantManager)
                }
            }
            .padding()
        }
        .onAppear {
            restaurantManager.fetchRestaurants()
        }
    }
}

struct RestaurantCard: View {
    var restaurant: Restaurant
    var groupId: String
    var userId: String
    @EnvironmentObject var restaurantManager: RestaurantManager

    var alreadyVoted: Bool {
        restaurant.usersVoted.contains(userId)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(restaurant.name)
                    .font(.headline)
                    .foregroundColor(.black)
                ForEach(restaurant.menu.meals, id: \.name) { meal in
                    Text(meal.name)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }
            Spacer()
            VStack {
                Text("\(restaurant.usersVoted.count)")
                Button(action: {
                    restaurantManager.voteForRestaurant(groupId: groupId, restaurantId: restaurant.id, userId: userId)
                }, label: {
                    Image(systemName: alreadyVoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .foregroundColor(alreadyVoted ? .blue : .gray)
                })
                .disabled(alreadyVoted)
            }
        }
        .padding()
        .background(darkYellow)
        .cornerRadius(10)
    }
}

struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeals = [Meal(name: "Meal 1"), Meal(name: "Meal 2"), Meal(name: "Meal 3")]
        let sampleMenu = DayMenu(meals: sampleMeals)
        let sampleRestaurant = Restaurant(id: UUID().uuidString, name: "Sample Restaurant", menu: sampleMenu, distance: 5)
        let sampleGroup = Group(id: "123", name: "123", owner: "123", code: "123", joinedUsers: ["user1", "user2"], isVoting: true, votingRestaurants: [sampleRestaurant])

        return VotingView(group: sampleGroup)
            .environmentObject(DataManager())
            .environmentObject(RestaurantManager(groupId: sampleGroup.id))
    }
}
