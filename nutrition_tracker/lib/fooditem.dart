class FoodItem {
	String name;
	int calories;
	int carbs;
	int fat;
	int protein;
	String category;

	FoodItem(this.name, this.calories, this.carbs, this.fat, this.protein);

	FoodItem.fromJSON(Map<dynamic, dynamic> json) :
			name = json["Name"],
			calories = json["Calories"],
			carbs = json["Carbs"],
			fat = json["Fat"],
			protein = json["Protein"],
			category = json["Category"];
	
	String getName() {
		return this.name;
	}
	int getCalories() {
		return this.calories;
	}

	void setCategory(String category){
	  this.category = category.toUpperCase();
  }

  String getCategory(){
	  return category;
  }

	List getMacros() {
		List<int> macros = [this.carbs, this.fat, this.protein];
		return macros;
	}

	int getCarbs() {
		return this.carbs;
	}

	int getFat() {
		return this.fat;
	}

	int getProtein() {
		return this.protein;
	}

	Map<String, dynamic> toJSON() {
		return {
			"Name": name,
			"Calories": calories,
			"Carbs": carbs,
			"Fat": fat,
			"Protein": protein,
			"Category": category
		};
	}
}