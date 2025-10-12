extends Node

var typeToTile = {
	"Stone":Stone,
	"Air":Air,
	"Coal":Coal,
	"Copper":Copper,
	"Furnace":Furnace,
	"Copper Anvil":CopperAnvil
}

var typeToItem = {
	"Basic Shovel":BasicShovel,
	"Copper Ingot":CopperIngot,
	"Copper Shovel":CopperShovel
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
	"Copper Anvil":{
		"tileItem":true,
		"requires":[
			{"type":"Copper Ingot",
			"count":5,
			"tileItem":false},
			{"type":"Stone",
			"count":10,
			"tileItem":true},
		],
		"station":"",
		"count":1
	},
	"Copper Shovel":{
		"tileItem":false,
		"requires":[
			{
				"type":"Copper Ingot",
				"count":7,
				"tileItem":false
			}
		],
		"station":"Copper Anvil",
		"count":1
	}
}
