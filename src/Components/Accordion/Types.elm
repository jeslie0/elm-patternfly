module Components.Accordion.Types exposing (HeadingLevel(..))

{-| The list type - either a `DefinitionList` or a `Div`. Information
about definition lists can be found [here](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dl).
-}



-- * Heading level


{-| Each heading level corresponds to a HTML heading level.
-}
type HeadingLevel
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6
    | DefinitionList
