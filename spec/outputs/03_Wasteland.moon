--textdomain wesnoth-aoi

-- Warning: If you are not a native and literate English speaker, do
-- not try to modify the storyline text. It is deliberately written
-- in a somewhat archaic and poetic form of English, and some previous
-- attempts to "fix" it inflicted damage that was difficult to undo.

scenario{
    id: "03_Wasteland"
    name: _ "Wasteland"
    map_data: "{campaigns/An_Orcish_Incursion/maps/03_Wasteland.map}"
    turns: 24
    next_scenario: "04_Valley_of_Trolls"

    DEFAULT_SCHEDULE

    SCENARIO_MUSIC("elvish-theme.ogg")
    EXTRA_SCENARIO_MUSIC("casualties_of_war.ogg")
    EXTRA_SCENARIO_MUSIC("nunc_dimittis.ogg")

    story: {
        part: {
            music: "revelation.ogg"
            AOI_BIGMAP
            story: _ "As they fared further north the green forest thinned around them, slowly fading into a barren and fallow country. The signs were obvious and unmistakable — tree stumps, an occasional half-rotten tree felled long ago, and dead wood around them in scarce grass. This had been forest once, like the woods they called home. It had been murdered."
        }
        part: {
            AOI_BIGMAP
            story: _ "There was no trail to be found here; wind and rain had erased the spoor. Fortunately, there was no need of a trail; smoke on the horizon betrayed the presence of their enemies."
        }
        part: {
            AOI_BIGMAP
            story: _ "Erlornas was near-certain they would find orcs there. No clan of dwarves would break their ancient treaties with the elves in this way; humans were never so... methodical in their destruction, and did not travel in sufficiently large numbers in a north country they found too cold and damp for comfort. The great question remained — would he find Rualsha?"
        }
        part: {
            AOI_BIGMAP
            story: _ "Perhaps, but not here. The tribe this camp housed was too small to impress fear on other orcs. Come next morning, the elves were prepared for battle."
        }
    }

    AOI_TRACK(JOURNEY_03_NEW)

    -- wmllint: validate-off
    side: {
        side: 1
        controller: "human"
        INCOME(12, 9, 9)
        team_name: "Elves"
        user_team_name: _ "Elves"
        FLAG_VARIANT("wood-elvish")

        -- wmllint: recognize Erlornas
        CHARACTER_STATS_ERLORNAS

        facing: "nw"
    }
    -- wmllint: validate-on

    side: {
        side: 2
        controller: "ai"
        recruit: "Orcish Archer,Orcish Crossbowman,Orcish Grunt,Orcish Warrior,Wolf Rider"
        GOLD(100, 120, 160)
        INCOME(8, 12, 12)
        team_name: "Orcs"
        user_team_name: _ "Orcs"
        FLAG_VARIANT6("ragged")

        type: "Orcish Warlord"
        id: "Gnargha"
        name: _ "Gnargha"
        canrecruit: true

        facing: "se"

        ai: {
            grouping: "offensive"
            attack_depth: 5
        }
    }

    event: {
        name: "prestart"

        do: -> objectives{
                objective: {
                    description: _ "Defeat Gnargha"
                    condition: "win"
                }
                objective: {
                    description: _ "Death of Erlornas"
                    condition: "lose"
                }

                TURNS_RUN_OUT

                gold_carryover: {
                    bonus: true
                    carryover_percentage: 40
                }

                if EASY then { _merge:
                    HINT(_ "There are no villages in this scenario — you must use healers instead. Use hit-and-run tactics to weaken enemy units who cannot heal themselves.")
                }
            }

            VARIABLE("orcs_recruited", 0)
            VARIABLE("camp_gold", 300)
            VARIABLE_OP("modulo_factor", "rand", "2..4")

            RECALL_ADVISOR

            MODIFY_UNIT({side: 1}, "facing", "nw")
    }

    event: {
        name: "start"

        do: -> message{
                role: "advisor"
                message: _ "Lord... I’m... I am filled with grief. This senseless destruction is... overwhelming."
            }

            message{
                speaker: "Erlornas"
                message: _ "Yes. And this is the threat we were blind to but are now facing. This tribe is small, yet we must drive them back to the north. They must have no footholds south of the hills."
            }

            message{
                speaker: "Gnargha"
                message: _ "Elves!? This means Urugha failed and his spirit will suffer greatly for his weakness. So be it!"
            }

            message{
                speaker: "Gnargha"
                message: _ "Rise up, grunts! We have a great fight upon us! Let your rage flow freely! Let your blades slay all! First one to draw blood will feast by my fire this night!"
            }

            message{
                speaker: "Erlornas"
                message: _ "Aim true, men, with wit and courage the day will be ours. And spare no-one, there can be no orc south of the hills, else we’ll never have peace again."
            }
    }

    event: {
        name: "recruit"
        first_time_only: false
        filter: {
            side: 2
        }

        do: -> VARIABLE("temporary", orcs_recruited)
            VARIABLE_OP("temporary", "modulo", modulo_factor)

            if{
                variable: {
                    name: "temporary"
                    equals: 0
                }
                then: ->
                    disallow_recruit{
                        side: 2
                        type: "Orcish Archer, Orcish Grunt, Wolf Rider"
                    }

                    allow_recruit{
                        side: 2
                        type: "Orcish Crossbowman, Orcish Warrior"
                    }

                    VARIABLE_OP("modulo_factor", "rand", "2..4")

                else: ->
                    disallow_recruit{
                        side: 2
                        type: "Orcish Crossbowman, Orcish Warrior"
                    }

                    allow_recruit{
                        side: 2
                        type: "Orcish Archer, Orcish Grunt, Wolf Rider"
                    }

            }

            VARIABLE_OP("camp_gold", "sub", unit.cost)
            VARIABLE_OP("orcs_recruited", "add", 1)
            CLEAR_VARIABLE("temporary")
    }

    event: {
        name: "last breath"
        filter: {
            id: "Gnargha"
        }

        do: -> message{
                speaker: "unit"
                message: _ "You won... elf... But it changes... nothing... (<i>cough</i>)"
            }

            message{
                speaker: "unit"
                message: _ "We found the way... Now... we will come in numbers... (<i>cough</i>) you can’t imagine..."
            }

            message{
                speaker: "unit"
                message: _ "(<i>Cough</i>) I’ll be waiting... among the dead..."
            }
    }

    event: {
        name: "die"
        filter: {
            id: "Gnargha"
        }

        do: -> message{
                speaker: "narrator"
                image: "wesnoth-icon.png"
                message: _ "The orcish chieftain finally fell, overcome by his wounds. The elves found themselves in a half-ruined camp littered with the bodies of both sides, there was no hale orc in sight, nor did any of the wounded beg mercy. The elves took no prisoners."
            }

            endlevel{
                result: "victory"
                bonus: true
                NEW_GOLD_CARRYOVER(40)
            }
    }

    event: {
        name: "victory"

        do: -> RECALL_ADVISOR!

            message{
                role: "advisor"
                message: _ "It’s done, lord. No-one escaped. No-one tried to escape. I’m... disturbed."
            }

            message{
                speaker: "Erlornas"
                message: _ "Good. But their disregard for self-preservation is astounding. As is their ferocity when defending what they claim as their own. Have the scouts found others this side of the hills?"
            }

            message{
                role: "advisor"
                message: _ "No, lord. But trolls were spotted in the hills ahead. Do we really need to cross them to the north?"
            }

            message{
                speaker: "Erlornas"
                message: _ "Yes. The council has spoken to me through a dream-sending. They are troubled. Reinforcements have been sent after us, but we need to press on. Tell the men to rest, we’ll move out at dawn."
            }

            if{
                variable: {
                    name: "camp_gold"
                    greater_than: 100
                }
                then: {
                    message{
                        role: "advisor"
                        message: _ "What about the loot lord? We found supplies worth over a hundred gold in the camp."
                    }

                    message{
                        speaker: "Erlornas"
                        message: _ "Distribute some among the men, save the rest for the road. This country is a wasteland now; we won’t find much forage on the march."
                    }
                }
            }

            if{
                variable: {
                    name: "camp_gold"
                    greater_than: 50
                }
                variable: {
                    name: "camp_gold"
                    less_than_equal_to: 100
                }
                then: ->
                    message{
                        role: "advisor"
                        message: _ "We found some supplies when searching the camp, but nothing much. What is to be done with them?"
                    }

                    message{
                        speaker: "Erlornas"
                        message: _ "Save it for the march north. There is little to be found in this barren country."
                    }

            }

            if{
                variable: {
                    name: "camp_gold"
                    greater_than: 0
                }
                then: ->
                    gold{
                        side: 1
                        amount: camp_gold
                    }

            }

            CLEAR_VARIABLE("camp_gold", "orcs_recruited", "modulo_factor")
    }

    event: {
        name: "time over"

        PROMOTE_ADVISOR!

        do: -> message{
                role: "advisor"
                message: _ "We can’t carry on Lord, the men are too tired. We have to fall back."
            }

            message{
                speaker: "Erlornas"
                message: _ "Damn it. Sound the retreat, we’ll try again when reinforcements arrive."
            }

            message{
                speaker: "narrator"
                image: "wesnoth-icon.png"
                message: _ "The expected relief caught up with them a few days later. The following morning they took the field against a far larger host of orcs. The battle ended in a draw; the war raged on for years..."
            }
    }

    HERODEATH_ERLORNAS
}
