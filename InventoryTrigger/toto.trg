IF trigger == "open"
    builder = PokemonBuilder.builder().species({path+".spec"})
    builder = builder.form({path+".form"})

    builder = builder.level({path+".level"})

    builder = builder.shiny({path+".isShiny"})
    builder = builder.ivs({path+".iv"})

    pokemonList.add()
ENDIF