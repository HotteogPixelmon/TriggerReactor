import java.text.DecimalFormat
IMPORT java.lang.Integer

IF {"player."+player.getName() + ".money"} == null
    {"player."+player.getName() + ".money"} = 0
ENDIF

money = {"player." + player.getName() + ".money"}
formatter = new DecimalFormat("###,###");

IF args.length == 1

    IF args[0] == "보기"
        #MESSAGE "&6[돈]&b "+player.getName()+"&f님은 현재 &e"+ formatter.format(money)  + "원&f을 보유 중입니다."
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
                IF {"player."+playerArr[j]+".money"} < {"player."+playerArr[j+1]+".money"}
                    

                ENDIF
            ENDFOR
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

IF args.length >= 1 &&
    IF args.length <= 2
        #MESSAGE "&6[돈]&f 사용법 : /돈 송금 <playername> <보낼 돈>"
        #STOP
    ENDIF
ENDIF

ELSEIF args[0] == "보기"
    #MESSAGE "&6[돈]&b "+player.getName()+"&f님은 현재 &e"+ String.format("%,d", money)  + "원&f을 보유 중입니다."

ELSEIF args[0] == "송금"
    IF args.length <= 2
        #MESSAGE "&6[돈]&f 사용법 : /돈 송금 <playername> <보낼 돈>"
    ELSE

        target = player(args[1])

        IF target == null 
            #MESSAGE "&6[돈]&f 현재 서버에 존재하지 않는 플레이어입니다."
            #STOP
        ENDIF

        IF target.getName() == $playername
            #MESSAGE "&6[돈]&f 자기 자신에게는 돈을 송금할 수 없습니다."
            #STOP
        ENDIF

        IF args[2].matches("-?\\d+") == false
            #MESSAGE "&6[돈]&f 양의 정수로 적어주세요"
            #STOP
        ENDIF
        
        money = parseInt(args[2])

        IF money <= 0
            #MESSAGE "&6[돈]&f 양의 정수로 적어주세요"
            #STOP
        ENDIF

        IF money > {"player."+$playername+".money"}
            #MESSAGE "&6[돈]&f 송금할 돈이 모자랍니다."
            #STOP
        ENDIF

        {"player."+$playername+".money"} -= money
        #MESSAGE "&6[돈]&b " +target.getName()+"&f님에게 &e"+ String.format("%,d", money) + "원&f을 송금하였습니다."
        {"player."+target.getName()+".money"} += money
        target.sendMessage(color("&6[돈]&b "+ $playername+"&f님에게 &e"+String.format("%,d", money)+ "원&f을 송금받았습니다."))

    ENDIF

ELSEIF args[0] == "랭킹"

    p = {"player"}
    players = p.keySet().toArray()
    
    FOR i = 0:players.length - 1
        FOR j = 0:players.length - 1 - i
            IF {"player."+players[j]+".money"}  >  {"player."+players[j+1]+".money"}
                blank = players[j]
                players[j] = players[j+1]
                players[j+1] = blank
            ENDIF
        ENDFOR
    ENDFOR

    FOR i = 0 : players.length / 2
        blank = players[i]
        players[i] = players[players.length - 1 - i]
        players[players.length - 1 - i] = blank
    ENDFOR

    total = 0
    FOR i = 0 : players.length
        total += {"player."+players[i]+".money"}
    ENDFOR

    #MESSAGE "&e------- [&6 부자 Top 5 &e] ----------"
    FOR i = 0:5
        share = round(({"player."+players[i]+".money"}/1.0) / (total/1.0) * 100, 1)
        #MESSAGE "&6Top "+(i+1)+" &b"+players[i]+" &f: &e"+ String.format("%,d", {"player."+players[i]+".money"}) +"원 &7- "+ share +"%"
    ENDFOR
    
    #MESSAGE "&e-----------------------------"

ELSE
    #MESSAGE "-------------------"
    #MESSAGE "/돈 보기"
    #MESSAGE "/돈 송금"
    #MESSAGE "/돈 랭킹"
    #MESSAGE "-------------------"
ENDIF

#MESSAGE "-------------------"
#MESSAGE "/돈 보기"
#MESSAGE "/돈 송금"
#MESSAGE "/돈 랭킹"
#MESSAGE "-------------------"