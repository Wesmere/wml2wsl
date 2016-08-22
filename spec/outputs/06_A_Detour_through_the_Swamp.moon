
scenario{
    id: "06_A_Detour_through_the_Swamp"
    name: _ "A Detour through the Swamp"
    map_data: "06_A_Detour_through_the_Swamp.map"
    turns: 24
    next_scenario: "07_Showdown"

    DEFAULT_SCHEDULE

    INTRO_AND_SCENARIO_MUSIC("the_deep_path.ogg", "underground.ogg")
    EXTRA_SCENARIO_MUSIC("vengeful.ogg")
    EXTRA_SCENARIO_MUSIC("revelation.ogg")

    music:{"underground","vengeful","revelation"}

    story:AOI_TRACK JOURNEY_06_NEW, { music: "the_deep_path" }

    side: {
        FLAG_VARIANT "wood-elvish"
        side: 1
        controller: "human"
        recruit: "Elvish Scout","Elvish Fighter","Elvish Archer","Elvish Shaman"
        team_name: "good"
        user_team_name: _ "Elves"
        CHARACTER_STATS_ERLORNAS
        facing:"se"
    }

    side: {
        FLAG_VARIANT("undead")
        side: 2
        controller: "ai"
        recruit: "Ghoul, Revenant, Skeleton, Skeleton Archer, Ghost, Walking Corpse"
        GOLD(150, 200, 250)
        income: 0
        team_name: "undead"
        user_team_name: _ "Undead"
        unit:
            type: "Lich"
            id: "Keremal"
            name: _ "Keremal"
            can_recruit: true
            facing: "nw"
        ai: {
            villages_per_scout: 4
            leader_value: 3
            village_value: 1
            grouping: "offensive"
            attack_depth: 5
        }
    }

    event: {
        name: "prestart"

        do: -> objectives{
                side: 1
                objective: {
                    HINT(_ "Undead are resistant to physical attack. Use mages to attack the undead, and elves to protect and support the mages.")
                    description: _ "Defeat Keremal"
                    condition: "win"
                }
                objective: {
                    description: _ "Death of Erlornas"
                    condition: "lose"
                }
                objective: {
                    description: _ "Death of Linaera"
                    condition: "lose"
                }
                objective: {
                    TURNS_RUN_OUT
                }
                gold_carryover: {
                    bonus: true
                    carryover_percentage: 40
                }
            }
            recall{
                id: "Linaera"
            }
            role{
                type: "Red Mage,White Mage,Mage,Arch Mage,Mage of Light,Great Mage"
                role: "mage"
            }
            recall{
                role: "mage"
            }
            MODIFY_UNIT({side: 1}, "facing", "se")

    Start: ->
        message
            speaker:"Linaera"
            message: _ "The evil spirits who have settled in this wetland have turned it into a vile bog. My apprentices and I have the power to dispel them, but you must protect us from their weapons."

    EnemiesDefeated: ->
        role
            type:"Red Mage,White Mage,Mage,Arch Mage,Mage of Light,Great Mage"
            role:"mage"
        message
            speaker:"Linaera"
            message: _ "Thank you, Erlornas... now I can return to my tower in peace. But I think some of my apprentices wish to follow you north in pursuit of the orcs."
        message
            role:"mage"
            message: _ "I have always wished to see elves, and now I have fought alongside them! May I please travel with you?"
        message
            speaker:"Erlornas"
            message: _ "Certainly... I shall be glad of your help."
        endlevel NEW_GOLD_CARRYOVER 40
            result:"victory"
            bonus:true

    HERODEATH_ERLORNAS
    HERODEATH_LINAERA
}
