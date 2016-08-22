
scenario
    id:"07_Showdown"
    name: _ "Showdown"
    map:"07_Showdown.map"
    turns:24

    time:DEFAULT_SCHEDULE
    music:{"the_city_falls","siege_of_laurelmor","battle"}

    -- {AOI_TRACK {JOURNEY_07_NEW}}

    side: CHARACTER_STATS_ERLORNAS FLAG_VARIANT "wood-elvish"
        side:1
        controller:"human"
        recruit:"Elvish Archer, Elvish Fighter, Elvish Scout, Elvish Shaman"
        gold:100
        income:0
        team_name:"good"
        user_team_name: _ "Elves"
        facing:"nw"

    side: FLAG_VARIANT6 "ragged"
        side:2
        controller:"ai"
        recruit: QUANTITY "Orcish Archer, Orcish Assassin, Orcish Crossbowman, Orcish Grunt, Orcish Warrior, Troll, Troll Whelp, Wolf Rider",
            "Goblin Knight, Orcish Archer, Orcish Assassin, Orcish Crossbowman, Orcish Grunt, Orcish Warrior, Troll, Troll Whelp, Wolf Rider",
            "Goblin Knight, Orcish Archer, Orcish Assassin, Orcish Crossbowman, Orcish Grunt, Orcish Warrior, Troll, Troll Whelp, Wolf Rider"
        gold: QUANTITY 200, 250, 300
        income: QUANTITY 0, 5, 5
        team_name:"orcs"
        user_team_name: _ "Orcs"
        type:"Orcish Sovereign"
        id:"Rualsha"
        name: _ "Rualsha"
        can_recruit:true
        facing:"se"
        ai:
            villages_per_scout:4
            leader_value:3
            village_value:1
            grouping:"offensive"
            attack_depth:5

    -- {STARTING_VILLAGES 1 4}
    -- {STARTING_VILLAGES 2 4}

    Prestart: ->
        kill
            id:"Linaera"
        objectives
            side:1
            objective:
                description: _ "Defeat Rualsha"
                condition:"win"
            objective:
                description: _ "Death of Erlornas"
                condition:"lose"
            --{TURNS_RUN_OUT}
            --{IS_LAST_SCENARIO}
            --{HINT ( _ "Your enemy is well-defended against attacks from the south. Use rangers to sneak through the forest and mount a surprise attack from the north.")}

    Start: ->
        move_unit_fake
            type:"Elvish Rider"
            x:{18,18,17,16}
            y:{20,19,19,18}
        unit
            type:"Elvish Rider"
            id:"Lomarfel"
            name: _ "Lomarfel"
            profile:"portraits"/lomarfel.png
            x:16,y:18
            side:1
            upkeep:"loyal"
            facing:"sw"
        move_unit_fake
            type:"Elvish Ranger"
            x:{18,18,17,17}
            y:{20,19,19,18}
        unit
            type:"Elvish Ranger"
            id:"Celodith"
            name: _ "Celodith"
            gender:"female"
            x:17,y:18
            side:1
            upkeep:"loyal"
            facing:"sw"
        move_unit_fake
            type:"Elvish Ranger"
            x:{18,18,17}
            y:{20,19,19}
        unit
            type:"Elvish Ranger"
            id:"Earanduil"
            name: _ "Earanduil"
            gender:"male"
            x:17,y:19
            side:1
            upkeep:"loyal"
            facing:"sw"
        move_unit_fake
            type:"Elvish Ranger"
            x:{18,18,18}
            y:{20,19,18}
        unit
            type:"Elvish Ranger"
            id:"Elvyniel"
            name: _ "Elvyniel"
            gender:"female"
            x:18,y:18
            side:1
            upkeep:"loyal"
            facing:"sw"
        move_unit_fake
            type:"Elvish Ranger"
            x:{18,18}
            y:{20,19}
        unit
            type:"Elvish Ranger"
            id:"Delorfilith"
            name: _ "Delorfilith"
            gender:"male"
            x:18,y:19
            side:1
            upkeep:"loyal"
            facing:"sw"
        message
            speaker:"Lomarfel"
            message: _ "My lord! We have ridden hard for over a week to catch up with you! The Ka’lian has deliberated, and asks you to defeat Rualsha quickly before he can muster a full invasion force."
        message
            speaker:"Rualsha"
            message: _ "Puny elves! My full army will be here soon, and then we will crush you. You will beg for a quick death!"

    LastBreath:
        filter:
            id:"Rualsha"
        command: ->
            message:
                speaker:"unit"
                message: _ "You may slay me, Erlornas, but my people live on. They will not forget! They will pursue you, and destroy you utterly... we will... we... arrgh..."

    Die:
        filter:
            id:"Rualsha"
        command: ->
            message
                speaker:"narrator"
                message: _ "But Rualsha overestimated the will of his troops. With their leader dead, they scattered, and fled from the elves back to their fastnesses in the far north."
            kill
                side:2
            role
                type:"Elvish Champion,Elvish Marshal,Elvish Captain,Elvish Hero,Elvish Outrider,Elvish Rider,Elvish Avenger,Elvish Ranger,Elvish Sharpshooter,Elvish Marksman,Elvish Shyde,Elvish Druid,Elvish Fighter,Elvish Archer,Elvish Shaman,Elvish Scout"
                role:"Advisor"
            message
                speaker:"Erlornas"
                message: _ "It grieves me to take life, even of a barbarian such as Rualsha."
            message
                role:"Advisor"
                message: _ "If the orcs press us, we shall need to become more accustomed to fighting."
            message
                speaker:"Erlornas"
                message: _ "I fear it will be so. We have won a first victory here, but dark times come upon its heels."
            music
                name:"traveling_minstrels"
                immediate:true
                append:false
            endlevel
                carryover_report:false
                save:false

    --{HERODEATH_ERLORNAS}
