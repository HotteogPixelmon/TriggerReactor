import com.pixelmonmod.pixelmon.api.pokemon.PokemonBuilder;

pokeSize = 2
pokemonList = list()

FOR i = 0:pokeSize
    path = "toto.pokemon."+i

    IF {?path+".len"} == null
        {?path+".len"} = 0
    ENDIF

    builder = PokemonBuilder.builder().species({?path+".spec"})
    builder = builder.form({?path+".form"})

    builder = builder.shiny({?path+".isShiny"})

    pokemonList.add()
ENDFOR

goal = false
goalList = list()
{?"toto.started"} = true

WHILE !goal

    // 확률에 따른 전진 여부 판별
    FOR i = 0:pokeSize

    ENDFOR

    // 동시에 들어갔다면 리스트에 담고 나중에 랜덤으로 뽑기.
    FOR i = 0:pokeSize
        IF {?"toto.pokemon."+i+".len"} > 7
            goal = true
            goalList.add(i)
        ENDIF
    ENDFOR

    #WAIT 0.1
ENDWHILE

goalIndex = goalList.get(random(goalList.size()))
// Distribution monies