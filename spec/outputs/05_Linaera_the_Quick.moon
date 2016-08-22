
scenario
    id:"05_Linaera_the_Quick"
    name: _ "Linaera the Quick"
    map:"05_Linaera_the_Quick.map"
    turns:24
    next_scenario:"06_A_Detour_through_the_Swamp"

    time:DEFAULT_SCHEDULE
    music:{"knolls","heroes_rite","traveling_minstrels","legends_of_the_north"}

    story:
        part: AOI_BIGMAP
            music:"wanderer"
            story: _ "After a day of hard-earned rest the elves marched north again. This was unknown country, not frequented even by Wesmere’s furthermost-faring scouts."
        part: AOI_BIGMAP
            story: _ "Two days’ travel later, the forward scouts reported another orcish warband laying siege to a tower."
        part: AOI_BIGMAP
            story: _ "Erlornas surveyed the siege from atop a small tree-covered hill overlooking the tower valley..."
    story:AOI_TRACK JOURNEY_05_NEW

    side: CHARACTER_STATS_ERLORNAS FLAG_VARIANT "wood-elvish"
        side:1
        controller:"human"
        recruit:{"Elvish Archer", "Elvish Fighter", "Elvish Scout", "Elvish Shaman"}
        gold: QUANTITY 100, 100, 100
        income: QUANTITY 0, 0, 0
        team_name:"good"
        user_team_name: _ "Elves"
        facing:"nw"

    side: FLAG_VARIANT6 "ragged"
        side:2
        controller:"ai"
        recruit:{"Goblin Knight", "Orcish Archer", "Orcish Crossbowman", "Orcish Grunt", "Orcish Warrior", "Wolf Rider"}
        gold: QUANTITY 190, 220, 250
        income: QUANTITY 0, 0, 0
        team_name:"orcs"
        user_team_name: _ "Orcs"
        unit:
            type:"Orcish Warlord"
            id:"Krughnar"
            name: _ "Krughnar"
            can_recruit:true
            facing:"se"
        ai:
            grouping:"offensive"
            attack_depth: QUANTITY 4, 5, 6
            villages_per_scout:4
            leader_value:3
            village_value:1

    side: CHARACTER_STATS_LINAERA
        side:3
        controller:"ai"
        team_name:"Wizards"
        user_team_name: _ "Wizards"
        -- Use stock flags
        facing:"nw"

    Prestart: -> STARTING_VILLAGES 1, 6
    Prestart: -> STARTING_VILLAGES 2, 9

    Prestart: ->
        objectives HINT _ "Use Elven Scouts and Linaera’s power of teleportation to mount hit-and-run attacks."
            objective:
                description: _ "Defeat Krughnar and break the siege"
                condition:"win"
            objective:
                description: _ "Death of Erlornas"
                condition:"lose"
            objective:
                description: _ "Death of Linaera"
                condition:"lose"
            objective: TURNS_RUN_OUT
            gold_carryover:
                bonus:true
                carryover_percentage:40
        RECALL_ADVISOR!
        MODIFY_UNIT {side:1}, facing, nw

    Start: ->
        message
            id:"Erlornas"
            message: _ "Report."
        message
            role:"Advisor"
            message: _ "A warband of orcs, no women or children among them, besieges a tower. It’s of human design... but we are far from the lands granted to humans by treaty, my lord Erlornas."
        message
            speaker:"Erlornas"
            message: _ "Under the letter of the treaty, it is so. But this country is too cold and barren for us. I wonder, what manner of human would choose to live here, far from its kind? Hmmm..."
        message
            role:"Advisor"
            message: _ "It trespasses, and should be driven out!"
        message
            speaker:"Erlornas"
            message: _ "Hold. It is only one human, or a few of them at most. Time enough to speak of driving it out when we have no enemies in common."
        message
            speaker:"Erlornas"
            message: _ "Tell me: I see no bridge over the chasm around that keep. Is there any sign that one has been withdrawn by the defenders?"
        message
            role:"Advisor"
            message: _ "No, lord. No traces of any construction. It looks like no bridge has ever existed there. There must be other, hidden means of access to the tower."
        message
            speaker:"Erlornas"
            message: _ "Interesting... Go to my personal stores and bring me a bottle of wine. And a couple of glasses."
        message
            role:"Advisor"
            message: _ "... Glasses?"
        message
            speaker:"Erlornas"
            message: _ "Do it. We’ll have a guest soon."
        message
            speaker:"narrator"
            --po: Faerie in this paragraph is a rare, poetic word in
            --po: English. It is the proper name of a magical otherworld
            --po: associated with elves - actually, originally with
            --po: fairies, but before Tolkien the boundary between elves
            --po: and fairies was extremely blurry. In Wesnoth it is
            --po: deliberately unclear whether Faerie is a place that is
            --po: the source of magical power or a label for the inner
            --po: nonhuman/magical nature of the Elves.  Translate freely.
            message: _ "Erlornas closed his eyes and brought his hands forward, joined palms forming a cup open to the sky. Soon they began to glow, then to flare like a brazier with the fire of Faerie, casting a cold, blue light all around the elf-lord. A wisp of light emerged from the eerie flames, and at a few murmured words from the elf-lord flew away towards the tower below. Then the light around Erlornas faded and all was seemingly as before."
        delay
            time:500
        message
            speaker:"narrator"
            message: _ "Some time later..."
        teleport
            filter:
                id:"Linaera"
            x:16,y:17
            animate:true
        MODIFY_UNIT {side:1}, "facing", "se"
        GENERIC_UNIT 3, Mage, 17, 17
            facing:"se"
            overlays:"misc/loyal-icon.png"
            modifications:
                {TRAIT_LOYAL}
        GENERIC_UNIT 3, Mage, 16, 18
            facing:"se"
            overlays:"misc/loyal-icon.png"
            modifications:
                {TRAIT_LOYAL}
        GENERIC_UNIT 3, Mage, 15, 17
            facing:"se"
            overlays:"misc/loyal-icon.png"
            modifications:
                {TRAIT_LOYAL}
        message
            speaker:"Erlornas"
            message:"_ So you decided to accept the invitation. Good. Welcome, I am lord Erlornas of Wesmere. I find your presence here... surprising."
        message
            speaker:"Linaera"
            message: _ "Scarcely less than I find yours, my lord elf, but I would welcome your aid against these orcs. They have been besieging my tower for weeks."
        message
            id:"Erlornas"
            message: _ "I wish their foul kind driven as far as possible from my borders, not to return. It would be no bad thing if an ally of the elves kept watch over this country."
        message
            speaker:"Linaera"
            message: _ "Count me an ally, then, lord Erlornas. We can defeat them together."
        modify_unit
            filter:
                side:3
            side:1
        message
            role:"Advisor"
            message: _ "My lord... humans cannot be trusted! They shift their allegiances with the changing of the wind!"
        message
            speaker:"Erlornas"
            message: _ "That may be, but I do not think this one will betray us to the orcs. And we may need her assistance, too: that is a powerful force of orcs ahead."


    EnemiesDefeated: ->
        message
            speaker:"Erlornas"
            message: _ "And that is well ended. But, Linaera, there is somewhat else that concerns me. You are a mage; do you not feel something... wrong... to the east of here?"
        message
            speaker:"Linaera"
            message: _ "I do indeed. Something evil has recently made a nest in the next valley over; its servants have been sniffing at the edges of my domain. I had meant to deal with it myself, but if you elves revere the green earth I think you will want it abolished as much as do I."
        message
            speaker:"Erlornas"
            message: _ "We are of one mind, then. Let us go to it."
        endlevel NEW_GOLD_CARRYOVER 40
            result:"victory"
            bonus:true


    Prestart: HERODEATH_ERLORNAS
    Prestart: HERODEATH_LINAERA
