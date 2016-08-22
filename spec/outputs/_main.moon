--textdomain wesnoth-aoi
textdomain{
    name: "wesnoth-aoi"
}

-- wmlscope: set export=no
campaign{
    id: "An_Orcish_Incursion"
    icon: "units/elves-wood/lord.png~TC(1,magenta)"
    image: "data/campaigns/An_Orcish_Incursion/images/campaign_image.png"
    name: _ "An Orcish Incursion"
    abbrev: _ "AOI"
    rank: 15
    first_scenario: "01_Defend_the_Forest"
    define: "CAMPAIGN_AN_ORCISH_INCURSION"
    description: _ [[Defend the forests of the elves against the first orcs to reach the Great Continent, learning valuable tactics as you do so.

]] .. _ "(Novice level, 7 scenarios.)"

    CAMPAIGN_DIFFICULTY("EASY", "units/elves-wood/fighter.png~RC(magenta>red)", ( _ "Fighter") ( _ "Beginner"))
    CAMPAIGN_DIFFICULTY("NORMAL", "units/elves-wood/lord.png~RC(magenta>red)", ( _ "Lord") ( _ "Normal")} {DEFAULT_DIFFICULTY}
    CAMPAIGN_DIFFICULTY("HARD", "units/elves-wood/high-lord.png~RC(magenta>red)", ( _ "High Lord") ( _ "Challenging"))

    -- Geographical and historical assumptions (ESR):
    --
    -- As originally written by Josh Parsons, this campaign was not set in
    -- any particular time or place.  I changed it to a few years after the
    -- arrival of orcs on the Great Continent, and pinned it to the
    -- northern marches of Wesmere.  Erlornas and his troops were originally
    -- professional guards, but I've changed them to a scratch force of
    -- civilians raused by a local noble and gradually militarizing.  Thus,
    -- this becomes a story of how elves learned the nature of orcs and how
    -- to cope.

    about: {
        title: _ "Campaign Design"
        entry: {
            name: "Josh Parsons"
        }
    }
    about: {
        title: _ "Adaptation for mainline"
        entry: {
            name: "Eric S. Raymond"
        }
    }
    about: {
        title: _ "Post 1.4 story and gameplay improvements"
        entry: {
            name: "Piotr Cychowski (cycholka)"
        }
    }
    about: {
        title: _ "Artwork and Graphics Design"
        entry: {
            name: "Kathrin Polikeit (Kitty)"
            comment: "portraits"
        }
    }
    about: {
        title: _ "Editing, proofreading and gameplay testing"
        entry: {
            name: "Charlie Roselius (Jozrael)"
        }
        entry: {
            name: "Eric S. Raymond"
        }
        entry: {
            name: "vicza"
        }
    }
}

if CAMPAIGN_AN_ORCISH_INCURSION
    binary_path{
        path: "data/campaigns/An_Orcish_Incursion"
    }
    campaigns.An_Orcish_Incursion.utils
    campaigns.An_Orcish_Incursion.scenarios


-- wmllint: directory spelling Rualsha Urugha
