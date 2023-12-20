import com.pixelmonmod.pixelmon.api.pokemon.PokemonBuilder;
import com.pixelmonmod.pixelmon.api.pokemon.stats.BattleStatsType;
import com.pixelmonmod.pixelmon.api.registries.PixelmonSpecies;

pokeSize = 2
movePerArr = array(pokeSize)

FOR i = 0:pokeSize
    path = "toto.pokemon."+i
    {?path+".len"} = 0

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
    #MESSAGE i+", " + movePerArr[i]
ENDFOR

goal = false
goalList = list()
{?"toto.started"} = true

runParams = list()
FOR p = movePerArr
    param = map()
    param.put("probability", p)

    // if you want, add any params for new function.
    param.put("groggy", false)

    runParams.add(param)
ENDFOR

speed = 0.1 // 0~1 사이의 값.
events = list() // params = runParams | retrun modified probability

// for Example. its Groggy event method
events.add(LAMBDA params => 
    FOR o = 0:params.size()

        option = params.get(o)
        groggy = option.get("groggy")
        #MESSAGE o+", "+groggy

        IF !groggy && random(1.0) < 0.05 * {?"toto.pokemon."+i+".len"} * speed
            option.put("groggy", true)
            option.put("probability", 0)
            #MESSAGE "Groggied!"
        ELSEIF groggy && random(1.0) < 0.1 * speed
            option.put("groggy", false)
            option.put("probability", movePerArr[i])
            #MESSAGE "Groggy was disabled"
        ENDIF

        params.set(o, option)
        
    ENDFOR

    params
ENDLAMBDA)

WHILE !goal

    // event Listener
    FOR e = events
        runParams = e.run(runParams)
    ENDFOR

    // 확률에 따른 전진 여부 판별
    FOR i = 0:pokeSize
        IF random(1.0) < runParams.get(i).get("probability") * speed
            {?"toto.pokemon."+i+".len"} += 1
            #MESSAGE {?"toto.pokemon.0.len"} +" Vs " + {?"toto.pokemon.1.len"}
        ENDIF
    ENDFOR

    // 동시에 들어갔다면 리스트에 담고 나중에 랜덤으로 뽑기.
    FOR i = 0:pokeSize
        IF {?"toto.pokemon."+i+".len"} > 7
            goal = true
            goalList.add(i)
        ENDIF
    ENDFOR

    #WAIT 0.1 // repeat delay
ENDWHILE

goalIndex = goalList.get(random(goalList.size()))
// Distribution monies