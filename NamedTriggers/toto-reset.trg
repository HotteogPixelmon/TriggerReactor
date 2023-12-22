import java.lang.Math;
import java.util.Random;

import com.pixelmonmod.pixelmon.api.registries.PixelmonSpecies;
import com.pixelmonmod.pixelmon.api.pokemon.PokemonBuilder;

pokeSize = 2
{"toto.time"} = 3600

rand = Random()

pickUpRandomSpec = LAMBDA =>

    spec = PixelmonSpecies.getRandomSpecies(true, true, false)
    IF rand.nextDouble() < 0.2
        spec = PixelmonSpecies.getRandomLegendary(true)
        IF rand.nextDouble() < 0.3
            spec = PixelmonSpecies.getRandomMythical()
        ENDIF
    ENDIF

    spec

ENDLAMBDA

FOR i = 0:pokeSize
    species = pickUpRandomSpec()
    specForms = species.getForms(true)
    formName = "Base"
    isShiny = false

    randomForm = specForms.get(random(specForms.size()))

    IF !randomForm.getName().isEmpty()
        formName = randomForm.getName()
    ENDIF

    IF rand.nextDouble() < 0.05
        isShiny = true
    ENDIF

    pokePath = "toto.pokemon." + i

    {pokePath} = null // init

    {pokePath + ".spec"} = species.getName()
    {pokePath + ".form"} = formName
    {pokePath + ".isShiny"} = isShiny
    {pokePath + ".iv"} = arrayOf(rand.nextInt(31), rand.nextInt(31), rand.nextInt(31), rand.nextInt(31), rand.nextInt(31), rand.nextInt(31))
    {pokePath + ".level"} = Math.min(Math.max(rand.nextGaussian() * 15 + 50, 1), 100)
    {pokePath + ".status"} = Math.min(Math.max(rand.nextGaussian() / 8.0 + 0.5, 0), 1)

    // Default moneys
    {pokePath + ".betted.System"} = 50000
ENDFOR