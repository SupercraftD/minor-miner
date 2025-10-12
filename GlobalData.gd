extends Node

var typeToTile = {
	"Stone":Stone,
	"Air":Air,
	"Coal":Coal,
	"Copper":Copper,
	"Furnace":Furnace
}

var typeToItem = {
	"BasicShovel":BasicShovel,
	"Copper Ingot":CopperIngot
}

var craftingRecipes = {
	"Furnace":{
		"tileItem":true,
		"requires":[{
			"type":"Stone",
			"count":10,
			"tileItem":true
		},
		{
			"type":"Coal",
			"count":5,
			"tileItem":true
		}],
		"station":"",
		"count":1
	},
	"Copper Ingot":{
		"tileItem":false,
		"requires":[{
			"type":"Copper",
			"count":3,
			"tileItem":true
		}],
		"station":"Furnace",
		"count":1
	},
}
