Config = {}
Config.Debug = true

QBCore = exports['qb-core']:GetCoreObject() -- DELETE IF YOU USE ESX
-- ESX = exports["es_extended"]:getSharedObject() -- UNCOMMENT IF YOU USE ESX

Config.Settings = {
    Framework = 'QB', -- QB/ESX
    Target = "OX", -- OX/QB/BT
    Inventory = 'QB'
}
