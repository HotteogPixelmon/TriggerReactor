IMPORT java.lang.String
IMPORT java.lang.Integer
IF args.length >= 1
    IF args[0].matches("-?\\d+") == true
        money = Integer.parseInt(args[0])
        IF money > 0
            IF {"player."+player.getName() + ".money"} >= Integer.parseInt(args[0])
                tnvy = item("PAPER", 1)
                setItemTitle(tnvy, "&f" + "수표")
                addLore(tnvy, args[0])
                {"player."+player.getName() + ".money"} = {"player."+player.getName() + ".money"} - Integer.parseInt(args[0])
                #GIVE tnvy
                #MESSAGE "&6[돈] &e"+ String.format("%,d", money) + "원&f을 수표로 발행했습니다."
            ELSE
                #MESSAGE "&6[돈] &f잔액이 부족합니다"
            ENDIF
        ELSE 
            #MESSAGE "&6[돈] &f양의 정수를 입력해주세요."
        ENDIF
    ELSE 
        #MESSAGE "&6[돈] &f양의 정수를 입력해주세요."
    ENDIF 
ELSE 
    #MESSAGE "&6[돈] &f사용법 : /수표 <금액>"
ENDIF