--textdomain wesnoth-aoi

CHARACTER_STATS_ERLORNAS = ->
    {   _merge: true, type: "Elvish Lord"
        id: "Erlornas"
        name: _ "Erlornas"
        profile: "portraits/erlornas.png"
        canrecruit: true
        extra_recruit: "Elvish Archer,Elvish Fighter,Elvish Scout,Elvish Shaman"
        unrenamable: true
    }

CHARACTER_STATS_LINAERA = ->
    {   _merge: true, type: "Silver Mage"
        id: "Linaera"
        name: _ "Linaera"
        profile: "portraits/linaera.png"
        gender: "female"
        canrecruit: true
        extra_recruit: "Mage"
        unrenamable: true
        modifications: {
            TRAIT_LOYAL
        }
    }
