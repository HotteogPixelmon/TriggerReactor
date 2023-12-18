IF {"player."+player.getName() + ".money"} == null
    {"player."+player.getName() + ".money"} = 0
ENDIF

action = event.getAction().name()
IF action == "RIGHT_CLICK_AIR"
    
    mainHandItem = player.getInventory().getItemInMainHand()

    IF mainHandItem.getType().name() == "PAPER"
        itemLore = mainHandItem.getItemMeta().getLore()

        IF itemLore != null
            checkCount = parseInt(itemLore.get(0))
            mulCheckCount = checkCount * mainHandItem.getAmount()

            {"player."+player.getName() + ".money"} = {"player."+player.getName() + ".money"} + mulCheckCount

            #MESSAGE mulCheckCount + "원이 통장에 입급되었습니다"

            player.getInventory().removeItem(mainHandItem)
        ENDIF
    ENDIF
ENDIF