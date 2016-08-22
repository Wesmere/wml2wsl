--textdomain wesnoth-aoi

HERODEATH_ERLORNAS = ->
    event{
        name: "die"
        filter: {
            id: "Erlornas"
        }

        do: -> message{
                speaker: "narrator"
                image: "wesnoth-icon.png"
                message: _ "Lord Erlornas never saw the blade that felled him. He died on the spot, with not a chance to issue last commands or farewells. Without him his wardens soon fell into confusion, and losing heart withdrew from the battle."
            }

            message{
                speaker: "narrator"
                image: "wesnoth-icon.png"
                message: _ "When reinforcements finally arrived, elves managed to dislodge the orcish tribe. But the threat from the north remained unresolved and loomed large over their future."
            }

            endlevel{
                result: "defeat"
            }
    }


HERODEATH_LINAERA = ->
    event{
        name: "last breath"
        filter: {
            id: "Linaera"
        }

        do: -> message{
                speaker: "Linaera"
                message: _ "Alas, Erlornas, I have failed us..."
            }
    }

    event{
        name: "die"
        filter: {
            id: "Linaera"
        }

        do: -> message{
                speaker: "Erlornas"
                message: _ "All is lost! Without Linaera’s help, I cannot hope to defeat these abominations!"
            }

            endlevel{
                result: "defeat"
            }
    }

