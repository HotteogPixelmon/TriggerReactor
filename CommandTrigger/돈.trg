import java.text.DecimalFormat
IMPORT java.lang.Integer

IF {"player."+player.getName() + ".money"} == null
    {"player."+player.getName() + ".money"} = 0
ENDIF

formatter = new DecimalFormat("###,###");
prefix = "&6[돈] &f" // for maintenance

IF args.length == 1

    IF args[0] == "보기"
        #MESSAGE prefix + "&b"+player.getName()+"&f님은 현재 &e"+ formatter.format({"player." + player.getName() + ".money"})  + "원&f을 보유 중입니다."
        #STOP
    ENDIF

    IF args[0] == "랭킹"

        // init player list
        players = {"player"}
        players = players.keySet()

        // remove unregistered players
        FOR p = players.iterator();
            IF {"player."+ p + ".money"} == null
                players.remove(p)
            ENDIF
        ENDFOR
        
        // sort
        topArr = array(5)
        FOR i = 0:5
            maxPlayer = ""
            FOR p = players.iterator()
                IF maxPlayer.isEmpty()
                    maxPlayer = p
                    #CONTINUE
                ENDIF

                IF {"player."+maxPlayer+".money"} < {"player."+p+".money"}
                    maxPlayer = p
                ENDIF
            ENDFOR

            topArr[i] = maxPlayer
            players.remove(maxPlayer)
        ENDFOR

        // getTotal Money
        total = 0
        FOR i = 0 : playerArr.length
            total += {"player."+playerArr[i]+".money"}
        ENDFOR

        #MESSAGE "&e------- [&6 부자 Top 5 &e] ----------"
        FOR i = 0:5
            targetMoney = {"player."+playerArr[i]+".money"}
            targetRatio = round(toDouble(targetMoney) / toDouble(total) * 100, 1)
            #MESSAGE "&6Top "+(i+1)+" &b"+playerArr[i]+" &f: &e"+ formatter.format(targetMoney) +"원 &7- "+ targetRatio +"%"
        ENDFOR
        #MESSAGE "&e-----------------------------"
        #STOP
    ENDIF

ENDIF

IF args.length > 0 && args.length < 4 // Optimization

    IF args[0] == "송금"

        IF args.length < 3 // Optimization
            #MESSAGE prefix + "&f사용법 : /돈 송금 <playername> <보낼 돈>"
            #STOP
        ENDIF

        target = player(args[1])

        IF target == null 
            #MESSAGE prefix + "&f현재 서버에 존재하지 않는 플레이어입니다."
            #STOP
        ENDIF

        IF target.getName() == $playername
            #MESSAGE prefix + "&f자기 자신에게는 돈을 송금할 수 없습니다."
            #STOP
        ENDIF

        IF args[2].matches("^[0-9]+$") == false // allow only positive number
            #MESSAGE prefix + "&f양의 정수로 적어주세요"
            #STOP
        ENDIF
        
        money = parseInt(args[2])

        IF money > {"player."+$playername+".money"}
            #MESSAGE prefix + "&f송금할 돈이 모자랍니다."
            #STOP
        ENDIF

        // binding tarnsfer and send message
        {"player."+$playername+".money"} -= money
        {"player."+target.getName()+".money"} += money

        #MESSAGE prefix + "&b" + target.getName() + "&f님에게 &e" + formatter.format(money) + "원&f을 송금하였습니다."
        target.sendMessage(color(prefix + "&b" + $playername+"&f님에게 &e"+formatter.format(money) + "원&f을 송금받았습니다."))
        #STOP
    ENDIF

ENDIF

#MESSAGE "-------------------"
#MESSAGE "/돈 보기"
#MESSAGE "/돈 송금"
#MESSAGE "/돈 랭킹"
#MESSAGE "-------------------"