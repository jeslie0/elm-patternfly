module Components.Accordion.Item exposing (accordionItem)

{-| For use as children of accordions.

# Accordion item

@docs accordionItem
-}



import Html exposing (Html, div)


{-| An accordion item. For use in accordions.
-}
accordionItem : List (Html msg) -> Html msg
accordionItem =
    div []
