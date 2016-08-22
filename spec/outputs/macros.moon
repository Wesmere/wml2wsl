--textdomain wesnoth-aoi

HINT = (MESSAGE) ->
    {   notes_string: _ "Hint:",

        note: {
            description: MESSAGE
        }
    }

RECALL_ADVISOR = ->
    role{
        role: "advisor"
        auto_recall: {}
        search_recall_list: true

        side: 1
        race: "elf"
        not: {
            id: "Erlornas"
        }

        else: ->
            unit{
                type: "Elvish Fighter"
                side: 1
                role: "advisor"
                animate: true
                placement: "leader"
            }

    }


PROMOTE_ADVISOR = ->
    role{
        role: "advisor"
        search_recall_list: false

        side: 1
        race: "elf"
        not: {
            id: "Erlornas"
        }
    }


RECALL_MAGE = ->
    role{
        role: "mage"
        auto_recall: {}
        search_recall_list: true

        side: 1
        type: "Great Mage,Mage of Light,Arch Mage,Silver Mage,White Mage,Red Mage,Mage"
        not: {
            id: "Linaera"
        }

        else: ->
            unit{
                type: "Mage"
                side: 1
                role: "mage"
                animate: true
                placement: "leader"
            }

    }

