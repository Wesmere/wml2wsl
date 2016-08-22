--textdomain wesnoth-aoi

-- Warning: If you are not a native and literate English speaker, do
-- not try to modify the storyline text. It is deliberately written
-- in a somewhat archaic and poetic form of English, and some previous
-- attempts to "fix" it inflicted damage that was difficult to undo.

scenario{
    id: "01_Defend_the_Forest"
    name: _ "Defend the Forest"
    map_data: "{campaigns/An_Orcish_Incursion/maps/01_Defend_the_Forest.map}"
    turns: 24
    next_scenario: "02_Assassins"

    DEFAULT_SCHEDULE!

    SCENARIO_MUSIC("knolls.ogg")
    EXTRA_SCENARIO_MUSIC("wanderer.ogg")
    EXTRA_SCENARIO_MUSIC("sad.ogg")

    story: {
        part: {
            music: "elvish-theme.ogg"
            AOI_BIGMAP!
            story: _ "The arrival of humans and orcs caused turmoil among the nations of the Great Continent. Elves, previously in uneasy balance with dwarves and others, had for centuries fought nothing more than an occasional skirmish. They were to find themselves facing conflicts of a long-forgotten intensity."
        }
        part: {
            AOI_BIGMAP!
            story: _ "Their first encounter with the newcomers went less well than either side might have wished."
        }
        part: {
            AOI_BIGMAP!
            story: _ "But humans, though crude and brash, at least had in them a creative spark which elves could recognize as akin to their own nature. Orcs seemed completely alien."
        }
        part: {
            AOI_BIGMAP!
            story: _ "For some years after Haldric’s people landed, orcs remained scarce more than a rumor to trouble the green fastnesses of the elves. That remained so until the day that an elvish noble of ancient line, Erlornas by name, faced an enemy unlike any he had ever met before."
        }
        part: {
            AOI_BIGMAP!
            --po: "northern marches" is *not* a typo for "northern marshes" here.
            --po: In archaic English, "march" means "border country".
            story: _ "The orcs were first sighted from the north marches of the great forest of Wesmere."
        }
    }

    AOI_TRACK(JOURNEY_01_NEW!)

    -- wmllint: validate-off
    side: {
        side: 1
        controller: "human"
        GOLD(200, 150, 100)
        income: 0
        team_name: "Elves"
        user_team_name: _ "Elves"
        FLAG_VARIANT("wood-elvish")

        -- wmllint: recognize Erlornas
        CHARACTER_STATS_ERLORNAS!

        facing: "nw"

        unit: {
            side: 1
            type: "Elvish Rider"
            id: "Lomarfel"
            name: _ "Lomarfel"
            profile: "portraits/lomarfel.png"
            x: 15, y: 18
            modifications: {
                TRAIT_LOYAL!
                TRAIT_RESILIENT!
            }
            IS_LOYAL!
            facing: "ne"
        }
    }
    -- wmllint: validate-on

    side: {
        side: 2
        controller: "ai"
        recruit: "Orcish Archer,Orcish Grunt,Wolf Rider"
        GOLD(100, 125, 150)
        income: 0
        team_name: "Orcs"
        user_team_name: _ "Orcs"
        FLAG_VARIANT6("ragged")

        type: "Orcish Warrior"
        id: "Urugha"
        name: _ "Urugha"
        canrecruit: true

        facing: "se"

        ai: {
            grouping: "offensive"
            attack_depth: 5
        }
    }

    STARTING_VILLAGES(1, 6)

    event: {
        name: "prestart"

        do: -> SCATTER_IMAGE({terrain: "Re"}, 1, "scenery/rubble.png")

            objectives{
                objective: {
                    description: _ "Defeat Urugha"
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
                    HINT(_ "Elves can move quickly and safely among the trees. Pick off the enemy grunts with your archers from the safety of the forest.")
                }
            }
    }

    event: {
        name: "start"

        do: -> message{
                speaker: "Lomarfel"
                message: _ "My lord! A party of aliens has made camp to the north and lays waste to the forest. Our scouts believe it’s a band of orcs."
            }

            message{
                speaker: "Erlornas"
                message: _ "Orcs? It seems unlikely. The human king, Haldric, crushed them when they landed on these shores, and since then they’ve been no more than a bogey mothers use to scare the children."
            }

            message{
                speaker: "Lomarfel"
                message: _ "So it seemed, my lord. Yet there is a band of them in the north cutting down healthy trees by the dozen, and making great fires from the wood. They trample the greensward into mud and do not even bury their foul dung. I believe I can smell the stench even here."
            }

            message{
                speaker: "Erlornas"
                message: _ "So the grim tales of them prove true. They must not be allowed to continue; we must banish this blight from our forests. I shall marshal the wardens and drive them off. And the Council needs to hear of this; take the message and return with reinforcements, there might be more of them."
            }

            message{
                speaker: "Lomarfel"
                message: _ "Yes, my lord!"
            }

            kill{
                id: "Lomarfel"
            }

            move_unit_fake{
                type: "Elvish Rider"
                x: {15, 14, 14, 13, 12, 11, 10}
                y: {18, 18, 19, 20, 20, 20, 20}
            }
    }

    event: {
        name: "turn 2"

        do: -> message{
                speaker: "Erlornas"
                message: _ "Look at them. Big, slow, clumsy and hardly a bow in hand. Keep to the trees, use your arrows and the day will be ours."
            }
    }

    event: {
        name: "time over"

        do: -> message{
                race: "elf"
                message: _ "It’s hopeless; we’ve tried everything, and they’re still coming back."
            }

            message{
                speaker: "Urugha"
                message: _ "Forward, you worthless worms! Look at them, they’re tired and afraid! You killed their will to fight, now go and finish the job!"
            }

            message{
                speaker: "Erlornas"
                message: _ "That cloud of dust on the horizon... flee! There’s more of the abominations heading this way! Fall back before we’re outnumbered and crushed."
            }

            message{
                speaker: "narrator"
                image: "wesnoth-icon.png"
                message: _ "Lord Erlornas didn’t drive the orcs back, although he and his warriors tried their absolute best. When another war band arrived, elvish resistance crumbled."
            }

            message{
                speaker: "narrator"
                image: "wesnoth-icon.png"
                message: _ "Of the ensuing events little is known, since much was lost in the chaos and confusion, but one thing is painfully sure. Elves lost the campaign."
            }
    }

    event: {
        name: "last breath"
        filter: {
            id: "Erlornas"
        }

        do: -> message{
                speaker: "Erlornas"
                message: _ "Ugh..."
            }

            message{
                speaker: "Urugha"
                message: _ "Finally! Got him!"
            }

            message{
                race: "elf"
                not: {
                    id: "Erlornas"
                }
                message: _ "Lord!"
            }

            message{
                speaker: "Erlornas"
                message: _ "Take... command... Drive them... away."
            }

            message{
                speaker: "narrator"
                image: "wesnoth-icon.png"
                message: _ "Lord Erlornas died the day he first fought the orcs and never saw the end of the war. Given its final outcome, this was perhaps for the best."
            }
    }

    event: {
        name: "last breath"
        filter: {
            id: "Urugha"
        }

        do: -> message{
                speaker: "unit"
                message: _ "I’ve been bested, but the combat wasn’t fair... A thousand curses on you, withered coward! May you suffer... and when my master, Rualsha, finds you may he wipe your people from the face of this earth!"
            }
    }

    event: {
        name: "die"
        filter: {
            id: "Urugha"
        }

        do: -> message{
                speaker: "Erlornas"
                message: _ "Rualsha? Hmm... What if... Assemble a war-party, we need to scout north!"
            }

            endlevel{
                result: "victory"
                bonus: true
                NEW_GOLD_CARRYOVER(40)
            }
    }
}
