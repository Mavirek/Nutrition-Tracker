class FoodItem {
	String name;
	int calories;
	int carbs;
	int fat;
	int protein;
	
	FoodItem( this.name, this.calories, this.carbs, this.fat, this.protein);
	
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