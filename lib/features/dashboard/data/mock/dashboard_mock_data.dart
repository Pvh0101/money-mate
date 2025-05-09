import 'package:flutter/material.dart';

// TODO: Replace with actual data models and sources when integrating with Bloc/Repository

class DashboardMockData {
  static final List<Map<String, dynamic>> statCardData = [
    {
      "title": "Total Salary",
      "value": "\$1,289",
      "isPrimary": false,
      "icon": "assets/icons/wallet.svg"
    }, // Placeholder icon path
    {
      "title": "Total Expense",
      "value": "\$298",
      "isPrimary": true,
      "icon": "assets/icons/wallet.svg"
    }, // Placeholder icon path
    {
      "title": "Monthly Expense",
      "value": "\$3,389",
      "isPrimary": false,
      "icon": "assets/icons/wallet.svg"
    }, // Placeholder icon path
    // Add other cards here if needed
  ];

  static final List<Map<String, dynamic>> actionCardData = [
    {
      "title": "Savings",
      "icon": "assets/icons/add.svg",
      "isHighlighted": true
    }, // Placeholder icon path
    {
      "title": "Remind",
      "icon": "assets/icons/notification.svg",
      "isHighlighted": false
    }, // Placeholder icon path
    {
      "title": "Budget",
      "icon": "assets/icons/wallet.svg",
      "isHighlighted": false
    }, // Placeholder icon path for action, different from bottom nav
  ];

  static final List<Map<String, dynamic>> latestEntriesData = [
    {
      "icon": "assets/icons/icon_food_cashback.svg",
      "category": "Food",
      "date": "20 Feb 2024",
      "amount": "+ \$20 + Vat 0.5%",
      "paymentMethod": "Google Pay",
    },
    {
      "icon": "assets/icons/icon_uber_bike.svg",
      "category": "Uber",
      "date": "13 Mar 2024",
      "amount": "- \$18 + Vat 0.8%",
      "paymentMethod": "Cash",
    },
    {
      "icon": "assets/icons/icon_shopping_bags.svg",
      "category": "Shopping",
      "date": "11 Mar 2024",
      "amount": "- \$400 + Vat 0.12%",
      "paymentMethod": "Paytm",
    },
    {
      "icon": "assets/icons/icon_salary_money_bag.svg",
      "category": "Salary",
      "date": "01 Apr 2024",
      "amount": "+ \$2500",
      "paymentMethod": "Bank Transfer",
    },
    {
      "icon": "assets/icons/icon_price_money_custom.svg",
      "category": "Groceries",
      "date": "02 Apr 2024",
      "amount": "- \$75",
      "paymentMethod": "Credit Card",
    },
    {
      "icon": "assets/icons/icon_cashback_custom.svg",
      "category": "Cashback Reward",
      "date": "03 Apr 2024",
      "amount": "+ \$15",
      "paymentMethod": "Wallet",
    },
    {
      "icon": "assets/icons/icon_food_cashback.svg",
      "category": "Restaurant",
      "date": "04 Apr 2024",
      "amount": "- \$55",
      "paymentMethod": "Google Pay",
    },
    {
      "icon": "assets/icons/icon_uber_bike.svg",
      "category": "Transportation",
      "date": "05 Apr 2024",
      "amount": "- \$22",
      "paymentMethod": "Cash",
    },
    {
      "icon": "assets/icons/icon_shopping_bags.svg",
      "category": "Electronics",
      "date": "06 Apr 2024",
      "amount": "- \$120",
      "paymentMethod": "Credit Card",
    },
    {
      "icon": "assets/icons/wallet.svg",
      "category": "Utility Bill",
      "date": "07 Apr 2024",
      "amount": "- \$90",
      "paymentMethod": "Bank Transfer",
    },
  ];
}
