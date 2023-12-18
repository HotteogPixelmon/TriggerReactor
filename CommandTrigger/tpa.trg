server = "&e&l[&6&lSERVER&e&l] &f"

IF args.length == 0
    #MESSAGE "-----------------------"
    #MESSAGE "./tpa <닉네임>"
    #MESSAGE "./tpa 수락"
    #MESSAGE "./tpa 거절"    
    #MESSAGE "-----------------------"
ENDIF

IF args.length == 1
    playerPath = "players." + player.getUniqueId().toString() + ".tpa"
    IF {?playerPath} != null

        IF args[0] == "수락"
            target = player({?playerPath})
            IF target == null
                #MESSAGE server+"&ctpa 요청을 수락했지만 플레이어가 서버에 존재하지 않습니다."
                {?playerPath} = null
                #STOP
            ENDIF
            #MESSAGE server+"&atpa 요청을 수락했습니다."

            SYNC
                target.teleport(player)
            ENDSYNC
            target = player({?playerPath})
            IF target != null
                target.sendMessage(color(server+"&a상대가 tpa 요청을 수락했습니다."))
            ENDIF
            {?playerPath} = null
            
        ELSEIF args[0] == "거절"
            #MESSAGE server+"&ctpa 요청을 거절했습니다."
            target = player({?playerPath})
            IF target != null
                target.sendMessage(color(server+"&c상대가 tpa 요청을 거절했습니다."))
            ENDIF
            {?playerPath} = null
        ENDIF
        
    ELSEIF args[0] == "수락" || args[0] == "거절"
        #MESSAGE server+"&c받은 tpa 요청이 없습니다."
    ENDIF

    IF args[0] != "수락" && args[0] != "거절"
        target = player(args[0])

        IF target == null
            #MESSAGE server+"&c서버에 존재하지 않는 플레이어입니다."
            #STOP
        ENDIF

        // IF target == player
        //     #MESSAGE server+"자신에게는 tpa를 사용할 수 없습니다."
        //     #STOP
        // ENDIF

        targetPath = "players." + target.getUniqueId().toString() + ".tpa"

        IF {?targetPath} != null
            #MESSAGE server+"&c상대가 이미 다른 tpa 요청을 받고 있습니다."
            #STOP
        ENDIF

        {?targetPath} = $playername
        #MESSAGE server+"&b"+target.getName()+"님에게 tpa 요청을 보냈습니다."

        target.sendMessage(color(server+"&b"+player.getName()+"님에게 tpa 요청을 받았습니다.&3 (60초 후에 자동 거절됩니다.)"))
        target.sendMessage(color(server+"수락하려면 &a/tpa 수락&f을 입력하세요."))
        target.sendMessage(color(server+"거절하려면 &c/tpa 거절&f을 입력하세요."))

        FOR i = 0:60
            #WAIT 1
            IF !target.isOnline()
                {?targetPath} = null
                #MESSAGE server+"&c"+player.getName()+"님이 오프라인 상태가 되어 tpa요청이 거절되었습니다."
            ENDIF

            IF {?targetPath} == null
                #STOP
            ENDIF
        ENDFOR

        IF target.isOnline()
            target.sendMessage(color(server+"&c"+"60초가 지나서 "+player.getName()+"님의 tpa 요청이 거절되었습니다."))
        ENDIF

        {?targetPath} = null
    ENDIF
ENDIF