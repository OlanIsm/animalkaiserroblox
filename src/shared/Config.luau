return {
	Gloves = {
		{ name = "Bare Hands", cost = 0, gain = 1 },
		{ name = "Basic Gloves", cost = 250, gain = 2 },
		{ name = "Iron Gloves", cost = 1500, gain = 5 },
		{ name = "Golden Gloves", cost = 10000, gain = 10 },
	},
	Areas = {
		{ cost = 0, radius = 0 },
		{ cost = 1000, radius = 6.5 },
		{ cost = 5000, radius = 10 },
		{ cost = 20000, radius = 14 },
	},
	Zones = {
		{ hp = 10, color = Color3.fromRGB(171, 116, 75), material = Enum.Material.Brick },
		{ hp = 100, color = Color3.fromRGB(112, 116, 125), material = Enum.Material.Slate },
		{ hp = 1000, color = Color3.fromRGB(55, 61, 70), material = Enum.Material.Metal },
	},
	Brainrots = {
		{ name = "Tralalero", rarity = "Common", value = 100 },
		{ name = "Bombardiro", rarity = "Common", value = 150 },
		{ name = "Brr Brr Patapim", rarity = "Uncommon", value = 400 },
		{ name = "Tung Tung Sahur", rarity = "Uncommon", value = 600 },
		{ name = "La Vaca Saturno", rarity = "Rare", value = 2500 },
	},
	LootChances = { none = 55, common = 30, uncommon = 12, rare = 3 },
	RebirthCash = 100000,
	CashBonusPerRebirth = 0.25,
	TrainingInterval = 0.8,
	TrainingSpeedPerRebirth = 0.08,
	MinimumTrainingInterval = 0.3,
}
