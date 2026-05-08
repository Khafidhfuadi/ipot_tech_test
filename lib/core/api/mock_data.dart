/// Static mock JSON data for offline/fallback usage.
class MockData {
  MockData._();

  static const String kMockMenuJson = '''
{
  "restaurant": {
    "id": "rest_001",
    "name": "Sushi Zen",
    "tableId": "T1"
  },
  "categories": [
    {"id": "cat_appetizer", "name": "Appetizer", "sortOrder": 1},
    {"id": "cat_sashimi", "name": "Sashimi", "sortOrder": 2},
    {"id": "cat_main", "name": "Main Course", "sortOrder": 3},
    {"id": "cat_drinks", "name": "Drinks", "sortOrder": 4}
  ],
  "items": [
    {
      "id": "item_001",
      "name": "Edamame",
      "description": "Steamed young soybeans with sea salt",
      "price": 25000,
      "categoryId": "cat_appetizer",
      "imageUrl": null,
      "customizationGroups": [
        {
          "id": "cg_edamame_spice",
          "name": "Spice Level",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_mild", "name": "Mild", "priceModifier": 0},
            {"id": "opt_medium", "name": "Medium", "priceModifier": 0},
            {"id": "opt_hot", "name": "Hot", "priceModifier": 0}
          ]
        }
      ]
    },
    {
      "id": "item_002",
      "name": "Salmon Sashimi",
      "description": "Fresh Norwegian salmon, 5 slices",
      "price": 65000,
      "categoryId": "cat_sashimi",
      "imageUrl": null,
      "customizationGroups": [
        {
          "id": "cg_sashimi_portion",
          "name": "Portion Size",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_5pcs", "name": "5 Pcs (Regular)", "priceModifier": 0},
            {"id": "opt_10pcs", "name": "10 Pcs", "priceModifier": 35000}
          ]
        },
        {
          "id": "cg_sashimi_extras",
          "name": "Extra Toppings",
          "required": false,
          "maxSelections": 3,
          "options": [
            {"id": "opt_wasabi", "name": "Extra Wasabi", "priceModifier": 3000},
            {"id": "opt_ginger", "name": "Extra Ginger", "priceModifier": 3000},
            {"id": "opt_soy", "name": "Premium Soy Sauce", "priceModifier": 5000}
          ]
        }
      ]
    },
    {
      "id": "item_003",
      "name": "Chicken Ramen",
      "description": "Rich tonkotsu broth with tender chicken chashu, soft-boiled egg, and nori",
      "price": 55000,
      "categoryId": "cat_main",
      "imageUrl": null,
      "customizationGroups": [
        {
          "id": "cg_ramen_broth",
          "name": "Broth Type",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_tonkotsu", "name": "Tonkotsu (Original)", "priceModifier": 0},
            {"id": "opt_miso", "name": "Miso", "priceModifier": 0},
            {"id": "opt_shoyu", "name": "Shoyu", "priceModifier": 0}
          ]
        },
        {
          "id": "cg_ramen_toppings",
          "name": "Extra Toppings",
          "required": false,
          "maxSelections": 5,
          "options": [
            {"id": "opt_extra_egg", "name": "Extra Egg", "priceModifier": 8000},
            {"id": "opt_extra_chashu", "name": "Extra Chashu", "priceModifier": 15000},
            {"id": "opt_extra_nori", "name": "Extra Nori", "priceModifier": 5000},
            {"id": "opt_corn", "name": "Sweet Corn", "priceModifier": 5000},
            {"id": "opt_bamboo", "name": "Bamboo Shoots", "priceModifier": 5000}
          ]
        },
        {
          "id": "cg_ramen_noodle",
          "name": "Noodle Texture",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_firm", "name": "Firm (Kata)", "priceModifier": 0},
            {"id": "opt_regular_noodle", "name": "Regular", "priceModifier": 0},
            {"id": "opt_soft", "name": "Soft (Yawaraka)", "priceModifier": 0}
          ]
        }
      ]
    },
    {
      "id": "item_004",
      "name": "Green Tea",
      "description": "Traditional Japanese green tea, hot or iced",
      "price": 15000,
      "categoryId": "cat_drinks",
      "imageUrl": null,
      "customizationGroups": [
        {
          "id": "cg_tea_temp",
          "name": "Temperature",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_hot_tea", "name": "Hot", "priceModifier": 0},
            {"id": "opt_iced_tea", "name": "Iced", "priceModifier": 3000}
          ]
        },
        {
          "id": "cg_tea_sugar",
          "name": "Sugar Level",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_no_sugar", "name": "No Sugar", "priceModifier": 0},
            {"id": "opt_less_sugar", "name": "Less Sugar", "priceModifier": 0},
            {"id": "opt_normal_sugar", "name": "Normal Sugar", "priceModifier": 0}
          ]
        }
      ]
    }
  ]
}
''';
}
