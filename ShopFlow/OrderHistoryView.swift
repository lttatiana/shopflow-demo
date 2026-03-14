import SwiftUI

// MARK: - Models

struct Order: Identifiable {
    let id: String
    let date: String
    let status: OrderStatus
    let items: [OrderItem]
    let total: Double
    let trackingAction: String?
}

struct OrderItem {
    let emoji: String
    let name: String
}

enum OrderStatus: String {
    case delivered = "Delivered"
    case processing = "Processing"
    case inTransit = "In Transit"
    case cancelled = "Cancelled"

    var color: Color {
        switch self {
        case .delivered:  return Color(red: 0.1, green: 0.48, blue: 0.1)
        case .processing: return Color(red: 0.0, green: 0.31, blue: 0.83)
        case .inTransit:  return Color(red: 0.6, green: 0.4, blue: 0.0)
        case .cancelled:  return Color(red: 0.8, green: 0.0, blue: 0.0)
        }
    }

    var bgColor: Color {
        switch self {
        case .delivered:  return Color(red: 0.83, green: 0.96, blue: 0.83)
        case .processing: return Color(red: 0.83, green: 0.89, blue: 1.0)
        case .inTransit:  return Color(red: 1.0, green: 0.94, blue: 0.83)
        case .cancelled:  return Color(red: 1.0, green: 0.83, blue: 0.83)
        }
    }
}

// MARK: - Mock Data

let mockOrders: [Order] = [
    Order(
        id: "ORD-1003",
        date: "February 1, 2026",
        status: .inTransit,
        items: [
            OrderItem(emoji: "👟", name: "Nike Air Max 90"),
            OrderItem(emoji: "🧦", name: "Athletic Crew Socks"),
        ],
        total: 149.00,
        trackingAction: nil
    ),
    Order(
        id: "ORD-1002",
        date: "January 20, 2026",
        status: .cancelled,
        items: [
            OrderItem(emoji: "🎧", name: "Sony WH-1000XM5"),
        ],
        total: 29.99,
        trackingAction: nil
    ),
    Order(
        id: "ORD-1001",
        date: "January 15, 2026",
        status: .delivered,
        items: [
            OrderItem(emoji: "👕", name: "Cotton T-Shirt"),
            OrderItem(emoji: "👖", name: "Slim Fit Chinos"),
            OrderItem(emoji: "🧢", name: "Baseball Cap"),
        ],
        total: 49.99,
        trackingAction: "View Delivery Photos"
    ),
]

// MARK: - Views

struct OrderHistoryView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    SectionHeader(title: "RECENT")

                    ForEach(mockOrders.prefix(2)) { order in
                        OrderCard(order: order)
                    }

                    SectionHeader(title: "JANUARY 2026")

                    ForEach(mockOrders.suffix(1)) { order in
                        OrderCard(order: order)
                    }
                }
                .padding(.horizontal, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .medium))
                            Text("Account")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Filter") {}
                }
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.footnote)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            Spacer()
        }
        .padding(.top, 24)
        .padding(.bottom, 7)
    }
}

struct OrderCard: View {
    let order: Order

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                // Top row: order number + badge
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Order #\(order.id.replacingOccurrences(of: "ORD-", with: ""))")
                            .font(.system(size: 17, weight: .semibold))
                        Text(order.date)
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    StatusBadge(status: order.status)
                }

                // Item thumbnails
                HStack(spacing: 8) {
                    ForEach(order.items.indices, id: \.self) { i in
                        Text(order.items[i].emoji)
                            .font(.system(size: 22))
                            .frame(width: 52, height: 52)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                    Spacer()
                }

                // Bottom row: total + chevron
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(String(format: "$%.2f", order.total))
                            .font(.system(size: 17, weight: .semibold))
                        Text("\(order.items.count) item\(order.items.count == 1 ? "" : "s")")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(UIColor.systemGray3))
                }
            }
            .padding(16)

            // Tracking action row
            if let action = order.trackingAction {
                Divider()
                HStack(spacing: 6) {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.blue)
                    Text(action)
                        .font(.system(size: 15))
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(UIColor.systemGray6).opacity(0.5))
            }
        }
        .background(Color.white)
        .cornerRadius(13)
        .padding(.bottom, 10)
    }
}

struct StatusBadge: View {
    let status: OrderStatus

    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 13, weight: .semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(status.bgColor)
            .foregroundColor(status.color)
            .cornerRadius(7)
    }
}

#Preview {
    OrderHistoryView()
}
