import java.lang.Math;

import com.pixelmonmod.pixelmon.api.pokemon.PokemonBuilder;
import com.pixelmonmod.pixelmon.api.pokemon.stats.BattleStatsType;
import com.pixelmonmod.pixelmon.api.registries.PixelmonSpecies;

#CALL "utils"

pokeSize = 2
movePerArr = array(pokeSize)

FOR i = 0:pokeSize
    path = "toto.pokemon."+i

    // 포켓몬 종족을 구함.
    species = PixelmonSpecies.fromName({path+".spec"}).getValueUnsafe()

    // 포켓몬 폼 구함.
    IF {path+".form"} == "Base"
        forms = species.getDefaultForm()
    ELSE
        forms = species.getForm({path+".form"})
    ENDIF

    // 무한다이맥스 무한다이노 제외.
    IF species.getName() == "Eternatus"
        forms = species.getDefaultForm()
    ENDIF

    // 종족값 총합을 구함.
    baseStat = 0
    battleStats = forms.getBattleStats()
    battleStatsEnum = arrayOf(BattleStatsType.HP, BattleStatsType.ATTACK, BattleStatsType.DEFENSE, BattleStatsType.SPECIAL_ATTACK, BattleStatsType.SPECIAL_DEFENSE, BattleStatsType.SPEED)
    FOR e = battleStatsEnum
        stat = battleStats.getStat(e)
        baseStat += stat
    ENDFOR

    // 개체값을 구함.
    ivs = 0
    FOR iv = {path+".iv"}
        ivs += iv
    ENDFOR

    // 확률 로직
    BaseRatio = baseStat / 900.0
    // (값 * 가중치) - 단 가중치의 합이 1을 넘으면 안됨.
    movePerArr[i] = (BaseRatio * 0.2) + (({path+".level"} / 100.0) * 0.4) + (((ivs + 1) / 187.0) * 0.4)

    IF {path+".isShiny"}
        movePerArr[i] *= 1.1
    ENDIF

    movePerArr[i] = movePerArr[i] * ({path+".status"} * 0.4 + 0.6)
ENDFOR

goal = false
goalList = list()
{?"toto.started"} = true

runParams = list()
FOR p = movePerArr
    param = map()
    param.put("probability", p)
    param.put("distance", 0)
    param.put("stayTurn", 0)

    // if you want, add any params for new function.
    param.put("groggy", false)
    param.put("groggy_time", 0)

    runParams.add(param)
ENDFOR

speed = 0.1 // 0~1 사이의 값.
events = list() // params = runParams | retrun modified probability

// for Example. its Groggy event method
events.add(LAMBDA params => 

    groggy = params.get("groggy")

    IF !groggy && random(1.0) < 0.002 * (params.get("distance") * 3.0) * speed
        params.put("groggy", true)
        params.put("probability", 0)
    ELSEIF groggy && random(1.0) < 0.005 * (params.get("groggy_time") * 0.75) * speed
        params.put("groggy", false)
        params.put("groggy_time", 0)
        params.put("probability", movePerArr[i])
    ELSEIF groggy
        params.put("groggy_time", params.get("groggy_time") + 1)
        params.put("stayTurn", params.get("stayTurn") - 1)
    ENDIF

    params
ENDLAMBDA)

goal = true // test
WHILE !goal

    // event Listener
    FOR i = 0:pokeSize

        FOR e = events
            runParams.set(i, e.run(runParams.get(i)))
        ENDFOR

    ENDFOR

    // 확률에 따른 전진 여부 판별
    FOR i = 0:pokeSize
        params = runParams.get(i)

        IF random(1.0) < (params.get("probability") * (1.0 + (params.get("stayTurn") * 0.05))) * speed
            params.put("distance", params.get("distance") + 1)
            params.put("stayTurn", Math.max(toInt(params.get("stayTurn") - 10), 0))
        ELSE
            params.put("stayTurn", params.get("stayTurn") + 1)
        ENDIF

        runParams.set(i, params)
    ENDFOR

    // 동시에 들어갔다면 리스트에 담고 나중에 랜덤으로 뽑기.
    FOR i = 0:pokeSize
        params = runParams.get(i)

        IF params.get("distance") > 7
            goal = true
            goalList.add(i)
        ENDIF
    ENDFOR

    // 전역변수에 현재 게임 상태 업데이트.
    FOR i = 0:runParams.size()
        globalVar_putMap("toto.runtime.params."+i, runParams.get(i), true)
    ENDFOR

    #WAIT 0.1 // repeat delay
ENDWHILE

goalList.add(0)
goalIndex = goalList.get(random(goalList.size()))

// Distribution monies
winners = {"toto.pokemon."+ goalIndex +".betted"}

total = 0
winnerTotal = 0
FOR i = 0:pokeSize
    pList = {"toto.pokemon."+ i +".betted"}
    
    FOR m = pList.values()
        IF i == goalIndex
            winnerTotal += m
        ELSE
            total += m
        ENDIF
    ENDFOR

ENDFOR

// give monies
FOR p = winners.keySet()
    IF p == "System"
        #CONTINUE
    ENDIF
    {"player."+p+".money"} += (total * (winners.get(p)/winnerTotal))
ENDFOR