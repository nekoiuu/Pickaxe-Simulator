--stone
export type StoneData = {
    Name:string,
    Health:number,
    MaxHealth:number,
    ImageId:string,
    Drop:InventoryStone,
}

export type InventoryStone = {
    Name:string,
    Amount:number,
}

--pickaxe
export type InventoryPickaxe = {
    Id:string,
    Name:string,
}

export type PickaxeData = {
    Name:string,
    Damage:number,
    CoolDown:number,
    Tool:Tool,
    ImageId:string,
    AnimationIds:{
        Idle:string,
        Attack:string
    }
}

--inventory
export type Inventory = {
    Pickaxes:{InventoryPickaxe},
    Stones:{InventoryStone}
}
export type Profile_Template = {
    Money:number,
    Inventory:Inventory
}


return {}