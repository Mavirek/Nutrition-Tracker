class FoodItem {
	String name;
	int calories;
	int carbs;
	int fat;
	int protein;
	String category;

	FoodItem(this.name, this.calories, this.carbs, this.fat, this.protein);
	
	String getName() {
		return this.name;
	}
	int getCalories() {
		return this.calories;
	}

	void setCategory(String category){
	  this.category = category;
  }

  String getCategory(){
	  return category;
  }

	List getMacros() {
		List<int> macros = [this.carbs, this.fat, this.protein];
		return macros;
	}
}