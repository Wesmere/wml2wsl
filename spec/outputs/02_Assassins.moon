--textdomain wesnoth-aoi

-- Warning: If you are not a native and literate English speaker, do
-- not try to modify the storyline text. It is deliberately written
-- in a somewhat archaic and poetic form of English, and some previous
-- attempts to "fix" it inflicted damage that was difficult to undo.

scenario{
    id: "02_Assassins"
    name: _ "Assassins"
    map_data: "{campaigns/An_Orcish_Incursion/maps/02_Assassins.map}"
    turns: 24
    next_scenario: "03_Wasteland"

    DEFAULT_SCHEDULE!

    SCENARIO_MUSIC("underground.ogg")
    EXTRA_SCENARIO_MUSIC("battle.ogg")
    EXTRA_SCENARIO_MUSIC("frantic.ogg")

    story: {
        part: {
            music: "northerners.ogg"
            AOI_BIGMAP!
            story: _ "The path of the orcish war band was easy to follow — a wide swathe of trampled ground through violated forest. Erlornas and his party swiftly followed it north and west."
        }
        part: {
            AOI_BIGMAP!
            story: _ "Soon they arrived at a region where the forest was cut through by many streams, only to find something unexpected."
        }
    }

    AOI_TRACK(JOURNEY_02_NEW!)

    -- wmllint: validate-off
    side: {
        side: 1
        controller: "human"
        type: "Elvish Lord"
        team_name: "Elves"
        user_team_name: _ "Elves"

        FLAG_VARIANT("wood-elvish")

        -- wmllint: recognize Erlornas
        CHARACTER_STATS_ERLORNAS!

        facing: "nw"
    }
    -- wmllint: validate-on

    side: {
        side: 2
        controller: "ai"
        recruit: "Orcish Assassin,Orcish Grunt,Wolf Rider"
        GOLD(150, 200, 240)
        INCOME(0, 0, 2)
        team_name: "Orcs"
        user_team_name: _ "Orcs"
        FLAG_VARIANT6("ragged")

        type: "Orcish Slayer"
        id: "Gharlsa"
        canrecruit: true
        name: _ "Gharlsa"

        facing: "se"

        ai: {
            villages_per_scout: 6
            aggression: 0.5
            caution: 0.25
            leader_value: 3
            village_value: 1
            scout_village_targeting: 3
            goal: {
                name: "protect_unit"
                criteria: {
                    side: 2
                    canrecruit: true
                }
                protect_radius: 20
                value: 1
            }
            grouping: "offensive"
            attack_depth: 5
        }
    }

    STARTING_VILLAGES(1, 6)
    STARTING_VILLAGES(2, 6) -- Gharlsa starts with all villages north of the northernmost river

    event: {
        name: "prestart"

        do: -> objectives{
                objective: {
                    description: _ "Defeat Gharlsa"
                    condition: "win"
                }
                objective: {
                    description: _ "Death of Erlornas"
                    condition: "lose"
                }

                TURNS_RUN_OUT!

                gold_carryover: {
                    bonus: true
                    carryover_percentage: 40
                }

                if EASY then { _merge:
                    HINT(_ "Assassins are hard to hit, and their poison is insidious. Stay close to the villages, where poisoning can be cured, and force your enemies to attack you from the river.")
                }
            }

            RECALL_ADVISOR!

            MODIFY_UNIT({side: 1}, "facing", "nw")
    }

    event: {
        name: "start"

        do: -> message{
                role: "advisor"
                message: _ "The trail leads straight to this place, my lord."
            }

            message{
                speaker: "Erlornas"
                message: _ "There is a keep ahead of us. How comes it that we know nothing of it? I thought our borders were watched more carefully."
            }

            message{
                role: "advisor"
                message: _ "I... I know not, my lord. For ages there was no one in these lands that could build such a thing save us. I fear we have fallen prey a false sense of security that has injured the vigilance of our scouts."
            }

            message{
                speaker: "Erlornas"
                message: _ "When the fighting ends, I’ll have some answers. But for now—"
            }

            message{
                speaker: "Gharlsa"
                message: _ "Gharlsa sees elves... yes... Fresh meat for wolves. Yes, yes..."
            }

            message{
                speaker: "Erlornas"
                message: _ "— let’s focus on the task at hand."
            }

            message{
                role: "advisor"
                message: _ "Does that demented creature truly believe he can kill us?"
            }

            message{
                speaker: "Erlornas"
                message: _ "Appearances can be deceiving. Tell the men to be cautious."
            }
    }

    event: {
        name: "attack"
        filter: {
            type: "Orcish Assassin"
        }

        do: -> message{
                speaker: "Gharlsa"
                message: _ "Yes... yes... Slay them!"
            }
    }

    event: {
        name: "last breath"
        filter: {
            speaker: "Gharlsa"
        }

        do: -> message{
                speaker: "unit"
                message: _ "Hurts... failed... Rualsha gonna be angry..."
            }
    }

    event: {
        name: "die"
        filter: {
            id: "Gharlsa"
        }

        do: -> message{
                speaker: "Erlornas"
                message: _ "This... ‘Rualsha’ again. We need to forge ahead; the answers we seek are not here. Perhaps we will find them further north."
            }

            message{
                speaker: "Erlornas"
                message: _ "Destroy this place and let the forest take the ruins. We don’t want any more undesirables to use it."
            }

            endlevel{
                result: "victory"
                bonus: true
                NEW_GOLD_CARRYOVER(40)
            }
    }

    HERODEATH_ERLORNAS!
}
