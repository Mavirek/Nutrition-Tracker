class FoodItem {
	String name;
	int calories;
	int carbs;
	int fat;
	int protein;
	
	FoodItem(String this.name; int this.calories, int this.carbs, int this.fat, int this.protein) {
	}
	
	String getName() {
		return this.name;
	}
	int getCalories() {
		return this.calories;
	}
	list getMacros() {
		list macros = [this.carbs, this.fat, this.protein];
		return macros;
	}
}