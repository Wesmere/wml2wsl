--textdomain wesnoth-aoi

-- Warning: If you are not a native and literate English speaker, do
-- not try to modify the storyline text. It is deliberately written
-- in a somewhat archaic and poetic form of English, and some previous
-- attempts to "fix" it inflicted damage that was difficult to undo.

scenario{
    id: "04_Valley_of_Trolls"
    name: _ "Valley of Trolls"
    map_data: "{campaigns/An_Orcish_Incursion/maps/04_Valley_of_Trolls.map}"
    turns: 24
    next_scenario: "05_Linaera_the_Quick"

    DEFAULT_SCHEDULE

    SCENARIO_MUSIC("the_dangerous_symphony.ogg")
    EXTRA_SCENARIO_MUSIC("wanderer.ogg")
    EXTRA_SCENARIO_MUSIC("underground.ogg")

    story: {
        part: {
            music: "breaking_the_chains.ogg"
            AOI_BIGMAP
            story: _ "Next morning, the elves set off again, increasingly wearied by the hardships of the campaign and longing for the green comfort of their home forests. This land was barren and rugged; nothing shielded them from biting northern wind as they traveled towards the mountains looming before them."
        }
        part: {
            AOI_BIGMAP
            story: _ "At dusk they arrived at the mouth of a valley cutting almost straight through the range and made camp, as scouts warned that the area was hostile and the road ahead treacherous in darkness. There were no songs or music that night and most of the elves slept uneasily. An unlucky few kept a cautious watch."
        }
        part: {
            AOI_BIGMAP
            story: _ "When sunrise came, the elves moved into battle formations. Whatever waited in the slopes ahead, it would not find them unprepared."
        }
    }

    AOI_TRACK(JOURNEY_04_NEW)

    -- wmllint: validate-off
    side: {
        side: 1
        controller: "human"
        team_name: "Elves"
        recruit: "Elvish Scout,Elvish Fighter,Elvish Archer,Elvish Shaman"
        user_team_name: _ "Elves"
        FLAG_VARIANT("wood-elvish")

        -- wmllint: recognize Erlornas
        CHARACTER_STATS_ERLORNAS

        facing: "nw"
        shroud: true
    }

    side: {
        side: 2
        controller: "ai"
        recruit: if EASY
            "Troll, Troll Whelp"
        else
            "Troll, Troll Rocklobber, Troll Whelp"
        GOLD(30, 40, 50)
        INCOME(5, 7, 9)
        team_name: "Trolls"
        user_team_name: _ "Trolls"
        FLAG_VARIANT("undead")
        type: if EASY
            "Troll"
        else
            "Troll Warrior"
        id: "Gurk"
        name: _ "Gurk"
        canrecruit: true
        facing: "ne"
        ai: {
            aggression: 0.8
            turns: "4,5,6,10,11,12,16,17,18,22,23,24"
            grouping: "offensive"
            attack_depth: QUANTITY(1, 3, 5)
        }
        ai: {
            aggression: -0.1
            simple_targeting: true
            turns: "1,2,3,7,8,9,13,14,15,19,20,21"
            grouping: "none"
            attack_depth: QUANTITY(1, 3, 5)
        }
    }

    side: FLAG_VARIANT "undead"
        side:3
        controller:"ai"
        recruit: if EASY
            "Troll Rocklobber, Troll Whelp"
        else
            "Troll, Troll Rocklobber,Troll Whelp"
        gold: QUANTITY 30, 40, 50
        income: QUANTITY 5, 7, 9
        team_name:"Trolls"
        user_team_name: _ "Trolls"
        type: if EASY
            "Troll"
        else
            "Troll Warrior"
        id:"Hrugu"
        name: _ "Hrugu"
        can_recruit:true
        facing:"sw"
        ai:
            aggression:0.8
            turns:"4,5,6,10,11,12,16,17,18,22,23,24"
            grouping:"offensive"
            attack_depth:5
        ai:
            aggression:-0.1
            turns:"1,2,3,7,8,9,13,14,15,19,20,21"
            grouping:"none"
            attack_depth:5
            simple_targeting:true

--     {LIMIT_CONTEMPORANEOUS_RECRUITS 2 "Troll"            1}
--     {LIMIT_CONTEMPORANEOUS_RECRUITS 2 "Troll Rocklobber" 1}
--     {LIMIT_CONTEMPORANEOUS_RECRUITS 3 "Troll"            1}
--     {LIMIT_CONTEMPORANEOUS_RECRUITS 3 "Troll Rocklobber" 1}
-- --ifdef EASY
--     {LIMIT_CONTEMPORANEOUS_RECRUITS 2 "Troll Whelp" 3}
--     {LIMIT_CONTEMPORANEOUS_RECRUITS 3 "Troll Whelp" 3}
-- --endif

    Prestart: ->
        remove_shroud
            side:1
            terrain:"G*,Ww,Ww^*,R*,Gs^*,Gg^*"
        objectives
            objective:
                description: _ "Defeat all enemy leaders"
                condition:"win"
            objective:
                description: _ "Death of Erlornas"
                condition:"lose"
            --{TURNS_RUN_OUT}
            gold_carryover:
                bonus:true
                carryover_percentage:40
        if EASY
            HINT _ "Trolls are poor fighters when not on rugged terrain and fare even worse during the daytime. Lure them out of the hills and attack in the sunlight."
        RECALL_ADVISOR!
        MODIFY_UNIT {side:1}, "facing", "nw"

    Start: ->
        message:
            role:"Advisor"
            message: _ "We are far from our lands, now, Erlornas, and we have driven the orcs from the forest. Why do we not return home?"
        message:
            speaker:"Erlornas"
            message: _ "You know well enough... Rualsha. That name sounds everywhere we go since the incursion began. That orc is much more than a mere marauding bandit in search of pillage. And he wants this land. <i>Our</i> land. He is planning an invasion, I’m sure of it. We must gather more information about his plans before we go back."
        message:
            speaker:"Erlornas"
            message: _ "And tell me... How did you sleep last night?"
        message:
            role:"Advisor"
            message: _ "How did I?... Uneasy, lord. My dreams were bleak, some of them nightmares."
        message:
            speaker:"Erlornas"
            message: _ "Yes. The earth currents are perturbed here, and the bridges to the dreamland are tainted. I think there is a mage dwelling somewhere nearby. Or perhaps more than one; the traces are mixed, and some of them have an unwholesome flavor."
        message:
            role:"Advisor"
            message: _ "It would be dire indeed for us if these orcs have magic to add to their battle-might."
        message:
            speaker:"Erlornas"
            message: _ "We must discover if this is so."
        message:
            role:"Advisor"
            message: _ "Information will do us no good if we are killed before we return with it! These mountains look like troll territory."
        message:
            speaker:"Erlornas"
            message: _ "Enough. The sun’s fully over the horizon. Give the order to advance."

    EnemiesDefeated: ->
        role:
            race:"elf"
            not:
                can_recruit:true
            role:"Advisor"
        message:
            role:"Advisor"
            message: _ "That was the last of the chieftains, lord. The lesser trolls seem to be retreating now."
        message:
            speaker:"Erlornas"
            message: _ "It is well. Break camp and move everyone through the pass before they rally. We’ll rest a bit on the other side; we have earned it."
        message:
            role:"Advisor"
            message: _ "At once. How much time do you think we have?"
        message:
            speaker:"Erlornas"
            message: _ "A day, perhaps. We fought two clans today; they won’t take long to rally. We need to be gone from here by sunset next."
        endlevel:
            result:"victory"
            bonus:true
            carryover_add:true
            carryover_percentage:40

    Die:
        filter:
            race:"troll"
            can_recruit:true
        command: ->
            message
                speaker:"Erlornas"
                message: _ "We have slain a chieftain! Take heart! This battle is almost won!"

    Die:
        filter:
            id:"Erlornas"
        command: ->
            role
                race:"elf"
                not:
                    can_recruit:true
                role:"Advisor"
            message
                speaker:"second_unit"
                message: _ "Ha! Me smashed da funny elf. Me got a trophy!"
            message
                role:"Advisor"
                message: _ "No! This can’t be!"
            message
                speaker:"narrator"
                message: _ "Soon after Erlornas died, the elven party, lacking a leader and pressed from all sides, scattered and fled. Their retreat to Wesmere was arduous and long."
            message
                speaker:"narrator"
                message: _ "During their retreat, the pass was crossed by another army moving in the opposite direction. Orcs were back south of the pass, and this time they were to stay for a long, long time."

    TimeOver: ->
        message
            role:"Advisor"
            message: _ "We can’t get through, my Lord. These whelps are not individually very dangerous, but there are huge numbers of them."
        message
            speaker:"Erlornas"
            message: _ "Four days of combat and nothing to show for it. How does it feel to you?"
        message
            role:"Advisor"
            message: _ "Terrible, my lord. Never in my life did I dream I’d be bested by mere trolls. What are your orders?"
        message
            speaker:"Erlornas"
            message: _ "Withdraw and make camp a safe distance from the hills. There is no further point in this fight. We’ll wait for reinforcements."
        message
            speaker:"narrator"
            message: _ "The reinforcements arrived a few days later, a crack force of rangers with some cavalry support. When they attempted the pass again, they found not trolls but something worse — an orcish army approaching from the north."
        message
            speaker:"narrator"
            message: _ "The battle that ensued was bloody and inconclusive, and the elven losses were only the beginning of the mournful toll in a war that would rage for many years after."
