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
    {"id": "cat_appetizer", "name": "Appetizer",   "sortOrder": 1},
    {"id": "cat_sashimi",   "name": "Sashimi",     "sortOrder": 2},
    {"id": "cat_sushi",     "name": "Sushi Roll",  "sortOrder": 3},
    {"id": "cat_main",      "name": "Main Course", "sortOrder": 4},
    {"id": "cat_sides",     "name": "Side Dish",   "sortOrder": 5},
    {"id": "cat_dessert",   "name": "Dessert",     "sortOrder": 6},
    {"id": "cat_drinks",    "name": "Drinks",      "sortOrder": 7}
  ],
  "items": [

    {
      "id": "item_001",
      "name": "Edamame",
      "description": "Steamed young soybeans with sea salt",
      "price": 25000,
      "categoryId": "cat_appetizer",
      "imageUrl": "https://images.alodokter.com/dk0z4ums3/image/upload/v1616471234/attached_image/fakta-fakta-mencengangkan-tentang-kedelai-edamame.jpg",
      "customizationGroups": [
        {
          "id": "cg_edamame_spice",
          "name": "Spice Level",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_mild",   "name": "Mild",   "priceModifier": 0},
            {"id": "opt_medium", "name": "Medium", "priceModifier": 0},
            {"id": "opt_hot",    "name": "Hot",    "priceModifier": 0}
          ]
        }
      ]
    },
    {
      "id": "item_002",
      "name": "Gyoza",
      "description": "Pan-fried Japanese dumplings filled with pork and cabbage, served with ponzu dipping sauce",
      "price": 35000,
      "categoryId": "cat_appetizer",
      "imageUrl": "https://cardamommagazine.com/wp-content/uploads/2021/04/chicken-gyoza.jpg",
      "customizationGroups": [
        {
          "id": "cg_gyoza_cook",
          "name": "Cooking Style",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_pan_fried",  "name": "Pan Fried (Yaki)", "priceModifier": 0},
            {"id": "opt_steamed",    "name": "Steamed (Mushi)",  "priceModifier": 0},
            {"id": "opt_deep_fried", "name": "Deep Fried (Age)", "priceModifier": 3000}
          ]
        },
        {
          "id": "cg_gyoza_portion",
          "name": "Portion",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_gyoza_5",  "name": "5 pcs (Regular)", "priceModifier": 0},
            {"id": "opt_gyoza_10", "name": "10 pcs",          "priceModifier": 30000}
          ]
        }
      ]
    },
    {
      "id": "item_003",
      "name": "Takoyaki",
      "description": "Crispy octopus balls topped with bonito flakes, mayo, and takoyaki sauce",
      "price": 32000,
      "categoryId": "cat_appetizer",
      "imageUrl": "https://assets.pikiran-rakyat.com/crop/0x0:0x0/720x0/webp/photo/2025/01/05/3503370461.png",
      "customizationGroups": [
        {
          "id": "cg_tako_sauce",
          "name": "Sauce",
          "required": false,
          "maxSelections": 2,
          "options": [
            {"id": "opt_tako_original", "name": "Original Sauce", "priceModifier": 0},
            {"id": "opt_tako_spicy",    "name": "Spicy Mayo",     "priceModifier": 2000},
            {"id": "opt_tako_cheese",   "name": "Cheese Sauce",   "priceModifier": 5000}
          ]
        }
      ]
    },

    {
      "id": "item_004",
      "name": "Salmon Sashimi",
      "description": "Fresh Norwegian salmon, 5 slices",
      "price": 65000,
      "categoryId": "cat_sashimi",
      "imageUrl": "https://sudachirecipes.com/wp-content/uploads/2023/04/salmonsashimi2-sq.jpg",
      "customizationGroups": [
        {
          "id": "cg_sashimi_portion",
          "name": "Portion Size",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_5pcs",  "name": "5 Pcs (Regular)", "priceModifier": 0},
            {"id": "opt_10pcs", "name": "10 Pcs",          "priceModifier": 35000}
          ]
        },
        {
          "id": "cg_sashimi_extras",
          "name": "Extra Toppings",
          "required": false,
          "maxSelections": 3,
          "options": [
            {"id": "opt_wasabi", "name": "Extra Wasabi",      "priceModifier": 3000},
            {"id": "opt_ginger", "name": "Extra Ginger",      "priceModifier": 3000},
            {"id": "opt_soy",    "name": "Premium Soy Sauce", "priceModifier": 5000}
          ]
        }
      ]
    },
    {
      "id": "item_005",
      "name": "Tuna Sashimi",
      "description": "Premium bluefin tuna, lean and buttery, 5 slices",
      "price": 75000,
      "categoryId": "cat_sashimi",
      "imageUrl": "https://getfish.com.au/cdn/shop/articles/Step_3_-_Tuna_Sashimi.png?v=1768270704&width=1200",
      "customizationGroups": [
        {
          "id": "cg_tuna_portion",
          "name": "Portion Size",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_tuna_5",  "name": "5 Pcs (Regular)", "priceModifier": 0},
            {"id": "opt_tuna_10", "name": "10 Pcs",          "priceModifier": 40000}
          ]
        }
      ]
    },

    {
      "id": "item_006",
      "name": "Dragon Roll",
      "description": "Shrimp tempura inside, topped with avocado, eel, and spicy mayo",
      "price": 72000,
      "categoryId": "cat_sushi",
      "imageUrl": "https://thesushiman.com/wp-content/uploads/2025/01/Dragon-Roll-1-scaled.jpg",
      "customizationGroups": [
        {
          "id": "cg_dragon_spice",
          "name": "Spice Level",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_dragon_mild",  "name": "Mild",        "priceModifier": 0},
            {"id": "opt_dragon_spicy", "name": "Extra Spicy", "priceModifier": 0}
          ]
        },
        {
          "id": "cg_dragon_extras",
          "name": "Add-ons",
          "required": false,
          "maxSelections": 2,
          "options": [
            {"id": "opt_dragon_tobiko",  "name": "Tobiko (Fish Roe)", "priceModifier": 8000},
            {"id": "opt_dragon_truffle", "name": "Truffle Oil",       "priceModifier": 12000}
          ]
        }
      ]
    },
    {
      "id": "item_007",
      "name": "California Roll",
      "description": "Crab stick, avocado, and cucumber wrapped in seasoned rice and nori",
      "price": 45000,
      "categoryId": "cat_sushi",
      "imageUrl": "https://ichibansushi.co.id/wp-content/uploads/2023/07/CALIFORNIA-ROLL-1.jpg",
      "customizationGroups": [
        {
          "id": "cg_cali_wrap",
          "name": "Wrap Style",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_cali_nori",    "name": "Nori (Original)", "priceModifier": 0},
            {"id": "opt_cali_soybean", "name": "Soybean Paper",   "priceModifier": 3000}
          ]
        }
      ]
    },

    {
      "id": "item_008",
      "name": "Chicken Ramen",
      "description": "Rich tonkotsu broth with tender chicken chashu, soft-boiled egg, and nori",
      "price": 55000,
      "categoryId": "cat_main",
      "imageUrl": "https://www.forkknifeswoon.com/wp-content/uploads/2014/10/simple-homemade-chicken-ramen-fork-knife-swoon-01.jpg",
      "customizationGroups": [
        {
          "id": "cg_ramen_broth",
          "name": "Broth Type",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_tonkotsu", "name": "Tonkotsu (Original)", "priceModifier": 0},
            {"id": "opt_miso",     "name": "Miso",                "priceModifier": 0},
            {"id": "opt_shoyu",    "name": "Shoyu",               "priceModifier": 0}
          ]
        },
        {
          "id": "cg_ramen_toppings",
          "name": "Extra Toppings",
          "required": false,
          "maxSelections": 5,
          "options": [
            {"id": "opt_extra_egg",    "name": "Extra Egg",     "priceModifier": 8000},
            {"id": "opt_extra_chashu", "name": "Extra Chashu",  "priceModifier": 15000},
            {"id": "opt_extra_nori",   "name": "Extra Nori",    "priceModifier": 5000},
            {"id": "opt_corn",         "name": "Sweet Corn",    "priceModifier": 5000},
            {"id": "opt_bamboo",       "name": "Bamboo Shoots", "priceModifier": 5000}
          ]
        },
        {
          "id": "cg_ramen_noodle",
          "name": "Noodle Texture",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_firm",           "name": "Firm (Kata)",     "priceModifier": 0},
            {"id": "opt_regular_noodle", "name": "Regular",         "priceModifier": 0},
            {"id": "opt_soft",           "name": "Soft (Yawaraka)", "priceModifier": 0}
          ]
        }
      ]
    },
    {
      "id": "item_009",
      "name": "Beef Teriyaki Don",
      "description": "Grilled beef strips glazed with house teriyaki sauce over steamed Japanese rice",
      "price": 65000,
      "categoryId": "cat_main",
      "imageUrl": "https://sudachirecipes.com/wp-content/uploads/2024/01/wasabi-teriyaki-beef-bowl-thumb.jpg",
      "customizationGroups": [
        {
          "id": "cg_beef_doneness",
          "name": "Beef Doneness",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_medium_rare", "name": "Medium Rare", "priceModifier": 0},
            {"id": "opt_medium_done", "name": "Medium",      "priceModifier": 0},
            {"id": "opt_well_done",   "name": "Well Done",   "priceModifier": 0}
          ]
        },
        {
          "id": "cg_beef_extras",
          "name": "Add-ons",
          "required": false,
          "maxSelections": 3,
          "options": [
            {"id": "opt_beef_egg",    "name": "Onsen Egg",  "priceModifier": 8000},
            {"id": "opt_beef_salad",  "name": "Side Salad", "priceModifier": 10000},
            {"id": "opt_beef_kimchi", "name": "Kimchi",     "priceModifier": 8000}
          ]
        }
      ]
    },

    {
      "id": "item_010",
      "name": "Miso Soup",
      "description": "Traditional Japanese miso soup with tofu, wakame seaweed, and green onion",
      "price": 12000,
      "categoryId": "cat_sides",
      "imageUrl": "https://sudachirecipes.com/wp-content/uploads/2021/11/homemade-miso-soup-thumb.png",
      "customizationGroups": [
        {
          "id": "cg_miso_type",
          "name": "Miso Type",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_shiro", "name": "Shiro (White)", "priceModifier": 0},
            {"id": "opt_aka",   "name": "Aka (Red)",     "priceModifier": 0}
          ]
        }
      ]
    },
    {
      "id": "item_011",
      "name": "Steamed Rice",
      "description": "Premium Japanese short-grain steamed rice",
      "price": 10000,
      "categoryId": "cat_sides",
      "imageUrl": "https://www.allrecipes.com/thmb/RKpnSHLUDT2klppYgx8jAF47GyM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/52490-PuertoRicanSteamedRice-DDMFS-061-4x3-3c3da714aa614037ad1c135ec303526d.jpg",
      "customizationGroups": [
        {
          "id": "cg_rice_type",
          "name": "Rice Type",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_rice_white", "name": "White Rice", "priceModifier": 0},
            {"id": "opt_rice_brown", "name": "Brown Rice", "priceModifier": 3000}
          ]
        }
      ]
    },

    {
      "id": "item_012",
      "name": "Matcha Ice Cream",
      "description": "Premium ceremonial-grade matcha ice cream, two scoops",
      "price": 28000,
      "categoryId": "cat_dessert",
      "imageUrl": "https://sudachirecipes.com/wp-content/uploads/2022/08/matcha-ice-cream-thumbnail.jpg",
      "customizationGroups": [
        {
          "id": "cg_icecream_topping",
          "name": "Topping",
          "required": false,
          "maxSelections": 2,
          "options": [
            {"id": "opt_azuki", "name": "Azuki (Red Bean)", "priceModifier": 5000},
            {"id": "opt_mochi", "name": "Mochi Bits",       "priceModifier": 5000},
            {"id": "opt_wafer", "name": "Wafer Cone",       "priceModifier": 3000}
          ]
        }
      ]
    },
    {
      "id": "item_013",
      "name": "Dorayaki",
      "description": "Fluffy Japanese pancake sandwich filled with sweet azuki red bean paste",
      "price": 22000,
      "categoryId": "cat_dessert",
      "imageUrl": "https://sudachirecipes.com/wp-content/uploads/2025/10/dorayaki-new-thumb.jpg",
      "customizationGroups": [
        {
          "id": "cg_dora_filling",
          "name": "Filling",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_dora_azuki",   "name": "Azuki (Original)", "priceModifier": 0},
            {"id": "opt_dora_matcha",  "name": "Matcha Cream",     "priceModifier": 3000},
            {"id": "opt_dora_custard", "name": "Custard",          "priceModifier": 3000}
          ]
        }
      ]
    },

    {
      "id": "item_014",
      "name": "Green Tea",
      "description": "Traditional Japanese green tea, hot or iced",
      "price": 15000,
      "categoryId": "cat_drinks",
      "imageUrl": "https://gimmedelicious.com/wp-content/uploads/2018/03/Iced-Matcha-Latte2.jpg",
      "customizationGroups": [
        {
          "id": "cg_tea_temp",
          "name": "Temperature",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_hot_tea",  "name": "Hot",  "priceModifier": 0},
            {"id": "opt_iced_tea", "name": "Iced", "priceModifier": 3000}
          ]
        },
        {
          "id": "cg_tea_sugar",
          "name": "Sugar Level",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_no_sugar",     "name": "No Sugar",     "priceModifier": 0},
            {"id": "opt_less_sugar",   "name": "Less Sugar",   "priceModifier": 0},
            {"id": "opt_normal_sugar", "name": "Normal Sugar", "priceModifier": 0}
          ]
        }
      ]
    },
    {
      "id": "item_015",
      "name": "Matcha Latte",
      "description": "Ceremonial grade matcha blended with steamed milk, smooth and earthy",
      "price": 32000,
      "categoryId": "cat_drinks",
      "imageUrl": "https://www.modernfarmhouseeats.com/wp-content/uploads/2022/02/starbucks-iced-matcha-latte-8.jpg",
      "customizationGroups": [
        {
          "id": "cg_matcha_temp",
          "name": "Temperature",
          "required": true,
          "maxSelections": 1,
          "options": [
            {"id": "opt_matcha_hot",  "name": "Hot",  "priceModifier": 0},
            {"id": "opt_matcha_iced", "name": "Iced", "priceModifier": 3000}
          ]
        },
        {
          "id": "cg_matcha_milk",
          "name": "Milk Type",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_full_cream", "name": "Full Cream",   "priceModifier": 0},
            {"id": "opt_oat_milk",   "name": "Oat Milk",    "priceModifier": 8000},
            {"id": "opt_almond",     "name": "Almond Milk", "priceModifier": 8000}
          ]
        },
        {
          "id": "cg_matcha_sugar",
          "name": "Sugar Level",
          "required": false,
          "maxSelections": 1,
          "options": [
            {"id": "opt_ml_no",     "name": "No Sugar",     "priceModifier": 0},
            {"id": "opt_ml_less",   "name": "Less Sugar",   "priceModifier": 0},
            {"id": "opt_ml_normal", "name": "Normal Sugar", "priceModifier": 0}
          ]
        }
      ]
    }

  ]
}
''';
}
